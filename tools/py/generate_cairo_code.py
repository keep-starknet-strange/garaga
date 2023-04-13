import sys, os
cwd = os.getcwd()
sys.path.append(cwd)

from tools.py.bn128_field import FQ, FQ2, FQ12, field_modulus
from tools.py.bn128_curve import twist, G2, G12, add, double, multiply, curve_order, neg
from tools.py.bn128_pairing import log_ate_loop_count, ate_loop_count


def split(num):
    BASE = 2 ** 86
    a = []
    for _ in range(3):
        num, residue = divmod(num, BASE)
        a.append(residue)
    assert num == 0
    return a

def gen_range_checks():
    for i in range(12):
        for j in range(3):
            print(f'[range_check_ptr - {3*i+j + 1}] = res.e{i:X}.d{j}; ap++')

def gen_diff():
    print("let x_diff = FQ12(")
    for i in range(12):
        print('\tBigInt3(', end="")
        tmp = []
        for j in range(3):
            tmp.append(f'd{j}=pt0.x.e{i:X}.d{j} - pt1.x.e{i:X}.d{j}')
        print(", ".join(tmp) + "),")
    print("\t)")

def cairo_bigint3(x):
    res = 'BigInt3('
    tmp = []
    for i,x in enumerate(split(x)):
        tmp.append(f'd{i}={x}')
    res += ", ".join(tmp) + ")"
    return res

def cairo_FQ2(x):
    res = "FQ2(\n\t"
    res += cairo_bigint3(x.coeffs[0].n) 
    res += ", "
    res += cairo_bigint3(x.coeffs[1].n) 
    res += ')'
    return res

def cairo_G2(pt):
    res = "G2Point(\n"
    res += "\t" + cairo_FQ2(pt[0]) + ",\n"
    res += "\t" + cairo_FQ2(pt[1]) 
    res += ")"
    return res

def cairo_FQ12(x):
    res = "FQ12(\n\t"
    for i in range(12):

        res += cairo_bigint3(x.coeffs[i].n) 
        res += ", "
        if i % 3 == 2:
            res += '\n\t'
    res += ')'
    return res

def cairo_G12(pt):
    res = "GTPoint(\n"
    res += "\t" + cairo_FQ12(pt[0]) + ",\n"
    res += "\t" + cairo_FQ12(pt[1]) 
    res += ")"
    return res

def cairo_G12_constants():
    one, two, three = G12, double(G12), multiply(G12, 3)
    negone, negtwo, negthree = multiply(G12, curve_order - 1), multiply(G12, curve_order - 2), multiply(G12, curve_order - 3)

    for pt in [two, three, negone, negtwo, negthree]:
        print(cairo_G12(pt))

def ate_loop_count_bits():
    bits = []
    for i in range(log_ate_loop_count, -1, -1):
        if ate_loop_count & (2**i):
            bits.append(1)
        else:
            bits.append(0)
        print(i, bits[-1])
    return bits

def cairo_loop_bits():
    print(f'{ate_loop_count:b}', len(f'{ate_loop_count:b}'))
    bits = ate_loop_count_bits()
    print("".join(map(str, bits)))
    print(bits)

    for b in bits[::-1]:
        print(f'dw {b}')
    print(len(bits))

def cairo_final_exponent():
    num = (field_modulus ** 12 - 1 ) // curve_order
    BASE = 2 ** (86*3)
    a = []
    for _ in range(12):
        num, residue = divmod(num, BASE)
        a.append(residue)
    assert num == 0

    res = "FQ12(\n\t"
    for i in range(12):
        res += cairo_bigint3(a[i]) 
        res += ", "
        if i % 3 == 2:
            res += '\n\t'
    res += ')'
    return res

def gen_diff23():
    print("let x_diff = UnreducedFQ23(")
    for i in range(23):
        print('\tUnreducedBigInt5(', end="")
        tmp = []
        for j in range(5):
            tmp.append(f'pt0.x.e{i:02X}.d{j} + pt1.x.e{i:02X}.d{j}')
        print(", ".join(tmp) + "),")
    print("\t)")

def gen_diff12_23():
    print("let x_diff = UnreducedFQ23(")
    for i in range(23):
        tmp = []
        if i < 12:
            print('\tUnreducedBigInt5(', end="")
            for j in range(5):
                tmp.append(f'pt0.x.e{i:02X}.d{j} - pt1.x.e{i:X}.d{j}')
            print(", ".join(tmp) + "),")
        else: 
            print(f'\tpt0.e{i:02X},')
        
    print("\t)")

# cairo_loop_bits()
# cairo_G12_constants()
# print(cairo_final_exponent())
# print(cairo_G2(neg(G2)))
# ufq12mul()
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