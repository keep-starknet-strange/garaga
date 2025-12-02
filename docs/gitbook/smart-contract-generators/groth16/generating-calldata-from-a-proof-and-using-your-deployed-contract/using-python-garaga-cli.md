# Using Python/Garaga CLI

Using the `garaga calldata` command from the CLI, you can generate the calldata needed to verify a proof for the `verify_groth16_proof_[curve_name]`.

First, ensure that:

* Your circuit is compiled and the verification key `verification_key.json` is created
* The public input file `public.json` and the associated proof `proof.json` are created

The call the following command by replacing the parameters with your data:

```bash
garaga calldata --system groth16 --vk verification_key.json --proof proof.json --public-inputs public.json
2789 41983001825546257095993508953 3045291465937026073442547681 1840582864647114302 0 69020349870260156176548317333 16784567729677911275297018120 1865382613176499468 0 51545988015561248414407597558 44248521764831362261757723052 8850086 ...
```

## `starkli` usage

Using the command option `--format starkli`,\
you can directly pipe the generated calldata to `starkli` to invoke a transaction on your deployed contract.

The proof must be the last parameter of your contract's method.

```bash
garaga calldata --system groth16 --vk verification_key.json --proof proof.json --public-inputs public.json --format starkli | xargs starkli invoke --keystore-password $KEYSTORE_PASSWORD --watch $YOUR_CONTRACT your_verify_method YOUR_PARAMETERS
```

## Cairo code usage

Use the command option `--format array` to generate calldata in array format to be used in your smart-contract tests.

```bash
garaga calldata --system groth16 --vk verification_key.json --proof proof.json --public-inputs public.json --format array
[2789, 41983001825546257095993508953, 3045291465937026073442547681, 1840582864647114302, 0, 69020349870260156176548317333, 16784567729677911275297018120, 1865382613176499468, 0, 51545988015561248414407597558, 44248521764831362261757723052, 88500861247646845, 0, ... ]
```
