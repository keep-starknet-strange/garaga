# Bulletproofs++ implementation on Rust

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Pull Requests welcome](https://img.shields.io/badge/PRs-welcome-ff69b4.svg?style=flat-square)](https://github.com/distributed-lab/bp-pp/issues)
<a href="https://github.com/distributed-lab/bp-pp">
<img src="https://img.shields.io/github/stars/distributed-lab/bp-pp?style=social"/>
</a>

⚠️ __Please note - this crypto library has not been audited, so use it at your own risk.__

## Abstract

Present Rust library contains the implementation of Bulletproofs++
over [secp256k1 curve](https://docs.rs/k256/latest/k256/) that includes: weight norm linear argument protocol,
arithmetic circuit protocol and reciprocal range proofs described in Distributed
Lab's [Bulletproofs++ Construction and Examples](https://distributedlab.com/whitepaper/Bulletproofs-Construction-and-Examples.pdf).
Also, contains the `u64` range proof protocol as a primary use-case for reciprocal range proofs.

This implementation uses [Merlin transcript](https://doc.dalek.rs/merlin/index.html) for challenges generation as was
recommended by Bulletproofs protocol authors.

All `Proof` data models has corresponding `SerializeProof` models where [serde](https://serde.rs/) `Serialize`
and `Deserialize` was implemented.

## Performance

Implemented solution has 2G points advantage over existing BP and BP+ protocols on proving of one 64-bit value and this
advantage will increase for more values per proof.

| Protocol | G  | F |
|----------|----|---|
| BP       | 16 | 5 |
| BP+      | 15 | 3 |
| Our BP++ | 13 | 3 |

On MacBook M3Pro 36GB MacOS 14.1 Rust 1.78.0 it [consumes](./macbook-m3-pro-36GB-bench-result.txt):

- 14.361 ms average for proof generation
- 3.8080 ms average for proof verification

## Example of usage

Use [tests](./src/tests.rs) to run the provided example:

```rust
use k256::elliptic_curve::{Group, rand_core::OsRng};
use k256::ProjectivePoint;

use bp_pp::range_proof;
use bp_pp::range_proof::u64_proof::G_VEC_FULL_SZ;
use bp_pp::range_proof::u64_proof::H_VEC_FULL_SZ;
use bp_pp::range_proof::reciprocal::{SerializableProof, self};

fn main() {
    let mut rand = OsRng::default();

    let x = 123456u64; // private value to create proof for.
    let s = k256::Scalar::generate_biased(&mut rand); // blinding value

    // Base points
    let g = k256::ProjectivePoint::random(&mut rand);
    let g_vec = (0..G_VEC_FULL_SZ).map(|_| k256::ProjectivePoint::random(&mut rand)).collect::<Vec<ProjectivePoint>>();
    let h_vec = (0..H_VEC_FULL_SZ).map(|_| k256::ProjectivePoint::random(&mut rand)).collect::<Vec<ProjectivePoint>>();

    let public = range_proof::u64_proof::U64RangeProofProtocol {
        g,
        g_vec,
        h_vec,
    };

    // transcript will be used for challenge generation - to move from interactive to non-interactive protocol.
    // transcript should be the new instance but with same label for prover and verifier.
    let mut pt = merlin::Transcript::new(b"u64 range proof");
    let proof = public.prove(x, &s, &mut pt, &mut rand);

    // value commitment: `commitment = x*g + s*h_vec[0]`
    let commitment = public.commit_value(x, &s);

    println!("{}", serde_json::to_string_pretty(&reciprocal::SerializableProof::from(&proof)).unwrap());

    let mut vt = merlin::Transcript::new(b"u64 range proof");
    assert!(public.verify(&commitment, proof, &mut vt));
}
```
