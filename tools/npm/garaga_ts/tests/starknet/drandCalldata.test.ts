import * as garaga from "../../src/node/index.js";
import { describe, test } from 'node:test';

describe('Drand Getting calldata', () => {

    const roundNumbers = [1, 2, 3, 'latest'] as const;

    for (const round of roundNumbers) {
        test(`should get Drand calldata for round ${round}`, async () => {
            await garaga.init();
            await garaga.fetchAndGetDrandCallData(round);
        });
    }

});
