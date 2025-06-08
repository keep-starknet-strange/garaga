#![allow(non_snake_case)]

use crate::circuit::{ArithmeticCircuit, PartitionType, Witness};
use crate::range_proof::reciprocal;
use crate::range_proof::u64_proof::*;
use crate::util::minus;
use crate::{circuit, range_proof, wnla};
use k256::elliptic_curve::rand_core::OsRng;
use k256::elliptic_curve::Group;
use k256::{ProjectivePoint, Scalar};

#[test]
fn u64_proof_works() {
    let mut rand = OsRng::default();

    let x = 123456u64;
    let s = k256::Scalar::generate_biased(&mut rand);

    println!(
        "Value {}, blinding: {}",
        x,
        serde_json::to_string_pretty(&s).unwrap()
    );

    // Base points
    let g = k256::ProjectivePoint::random(&mut rand);
    let g_vec = (0..G_VEC_FULL_SZ)
        .map(|_| k256::ProjectivePoint::random(&mut rand))
        .collect::<Vec<ProjectivePoint>>();
    let h_vec = (0..H_VEC_FULL_SZ)
        .map(|_| k256::ProjectivePoint::random(&mut rand))
        .collect::<Vec<ProjectivePoint>>();

    let public = range_proof::u64_proof::U64RangeProofProtocol { g, g_vec, h_vec };

    let commitment = public.commit_value(x, &s);

    let mut pt = merlin::Transcript::new(b"u64 range proof");
    let proof = public.prove(x, &s, &mut pt, &mut rand);

    println!(
        "Commitment: {}",
        serde_json::to_string_pretty(&commitment.to_affine()).unwrap()
    );
    println!(
        "Proof: {}",
        serde_json::to_string_pretty(&reciprocal::SerializableProof::from(&proof)).unwrap()
    );

    let mut vt = merlin::Transcript::new(b"u64 range proof");
    assert!(public.verify(&commitment, proof, &mut vt));
}

#[test]
fn ac_works() {
    // Test the knowledge of x, y for public z, r, such:
    // x + y = r
    // x * y = z

    let x = Scalar::from(3u32);
    let y = Scalar::from(5u32);

    let r = Scalar::from(8u32);
    let z = Scalar::from(15u32);

    let w_l = vec![Scalar::from(x)];
    let w_r = vec![Scalar::from(y)];
    let w_o = vec![Scalar::from(z), Scalar::from(r)];

    let dim_nm = 1;
    let dim_no = 2;
    let dim_nv = 2;
    let k = 1;

    let dim_nl = dim_nv * k; // 2
    let dim_nw = dim_nm + dim_nm + dim_no; // 4

    let W_m = vec![vec![Scalar::ZERO, Scalar::ZERO, Scalar::ONE, Scalar::ZERO]]; // Nm*Nw
    let a_m = vec![Scalar::ZERO]; // Nm

    let W_l = vec![
        vec![Scalar::ZERO, Scalar::ONE, Scalar::ZERO, Scalar::ZERO],
        vec![
            Scalar::ZERO,
            Scalar::ZERO.sub(&Scalar::ONE),
            Scalar::ONE,
            Scalar::ZERO,
        ],
    ]; // Nl*Nw

    let a_l = vec![minus(&r), minus(&z)]; // Nl

    //let w_v = vec![Scalar::from(x), Scalar::from(y)];
    //let w = vec![Scalar::from(x), Scalar::from(y), Scalar::from(z), Scalar::from(r)]; // w = wl||wr||wo
    //println!("Circuit check: {:?} = {:?}", vector_mul(&W_m[0], &w), vector_hadamard_mul(&w_l, &w_r));
    //println!("Circuit check: {:?} = 0", vector_add(&vector_add(&vec![vector_mul(&W_l[0], &w), vector_mul(&W_l[1], &w)], &w_v), &a_l));

    let mut rand = OsRng::default();

    let g = k256::ProjectivePoint::random(&mut rand);
    let g_vec = (0..1)
        .map(|_| k256::ProjectivePoint::random(&mut rand))
        .collect::<Vec<ProjectivePoint>>();
    let h_vec = (0..16)
        .map(|_| k256::ProjectivePoint::random(&mut rand))
        .collect::<Vec<ProjectivePoint>>();

    let partition = |typ: PartitionType, index: usize| -> Option<usize> {
        match typ {
            PartitionType::LL => Some(index),
            _ => None,
        }
    };

    let circuit = ArithmeticCircuit {
        dim_nm,
        dim_no,
        k,
        dim_nl,
        dim_nv,
        dim_nw,
        g,
        g_vec: g_vec[..dim_nm].to_vec(),
        h_vec: h_vec[..9 + dim_nv].to_vec(),
        W_m,
        W_l,
        a_m,
        a_l,
        f_l: true,
        f_m: false,
        g_vec_: g_vec[dim_nm..].to_vec(),
        h_vec_: h_vec[9 + dim_nv..].to_vec(),
        partition,
    };

    let witness = Witness {
        v: vec![vec![x, y]],
        s_v: vec![k256::Scalar::generate_biased(&mut rand)],
        w_l,
        w_r,
        w_o,
    };

    let v = (0..k)
        .map(|i| circuit.commit(&witness.v[i], &witness.s_v[i]))
        .collect::<Vec<ProjectivePoint>>();

    let mut pt = merlin::Transcript::new(b"circuit test");
    let proof = circuit.prove::<OsRng>(&v, witness, &mut pt, &mut rand);

    println!(
        "{}",
        serde_json::to_string_pretty(&circuit::SerializableProof::from(&proof)).unwrap()
    );

    let mut vt = merlin::Transcript::new(b"circuit test");
    assert!(circuit.verify(&v, &mut vt, proof));
}

#[test]
fn wnla_works() {
    const N: i32 = 4;

    let mut rand = OsRng::default();

    let g = k256::ProjectivePoint::random(&mut rand);
    let g_vec = (0..N)
        .map(|_| k256::ProjectivePoint::random(&mut rand))
        .collect();
    let h_vec = (0..N)
        .map(|_| k256::ProjectivePoint::random(&mut rand))
        .collect();
    let c = (0..N)
        .map(|_| k256::Scalar::generate_biased(&mut rand))
        .collect();
    let rho = k256::Scalar::generate_biased(&mut rand);

    let wnla = wnla::WeightNormLinearArgument {
        g,
        g_vec,
        h_vec,
        c,
        rho,
        mu: rho.mul(&rho),
    };

    let l = vec![
        Scalar::from(1 as u32),
        Scalar::from(2 as u32),
        Scalar::from(3 as u32),
        Scalar::from(4 as u32),
    ];
    let n = vec![
        Scalar::from(8 as u32),
        Scalar::from(7 as u32),
        Scalar::from(6 as u32),
        Scalar::from(5 as u32),
    ];

    let commit = wnla.commit(&l, &n);
    let mut pt = merlin::Transcript::new(b"wnla test");

    let proof = wnla.prove(&commit, &mut pt, l, n);

    println!(
        "{}",
        serde_json::to_string_pretty(&wnla::SerializableProof::from(&proof)).unwrap()
    );

    let mut vt = merlin::Transcript::new(b"wnla test");
    assert!(wnla.verify(&commit, &mut vt, proof))
}
