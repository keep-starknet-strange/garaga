import * as garaga from "../../src/node/index.js";
import assert from 'node:assert/strict';
import { describe, test } from 'node:test';

describe('Drand Tlock Encrypting and Getting calldata', () => {

    for (const round of [1, 2, 3]) {
        test(`should encrypt message and get Drand tlock calldata for round ${round}`, async () => {
            await garaga.init();
            const message = new Uint8Array(16);
            message.set(new TextEncoder().encode('Hello, world!'));
            const randomness = new Uint8Array(16);
            randomness.set(new TextEncoder().encode('fixed_randomness'));

            const calldata = garaga.encryptToDrandRoundAndGetCallData(round, message, randomness);
            assert.ok(calldata.length > 0);
        });
    }

});
