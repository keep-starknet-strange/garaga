import pytest
from starknet_py.net.full_node_client import FullNodeClient

from tests.contracts_e2e.fixtures.constants import SEPOLIA_RPC_URL


@pytest.fixture(name="client_devnet", scope="package")
def create_full_node_client_devnet(devnet) -> FullNodeClient:
    return FullNodeClient(node_url=devnet + "/rpc")


@pytest.fixture(name="client_sepolia", scope="package")
def create_full_node_client_sepolia() -> FullNodeClient:
    return FullNodeClient(node_url=SEPOLIA_RPC_URL)
