## File: [src/fustat/utils.cairo](https://github.com/keep-starknet-strange/garaga/blob/main/src/fustat//utils.cairo)

### func: hash_full_transcript_and_get_Z_3_LIMBS

- **[Lines 46-51](https://github.com/keep-starknet-strange/garaga/blob/main/src/fustat//utils.cairo#L46-L51)**

```python
//     from garaga.hints.io import pack_bigint_ptr
//     to_hash=pack_bigint_ptr(memory, ids.limbs_ptr, ids.N_LIMBS, ids.BASE, ids.n)
//     for e in to_hash:
//         print(f"Will Hash {hex(e)}")

```

- **[Lines 61-61](https://github.com/keep-starknet-strange/garaga/blob/main/src/fustat//utils.cairo#L61-L61)**

```python
ids.elements_end - ids.elements >= 6*ids.N_LIMBS
```

- **[Lines 63-68](https://github.com/keep-starknet-strange/garaga/blob/main/src/fustat//utils.cairo#L63-L68)**

```python
//     from garaga.hints.io import pack_bigint_ptr
//     to_hash=pack_bigint_ptr(memory, ids.elements, ids.N_LIMBS, ids.BASE, 6)
//     for e in to_hash:
//         print(f"\t Will Hash {hex(e)}")

```

- **[Lines 100-100](https://github.com/keep-starknet-strange/garaga/blob/main/src/fustat//utils.cairo#L100-L100)**

```python
ids.elements_end - ids.elements >= ids.N_LIMBS
```

- **[Lines 101-106](https://github.com/keep-starknet-strange/garaga/blob/main/src/fustat//utils.cairo#L101-L106)**

```python
//     from garaga.hints.io import pack_bigint_ptr
//     to_hash=pack_bigint_ptr(memory, ids.elements, ids.N_LIMBS, ids.BASE, 1)
//     for e in to_hash:
//         print(f"\t\t Will Hash {e}")

```

### func: hash_full_transcript_and_get_Z_4_LIMBS

- **[Lines 130-135](https://github.com/keep-starknet-strange/garaga/blob/main/src/fustat//utils.cairo#L130-L135)**

```python
//     from garaga.hints.io import pack_bigint_ptr
//     to_hash=pack_bigint_ptr(memory, ids.limbs_ptr, ids.N_LIMBS, ids.BASE, ids.n)
//     for e in to_hash:
//         print(f"Will Hash {hex(e)}")

```

- **[Lines 145-145](https://github.com/keep-starknet-strange/garaga/blob/main/src/fustat//utils.cairo#L145-L145)**
<<<<<<< HEAD

```python
ids.elements_end - ids.elements >= 6*ids.N_LIMBS
```

- **[Lines 147-152](https://github.com/keep-starknet-strange/garaga/blob/main/src/fustat//utils.cairo#L147-L152)**

```python
=======

```python
ids.elements_end - ids.elements >= 6*ids.N_LIMBS
```

- **[Lines 147-152](https://github.com/keep-starknet-strange/garaga/blob/main/src/fustat//utils.cairo#L147-L152)**

```python
//     from garaga.hints.io import pack_bigint_ptr
//     to_hash=pack_bigint_ptr(memory, ids.elements, ids.N_LIMBS, ids.BASE, 6)
//     for e in to_hash:
//         print(f"\t Will Hash {hex(e)}")

```

- **[Lines 184-184](https://github.com/keep-starknet-strange/garaga/blob/main/src/fustat//utils.cairo#L184-L184)**

```python
ids.elements_end - ids.elements >= ids.N_LIMBS
```

- **[Lines 185-190](https://github.com/keep-starknet-strange/garaga/blob/main/src/fustat//utils.cairo#L185-L190)**

```python
//     from garaga.hints.io import pack_bigint_ptr
//     to_hash=pack_bigint_ptr(memory, ids.elements, ids.N_LIMBS, ids.BASE, 1)
//     for e in to_hash:
//         print(f"\t\t Will Hash {hex(e)}")
<<<<<<< HEAD

```

- **[Lines 206-206](https://github.com/keep-starknet-strange/garaga/blob/main/src/fustat//utils.cairo#L206-L206)**
=======
>>>>>>> a504e556e4f9731d65815eff327cc8f5dd654411

```python
print(f"res {hex(ids.res)}")
```

- **[Lines 206-206](https://github.com/keep-starknet-strange/garaga/blob/main/src/fustat//utils.cairo#L206-L206)**

```python
print(f"res {hex(ids.res)}")
```

### func: retrieve_random_coefficients

- **[Lines 217-217](https://github.com/keep-starknet-strange/garaga/blob/main/src/fustat//utils.cairo#L217-L217)**

```python
i=0
```

- **[Lines 225-228](https://github.com/keep-starknet-strange/garaga/blob/main/src/fustat//utils.cairo#L225-L228)**

```python
i+=1
memory[ap] = 1 if i == ids.n else 0

```

- **[Lines 237-242](https://github.com/keep-starknet-strange/garaga/blob/main/src/fustat//utils.cairo#L237-L242)**

```python
//     from garaga.hints.io import pack_bigint_ptr
//     array=pack_bigint_ptr(memory, ids.coefficients, 1, ids.BASE, ids.n)
//     for i,e in enumerate(array):
//         print(f"CAIRO Using c_{i} = {hex(e)}")

```

### func: write_felts_to_value_segment

- **[Lines 251-251](https://github.com/keep-starknet-strange/garaga/blob/main/src/fustat//utils.cairo#L251-L251)**

```python
i=0
```

- **[Lines 258-261](https://github.com/keep-starknet-strange/garaga/blob/main/src/fustat//utils.cairo#L258-L261)**

```python
memory[ap] = 1 if i == ids.n else 0
i+=1

```

- **[Lines 267-273](https://github.com/keep-starknet-strange/garaga/blob/main/src/fustat//utils.cairo#L267-L273)**

```python
from garaga.hints.io import bigint_split
felt_val = memory[ids.values_start+i-1]
limbs = bigint_split(felt_val, ids.N_LIMBS, ids.BASE)
assert limbs[3] == 0
ids.d0, ids.d1, ids.d2 = limbs[0], limbs[1], limbs[2]

```

### func: felt_to_UInt384

- **[Lines 300-305](https://github.com/keep-starknet-strange/garaga/blob/main/src/fustat//utils.cairo#L300-L305)**

```python
from garaga.hints.io import bigint_split
limbs = bigint_split(ids.x, ids.N_LIMBS, ids.BASE)
assert limbs[3] == 0
ids.d0, ids.d1, ids.d2 = limbs[0], limbs[1], limbs[2]

```

### func: retrieve_output

- **[Lines 333-333](https://github.com/keep-starknet-strange/garaga/blob/main/src/fustat//utils.cairo#L333-L333)**

```python
print(f"Continuous output! start value : {hex(memory[ids.values_segment + ids.offset])} Size: {ids.n//4} offset:{ids.offset}")
```

- **[Lines 348-352](https://github.com/keep-starknet-strange/garaga/blob/main/src/fustat//utils.cairo#L348-L352)**

```python
index = memory[ids.output_offsets_ptr+ids.i]
# print(f"Output {ids.i}/{ids.n} Index : {index}")
memory[ap] = 1 if ids.i == ids.n else 0

```

### func: sign

- **[Lines 420-423](https://github.com/keep-starknet-strange/garaga/blob/main/src/fustat//utils.cairo#L420-L423)**

```python
from starkware.cairo.common.math_utils import as_int
ids.is_positive = 1 if as_int(ids.value, PRIME) >= 0 else 0

```

### func: scalar_to_base_neg3_le

- **[Lines 445-453](https://github.com/keep-starknet-strange/garaga/blob/main/src/fustat//utils.cairo#L445-L453)**

```python
from garaga.hints.neg_3 import neg_3_base_le, positive_negative_multiplicities
digits = neg_3_base_le(ids.scalar)
digits = digits + [0] * (82-len(digits))
segments.write_arg(ids.digits, digits)
pos, neg = positive_negative_multiplicities(digits)
assert pos - neg == ids.scalar

```

- **[Lines 476-476](https://github.com/keep-starknet-strange/garaga/blob/main/src/fustat//utils.cairo#L476-L476)**

```python
memory[ap] = 1 if ids.i == 82 else 0
```

- **[Lines 478-482](https://github.com/keep-starknet-strange/garaga/blob/main/src/fustat//utils.cairo#L478-L482)**

```python
//     print(f"{memory[ids.digits+ids.i]=}")
//     print(f"\t {ids.sum_p=}")
//     print(f"\t {ids.sum_n=}")

```

- **[Lines 509-513](https://github.com/keep-starknet-strange/garaga/blob/main/src/fustat//utils.cairo#L509-L513)**

```python
//     from starkware.cairo.common.math_utils import as_int
//     print(f"{as_int(ids.sum_p, PRIME)=}")
//     print(f"{as_int(ids.sum_n, PRIME)=}")

```

## File: [src/fustat/pairing.cairo](https://github.com/keep-starknet-strange/garaga/blob/main/src/fustat//pairing.cairo)

### func: final_exponentiation

- **[Lines 107-111](https://github.com/keep-starknet-strange/garaga/blob/main/src/fustat//pairing.cairo#L107-L111)**

```python
//     part1 = pack_bigint_ptr(memory, ids.output, 4, 2**96, ids.circuit.output_len//4)
//     for x in part1:
//         print(f"T0/T2/_SUM = {hex(x)}")

```

## File: [src/fustat/definitions.cairo](https://github.com/keep-starknet-strange/garaga/blob/main/src/fustat//definitions.cairo)

### func: is_zero_mod_P

- **[Lines 427-432](https://github.com/keep-starknet-strange/garaga/blob/main/src/fustat//definitions.cairo#L427-L432)**

```python
from garaga.hints.io import bigint_pack
x = bigint_pack(ids.x, 4, 2**96)
p = bigint_pack(ids.p, 4, 2**96)
x=x%p

```

- **[Lines 433-433](https://github.com/keep-starknet-strange/garaga/blob/main/src/fustat//definitions.cairo#L433-L433)**

```python
x == 0
```

- **[Lines 439-442](https://github.com/keep-starknet-strange/garaga/blob/main/src/fustat//definitions.cairo#L439-L442)**

```python
from garaga.hints.io import bigint_fill
bigint_fill(pow(x, -1, p), ids.x_inv, ids.N_LIMBS, ids.BASE)

```

### func: verify_zero4

- **[Lines 471-480](https://github.com/keep-starknet-strange/garaga/blob/main/src/fustat//definitions.cairo#L471-L480)**

```python
from garaga.hints.io import bigint_pack
x = bigint_pack(ids.x, 4, 2**96)
p = bigint_pack(ids.p, 4, 2**96)
q, r = divmod(x, p)
assert r == 0, f"verify_zero: Invalid input."
ids.q=q

```

### func: verify_zero7

- **[Lines 504-513](https://github.com/keep-starknet-strange/garaga/blob/main/src/fustat//definitions.cairo#L504-L513)**

```python
from garaga.hints.io import bigint_pack, bigint_fill
val = bigint_pack(ids.val, 7, 2**96)
p = bigint_pack(ids.p, 4, 2**96)
q, r = divmod(val, p)
assert r == 0, f"verify_zero: Invalid input {val%p}."
bigint_fill(q, ids.q, ids.N_LIMBS, ids.BASE)

```

## File: [src/fustat/ec_ops.cairo](https://github.com/keep-starknet-strange/garaga/blob/main/src/fustat//ec_ops.cairo)

### func: derive_EC_point_from_entropy

- **[Lines 147-147](https://github.com/keep-starknet-strange/garaga/blob/main/src/fustat//ec_ops.cairo#L147-L147)**

```python
print(f"Attempt : {ids.attempt}")
```

- **[Lines 159-167](https://github.com/keep-starknet-strange/garaga/blob/main/src/fustat//ec_ops.cairo#L159-L167)**

```python
from starkware.python.math_utils import is_quad_residue
from garaga.definitions import CURVES
a = CURVES[ids.curve_id].a
b = CURVES[ids.curve_id].b
p = CURVES[ids.curve_id].p
rhs = (ids.entropy**3 + a*ids.entropy + b) % p
ids.rhs_from_x_is_a_square_residue = is_quad_residue(rhs, p)

```

### func: compute_RHS_basis_sum

- **[Lines 275-282](https://github.com/keep-starknet-strange/garaga/blob/main/src/fustat//ec_ops.cairo#L275-L282)**

```python
//     from garaga.hints.io import bigint_pack
//     print(f"RHS INDEX : {ids.index}")
//     print(f"ep: {bigint_pack(ids.ep, 4, 2**96)}")
//     print(f"en: {bigint_pack(ids.en, 4, 2**96)}")
//     print(f"sp: {bigint_pack(ids.sp, 4, 2**96)}")
//     print(f"sn: {bigint_pack(ids.sn, 4, 2**96)}")

```

- **[Lines 290-293](https://github.com/keep-starknet-strange/garaga/blob/main/src/fustat//ec_ops.cairo#L290-L293)**

```python
//     from garaga.hints.io import bigint_pack
//     print(f"rhs_acc_intermediate: {bigint_pack(ids.new_sum, 4, 2**96)}")

```

### func: msm

- **[Lines 389-421](https://github.com/keep-starknet-strange/garaga/blob/main/src/fustat//ec_ops.cairo#L389-L421)**

```python
from tools.ecip_cli import EcipCLI
from garaga.hints.io import pack_bigint_ptr, pack_felt_ptr, fill_sum_dlog_div, fill_g1_point
from garaga.hints.neg_3 import construct_digit_vectors
import time
cli = EcipCLI(CurveID(ids.curve_id))
points = pack_bigint_ptr(memory, ids.points._reference_value, ids.N_LIMBS, ids.BASE, 2*ids.n)
points = list(zip(points[0::2], points[1::2]))
scalars = pack_felt_ptr(memory, ids.scalars._reference_value, 2*ids.n)
scalars_low, scalars_high = scalars[0::2], scalars[1::2]
dss_low = construct_digit_vectors(scalars_low)
dss_high = construct_digit_vectors(scalars_high)
dss_shifted = construct_digit_vectors([2**128])
print(f"\nComputing MSM with {ids.n} input points!")
t0=time.time()
print(f"Deriving the Sums of logarithmic derivatives of elliptic curve Diviors interpolating the {ids.n} input points with multiplicities...")
Q_low, SumDlogDivLow = cli.ecip_functions(points, dss_low)
Q_high, SumDlogDivHigh = cli.ecip_functions(points, dss_high)
Q_high_shifted, SumDlogDivShifted = cli.ecip_functions([Q_high], dss_shifted)
print(f"Time taken: {time.time() - t0}s")
print(f"Filling Function Field elements and results point")
t0=time.time()
fill_sum_dlog_div(SumDlogDivLow, ids.n, ids.SumDlogDivLow, segments)
fill_sum_dlog_div(SumDlogDivHigh, ids.n, ids.SumDlogDivHigh, segments)
fill_sum_dlog_div(SumDlogDivShifted, 1, ids.SumDlogDivShifted, segments)
fill_g1_point(Q_low, ids.Q_low)
fill_g1_point(Q_high, ids.Q_high)
fill_g1_point(Q_high_shifted, ids.Q_high_shifted)
print(f"Hashing Z = Poseidon(Input, Commitments) = Hash(Points, scalars, Q_low, Q_high, Q_high_shifted, SumDlogDivLow, SumDlogDivHigh, SumDlogDivShifted)...")

```

### func: tions

- **[Lines 449-449](https://github.com/keep-starknet-strange/garaga/blob/main/src/fustat//ec_ops.cairo#L449-L449)**

```python
print(f"Deriving random EC point for challenge from Z...")
```

### func: tion_challenge_circuit_shifted: ModuloCircuit*

- **[Lines 472-472](https://github.com/keep-starknet-strange/garaga/blob/main/src/fustat//ec_ops.cairo#L472-L472)**

```python
print(f"Verifying ZK-ECIP equations evaluated at the random point...")
```

### func: tion_challenge_circuit=eval_

- **[Lines 515-515](https://github.com/keep-starknet-strange/garaga/blob/main/src/fustat//ec_ops.cairo#L515-L515)**

```python
print(f"MSM Verification complete!\n Computing result = Q_low + Q_high_shifted")
```

- **[Lines 615-619](https://github.com/keep-starknet-strange/garaga/blob/main/src/fustat//ec_ops.cairo#L615-L619)**

```python
//     from garaga.hints.io import bigint_pack
//     print(f"LHS: {bigint_pack(ids.LHS, 4, 2**96)}")
//     print(f"RHS: {bigint_pack(ids.RHS, 4, 2**96)}")

```

## File: [src/fustat/modulo_circuit.cairo](https://github.com/keep-starknet-strange/garaga/blob/main/src/fustat//modulo_circuit.cairo)

### func: run_modulo_circuit

- **[Lines 68-81](https://github.com/keep-starknet-strange/garaga/blob/main/src/fustat//modulo_circuit.cairo#L68-L81)**

```python
from garaga.precompiled_circuits.all_circuits import ALL_FUSTAT_CIRCUITS, CircuitID
from garaga.hints.io import pack_bigint_ptr, fill_felt_ptr, flatten, bigint_split
from garaga.definitions import CURVES, PyFelt
p = CURVES[ids.circuit.curve_id].p
circuit_input = pack_bigint_ptr(memory, ids.input, ids.N_LIMBS, ids.BASE, ids.circuit.input_len//ids.N_LIMBS)
MOD_CIRCUIT = ALL_FUSTAT_CIRCUITS[CircuitID(ids.circuit.name)]['class'](ids.circuit.curve_id, auto_run=False)
MOD_CIRCUIT = MOD_CIRCUIT.run_circuit(circuit_input)
witnesses = flatten([bigint_split(x.value, ids.N_LIMBS, ids.BASE) for x in MOD_CIRCUIT.witnesses])
fill_felt_ptr(x=witnesses, memory=memory, address=ids.range_check96_ptr + ids.circuit.constants_ptr_len * ids.N_LIMBS + ids.circuit.input_len)
#MOD_CIRCUIT.print_value_segment()

```

### func: run_extension_field_modulo_circuit

- **[Lines 131-147](https://github.com/keep-starknet-strange/garaga/blob/main/src/fustat//modulo_circuit.cairo#L131-L147)**

```python
from garaga.precompiled_circuits.all_circuits import ALL_FUSTAT_CIRCUITS, CircuitID
from garaga.hints.io import bigint_split, pack_bigint_ptr, fill_felt_ptr, flatten
circuit_input = pack_bigint_ptr(memory, ids.input, ids.N_LIMBS, ids.BASE, ids.circuit.input_len//ids.N_LIMBS)
EXTF_MOD_CIRCUIT = ALL_FUSTAT_CIRCUITS[CircuitID(ids.circuit.name)]['class'](ids.circuit.curve_id, auto_run=False)
EXTF_MOD_CIRCUIT = EXTF_MOD_CIRCUIT.run_circuit(circuit_input)
print(f"\t{ids.circuit.constants_ptr_len} Constants and {ids.circuit.input_len//4} Inputs copied to RC_96 memory segment at position {ids.range_check96_ptr}")
commitments = flatten([bigint_split(x.value, ids.N_LIMBS, ids.BASE) for x in EXTF_MOD_CIRCUIT.commitments])
witnesses = flatten([bigint_split(x.value, ids.N_LIMBS, ids.BASE) for x in EXTF_MOD_CIRCUIT.witnesses])
fill_felt_ptr(x=commitments, memory=memory, address=ids.range_check96_ptr + ids.circuit.constants_ptr_len * ids.N_LIMBS + ids.circuit.input_len)
fill_felt_ptr(x=witnesses, memory=memory, address=ids.range_check96_ptr + ids.circuit.constants_ptr_len * ids.N_LIMBS + ids.circuit.input_len + ids.circuit.commitments_len)
print(f"\t{len(commitments)//4} Commitments & {len(witnesses)//4} witnesses computed and filled in RC_96 memory segment at positions {ids.range_check96_ptr+ids.circuit.constants_ptr_len * ids.N_LIMBS+ids.circuit.input_len} and {ids.range_check96_ptr + ids.circuit.constants_ptr_len * ids.N_LIMBS + ids.circuit.input_len + ids.circuit.commitments_len}")
#EXTF_MOD_CIRCUIT.print_value_segment()

```

- **[Lines 157-157](https://github.com/keep-starknet-strange/garaga/blob/main/src/fustat//modulo_circuit.cairo#L157-L157)**

```python
print(f"\tZ = Hash(Input|Commitments) = Poseidon({(ids.circuit.input_len+ids.circuit.commitments_len)//ids.N_LIMBS} * [Uint384]) computed")
```

- **[Lines 158-158](https://github.com/keep-starknet-strange/garaga/blob/main/src/fustat//modulo_circuit.cairo#L158-L158)**

```python
print(f"\tN={ids.circuit.N_Euclidean_equations} felt252 from Poseidon transcript retrieved.")
```

- **[Lines 160-163](https://github.com/keep-starknet-strange/garaga/blob/main/src/fustat//modulo_circuit.cairo#L160-L163)**

```python
# Sanity Check :
assert ids.Z == EXTF_MOD_CIRCUIT.transcript.continuable_hash, f"Z for circuit {EXTF_MOD_CIRCUIT.name} does not match {hex(ids.Z)} {hex(EXTF_MOD_CIRCUIT.transcript.continuable_hash)}"

```

- **[Lines 170-170](https://github.com/keep-starknet-strange/garaga/blob/main/src/fustat//modulo_circuit.cairo#L170-L170)**

```python
print(f"\tZ and felt252 written to value segment")
```

- **[Lines 171-171](https://github.com/keep-starknet-strange/garaga/blob/main/src/fustat//modulo_circuit.cairo#L171-L171)**

```python
print(f"\tRunning ModuloBuiltin circuit...")
```

### func: run_extension_field_modulo_circuit_continuation

- **[Lines 224-240](https://github.com/keep-starknet-strange/garaga/blob/main/src/fustat//modulo_circuit.cairo#L224-L240)**

```python
from garaga.precompiled_circuits.all_circuits import ALL_FUSTAT_CIRCUITS, CircuitID
from garaga.hints.io import bigint_split, pack_bigint_ptr, fill_felt_ptr, flatten
circuit_input = pack_bigint_ptr(memory, ids.input, ids.N_LIMBS, ids.BASE, ids.circuit.input_len//ids.N_LIMBS)
EXTF_MOD_CIRCUIT = ALL_FUSTAT_CIRCUITS[CircuitID(ids.circuit.name)]['class'](ids.circuit.curve_id, auto_run=False, init_hash=ids.init_hash)
EXTF_MOD_CIRCUIT = EXTF_MOD_CIRCUIT.run_circuit(input=circuit_input)
print(f"\t{ids.circuit.constants_ptr_len} Constants and {ids.circuit.input_len//4} Inputs copied to RC_96 memory segment at position {ids.range_check96_ptr}")
commitments = flatten([bigint_split(x.value, ids.N_LIMBS, ids.BASE) for x in EXTF_MOD_CIRCUIT.commitments])
witnesses = flatten([bigint_split(x.value, ids.N_LIMBS, ids.BASE) for x in EXTF_MOD_CIRCUIT.witnesses])
fill_felt_ptr(x=commitments, memory=memory, address=ids.range_check96_ptr + ids.circuit.constants_ptr_len * ids.N_LIMBS + ids.circuit.input_len)
fill_felt_ptr(x=witnesses, memory=memory, address=ids.range_check96_ptr + ids.circuit.constants_ptr_len * ids.N_LIMBS + ids.circuit.input_len + ids.circuit.commitments_len)
# print(f"continuation segment:, init_hash={hex(ids.init_hash)}")
#EXTF_MOD_CIRCUIT.print_value_segment()
print(f"\t{len(commitments)//4} Commitments & {len(witnesses)//4} witnesses computed and filled in RC_96 memory segment at positions {ids.range_check96_ptr+ids.circuit.constants_ptr_len * ids.N_LIMBS+ids.circuit.input_len} and {ids.range_check96_ptr + ids.circuit.constants_ptr_len * ids.N_LIMBS + ids.circuit.input_len + ids.circuit.commitments_len}")

```

- **[Lines 242-242](https://github.com/keep-starknet-strange/garaga/blob/main/src/fustat//modulo_circuit.cairo#L242-L242)**

```python
print(f"\tZ = Hash(Init_Hash|Commitments) = Poseidon(Init_Hash, Poseidon({(ids.circuit.commitments_len)//ids.N_LIMBS} * [Uint384])) computed")
```

- **[Lines 254-257](https://github.com/keep-starknet-strange/garaga/blob/main/src/fustat//modulo_circuit.cairo#L254-L257)**

```python
# Sanity Check :
assert ids.Z == EXTF_MOD_CIRCUIT.transcript.continuable_hash, f"Z for circuit {EXTF_MOD_CIRCUIT.name} does not match {hex(ids.Z)} {hex(EXTF_MOD_CIRCUIT.transcript.continuable_hash)}"

```

- **[Lines 264-264](https://github.com/keep-starknet-strange/garaga/blob/main/src/fustat//modulo_circuit.cairo#L264-L264)**

```python
print(f"\tZ and felt252 written to value segment")
```

- **[Lines 265-265](https://github.com/keep-starknet-strange/garaga/blob/main/src/fustat//modulo_circuit.cairo#L265-L265)**

```python
print(f"\tRunning ModuloBuiltin circuit...")
```

## File: [src/fustat/precompiled_circuits/dummy.cairo](https://github.com/keep-starknet-strange/garaga/blob/main/src/fustat//precompiled_circuits/dummy.cairo)
<<<<<<< HEAD

## File: [src/fustat/precompiled_circuits/ec.cairo](https://github.com/keep-starknet-strange/garaga/blob/main/src/fustat//precompiled_circuits/ec.cairo)

## File: [src/fustat/precompiled_circuits/extf_mul.cairo](https://github.com/keep-starknet-strange/garaga/blob/main/src/fustat//precompiled_circuits/extf_mul.cairo)

## File: [src/fustat/precompiled_circuits/final_exp.cairo](https://github.com/keep-starknet-strange/garaga/blob/main/src/fustat//precompiled_circuits/final_exp.cairo)

## File: [src/fustat/precompiled_circuits/multi_miller_loop.cairo](https://github.com/keep-starknet-strange/garaga/blob/main/src/fustat//precompiled_circuits/multi_miller_loop.cairo)
=======

## File: [src/fustat/precompiled_circuits/ec.cairo](https://github.com/keep-starknet-strange/garaga/blob/main/src/fustat//precompiled_circuits/ec.cairo)

## File: [src/fustat/precompiled_circuits/extf_mul.cairo](https://github.com/keep-starknet-strange/garaga/blob/main/src/fustat//precompiled_circuits/extf_mul.cairo)

## File: [src/fustat/precompiled_circuits/final_exp.cairo](https://github.com/keep-starknet-strange/garaga/blob/main/src/fustat//precompiled_circuits/final_exp.cairo)
>>>>>>> a504e556e4f9731d65815eff327cc8f5dd654411

## File: [src/fustat/precompiled_circuits/multi_miller_loop.cairo](https://github.com/keep-starknet-strange/garaga/blob/main/src/fustat//precompiled_circuits/multi_miller_loop.cairo)
