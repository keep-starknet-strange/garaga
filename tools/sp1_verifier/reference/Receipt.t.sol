// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {SP1Verifier} from "../target/reference/v6.1.0/SP1VerifierGroth16.sol";

interface Vm {
    function projectRoot() external view returns (string memory);
    function readFile(string calldata path) external view returns (string memory);
    function parseJsonBytes(string calldata json, string calldata key) external pure returns (bytes memory);
    function parseJsonBytes32(string calldata json, string calldata key) external pure returns (bytes32);
    function parseJsonString(string calldata json, string calldata key) external pure returns (string memory);
}

contract ReceiptTest {
    Vm private constant vm = Vm(address(uint160(uint256(keccak256("hevm cheat code")))));
    SP1Verifier private verifier;
    bytes32 private programKey;
    bytes private publicValues;
    bytes private proof;

    function setUp() public {
        verifier = new SP1Verifier();
        string memory fixture = vm.readFile(
            string.concat(
                vm.projectRoot(), "/../../hydra/garaga/starknet/groth16_contract_generator/examples/proof_sp1.json"
            )
        );
        programKey = vm.parseJsonBytes32(fixture, ".vkey");
        publicValues = vm.parseJsonBytes(fixture, ".publicValues");
        proof = vm.parseJsonBytes(fixture, ".proof");
    }

    function testCommittedReceiptVerifies() external view {
        verifier.verifyProof(programKey, publicValues, proof);
    }

    function testReferenceMatchesGaragaConstants() external view {
        string memory constants = vm.readFile(string.concat(vm.projectRoot(), "/../make/constants.json"));
        require(verifier.VERIFIER_HASH() == vm.parseJsonBytes32(constants, ".sp1.verifier_hash"), "verifier hash");
        require(verifier.VK_ROOT() == vm.parseJsonBytes32(constants, ".sp1.vk_root"), "VK root");
        require(
            keccak256(bytes(verifier.VERSION()))
                == keccak256(bytes(vm.parseJsonString(constants, ".sp1.verifier_version"))),
            "verifier version"
        );
    }

    function testMetadataMutationsAreRejected() external view {
        uint256[4] memory offsets = [uint256(0), 35, 67, 99];
        for (uint256 i; i < offsets.length; ++i) {
            bytes memory modified = proof;
            modified[offsets[i]] ^= bytes1(uint8(1));
            try verifier.verifyProof(programKey, publicValues, modified) {
                revert("modified receipt was accepted");
            } catch {}
        }
    }
}
