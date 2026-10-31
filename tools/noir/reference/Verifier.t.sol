// SPDX-License-Identifier: MIT
pragma solidity ^0.8.38;

import {HonkVerifier as HelloVerifier} from "../target/references/hello.sol";
import {HonkVerifier as MemoryVerifier} from "../target/references/memory.sol";
import {HonkVerifier as RecursiveVerifier} from "../target/references/recursive.sol";

import {HonkVerifier as MutatorVerifier} from "../target/references/mutator_set.sol";

interface Vm {
    function projectRoot() external view returns (string memory);
    function readFileBinary(string calldata path) external view returns (bytes memory);
    function expectRevert() external;
}

interface Verifier {
    function verify(bytes calldata proof, bytes32[] calldata inputs) external view returns (bool);
}

contract ReferenceVerifierTest {
    Vm constant vm = Vm(address(uint160(uint256(keccak256("hevm cheat code")))));

    function testMutatorProof() public {
        verifyBundle(Verifier(address(new MutatorVerifier())), "mutator_set/proof.bin", "mutator_set/public_inputs.bin");
    }

    function testHelloProof() public {
        verifyBundle(Verifier(address(new HelloVerifier())), "proof_ultra_keccak_zk.bin", "public_inputs_ultra_keccak.bin");
    }

    function testMemoryProof() public {
        verifyBundle(Verifier(address(new MemoryVerifier())), "memory/proof.bin", "memory/public_inputs.bin");
    }

    function testRecursiveProof() public {
        verifyBundle(Verifier(address(new RecursiveVerifier())), "recursive/proof.bin", "recursive/public_inputs.bin");
    }

    function verifyBundle(Verifier verifier, string memory proofPath, string memory inputsPath) internal {
        string memory root = string.concat(vm.projectRoot(), "/../../hydra/garaga/starknet/honk_contract_generator/examples/");
        bytes memory proof = vm.readFileBinary(string.concat(root, proofPath));
        bytes memory rawInputs = vm.readFileBinary(string.concat(root, inputsPath));
        require(rawInputs.length % 32 == 0);
        bytes32[] memory inputs = new bytes32[](rawInputs.length / 32);
        for (uint256 i = 0; i < inputs.length; i++) {
            bytes32 value;
            assembly { value := mload(add(add(rawInputs, 32), mul(i, 32))) }
            inputs[i] = value;
        }
        require(verifier.verify(proof, inputs), "The upstream verifier rejected the stored receipt");
        inputs[0] = bytes32(uint256(inputs[0]) ^ 1);
        vm.expectRevert();
        verifier.verify(proof, inputs);
    }
}
