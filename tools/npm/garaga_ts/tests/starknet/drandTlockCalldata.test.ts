import * as garaga from "../../src/node/index";

describe('Drand Tlock Encrypting and Getting calldata', () => {

    const roundNumbers = [1, 2, 3];

    test.each(roundNumbers)("should encrypt message and get Drand tlock calldata for round %s", async (roundNumber) => {

        await garaga.init();

        const text = 'Hello, world!';
        const message = new Uint8Array(16);
        message.set(new TextEncoder().encode(text));

        const randomness = new Uint8Array(16);
        randomness.set(new TextEncoder().encode('fixed_randomness'));

        console.log("roundNumber", roundNumber);
        console.log("message", message);

        const drandCalldata = garaga.encryptToDrandRoundAndGetCallData(roundNumber as number, message, randomness);

        console.log("drandCalldata", drandCalldata);

        expect(drandCalldata).toBeDefined();
        expect(drandCalldata.length).toBeGreaterThan(0);
    });

});
