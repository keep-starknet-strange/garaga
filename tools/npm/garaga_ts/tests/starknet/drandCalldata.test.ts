import * as garaga from "../../src/node/index";

describe('Drand Getting calldata', () => {

    const roundNumbers = [1, 2, 3, 'latest'];

    test.each(roundNumbers)("should get Drand calldata for round %s", async (roundNumber) => {

        await garaga.init();

        console.log("roundNumber", roundNumber);

        const drandCalldata = await garaga.fetchAndGetDrandCallData(roundNumber as number | 'latest');

        console.log("drandCalldata", drandCalldata);

    });

});

describe('Drand Encrypting and Getting calldata', () => {

    const roundNumbers = [1, 2, 3];

    test.each(roundNumbers)("should encrypt message and get Drand calldata for round %s", async (roundNumber) => {

        await garaga.init();

	const text = 'Hello, world!';

    	const message = new Uint8Array(16);
	message.set(new TextEncoder().encode(text));

        console.log("roundNumber", roundNumber);
        console.log("message", message);

        const drandCalldata = garaga.encryptToDrandRoundAndGetCallData(roundNumber as number, message);

        console.log("drandCalldata", drandCalldata);

    });

});
