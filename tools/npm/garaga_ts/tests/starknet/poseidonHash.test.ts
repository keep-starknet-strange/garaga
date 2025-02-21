import * as garaga from "../../src/node/index";

describe('Poseidon Hash Tests', () => {
    test("should compute Poseidon hash for BN254", async () => {
        await garaga.init();

        // Test vectors from the Rust implementation
        const x = 1n;
        const y = 2n;

        const hash = garaga.poseidonHashBN254(x, y);

        // Expected hash value from Rust test
        const expectedHash = BigInt("0x115cc0f5e7d690413df64c6b9662e9cf2a3617f2743245519e19607a4417189a");

        expect(hash).toBe(expectedHash);
    });

    test("should compute different hashes for different inputs", async () => {
        await garaga.init();

        const hash1 = garaga.poseidonHashBN254(1n, 2n);
        const hash2 = garaga.poseidonHashBN254(2n, 1n);

        expect(hash1).not.toBe(hash2);
    });

    test("should handle large numbers", async () => {
        await garaga.init();

        const x = BigInt("0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff");
        const y = BigInt("0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee");

        const hash = garaga.poseidonHashBN254(x, y);

        expect(typeof hash).toBe('bigint');
        expect(hash.toString(16).length).toBeLessThanOrEqual(64); // Should be within field size
    });

    test("should handle invalid inputs gracefully", async () => {
        await garaga.init();

        expect(() => {
            // Try to hash an invalid number
            garaga.poseidonHashBN254(-1n, 1n);
        }).toThrow();
    });
});
