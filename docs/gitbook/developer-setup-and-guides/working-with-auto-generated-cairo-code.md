---
icon: wand-sparkles
---

# Working with auto-generated Cairo Code

### Developer workflow

If working with the python - auto generated cairo code, the main script to work with is `make rewrite` \


{% code title="tools/make/rewrite.sh" %}
```bash
rm -rf src/src/tests/*
rm -rf src/src/circuits/*
rm -rf src/contracts/groth16_example_bls12_381/*
rm -rf src/contracts/groth16_example_bn254/*
rm -rf src/contracts/risc0_verifier_bn254/*

set -e  # Exit immediately if a command exits with a non-zero status

python hydra/garaga/precompiled_circuits/all_circuits.py || { echo "Error in all_circuits.py"; exit 1; }
python hydra/garaga/starknet/tests_and_calldata_generators/test_writer.py || { echo "Error in test_writer.py"; exit 1; }
python hydra/garaga/starknet/groth16_contract_generator/generator.py || { echo "Error in generator.py"; exit 1; }
python hydra/garaga/starknet/groth16_contract_generator/generator_risc0.py || { echo "Error in generator_risc0.py"; exit 1; }
```
{% endcode %}

\
As you can see this will :&#x20;

* Rewrite all the auto-generated cairo code in `src/src/circuits/` (with the `all_circuits.py` script)
* Rewrite all the auto-generated cairo tests in `src/src/tests/` (with the `test_writer.py` script)
* Rewrite the Groth16 verifiers smart contract templates examples in `src/contracts/` (with the `generator.py` and `generator_risc0.py` scripts)



## Creating auto-generated circuits.&#x20;

While it's relatively easy to write Cairo circuits yourself if their size is small, it starts to be quite time consuming if you need to build a large amount of them, parametrize them, and the circuits themselves are quite large.

{% hint style="info" %}
Examples of small hand-made small circuits can be found in [https://github.com/keep-starknet-strange/garaga/blob/main/src/src/basic\_field\_ops.cairo](https://github.com/keep-starknet-strange/garaga/blob/main/src/src/basic\_field\_ops.cairo)
{% endhint %}

\
If you want to write a new auto-generated circuit to `src/src/circuits`, you can define them with python code, and register them to the `all_circuits.py` file. \
\
Below we show a basic tutorial for a non-parametrized circuit.&#x20;

### Simple isolated example

<pre class="language-python"><code class="lang-python"><strong>import garaga.modulo_circuit_structs as structs
</strong>from garaga.definitions import CurveID, get_base_field
from garaga.modulo_circuit import PyFelt, ModuloCircuit


curve_id = CurveID.BN254 # BN254
field = get_base_field(curve_id) # Use with field(int) or field.random().

COMPILATION_MODE = 1 # 1 for Cairo, 0 for CairoZero.

circuit = ModuloCircuit(
    name=f"dummy_{curve_id.name.lower()},
    curve_id.value,
    generic_circuit=False,
    compilation_mode=COMPILATION_MODE,
)
# All "structs" expect a name (replicated in the signature) and a list of elements.
x, y = circuit.write_struct(structs.u384Span("xy", [field.random(), field.random()]))
# All "structs" written with write_struct will be expected in the Cairo
# function signature of the given type.
z = circuit.write_struct(structs.u384("z", [field(42)]))

# With this configuration,
# the signature will be fn(xy: Span&#x3C;u384>, z:u384).
# More structs and arbitrary ones are supported as well.

# To write constants, use set_or_get_constant.
one = circuit.set_or_get_constant(1)

# Here happens the core circuit logic.
# The core operations are add, sub, mul, inv.
# However, more high level methods are available that translate to
# a sequence of the core operations (ex: div &#x3C;=> inv then mul)
a = circuit.add(x, y)
b = circuit.sub(a, one)
c = circuit.mul(b, z)
d = circuit.inv(c)
f = circuit.div(d, z)

# Define the output of the function using structs as well.
circuit.extend_struct_output(structs.u384Span("abc", [a, b, c]))
circuit.extend_struct_output(structs.u384("f", [f]))

# Compile and print the compiled cairo circuit :
header = compilation_mode_to_file_header(1) # Cairo 1
compiled_code, function_name = circuit.compile_circuit()
# Note: some imports are unused in the header,
# we should make the compiler aware of the structs used ;)
print(header)
print(compiled_code)
</code></pre>

To obtain the corresponding Cairo code, you can do it like this&#x20;

The obtained Cairo code will be&#x20;

```rust
use core::circuit::{
    RangeCheck96, AddMod, MulMod, u384, u96, CircuitElement, CircuitInput, circuit_add, circuit_sub,
    circuit_mul, circuit_inverse, EvalCircuitResult, EvalCircuitTrait, CircuitOutputsTrait,
    CircuitModulus, AddInputResultTrait, CircuitInputs, CircuitDefinition,
    CircuitData, CircuitInputAccumulator
};
use garaga::core::circuit::AddInputResultTrait2;
use core::circuit::CircuitElement as CE;
use core::circuit::CircuitInput as CI;
use garaga::definitions::{get_a, get_b, get_p, get_g, get_min_one, G1Point, G2Point, E12D, u288, G1G2Pair, BNProcessedPair, BLSProcessedPair, MillerLoopResultScalingFactor, G2Line, get_BLS12_381_modulus,get_BN254_modulus};
use garaga::ec_ops::{SlopeInterceptOutput, FunctionFeltEvaluations, FunctionFelt};
use core::option::Option;


#[inline(always)]
fn run_dummy_bn254_circuit(xy: Span<u384>, z: u384) -> (Span<u384>, u384) {
    // CONSTANT stack
    let in0 = CE::<CI<0>> {}; // 0x1

    // INPUT stack
    let (in1, in2, in3) = (CE::<CI<1>> {}, CE::<CI<2>> {}, CE::<CI<3>> {});
    let t0 = circuit_add(in1, in2);
    let t1 = circuit_sub(t0, in0);
    let t2 = circuit_mul(t1, in3);
    let t3 = circuit_inverse(t2);
    let t4 = circuit_inverse(in3);
    let t5 = circuit_mul(t3, t4);

    let modulus = get_BN254_modulus(); // BN254 prime field modulus

    let mut circuit_inputs = (t0, t1, t2, t5,).new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs.next_2([0x1, 0x0, 0x0, 0x0]); // in0
    // Fill inputs:
    let mut xy = xy;
    while let Option::Some(val) = xy.pop_front() {
        circuit_inputs = circuit_inputs.next_2(*val);
    };
    // in1 - in2
    circuit_inputs = circuit_inputs.next_2(z); // in3

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let abc: Span<u384> = array![
        outputs.get_output(t0), outputs.get_output(t1), outputs.get_output(t2)
    ]
        .span();
    let f: u384 = outputs.get_output(t5);
    return (abc, f);
}
```

Note that the compiler will adapt the signature of the Cairo function depending on the `generic_circuit` parameter, and retrieve the corresponding modulus inside the function code.&#x20;

{% code title="https://github.com/keep-starknet-strange/garaga/blob/584cad66d067aa6c04447fe06a00c7be99bc2445/hydra/garaga/modulo_circuit.py#L1068-L1071" %}
```python
if self.generic_circuit:
    code = f"#[inline(always)]\nfn {function_name}({signature_input}, curve_index:usize)->{signature_output} {{\n"
else:
    code = f"#[inline(always)]\nfn {function_name}({signature_input})->{signature_output} {{\n"
```
{% endcode %}

### Using parameterization (docs in progress :construction:)&#x20;

#### The base class

Currently, the way we deal with parameterization is encapsulating the earlier `ModuloCircuit` class into a [BaseModuloCircuit](https://github.com/keep-starknet-strange/garaga/blob/584cad66d067aa6c04447fe06a00c7be99bc2445/hydra/garaga/precompiled\_circuits/compilable\_circuits/base.py#L12C7-L12C25)  class, and adding keyword arguments to the class deriving it.

```python
class BaseModuloCircuit(ABC):
    """
    Base class for all modulo circuits that will be compiled to Cairo code.
    Parameters:
    - name: str, the name of the circuit
    - curve_id: int, the id of the curve
    - auto_run: bool, whether to run the circuit automatically at initialization.
                When compiling, this flag must be set to true so the ModuloCircuit class inside the
                 ".circuit" member of this class holds the necessary metadata
                about the operations that will be compiled.
                For CairoZero, this flag will be set to False in the Python hint, so that
                BaseModuloCircuit.run_circuit() can be called on a segment parsed from the
                CairoZero VM.
    - compilation mode: 0 (CairoZero) or 1 (Cairo)
    """

    def __init__(
        self,
        name: str,
        curve_id: int,
        auto_run: bool = True,
        compilation_mode: int = 0,
```

All Cairo function must inherit from the base abstract class \
The abstract methods to implement are : \


*   `build_input`

    ```python
    def build_input(self) -> list[PyFelt]:
    """
    This method is used to create the necessary inputs that will be written to the ModuloCircuit.
    It works in pair with the _run_circuit_inner function, where the _run_circuit_inner will use the output of
    the build_input function to "deserialize" the list of elements and "write" them to the ModuloCircuit class.
    """
    ```
*   `_run_circuit_inner`

    ```python
    def _run_circuit_inner(self, input: list[PyFelt]) -> ModuloCircuit:
    """
    This method is responsible for
    - deserializing the input list of elements,
    - creating a ModuloCircuit class (or class that derives from ModuloCircuit)
    - "writing" the inputs to the ModuloCircuit class to obtain ModuloCircuitElements
    - using the methods add, sub, mul, inv (or higher level methods) of the ModuloCircuit class
        to define the list of operations on the given inputs.
    - Returning the ModuloCircuit class in a state where the circuit has been run, and therefore holding
        the metadata so that its instructions can be compiled to Cairo code.

    """
    ```



At initialization, you must choose a name for the circuit. \
Pay attention to the parameter `generic_circuit` passed to the `ModuloCircuit` class inside `_run_circuit_inner`

<pre class="language-python"><code class="lang-python"><strong>import garaga.modulo_circuit_structs as structs
</strong>from garaga.definitions import CurveID
from garaga.precompiled_circuits.compilable_circuits.base import BaseModuloCircuit
from garaga.modulo_circuit import PyFelt, ModuloCircuit

class FixedExpCircuit(BaseModuloCircuit):
    def __init__(
        self, curve_id: int, auto_run: bool = True, compilation_mode: int = 1, n:int=1

    ) -> None:
        super().__init__(
            name=f"fixed_exp_circuit_{CurveID(curve_id).name.lower()}_{n}",
<strong>            curve_id=curve_id,
</strong>            auto_run=auto_run,
            compilation_mode=compilation_mode,
        )
        self.n = n

    def build_input(self) -> list[PyFelt]:
        return [self.field.random()]

    def _run_circuit_inner(self, input: list[PyFelt]) -> ModuloCircuit:
        circuit = ModuloCircuit(
            self.name,
            self.curve_id,
            generic_circuit=True,
            compilation_mode=self.compilation_mode,
        )

        z = circuit.write_struct(structs.u384("z", [input[2]]), WriteOps.INPUT)
        res = z
        for i in range(n):
            res = circuit.mul(res, z)
        circuit.extend_struct_output(structs.u384("res", [res]))

        return circuit

</code></pre>
