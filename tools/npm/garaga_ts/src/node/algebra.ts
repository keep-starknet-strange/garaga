

export class TsFelt {
    value: bigint;
    p: bigint;

    constructor(value: bigint, p: bigint) {
        this.value = value;
        this.p = p;
    }

    get felt(): TsFelt {
        return this;
    }

    toString(): string {
        let pStr = `0x${this.p.toString(16)}`;
        if (pStr.length > 10) {
            pStr = `${pStr.slice(0, 6)}...${pStr.slice(-4)}`;
        }
        return `TsFelt(${this.value}, ${pStr})`;
    }

    add(right: TsFelt | bigint): TsFelt {
        const p = this.p;
        if (right instanceof TsFelt) {
            return new TsFelt((this.value + right.value) % p, p);
        }
        if (typeof right === 'bigint') {
            return new TsFelt((this.value + right) % p, p);
        }
        throw new TypeError(`Cannot add TsFelt and ${typeof right}`);
    }

    negate(): TsFelt {
        const p = this.p;
        return new TsFelt((-this.value % p + p) % p, p);
    }

    sub(right: TsFelt | bigint): TsFelt {
        const p = this.p;
        if (right instanceof TsFelt) {
            return new TsFelt((this.value - right.value) % p, p);
        }
        if (typeof right === 'bigint') {
            return new TsFelt((this.value - right) % p, p);
        }
        throw new TypeError(`Cannot subtract TsFelt and ${typeof right}`);
    }

    mul(right: TsFelt | bigint): TsFelt {
        const p = this.p;
        if (right instanceof TsFelt) {
            return new TsFelt((this.value * right.value) % p, p);
        }
        if (typeof right === 'bigint') {
            return new TsFelt((this.value * right) % p, p);
        }
        throw new TypeError(`Cannot multiply TsFelt and ${typeof right}`);
    }

    inv(): TsFelt {
        try {
            const inv = this.modInverse(this.value, this.p);
            return new TsFelt(inv, this.p);
        } catch (error) {
            throw new Error(`Cannot invert ${this.value} modulo ${this.p}`);
        }
    }

    div(right: TsFelt): TsFelt {
        if (right instanceof TsFelt) {
            return this.mul(right.inv());
        }
        throw new TypeError(`Cannot divide TsFelt and ${typeof right}`);
    }

    pow(exponent: bigint): TsFelt {
        return new TsFelt(this.modPow(this.value, exponent, this.p), this.p);
    }

    equals(other: TsFelt | bigint): boolean {
        if (other instanceof TsFelt) {
            return this.value === other.value;
        }
        if (typeof other === 'bigint') {
            return this.value === other;
        }
        throw new TypeError(`Cannot compare TsFelt and ${typeof other}`);
    }

    // Helper function to calculate modular inverse using extended Euclidean algorithm
    private modInverse(a: bigint, m: bigint): bigint {
        let [m0, x0, x1] = [m, BigInt(0), BigInt(1)];
        if (m === BigInt(1)) return BigInt(0);
        while (a > BigInt(1)) {
            const q = a / m;
            [m, a] = [a % m, m];
            [x0, x1] = [x1 - q * x0, x0];
        }
        return x1 < BigInt(0) ? x1 + m0 : x1;
    }

    // Helper function for modular exponentiation
    private modPow(base: bigint, exp: bigint, mod: bigint): bigint {
        let result = BigInt(1);
        base = base % mod;
        while (exp > BigInt(0)) {
            if (exp % BigInt(2) === BigInt(1)) {
                result = (result * base) % mod;
            }
            exp = exp / BigInt(2);
            base = (base * base) % mod;
        }
        return result;
    }
}


export interface ModuloCircuitElement {
    emulatedFelt: TsFelt;
    offset: bigint;
}
