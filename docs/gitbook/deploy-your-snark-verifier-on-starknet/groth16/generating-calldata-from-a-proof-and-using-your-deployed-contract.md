---
icon: microchip
---

# Generating calldata from a proof and using your deployed contract

{% hint style="info" %}
A npm package is under development to call your contract from the browser.
{% endhint %}



Once your groth16 contract is deployed and you have its address, you will need to call its main endpoint `verify_groth16_proof_bn254`, or `verify_groth16_proof_bls12_381`. \
\
The Groth16 proof needs pre-processing and extra computation to allow efficient verification. \
\
The Garaga CLI takes care of converting your proof to the correct calldata and calling your contract.\
To do this, use the garaga `verify-onchain` command.&#x20;

```bash
 Usage: garaga verify-onchain [OPTIONS]

 Invoke a SNARK verifier on Starknet given a contract address, a proof and a verification key.

╭─ Options ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╮
│ *  --system                    [groth16]          Proof system [default: None] [required]                                           │
│ *  --contract-address          TEXT               Starknet contract address [default: None] [required]                              │
│ *  --vk                        FILE               Path to the verification key JSON file [default: None] [required]                 │
│ *  --proof                     FILE               Path to the proof JSON file [default: None] [required]                            │
│    --public-inputs             FILE               Path to the public inputs JSON file [default: None]                               │
│    --endpoint                  TEXT               Smart contract function name. If not provided, the default                        │
│                                                   'verify_[proof_system]_proof_[curve_name]' will be used.                          │
│    --env-file                  FILE               Path to the environment file containing rpc, address, private_key                 │
│                                                   [default: /home/felt/PycharmProjects/garaga-flow/my_project/target/.secrets]      │
│    --network                   [sepolia|mainnet]  Starknet network [default: sepolia]                                               │
│    --help              -h                         Show this message and exit.                                                       │
╰─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╯
```

As for the verifying key, both Snarkjs and Gnark `proof.json` and `public.json` are supported out of the box. See the example in the [generate-and-deploy-your-verifier-contract.md](generate-and-deploy-your-verifier-contract.md "mention") for Gnark export.

Alternatively, the `--public-inputs` parameter can be omitted if your proof include everything at once, as below.

<pre class="language-json" data-title="my_proof.json"><code class="lang-json">{
    "eliptic_curve_id": "bn254",
    "proof": {
        "a": {
            "x": "0x2abaae3dd6e4c662f5e071bca525a26d21e2400d01d02c87bce2e8363285990a",
            "y": "0x24211ff0aa742a6dd1651aadce6f72757beb89de2cff83a6162de7c15674c2"
        },
        "b": {
            "x": [
                "0x2335f1564c154d7a2ec5d11faf6d991a205bef2858f1687976d0a46502f5224a",
                "0x223af0bb0912d8ebc535ed489d06cd01fcf4a8ab4596cc28164edf9041d97080"
            ],
            "y": [
                "0x182e8fd86a44983de1d1d9dc4f12f134535b75d39f7aeb21adbf57e1a32ee603",
                "0xecb11668a0dd5d5031b0837e62ba14222b45718dc101c1278f44a9ed823c16b"
            ]
        },
        "c": {
            "x": "0x290243624a4c11868e7cb0c0f7cfd690dac08e4205d19795b0a8f686dddcdfd6",
            "y": "0x15de00cc8af159fbdbdc802592e83e1ac61a8026b97e8889b8c5def59ec50b16"
        }
    },
    "public_inputs": [
        "0x1e17db88c1d2e83e49f692cce4bb8169309de90afb2b141156243106aa34b474"
    ]
<strong>}
</strong></code></pre>

The command should look like this:

{% code overflow="wrap" %}
```
garaga verify-onchain --system groth16 --contract-address 0x1234... --vk vk.json --proof proof.json --public-inputs public.json --env-file .secrets --network sepolia
```
{% endcode %}

If everything is good, the command will output the transaction hash along with an explorer link. \
Congrats!
