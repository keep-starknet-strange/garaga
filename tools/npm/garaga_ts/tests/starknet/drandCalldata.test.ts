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
