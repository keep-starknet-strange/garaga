import sys, os
cwd = os.getcwd()
sys.path.append(cwd)

DEGREE=3
BASE=2**96
def split(x, degree=DEGREE, base=BASE):
    coeffs = []
    for n in range(degree, 0, -1):
        q, r = divmod(x, base ** n)
        coeffs.append(q)
        x = r
    coeffs.append(x)
    return coeffs[::-1]

def write(data:list, path=""):
    file = open(path, 'w+')
    code="""\
from starkware.cairo.common.registers import get_label_location, get_fp_and_pc
from src.bls12_381.fq import BigInt4
from src.bls12_381.towers.e2 import E2
from src.bls12_381.g2 import G2Point, E4

func get_nQ_lines(n: felt) -> (pt: G2Point*, lines: E4*) {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    let (data) = get_label_location(nQ_lines);
    let nQ_array = cast(data, felt*);
    let i0 = 32 * n + 0;
    let i1 = 32 * n + 1;
    let i2 = 32 * n + 2;
    let i3 = 32 * n + 3;
    let i4 = 32 * n + 4;
    let i5 = 32 * n + 5;
    let i6 = 32 * n + 6;
    let i7 = 32 * n + 7;
    let i8 = 32 * n + 8;
    let i9 = 32 * n + 9;
    let i10 = 32 * n + 10;
    let i11 = 32 * n + 11;
    let i12 = 32 * n + 12;
    let i13 = 32 * n + 13;
    let i14 = 32 * n + 14;
    let i15 = 32 * n + 15;
    let i16 = 32 * n + 16;
    let i17 = 32 * n + 17;
    let i18 = 32 * n + 18;
    let i19 = 32 * n + 19;
    let i20 = 32 * n + 20;
    let i21 = 32 * n + 21;
    let i22 = 32 * n + 22;
    let i23 = 32 * n + 23;
    let i24 = 32 * n + 24;
    let i25 = 32 * n + 25;
    let i26 = 32 * n + 26;
    let i27 = 32 * n + 27;
    let i28 = 32 * n + 28;
    let i29 = 32 * n + 29;
    let i30 = 32 * n + 30;
    let i31 = 32 * n + 31;

    local Qx0: BigInt4 = BigInt4(nQ_array[i0], nQ_array[i1], nQ_array[i2], nQ_array[i3]);
    local Qx1: BigInt4 = BigInt4(nQ_array[i4], nQ_array[i5], nQ_array[i6], nQ_array[i7]);
    local Qy0: BigInt4 = BigInt4(nQ_array[i8], nQ_array[i9], nQ_array[i10], nQ_array[i11]);
    local Qy1: BigInt4 = BigInt4(nQ_array[i12], nQ_array[i13], nQ_array[i14], nQ_array[i15]);
    local lr0_a0: BigInt4 = BigInt4(nQ_array[i16], nQ_array[i17], nQ_array[i18], nQ_array[i19]);
    local lr0_a1: BigInt4 = BigInt4(nQ_array[i20], nQ_array[i21], nQ_array[i22], nQ_array[i23]);
    local lr1_a0: BigInt4 = BigInt4(nQ_array[i24], nQ_array[i25], nQ_array[i26], nQ_array[i27]);
    local lr1_a1: BigInt4 = BigInt4(nQ_array[i28], nQ_array[i29], nQ_array[i30], nQ_array[i31]);
    local Qx:E2 = E2(&Qx0, &Qx1);
    local Qy:E2 = E2(&Qy0, &Qy1);
    local Q: G2Point = G2Point(&Qx, &Qy);
    local lr0:E2 = E2(&lr0_a0, &lr0_a1);
    local lr1:E2 = E2(&lr1_a0, &lr1_a1);
    local l:E4 = E4(&lr0, &lr1);

    return (&Q, &l);
    nQ_lines:
""" 
    file.write(code)
    print(f"Writing {len(data)} Q points and lines to {path}...")
    for felts in data:
        file.write('\n')
        for x in felts:
            file.write('    ' + 'dw '+str(x)+';\n')
    file.write('}\n')
    file.close()