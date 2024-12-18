from pathlib import Path

import pytest
from starknet_py.contract import (
    Contract,
    ContractFunction,
    InvokeResult,
    PreparedFunctionInvokeV3,
)
from starknet_py.hash.address import compute_address
from starknet_py.hash.utils import pedersen_hash
from starknet_py.net.account.account import Account, BaseAccount
from starknet_py.net.client_errors import ContractNotFoundError

from garaga.hints.io import to_int
from garaga.starknet.cli.smart_contract_project import (
    Groth16SmartContract,
    SmartContractProject,
)
from garaga.starknet.groth16_contract_generator.generator import ECIP_OPS_CLASS_HASH
from garaga.starknet.groth16_contract_generator.parsing_utils import (
    find_item_from_key_patterns,
)
from garaga.starknet.honk_contract_generator.calldata import (
    HonkProof,
    HonkVk,
    get_ultra_keccak_honk_calldata_from_vk_and_proof,
)
from garaga.starknet.tests_and_calldata_generators.drand_calldata import (
    drand_round_to_calldata,
)

CONTRACTS_PATH = Path("src/contracts")

GROTH16_EXAMPLES_PATH = Path(
    "hydra/garaga/starknet/groth16_contract_generator/examples"
)
NOIR_EXAMPLES_PATH = Path("hydra/garaga/starknet/honk_contract_generator/examples")


ALL_GROTH16_CONTRACTS = [
    {
        "contract_project": Groth16SmartContract(
            smart_contract_folder=CONTRACTS_PATH / "risc0_verifier_bn254",
            vk_path=GROTH16_EXAMPLES_PATH / "vk_risc0.json",
        ),
        "proof_path": GROTH16_EXAMPLES_PATH / "proof_risc0.json",
    },
    {
        "contract_project": Groth16SmartContract(
            smart_contract_folder=CONTRACTS_PATH / "groth16_example_bls12_381",
            vk_path=GROTH16_EXAMPLES_PATH / "vk_bls.json",
        ),
        "proof_path": GROTH16_EXAMPLES_PATH / "proof_bls.json",
    },
    {
        "contract_project": Groth16SmartContract(
            smart_contract_folder=CONTRACTS_PATH / "groth16_example_bn254",
            vk_path=GROTH16_EXAMPLES_PATH / "vk_bn254.json",
        ),
        "proof_path": GROTH16_EXAMPLES_PATH / "proof_bn254.json",
    },
]

ECIP_CONTRACT = SmartContractProject(
    smart_contract_folder=CONTRACTS_PATH / "universal_ecip"
)

DEPLOYER_ADDRESS = 0x41A78E741E5AF2FEC34B695679BC6891742439F7AFB8484ECD7766661AD02BF


async def get_contract_if_exists(
    account: Account, contract_address: int
) -> Contract | None:
    try:
        res = await Contract.from_address(contract_address, account)
        return res
    except ContractNotFoundError:

        return None


@pytest.mark.asyncio
@pytest.mark.parametrize("contract_info", ALL_GROTH16_CONTRACTS)
async def test_groth16_contracts(account_devnet: BaseAccount, contract_info: dict):
    account = account_devnet
    contract_project: Groth16SmartContract = contract_info["contract_project"]
    proof_path: Path = contract_info["proof_path"]

    print(f"ACCOUNT {hex(account.address)}, NONCE {await account.get_nonce()}")

    for i in range(2):
        print(f"\n\nROUND {i}")
        # Declare the ECIP contract
        ecip_class_hash, _ = await ECIP_CONTRACT.declare_class_hash(account)

        assert (
            ecip_class_hash == ECIP_OPS_CLASS_HASH
        ), f"ECIP hardcoded class hash is not up to date, got {hex(ecip_class_hash)}, expected {hex(ECIP_OPS_CLASS_HASH)}"

        # Declare the groth16 contract
        groth16_class_hash, groth16_abi = await contract_project.declare_class_hash(
            account
        )

        print(f"Declared contract class hash: {hex(groth16_class_hash)}")

        # Deploy the groth16 contract
        precomputed_address = compute_address(
            class_hash=groth16_class_hash,
            constructor_calldata=[],
            salt=pedersen_hash(to_int(account.address), 1),
            deployer_address=DEPLOYER_ADDRESS,
        )

        try_contract = await get_contract_if_exists(account, precomputed_address)
        if try_contract is None:
            deploy_result = await Contract.deploy_contract_v1(
                account=account,
                class_hash=groth16_class_hash,
                abi=groth16_abi,
                deployer_address=DEPLOYER_ADDRESS,
                auto_estimate=True,
                salt=1,
                cairo_version=1,
            )
            await deploy_result.wait_for_acceptance()

            contract = deploy_result.deployed_contract
        else:
            print(f"Contract already deployed at {hex(precomputed_address)}")
            contract = try_contract

        print(f"Deployed contract address: {hex(contract.address)}")
        print(f"Deployed contract: {contract.functions}")

        function_call: ContractFunction = find_item_from_key_patterns(
            contract.functions, ["verify"]
        )

        prepare_invoke = PreparedFunctionInvokeV3(
            to_addr=function_call.contract_data.address,
            calldata=contract_project.generate_calldata(
                proof_path=proof_path, public_inputs_path=None
            ),
            selector=function_call.get_selector(function_call.name),
            l1_resource_bounds=None,
            _contract_data=function_call.contract_data,
            _client=function_call.client,
            _account=function_call.account,
            _payload_transformer=function_call._payload_transformer,
        )

        invoke_result: InvokeResult = await prepare_invoke.invoke(auto_estimate=True)

        await invoke_result.wait_for_acceptance()

        print(f"Invoke result : {invoke_result.status}")

        receipt = await account.client.get_transaction_receipt(invoke_result.hash)
        print(receipt.execution_resources)


@pytest.mark.asyncio
@pytest.mark.parametrize(
    "contract_info",
    [
        {
            "contract_project": SmartContractProject(
                smart_contract_folder=CONTRACTS_PATH / "drand_quicknet"
            )
        },
    ],
)
async def test_drand_contract(account_devnet: BaseAccount, contract_info: dict):
    account = account_devnet
    contract_project: SmartContractProject = contract_info["contract_project"]

    print(f"ACCOUNT {hex(account.address)}, NONCE {await account.get_nonce()}")

    drand_class_hash, drand_abi = await contract_project.declare_class_hash(account)

    print(f"Declared contract class hash: {hex(drand_class_hash)}")

    # Deploy the drand contract
    precomputed_address = compute_address(
        class_hash=drand_class_hash,
        constructor_calldata=[],
        salt=pedersen_hash(to_int(account.address), 1),
        deployer_address=DEPLOYER_ADDRESS,
    )

    try_contract = await get_contract_if_exists(account, precomputed_address)
    if try_contract is None:
        deploy_result = await Contract.deploy_contract_v1(
            account=account,
            class_hash=drand_class_hash,
            abi=drand_abi,
            deployer_address=DEPLOYER_ADDRESS,
            auto_estimate=True,
            salt=1,
            cairo_version=1,
        )
        await deploy_result.wait_for_acceptance()

        contract = deploy_result.deployed_contract
    else:
        print(f"Contract already deployed at {hex(precomputed_address)}")
        contract = try_contract

    print(f"Deployed contract address: {hex(contract.address)}")
    print(f"Deployed contract: {contract.functions}")

    function_call: ContractFunction = find_item_from_key_patterns(
        contract.functions, ["verify"]
    )

    for drand_round in range(1, 5):
        prepare_invoke = PreparedFunctionInvokeV3(
            to_addr=function_call.contract_data.address,
            calldata=drand_round_to_calldata(drand_round),
            selector=function_call.get_selector(function_call.name),
            l1_resource_bounds=None,
            _contract_data=function_call.contract_data,
            _client=function_call.client,
            _account=function_call.account,
            _payload_transformer=function_call._payload_transformer,
        )

        invoke_result: InvokeResult = await prepare_invoke.invoke(auto_estimate=True)

        await invoke_result.wait_for_acceptance()


HONK_CONTRACTS = [
    {
        "contract_project": SmartContractProject(
            smart_contract_folder=CONTRACTS_PATH / "noir_ultra_keccak_honk_example",
        ),
        "vk_path": NOIR_EXAMPLES_PATH / "vk_ultra_keccak.bin",
        "proof_path": NOIR_EXAMPLES_PATH / "proof_ultra_keccak.bin",
    },
]


@pytest.mark.asyncio
@pytest.mark.parametrize("contract_info", HONK_CONTRACTS)
async def test_honk_contracts(account_devnet: BaseAccount, contract_info: dict):
    account = account_devnet
    contract_project: SmartContractProject = contract_info["contract_project"]
    vk_path: Path = contract_info["vk_path"]
    proof_path: Path = contract_info["proof_path"]

    vk = HonkVk.from_bytes(open(vk_path, "rb").read())
    proof = HonkProof.from_bytes(open(proof_path, "rb").read())

    print(f"ACCOUNT {hex(account.address)}, NONCE {await account.get_nonce()}")

    # # Declare the ECIP contract
    # ecip_class_hash, _ = await ECIP_CONTRACT.declare_class_hash(account)

    # Declare the honk contract
    honk_class_hash, honk_abi = await contract_project.declare_class_hash(account)

    print(f"Declared contract class hash: {hex(honk_class_hash)}")

    # Deploy the honk contract
    precomputed_address = compute_address(
        class_hash=honk_class_hash,
        constructor_calldata=[],
        salt=pedersen_hash(to_int(account.address), 1),
        deployer_address=DEPLOYER_ADDRESS,
    )

    try_contract = await get_contract_if_exists(account, precomputed_address)
    if try_contract is None:
        deploy_result = await Contract.deploy_contract_v1(
            account=account,
            class_hash=honk_class_hash,
            abi=honk_abi,
            deployer_address=DEPLOYER_ADDRESS,
            auto_estimate=True,
            salt=1,
            cairo_version=1,
        )
        await deploy_result.wait_for_acceptance()

        contract = deploy_result.deployed_contract
    else:
        print(f"Contract already deployed at {hex(precomputed_address)}")
        contract = try_contract

    print(f"Deployed contract address: {hex(contract.address)}")
    print(f"Deployed contract: {contract.functions}")

    function_call: ContractFunction = find_item_from_key_patterns(
        contract.functions, ["verify"]
    )

    prepare_invoke = PreparedFunctionInvokeV3(
        to_addr=function_call.contract_data.address,
        calldata=get_ultra_keccak_honk_calldata_from_vk_and_proof(vk=vk, proof=proof),
        selector=function_call.get_selector(function_call.name),
        l1_resource_bounds=None,
        _contract_data=function_call.contract_data,
        _client=function_call.client,
        _account=function_call.account,
        _payload_transformer=function_call._payload_transformer,
    )

    invoke_result: InvokeResult = await prepare_invoke.invoke(auto_estimate=True)

    await invoke_result.wait_for_acceptance()

    print(f"Invoke result : {invoke_result.status}")

    receipt = await account.client.get_transaction_receipt(invoke_result.hash)
    print(receipt.execution_resources)
