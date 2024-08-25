---
icon: florin-sign
---

# EC (Multi)-Scalar Multiplication

For a given elliptic curve, scalar multiplication consists of adding a point  `P` to itself `s` times, where `P` is a point satisfying the curve equation and `s` a scalar. \
\
`k.P = P+P+P+...+P (k times)`\
\
\
Multi scalar multiplication consists of the sum of `n` scalar multiplication with different points and scalars :

$$
\sum_{i=1}^{n} k_i \times P_i
$$



A single `msm_g1` function in Garaga computes the multi-scalar multiplication for a given set of points and scalars for a given elliptic curve. Since it also works with `n=1`, it is also able to compute a single scalar multiplication.

{% hint style="info" %}
Additional points in the msm\_g1 function are **much** less expensive than combining different msm\_g1 with `n=1`
{% endhint %}

```toml
[package]
name = "my_package_that_needs_ec_scalar_mul"
version = "0.1.0"
edition = "2024_07"

[dependencies]
garaga = { git = "https://github.com/keep-starknet-strange/garaga.git" }

[cairo]
sierra-replace-ids = false
```

The function will be importable using&#x20;

```rust
use garaga::ec_ops::{msm_g1, G1Point, DerivePointFromXHint}
```

```rust
fn msm_g1(
    scalars_digits_decompositions: Option<Span<(Span<felt252>, Span<felt252>)>>,
    hint: MSMHint,
    derive_point_from_x_hint: DerivePointFromXHint,
    points: Span<G1Point>,
    scalars: Span<u256>,
    curve_index: usize
) -> G1Point {
```

As you can see, this function not only needs points and scalars, but also additional information, to perform the computation much more efficiently. \
\
Under `tools/starknet/tests_and_calldata_generator/`, you will find in the file [`msm.py`](https://github.com/keep-starknet-strange/garaga/blob/main/tools/starknet/tests\_and\_calldata\_generators/msm.py) some tools to generate a cairo test (using `MSMCalldataBuilder.to_cairo1_test()`) for this function given some points and scalars, or directly the raw calldata for starknet usage (using `MSMCalldataBuilder.serialize_to_calldata()`).&#x20;

### Generating and using calldata

\
An example contract is already [deployed](https://sepolia.voyager.online/contract/0x012686bdb4ca3f22ffc93dfe1e24d72294aac38a4f6b997b456fb4368fb3390b#readContract) on sepolia, solely holding an endpoint to this function. \
The source code to the contract is [here](https://github.com/keep-starknet-strange/garaga/blob/main/src/cairo/contracts/universal\_ecip/src/lib.cairo) .\
\
You can try this deployed contract on any supported curves modifying the [`msm.py`](https://github.com/keep-starknet-strange/garaga/blob/main/hydra/garaga/starknet/tests\_and\_calldata\_generators/msm.py) script at the end :&#x20;

```python
if __name__ == "__main__":
    import random

    c = CurveID.SECP256K1
    order = CURVES[c.value].n
    msm = MSMCalldataBuilder(
        curve_id=c,
        points=[G1Point.gen_random_point(c) for _ in range(1)],
        scalars=[random.randint(0, order) for _ in range(1)],
    )
    cd = msm.serialize_to_calldata(
        include_digits_decomposition=True,
        include_points_and_scalars=True,
        serialize_as_pure_felt252_array=False,
    )
    print(cd)
    print(len(cd))
```

The options are :

* `include_digits_decomposition`. This needs 162 additional felt252 per additional scalar, but it saves a lot of cairo steps. If set to `False`, the Cairo function will compute them directly in Cairo. If set to `True`, the Cairo program will verify the correctness of the decomposition (which is cheaper) and use it.
* `include_points_and_scalars` : If set to `False`, the input points, scalars, and `curve_index` will not be part of the calldata.
* `serialize_as_pure_felt252_array` : If set to `True`, preprend the total length of the calldata at the beginning. \


The last two options are only useful when you want to use points and scalars from another source than the calldata. \
\
For example, checkout the [groth16 verifier contracts](https://github.com/keep-starknet-strange/garaga/blob/8b6dddb9738c62a140fcbd3f9a80208ff07b9853/src/cairo/contracts/groth16\_example\_bn254/src/groth16\_verifier.cairo#L34-L73). It makes a delegated call to the endpoint `msm_g1`  using the already declared contract's class hash, and pushes the (fixed) points from the hardcoded verifying key, and the scalars from the groth16 proof. :

```rust
impl IGroth16VerifierBN254 of super::IGroth16VerifierBN254<ContractState> {
    fn verify_groth16_proof_bn254(
        ref self: ContractState,
        groth16_proof: Groth16Proof,
        mpcheck_hint: MPCheckHintBN254,
        small_Q: E12DMulQuotient,
        msm_hint: Array<felt252>,
    ) -> bool {
        groth16_proof.a.assert_on_curve(0);
        groth16_proof.b.assert_on_curve(0);
        groth16_proof.c.assert_on_curve(0);


        let ic = ic.span();


        let vk_x: G1Point = match ic.len() {
            0 => panic!("Malformed VK"),
            1 => *ic.at(0),
            _ => {
                // Start serialization with the hint array directly to avoid copying it.
                let mut msm_calldata: Array<felt252> = msm_hint;
                // Add the points from VK and public inputs to the proof.
                Serde::serialize(@ic.slice(1, N_PUBLIC_INPUTS), ref msm_calldata);
                Serde::serialize(@groth16_proof.public_inputs, ref msm_calldata);
                // Complete with the curve indentifier (0 for BN254):
                msm_calldata.append(0);


                // Call the multi scalar multiplication endpoint on the Garaga ECIP ops contract
                // to obtain vk_x.
                let mut _vx_x_serialized = core::starknet::syscalls::library_call_syscall(
                    ECIP_OPS_CLASS_HASH.try_into().unwrap(),
                    selector!("msm_g1"),
                    msm_calldata.span()
                )
                    .unwrap_syscall();


                ec_safe_add(
                    Serde::<G1Point>::deserialize(ref _vx_x_serialized).unwrap(), *ic.at(0), 0
                )
            }
        };
```

Here the `msm_hint` is used with `include_points_and_scalars=False` and `serialize_as_pure_felt252_array=True`\
\
Then the points from `ic` are pushed to the array, and the scalars from the groth16 proof's public inputs. Finally the curve identifier is pushed as well. \
\
In our example, we'll leave the default parameters that will include everything for a direct endpoint call. \
Simply run :

```
python tools/starknet/tests_and_calldata_generator/msm.py
```

And copy paste the array in voyager to see!

<figure><img src="../.gitbook/assets/ezgif-7-46048b79f9.gif" alt=""><figcaption></figcaption></figure>
