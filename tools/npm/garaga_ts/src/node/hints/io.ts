

export const toBigInt = (value: string | bigint | number | Uint8Array): bigint => {
    //Convert a string or integer to an integer. Supports hexadecimal and decimal strings.

    if (typeof value === 'string') {
        value = value.trim();
        try {
            return BigInt(value);
          } catch (e) {
            if (value.toLowerCase().startsWith('0x')) {
              throw new Error(`Invalid hexadecimal value: ${value}`);
            } else {
              throw new Error(`Invalid decimal value: ${value}`);
            }
          }
    } else if (typeof value === 'bigint') {
        return value;
    } else if (typeof value === 'number') {
        if (Number.isInteger(value)) {
            return BigInt(value);
        } else {
            throw new TypeError(`Expected integer number, got non-integer number: ${value}`);
        }
    } else if (value instanceof Uint8Array) {
    let result = BigInt(0);
    for (const byte of value) {
        result = (result << 8n) + BigInt(byte);
    }
    return result;
    } else {
        throw new TypeError(
            `Expected string, number, or Uint8Array, got ${typeof value}`
        );
    }
}

export const toHexStr = (value: string | number | bigint): string => {
    if (typeof value === 'string') {
      value = value.trim();

      const intValue = BigInt(value);

      return ('0x' + intValue.toString(16)).toLowerCase();
    } else if (typeof value === 'number' || typeof value === 'bigint') {
      const intValue = BigInt(value);

      return ('0x' + intValue.toString(16)).toLowerCase();
    } else {
      throw new TypeError(`Expected string, number integer, or bigint, got ${typeof value}`);
    }
}

export const hexStringToBytes = (hexString: string): Uint8Array => {
    if (hexString.toLowerCase().startsWith('0x')) {
      hexString = hexString.slice(2);
    }
    if (hexString.length % 2 !== 0) {
      hexString = '0' + hexString;
    }
    const bytes = new Uint8Array(hexString.length / 2);
    for (let i = 0; i < bytes.length; i++) {
      const byte = hexString.slice(i * 2, i * 2 + 2);
      bytes[i] = parseInt(byte, 16);
    }
    return bytes;
}

export const bitLength = (x: bigint): number => {
    if (x === 0n || x === -0n) {
      return 0;
    }
    let bits = 0;
    let n = x < 0n ? -x : x; // Handle negative numbers
    while (n > 0n) {
      n >>= 1n;
      bits++;
    }
    return bits;
}

export const split128 = (a: bigint): [bigint, bigint] => {
  try{

    console.log("a bigint", a);

    const MAX_UINT256 = 115792089237316195423570985008687907853269984665640564039457584007913129639936n;

    const MASK_128 = BigInt((1n << 128n) - 1n);

    if (a < 0n || a >= MAX_UINT256) {
        throw new Error(`Value ${a} is too large to fit in a u256`);
    }

    const low = a & MASK_128;
    const high = a >> BigInt(128);

    return [low, high];
  } catch(err){
    console.log("ERR split 128: ", err);
    throw new Error("ERROR split 128")
  }
}

export const  modInverse = (a: bigint, p: bigint): bigint => {
    let m0 = p;
    let y = BigInt(0), x = BigInt(1);

    if (p === BigInt(1)) {
        return BigInt(0);
    }

    while (a > BigInt(1)) {
        // q is quotient
        let q = a / p;
        let t = p;

        // p is remainder now, process same as Euclid's algorithm
        p = a % p;
        a = t;
        t = y;

        // Update x and y
        y = x - q * y;
        x = t;
    }

    // Make x positive
    if (x < BigInt(0)) {
        x = x + m0;
    }

    return x;
}
