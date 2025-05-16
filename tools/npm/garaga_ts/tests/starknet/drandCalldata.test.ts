import * as garaga from "../../src/node/index";

describe('Drand Getting calldata', () => {

    const roundNumbers = [1, 2, 3, 'latest'];

    test.each(roundNumbers)("should get honk calldata from proof %s, public inputs %s, vk %s and pub inputs %s", async (roundNumber) => {

        await garaga.init();

        console.log("roundNumber", roundNumber);

        const drandCalldata = await garaga.fetchAndGetDrandCallData(roundNumber);

        console.log("honkCalldata", drandCalldata);

    });

});
