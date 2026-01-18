import { CURVES, CurveId, G1Point, G2Point, findValueInStringToCurveId } from "../../definitions";
import * as fs from 'fs';
import { bitLength, hexStringToBytes, modInverse, split128, toBigInt, toHexStr } from "../../hints/io";
import { createHash } from 'crypto';
import { RISC0_CONTROL_ROOT, RISC0_BN254_CONTROL_ID, RISC0_SYSTEM_STATE_ZERO_DIGEST, SP1_VERIFIER_HASH, SP1_VERIFIER_VERSION } from "../../../constants";


//https://github.com/risc0/risc0-ethereum/blob/main/contracts/src/groth16/ControlID.sol


export interface Groth16Proof {
    a: G1Point,
    b: G2Point,
    c: G1Point,
    publicInputs: bigint[],
    curveId?: CurveId,
    imageIdJournalRisc0?: { imageId: Uint8Array, journal: Uint8Array },
    vkeyPublicValuesSp1?: { vkey: Uint8Array, publicValues: Uint8Array }
}

export interface Groth16VerifyingKey {
    alpha: G1Point,
    beta: G2Point,
    gamma: G2Point,
    delta: G2Point,
    ic: G1Point[]
}

interface Output {
    journalDigest: Uint8Array;
    assumptionsDigest: Uint8Array;
}

interface ExitCode {
    system: number;
    user: number;
}


interface ReceiptClaim {
    preStateDigest: Uint8Array;
    postStateDigest: Uint8Array;
    exitCode: ExitCode;
    input: Uint8Array;
    output: Uint8Array;
    tagDigest?: Uint8Array;
}

export class KeyPatternNotFoundError extends Error {
    constructor(message: string) {
        super(message);
        this.name = "KeyPatternNotFoundError";
    }
}



export const parseGroth16VerifyingKeyFromJson = (filePath: string): Groth16VerifyingKey => {
    try {
        const data: any = JSON.parse(fs.readFileSync(filePath, 'utf8'));

        return parseGroth16VerifyingKeyFromObject(data);

    } catch (err) {
        throw new Error(`Failed to parse Groth16 verifying key from ${filePath}: ${err}`);

    }
}

export const parseGroth16VerifyingKeyFromObject = (data: any): Groth16VerifyingKey => {

    try {
        const curveId = tryGuessingCurveIdFromJson(data);
        let verifyingKey: any;

        try {
            verifyingKey = findItemFromKeyPatterns(data, ["verifying_key"])
        } catch (err) {
            verifyingKey = data;
        }

        try {
            const alpha = tryParseG1PointFromKey(verifyingKey, ['alpha'], curveId);
            const beta = tryParseG2PointFromKey(verifyingKey, ['beta'], curveId);
            const gamma = tryParseG2PointFromKey(verifyingKey, ['gamma'], curveId);
            const delta = tryParseG2PointFromKey(verifyingKey, ['delta'], curveId);
            if (curveId !== null && curveId !== undefined) {


                const ic: G1Point[] = findItemFromKeyPatterns(verifyingKey, ['ic']).map((point: any) => {
                    const g1Point = tryParseG1Point(point, curveId)
                    return g1Point;
                });

                const vk: Groth16VerifyingKey = {
                    alpha,
                    beta,
                    gamma,
                    delta,
                    ic
                }


                if (checkGroth16VerifyingKey(vk)) {
                    return vk;
                }
                throw new Error(`Invalid Groth16 verifying key: ${vk}`);
            }
            throw new Error("Curve ID not provided");

        } catch (err) {
            // Gnark case
            const g1Points = findItemFromKeyPatterns(verifyingKey, ['g1']);
            const g2Points = findItemFromKeyPatterns(verifyingKey, ['g2']);

            const alpha = tryParseG1PointFromKey(g1Points, ['alpha'], curveId);
            const beta = tryParseG2PointFromKey(g2Points, ['beta'], curveId);
            const gamma = tryParseG2PointFromKey(g2Points, ['gamma'], curveId);
            const delta = tryParseG2PointFromKey(g2Points, ['delta'], curveId);


            if (curveId !== null && curveId !== undefined) {
                const ic: G1Point[] = findItemFromKeyPatterns(g1Points, ['K']).map((point: any) => tryParseG1Point(point, curveId));
                const vk = {
                    alpha,
                    beta,
                    gamma,
                    delta,
                    ic
                }

                if (checkGroth16VerifyingKey(vk)) {
                    return vk;
                }
            }
            throw new Error("Curve ID not provided");

        }

    } catch (err) {
        throw new Error(`Failed to parse Groth16 verifying key from object: ${err}`);
    }



}


export const parseGroth16ProofFromJson = (proofPath: string, publicInputsPath?: string | null): Groth16Proof => {

    try {

        const data: any = JSON.parse(fs.readFileSync(proofPath, 'utf8'));

        let publicInputs: any = null;


        if (publicInputsPath && publicInputsPath !== null && publicInputsPath !== undefined) {

            try {
                publicInputs = JSON.parse(fs.readFileSync(publicInputsPath, 'utf8'));
            }
            catch (err) {
                throw new Error(`Invalid public inputs format: ${publicInputsPath}`);
            }
        }

        return parseGroth16ProofFromObject(data, publicInputs);

    } catch (err) {
        throw new Error(`Failed to parse Groth16 proof from ${proofPath}: ${err}`);
    }

}


export const parseGroth16ProofFromObject = (data: any, publicInputsData?: bigint[] | object): Groth16Proof => {
    try {

        let curveId = tryGuessingCurveIdFromJson(data);

        let proof: any = null;

        try {
            proof = findItemFromKeyPatterns(data, ['proof']);
        } catch (err) {
            proof = data
        }

        // Try RISC0 parsing first
        try {
            const sealHex = toHexStr(findItemFromKeyPatterns(data, ['seal']));
            const imageIdHex = toHexStr(findItemFromKeyPatterns(data, ['image_id']));
            const journalHex = toHexStr(findItemFromKeyPatterns(data, ['journal']));

            const sealBytes = hexStringToBytes(sealHex);
            const imageIdBytes = hexStringToBytes(imageIdHex);
            const journalBytes = hexStringToBytes(journalHex);

            return createGroth16ProofFromRisc0(sealBytes, imageIdBytes, journalBytes)
        } catch (err) {
            // Continue to SP1 parsing
        }

        // Try SP1 parsing second
        try {
            const sp1VkeyHex = findItemFromKeyPatterns(data, ['vkey']);
            const sp1PublicValuesHex = findItemFromKeyPatterns(data, ['publicValues']);
            const sp1ProofHex = findItemFromKeyPatterns(data, ['proof']);

            let vkeyBytes: Uint8Array;
            let publicValuesBytes: Uint8Array;
            let proofBytes: Uint8Array;

            // Handle hex strings directly to preserve leading zeros
            if (typeof sp1VkeyHex === 'string') {
                vkeyBytes = hexStringToBytes(sp1VkeyHex);
            } else {
                vkeyBytes = hexStringToBytes(toHexStr(sp1VkeyHex));
            }

            if (typeof sp1PublicValuesHex === 'string') {
                publicValuesBytes = hexStringToBytes(sp1PublicValuesHex);
            } else {
                publicValuesBytes = hexStringToBytes(toHexStr(sp1PublicValuesHex));
            }

            if (typeof sp1ProofHex === 'string') {
                proofBytes = hexStringToBytes(sp1ProofHex);
            } else {
                proofBytes = hexStringToBytes(toHexStr(sp1ProofHex));
            }

            return createGroth16ProofFromSp1(vkeyBytes, publicValuesBytes, proofBytes);
        } catch (err) {
            // Continue to regular proof parsing
        }

        let publicInputs: bigint[] = [];

        if (publicInputsData && publicInputsData !== null && publicInputsData !== undefined) {

            if (typeof publicInputsData === 'object' && !Array.isArray(publicInputsData)) {
                // If it's an object, convert it to a list (array) of its values
                publicInputs = Object.values(publicInputsData).map(
                    (value: any) => toBigInt(value)
                );
            } else if (Array.isArray(publicInputsData)) {
                publicInputs = publicInputsData.map((value: any) => toBigInt(value));
            } else {
                throw new Error(`Invalid public inputs format: ${publicInputsData}`);
            }
        } else {

            try {
                publicInputs = findItemFromKeyPatterns(data, ['public']);
            } catch (err) {

            }
        }
        const a = tryParseG1PointFromKey(proof, ['a', 'Ar'], curveId);
        const b = tryParseG2PointFromKey(proof, ['b', 'Bs'], curveId);
        const c = tryParseG1PointFromKey(proof, ['c', 'Krs'], curveId);

        const returnProof = {
            a,
            b,
            c,
            publicInputs: publicInputs
        }

        if (checkGroth16Proof(returnProof)) {
            return returnProof;
        }

        throw new Error(`Invalid Groth16 proof: ${returnProof}`);

    } catch (err) {
        throw new Error(`Failed to parse Groth16 proof from object: ${err}`);
    }

}


export const createGroth16ProofFromRisc0 = (seal: Uint8Array, imageId: Uint8Array, journalBytes: Uint8Array,
    controlRoot: bigint = RISC0_CONTROL_ROOT, bn254ControlId: bigint = RISC0_BN254_CONTROL_ID): Groth16Proof => {

    if (imageId.length > 32) {
        throw new Error("imageId must be 32 bytes")
    }

    const [controlRoot0, controlRoot1] = splitDigest(controlRoot);

    const proof = seal.slice(4);



    const journal_digest = createHash("sha256").update(journalBytes).digest();

    const claimDigest = digestReceiptClaim(ok(imageId, journal_digest));


    const [claim0, claim1] = splitDigest(claimDigest);



    const groth16Proof: Groth16Proof = {
        a: {
            x: toBigInt(proof.slice(0, 32)),
            y: toBigInt(proof.slice(32, 64)),
            curveId: CurveId.BN254
        },
        b: {
            x: [
                toBigInt(proof.slice(96, 128)),
                toBigInt(proof.slice(64, 96))
            ],
            y: [
                toBigInt(proof.slice(160, 192)),
                toBigInt(proof.slice(128, 160))
            ],
            curveId: CurveId.BN254
        },
        c: {
            x: toBigInt(proof.slice(192, 224)),
            y: toBigInt(proof.slice(224, 256)),
            curveId: CurveId.BN254
        },
        publicInputs: [
            controlRoot0,
            controlRoot1,
            claim0,
            claim1,
            bn254ControlId
        ],
        imageIdJournalRisc0: {
            imageId,
            journal: journalBytes
        }
    }
    if (checkGroth16Proof(groth16Proof)) {
        return groth16Proof;
    }

    throw new Error(`Invalid Groth16 proof: ${groth16Proof}`);

}


export const checkGroth16Proof = (proof: Groth16Proof): boolean => {
    return proof.a.curveId === proof.b.curveId && proof.b.curveId === proof.c.curveId;
}

export const checkGroth16VerifyingKey = (vk: Groth16VerifyingKey): boolean => {
    if (vk.ic.length <= 1) {
        return false;
    }

    //check if ic points are different
    for (let i = 0; i < vk.ic.length; i++) {
        for (let j = i + 1; j < vk.ic.length; j++) {
            if (vk.ic[i]?.x === vk.ic[j]?.x && vk.ic[i]?.y === vk.ic[j]?.y && vk.ic[i]?.curveId === vk.ic[j]?.curveId) {
                return false;
            }
        }
        if (vk.ic[i]?.curveId !== vk.alpha.curveId) {
            return false;
        }
    }
    return vk.alpha.curveId === vk.beta.curveId && vk.beta.curveId === vk.gamma.curveId && vk.gamma.curveId === vk.delta.curveId;

}




// Helper: concatenate multiple Uint8Arrays
const concatBytes = (...arrays: Uint8Array[]): Uint8Array => {
    const totalLength = arrays.reduce((sum, arr) => sum + arr.length, 0);
    const result = new Uint8Array(totalLength);
    let offset = 0;
    for (const arr of arrays) {
        result.set(arr, offset);
        offset += arr.length;
    }
    return result;
};

// Helper: write uint32 as big-endian bytes
const uint32ToBE = (value: number): Uint8Array => {
    const arr = new Uint8Array(4);
    new DataView(arr.buffer).setUint32(0, value, false);
    return arr;
};

// Helper: write uint16 as big-endian bytes
const uint16ToBE = (value: number): Uint8Array => {
    const arr = new Uint8Array(2);
    new DataView(arr.buffer).setUint16(0, value, false);
    return arr;
};

// Helper: encode string to bytes
const stringToBytes = (str: string): Uint8Array => new TextEncoder().encode(str);

// Helper: bytes to hex string
const bytesToHex = (bytes: Uint8Array): string =>
    Array.from(bytes).map(b => b.toString(16).padStart(2, '0')).join('');

const digestReceiptClaim = (receipt: ReceiptClaim): Uint8Array => {
    const { tagDigest, input, preStateDigest, postStateDigest, output, exitCode } = receipt;

    const systemExitCodeBytes = uint32ToBE(exitCode.system << 24);
    const userExitCodeBytes = uint32ToBE(exitCode.user << 24);
    const twoBytes = uint16ToBE(4 << 8);

    const data = concatBytes(
        tagDigest!,
        input,
        preStateDigest,
        postStateDigest,
        output,
        systemExitCodeBytes,
        userExitCodeBytes,
        twoBytes
    );

    return createHash('sha256').update(data).digest();
}

function ok(imageId: Uint8Array, journalDigest: Uint8Array): ReceiptClaim {
    const exitCode: ExitCode = { system: 0, user: 0 };
    const output: Output = {
        journalDigest,
        assumptionsDigest: new Uint8Array(32)
    };

    return {
        tagDigest: createHash('sha256').update(stringToBytes("risc0.ReceiptClaim")).digest(),
        preStateDigest: imageId,
        postStateDigest: RISC0_SYSTEM_STATE_ZERO_DIGEST,
        exitCode,
        input: new Uint8Array(32),
        output: digestOutput(output),
    };
}


const digestOutput = (output: Output): Uint8Array => {
    const { journalDigest, assumptionsDigest } = output;

    const tagDigest = createHash('sha256').update(stringToBytes("risc0.Output")).digest();
    const twoBytes = uint16ToBE(512);

    const combined = concatBytes(
        tagDigest,
        journalDigest,
        assumptionsDigest,
        twoBytes
    );

    return createHash('sha256').update(combined).digest();
}

const reverseByteOrderUint256 = (value: bigint | Uint8Array): bigint => {
    let valueBytes: Uint8Array;

    if (typeof value === 'bigint') {
        const hexString = value.toString(16).padStart(64, '0');
        valueBytes = hexStringToBytes(hexString);
    } else {
        valueBytes = new Uint8Array(32);
        valueBytes.set(value.slice(0, 32), 0);
    }

    const reversedBytes = valueBytes.slice().reverse();
    return BigInt('0x' + bytesToHex(reversedBytes));
}

const splitDigest = (digest: bigint | Uint8Array): [bigint, bigint] => {
    const reversedDigest = reverseByteOrderUint256(digest);

    return split128(reversedDigest);
}

export const tryGuessingCurveIdFromJson = (data: Object): CurveId | null => {
    try {
        const curveId = findValueInStringToCurveId(findItemFromKeyPatterns(data, ['curve']));
        return curveId;
    } catch (err) {

        let x: bigint | null = null;

        for (let value in iterateNestedDictToArray(data)) {
            try {
                x = toBigInt(value);
                break;
            } catch (err) {
                continue;
            }
        }

        if (x == null || x == undefined) {
            throw new Error("No integer found in the JSON data.");
        }

        if (bitLength(x) > 256) {
            return CurveId.BLS12_381;
        } else {
            return CurveId.BN254;
        }
    }
}


const iterateNestedDictToArray = (d: any): any[] => {
    const result: any[] = [];
    for (const key in d) {
        if (Object.prototype.hasOwnProperty.call(d, key)) {
            const value = d[key];
            if (value && typeof value === 'object' && !Array.isArray(value)) {
                // Recursively collect values from nested objects
                result.push(...iterateNestedDictToArray(value));
            } else {
                // Add the value to the result array
                result.push(value);
            }
        }
    }
    return result;
}


const findItemFromKeyPatterns = (data: { [key: string]: any }, keyPatterns: string[]): any => {
    let bestMatch = null;
    let bestScore = -1;

    let bestMatchFound: boolean = false;


    Object.keys(data).forEach(key => {
        keyPatterns.forEach(pattern => {
            if (key.toLowerCase() == pattern.toLowerCase()) {
                bestMatch = data[key];
                bestMatchFound = true;
            }
            else if (!bestMatchFound && key.trim().toLowerCase().includes(pattern.trim().toLowerCase())) {
                //count number of matching character
                const re = new RegExp(pattern.toLowerCase(), 'g');
                const occurences = key.toLowerCase().match(re);
                const score = occurences ? occurences.length : 0;

                if (score > bestScore) {
                    bestScore = score;
                    bestMatch = data[key];
                }
            }
        });
    });

    if (bestMatch !== null) {
        return bestMatch;
    }
    throw new KeyPatternNotFoundError(`No key found with patterns ${keyPatterns}`);
}

export const getPFromCurveId = (curveId: CurveId): bigint => {
    return CURVES[curveId].p;
}

const projToAffine = (x: string | number | bigint | Uint8Array, y: string | number | bigint | Uint8Array,
    z: string | number | bigint | Uint8Array, curveId: CurveId): G1Point => {

    let xBigInt = toBigInt(x);
    let yBigInt = toBigInt(y);
    let zBigInt = toBigInt(z);

    const p = getPFromCurveId(curveId);

    zBigInt = modInverse(zBigInt, p);
    xBigInt = xBigInt * zBigInt % p;
    yBigInt = yBigInt * zBigInt % p;

    return {
        x: xBigInt,
        y: yBigInt,
        curveId
    }


}


const tryParseG1PointFromKey = (data: any, keyPatterns: string[], curveId: CurveId | null): G1Point => {
    const point = findItemFromKeyPatterns(data, keyPatterns);
    if (curveId === null || curveId === undefined) {
        throw new Error("Curve ID not provided");
    }
    return tryParseG1Point(point, curveId);
}


const tryParseG1Point = (point: any, curveId: CurveId): G1Point => {

    if (typeof point === "object" && !Array.isArray(point)) {
        const x = toBigInt(findItemFromKeyPatterns(point, ["x"]))
        const y = toBigInt(findItemFromKeyPatterns(point, ["y"]))
        return {
            x,
            y,
            curveId
        }
    } else if (Array.isArray(point)) {
        if (point.length == 2) {
            return {
                x: toBigInt(point[0]),
                y: toBigInt(point[1]),
                curveId
            }
        } else if (point.length == 3) {
            return projToAffine(point[0], point[1], point[2], curveId);
        }

        throw new Error(`Invalid point: ${point}`);
    } else {
        throw new Error(`Invalid point: ${point}`);
    }
}

const tryParseG2PointFromKey = (data: any, keyPatterns: string[], curveId: CurveId | null): G2Point => {
    const point = findItemFromKeyPatterns(data, keyPatterns);
    if (curveId === null || curveId === undefined) {
        throw new Error("Curve ID not provided");
    }
    return tryParseG2Point(point, curveId);
}


const tryParseG2Point = (point: any, curveId: CurveId): G2Point => {
    if (typeof point === "object" && !Array.isArray(point)) {
        const xG2 = findItemFromKeyPatterns(point, ["x"]);
        const yG2 = findItemFromKeyPatterns(point, ["y"]);

        if (typeof xG2 === "object" && typeof yG2 === "object" && !Array.isArray(xG2) && !Array.isArray(yG2)) {
            return {
                x: [
                    toBigInt(findItemFromKeyPatterns(xG2, ["a0"])),
                    toBigInt(findItemFromKeyPatterns(xG2, ["a1"]))
                ],
                y: [
                    toBigInt(findItemFromKeyPatterns(yG2, ["a0"])),
                    toBigInt(findItemFromKeyPatterns(yG2, ["a1"]))
                ],
                curveId: curveId
            };
        } else if (Array.isArray(xG2) && Array.isArray(yG2)) {
            return {
                x: [toBigInt(xG2[0]), toBigInt(xG2[1])],
                y: [toBigInt(yG2[0]), toBigInt(yG2[1])],
                curveId: curveId
            };
        } else {
            throw new Error(`Invalid point: ${point}`);
        }
    } else if (Array.isArray(point)) {
        let supposedX, supposedY;

        if (point.length === 2) {
            supposedX = point[0];
            supposedY = point[1];
        } else if (point.length === 3) {
            const check = [
                toBigInt(point[2][0]),
                toBigInt(point[2][1])
            ];
            if (check[0] !== 1n || check[1] !== 0n) {
                throw new Error("Non standard projective coordinates");
            }
            supposedX = point[0];
            supposedY = point[1];
        }

        if (Array.isArray(supposedX)) {
            if (supposedX.length !== 2) {
                throw new Error(`Invalid fp2 coordinates: ${supposedX}`);
            }
            supposedX = [toBigInt(supposedX[0]), toBigInt(supposedX[1])];
        }
        if (Array.isArray(supposedY)) {
            if (supposedY.length !== 2) {
                throw new Error(`Invalid fp2 coordinates: ${supposedY}`);
            }
            supposedY = [toBigInt(supposedY[0]), toBigInt(supposedY[1])];
        }

        return {
            x: supposedX,
            y: supposedY,
            curveId: curveId
        };
    } else {
        throw new Error(`Invalid point: ${point}`);
    }
}

export const createGroth16ProofFromSp1 = (vkey: Uint8Array, publicValues: Uint8Array, proof: Uint8Array): Groth16Proof => {
    // SP1 version checking - first 4 bytes should match expected hash
    const sp1VerifierHashBytes = hexStringToBytes(SP1_VERIFIER_HASH);
    const selector = proof.slice(0, 4);
    const expectedSelector = sp1VerifierHashBytes.slice(0, 4);

    if (!selector.every((byte, index) => byte === expectedSelector[index])) {
        throw new Error(`Invalid SP1 proof version. Expected ${Array.from(expectedSelector).map(b => b.toString(16).padStart(2, '0')).join('')} for version ${SP1_VERIFIER_VERSION}, got ${Array.from(selector).map(b => b.toString(16).padStart(2, '0')).join('')}`);
    }

    if (publicValues.length % 32 !== 0) {
        throw new Error("SP1 public values must be a multiple of 32 bytes");
    }

    // Hash public values and take mod 2^253
    const pubInputHash = createHash("sha256").update(publicValues).digest();
    const power253 = 1n << 253n; // 2^253 using bit shift
    const pubInputHashBigInt = toBigInt(pubInputHash) % power253;

    const actualProof = proof.slice(4);

    const groth16Proof: Groth16Proof = {
        a: {
            x: toBigInt(actualProof.slice(0, 32)),
            y: toBigInt(actualProof.slice(32, 64)),
            curveId: CurveId.BN254
        },
        b: {
            x: [
                toBigInt(actualProof.slice(96, 128)),
                toBigInt(actualProof.slice(64, 96))
            ],
            y: [
                toBigInt(actualProof.slice(160, 192)),
                toBigInt(actualProof.slice(128, 160))
            ],
            curveId: CurveId.BN254
        },
        c: {
            x: toBigInt(actualProof.slice(192, 224)),
            y: toBigInt(actualProof.slice(224, 256)),
            curveId: CurveId.BN254
        },
        publicInputs: [
            toBigInt(vkey),
            pubInputHashBigInt
        ],
        vkeyPublicValuesSp1: {
            vkey,
            publicValues
        }
    };

    if (checkGroth16Proof(groth16Proof)) {
        return groth16Proof;
    }

    throw new Error(`Invalid SP1 Groth16 proof: ${groth16Proof}`);
};
