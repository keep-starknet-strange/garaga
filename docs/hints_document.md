## File: [src/utils.cairo](https://github.com/keep-starknet-strange/garaga/blob/main/src//utils.cairo)

### func: hash_full_transcript_and_get_Z

- **[Lines 28-28](https://github.com/keep-starknet-strange/garaga/blob/main/src//utils.cairo#L28-L28)**

```python
print(f"N elemts in transcript : {ids.n} ")
```

- **[Lines 30-35](https://github.com/keep-starknet-strange/garaga/blob/main/src//utils.cairo#L30-L35)**

```python
//     from src.hints.io import pack_bigint_ptr
//     to_hash=pack_bigint_ptr(memory, ids.limbs_ptr, ids.N_LIMBS, ids.BASE, ids.n)
//     for e in to_hash:
//         print(f"Will Hash {hex(e)}")

```

- **[Lines 37-41](https://github.com/keep-starknet-strange/garaga/blob/main/src//utils.cairo#L37-L41)**

```python
for i in range(2*ids.n -1):
    memory[ids.ptr + 2 + 6*i] = 2
    memory[ids.ptr + 8 + 6*i] = 2

```

- **[Lines 47-47](https://github.com/keep-starknet-strange/garaga/blob/main/src//utils.cairo#L47-L47)**

```python
i=0
```

- **[Lines 55-58](https://github.com/keep-starknet-strange/garaga/blob/main/src//utils.cairo#L55-L58)**

```python
i+=1
memory[ap] = 1 if i == ids.n else 0

```

### func: retrieve_random_coefficients

- **[Lines 86-86](https://github.com/keep-starknet-strange/garaga/blob/main/src//utils.cairo#L86-L86)**

```python
i=0
```

- **[Lines 94-97](https://github.com/keep-starknet-strange/garaga/blob/main/src//utils.cairo#L94-L97)**

```python
i+=1
memory[ap] = 1 if i == ids.n else 0

```

- **[Lines 106-111](https://github.com/keep-starknet-strange/garaga/blob/main/src//utils.cairo#L106-L111)**

```python
//     from src.hints.io import pack_bigint_ptr
//     array=pack_bigint_ptr(memory, ids.coefficients, 1, ids.BASE, ids.n)
//     for i,e in enumerate(array):
//         print(f"CAIRO Using c_{i} = {hex(e)}")

```

### func: write_felts_to_value_segment

- **[Lines 120-120](https://github.com/keep-starknet-strange/garaga/blob/main/src//utils.cairo#L120-L120)**

```python
i=0
```

- **[Lines 127-130](https://github.com/keep-starknet-strange/garaga/blob/main/src//utils.cairo#L127-L130)**

```python
memory[ap] = 1 if i == ids.n else 0
i+=1

```

- **[Lines 136-142](https://github.com/keep-starknet-strange/garaga/blob/main/src//utils.cairo#L136-L142)**

```python
from src.hints.io import bigint_split 
felt_val = memory[ids.values_start+i-1]
limbs = bigint_split(felt_val, ids.N_LIMBS, ids.BASE)
assert limbs[3] == 0
ids.d0, ids.d1, ids.d2 = limbs[0], limbs[1], limbs[2]

```

### func: retrieve_output

- **[Lines 170-170](https://github.com/keep-starknet-strange/garaga/blob/main/src//utils.cairo#L170-L170)**

```python
print(f"Continuous output! start value : {hex(memory[ids.values_segment + ids.offset])} Size: {ids.n//4} offset:{ids.offset}")
```

- **[Lines 185-189](https://github.com/keep-starknet-strange/garaga/blob/main/src//utils.cairo#L185-L189)**

```python
index = memory[ids.output_offsets_ptr+ids.i]
# print(f"Output {ids.i}/{ids.n} Index : {index}")
memory[ap] = 1 if ids.i == ids.n else 0

```

## File: [src/definitions.cairo](https://github.com/keep-starknet-strange/garaga/blob/main/src//definitions.cairo)

### func: is_zero_mod_P

- **[Lines 194-199](https://github.com/keep-starknet-strange/garaga/blob/main/src//definitions.cairo#L194-L199)**

```python
from src.hints.io import bigint_pack
x = bigint_pack(ids.x, 4, 2**96)
p = bigint_pack(ids.p, 4, 2**96)
x=x%p

```

- **[Lines 200-200](https://github.com/keep-starknet-strange/garaga/blob/main/src//definitions.cairo#L200-L200)**

```python
x == 0
```

- **[Lines 206-209](https://github.com/keep-starknet-strange/garaga/blob/main/src//definitions.cairo#L206-L209)**

```python
from src.hints.io import bigint_fill
bigint_fill(pow(x, -1, p), ids.x_inv, ids.N_LIMBS, ids.BASE)

```

### func: verify_zero4

- **[Lines 238-247](https://github.com/keep-starknet-strange/garaga/blob/main/src//definitions.cairo#L238-L247)**

```python
from src.hints.io import bigint_pack
x = bigint_pack(ids.x, 4, 2**96)
p = bigint_pack(ids.p, 4, 2**96)
q, r = divmod(x, p)
assert r == 0, f"verify_zero: Invalid input."
ids.q=q

```

### func: verify_zero7

- **[Lines 271-280](https://github.com/keep-starknet-strange/garaga/blob/main/src//definitions.cairo#L271-L280)**

```python
from src.hints.io import bigint_pack, bigint_fill
val = bigint_pack(ids.val, 7, 2**96)
p = bigint_pack(ids.p, 4, 2**96)
q, r = divmod(val, p)
assert r == 0, f"verify_zero: Invalid input {val%p}."
bigint_fill(q, ids.q, ids.N_LIMBS, ids.BASE)

```

## File: [src/ec_ops.cairo](https://github.com/keep-starknet-strange/garaga/blob/main/src//ec_ops.cairo)

## File: [src/modulo_circuit.cairo](https://github.com/keep-starknet-strange/garaga/blob/main/src//modulo_circuit.cairo)

### func: run_modulo_circuit

- **[Lines 68-81](https://github.com/keep-starknet-strange/garaga/blob/main/src//modulo_circuit.cairo#L68-L81)**

```python
from src.precompiled_circuits.all_circuits import ALL_EXTF_CIRCUITS, CircuitID
from src.hints.io import pack_bigint_ptr, fill_felt_ptr, flatten
from src.definitions import CURVES, PyFelt
p = CURVES[ids.circuit.curve_id].p
circuit_input = pack_bigint_ptr(memory, ids.input, ids.N_LIMBS, ids.BASE, ids.circuit.input_len//ids.N_LIMBS)
MOD_CIRCUIT = ALL_EXTF_CIRCUITS[CircuitID(ids.circuit.name)](ids.circuit.curve_id, auto_run=False)
MOD_CIRCUIT = MOD_CIRCUIT.run_circuit(circuit_input)
witnesses = flatten([bigint_split(x.value, ids.N_LIMBS, ids.BASE) for x in MOD_CIRCUIT.witnesses])
fill_felt_ptr(x=witnesses, memory=memory, address=ids.range_check96_ptr + ids.circuit.constants_ptr_len * ids.N_LIMBS + ids.circuit.input_len)
#MOD_CIRCUIT.print_value_segment()

```

### func: run_extension_field_modulo_circuit

- **[Lines 131-147](https://github.com/keep-starknet-strange/garaga/blob/main/src//modulo_circuit.cairo#L131-L147)**

```python
from src.precompiled_circuits.all_circuits import ALL_EXTF_CIRCUITS, CircuitID
from src.hints.io import bigint_split, pack_bigint_ptr, fill_felt_ptr, flatten
circuit_input = pack_bigint_ptr(memory, ids.input, ids.N_LIMBS, ids.BASE, ids.circuit.input_len//ids.N_LIMBS)
EXTF_MOD_CIRCUIT = ALL_EXTF_CIRCUITS[CircuitID(ids.circuit.name)](ids.circuit.curve_id, auto_run=False)
EXTF_MOD_CIRCUIT = EXTF_MOD_CIRCUIT.run_circuit(circuit_input)
print(f"\t{ids.circuit.constants_ptr_len} Constants and {ids.circuit.input_len//4} Inputs copied to RC_96 memory segment at position {ids.range_check96_ptr}")
commitments = flatten([bigint_split(x.value, ids.N_LIMBS, ids.BASE) for x in EXTF_MOD_CIRCUIT.commitments])
witnesses = flatten([bigint_split(x.value, ids.N_LIMBS, ids.BASE) for x in EXTF_MOD_CIRCUIT.witnesses])
fill_felt_ptr(x=commitments, memory=memory, address=ids.range_check96_ptr + ids.circuit.constants_ptr_len * ids.N_LIMBS + ids.circuit.input_len)
fill_felt_ptr(x=witnesses, memory=memory, address=ids.range_check96_ptr + ids.circuit.constants_ptr_len * ids.N_LIMBS + ids.circuit.input_len + ids.circuit.commitments_len)
print(f"\t{len(commitments)//4} Commitments & {len(witnesses)//4} witnesses computed and filled in RC_96 memory segment at positions {ids.range_check96_ptr+ids.circuit.constants_ptr_len * ids.N_LIMBS+ids.circuit.input_len} and {ids.range_check96_ptr + ids.circuit.constants_ptr_len * ids.N_LIMBS + ids.circuit.input_len + ids.circuit.commitments_len}")
#EXTF_MOD_CIRCUIT.print_value_segment()

```

- **[Lines 156-156](https://github.com/keep-starknet-strange/garaga/blob/main/src//modulo_circuit.cairo#L156-L156)**

```python
print(f"\tZ = Hash(Input|Commitments) = Poseidon({(ids.circuit.input_len+ids.circuit.commitments_len)//ids.N_LIMBS} * [Uint384]) computed")
```

- **[Lines 157-157](https://github.com/keep-starknet-strange/garaga/blob/main/src//modulo_circuit.cairo#L157-L157)**

```python
print(f"\tN={ids.circuit.N_Euclidean_equations} felt252 from Poseidon transcript retrieved.")
```

- **[Lines 159-162](https://github.com/keep-starknet-strange/garaga/blob/main/src//modulo_circuit.cairo#L159-L162)**

```python
# Sanity Check : 
assert ids.Z == EXTF_MOD_CIRCUIT.transcript.continuable_hash, f"Z for circuit {EXTF_MOD_CIRCUIT.name} does not match {hex(ids.Z)} {hex(EXTF_MOD_CIRCUIT.transcript.continuable_hash)}"

```

- **[Lines 169-169](https://github.com/keep-starknet-strange/garaga/blob/main/src//modulo_circuit.cairo#L169-L169)**

```python
print(f"\tZ and felt252 written to value segment")
```

- **[Lines 170-170](https://github.com/keep-starknet-strange/garaga/blob/main/src//modulo_circuit.cairo#L170-L170)**

```python
print(f"\tRunning ModuloBuiltin circuit...")
```

### func: run_extension_field_modulo_circuit_continuation

- **[Lines 223-239](https://github.com/keep-starknet-strange/garaga/blob/main/src//modulo_circuit.cairo#L223-L239)**

```python
from src.precompiled_circuits.all_circuits import ALL_EXTF_CIRCUITS, CircuitID
from src.hints.io import bigint_split, pack_bigint_ptr, fill_felt_ptr, flatten
circuit_input = pack_bigint_ptr(memory, ids.input, ids.N_LIMBS, ids.BASE, ids.circuit.input_len//ids.N_LIMBS)
EXTF_MOD_CIRCUIT = ALL_EXTF_CIRCUITS[CircuitID(ids.circuit.name)](ids.circuit.curve_id, auto_run=False, init_hash=ids.init_hash)
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

- **[Lines 241-241](https://github.com/keep-starknet-strange/garaga/blob/main/src//modulo_circuit.cairo#L241-L241)**

```python
print(f"\tZ = Hash(Init_Hash|Commitments) = Poseidon(Init_Hash, Poseidon({(ids.circuit.commitments_len)//ids.N_LIMBS} * [Uint384])) computed")
```

- **[Lines 252-255](https://github.com/keep-starknet-strange/garaga/blob/main/src//modulo_circuit.cairo#L252-L255)**

```python
# Sanity Check : 
assert ids.Z == EXTF_MOD_CIRCUIT.transcript.continuable_hash, f"Z for circuit {EXTF_MOD_CIRCUIT.name} does not match {hex(ids.Z)} {hex(EXTF_MOD_CIRCUIT.transcript.continuable_hash)}"

```

- **[Lines 262-262](https://github.com/keep-starknet-strange/garaga/blob/main/src//modulo_circuit.cairo#L262-L262)**

```python
print(f"\tZ and felt252 written to value segment")
```

- **[Lines 263-263](https://github.com/keep-starknet-strange/garaga/blob/main/src//modulo_circuit.cairo#L263-L263)**

```python
print(f"\tRunning ModuloBuiltin circuit...")
```

## File: [src/pairing.cairo](https://github.com/keep-starknet-strange/garaga/blob/main/src//pairing.cairo)

### func: final_exponentiation

- **[Lines 143-147](https://github.com/keep-starknet-strange/garaga/blob/main/src//pairing.cairo#L143-L147)**

```python
//     part1 = pack_bigint_ptr(memory, ids.output, 4, 2**96, ids.circuit.output_len//4)
//     for x in part1:
//         print(f"T0/T2/_SUM = {hex(x)}")

```

## File: [src/precompiled_circuits/final_exp.cairo](https://github.com/keep-starknet-strange/garaga/blob/main/src//precompiled_circuits/final_exp.cairo)

## File: [src/precompiled_circuits/multi_miller_loop.cairo](https://github.com/keep-starknet-strange/garaga/blob/main/src//precompiled_circuits/multi_miller_loop.cairo)

## File: [src/precompiled_circuits/extf_mul.cairo](https://github.com/keep-starknet-strange/garaga/blob/main/src//precompiled_circuits/extf_mul.cairo)

## File: [src/precompiled_circuits/ec.cairo](https://github.com/keep-starknet-strange/garaga/blob/main/src//precompiled_circuits/ec.cairo)

