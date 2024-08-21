use lambdaworks_crypto::hash::poseidon::{starknet::PoseidonCairoStark252, Poseidon};
use lambdaworks_math::{
    field::{
        element::FieldElement, fields::fft_friendly::stark_252_prime_field::Stark252PrimeField,
    },
    traits::ByteConversion,
};
use num_bigint::BigUint;
use num_integer::Integer;
use num_traits::{One, Zero};

const BASE: u128 = 1 << 96;
const N_LIMBS: u32 = 4;

fn hades_permutation(s0: &BigUint, s1: &BigUint, s2: &BigUint) -> (BigUint, BigUint, BigUint) {
    let mut state: Vec<FieldElement<Stark252PrimeField>> = vec![
        FieldElement::<Stark252PrimeField>::from_bytes_be(&s0.to_bytes_be())
            .expect("Unable to convert first param from bytes to FieldElement"),
        FieldElement::<Stark252PrimeField>::from_bytes_be(&s1.to_bytes_be())
            .expect("Unable to convert second param from bytes to FieldElement"),
        FieldElement::<Stark252PrimeField>::from_bytes_be(&s2.to_bytes_be())
            .expect("Unable to convert third param from bytes to FieldElement"),
    ];
    PoseidonCairoStark252::hades_permutation(&mut state);
    let s0 = BigUint::from_bytes_be(&state[0].to_bytes_be());
    let s1 = BigUint::from_bytes_be(&state[0].to_bytes_be());
    let s2 = BigUint::from_bytes_be(&state[0].to_bytes_be());
    (s0, s1, s2)
}

fn bigint_split(x: &BigUint, n_limbs: u32, base: &BigUint) -> Vec<BigUint> {
    let mut x = x.clone();
    let mut coeffs = vec![];
    let degree = n_limbs - 1;
    for i in 0..degree {
        let n = degree - (i + 1);
        let (q, r) = x.div_rem(&base.pow(n));
        coeffs.insert(0, q);
        x = r;
    }
    coeffs.insert(0, x.clone());
    coeffs
}

pub struct CairoPoseidonTranscript {
    pub init_hash: BigUint,
    pub s: (BigUint, BigUint, BigUint),
    pub permutations_count: usize,
    pub poseidon_ptr_indexes: Vec<usize>,
}

impl CairoPoseidonTranscript {
    pub fn new(init_hash: BigUint) -> Self {
        let s = hades_permutation(&init_hash, &BigUint::zero(), &BigUint::one());
        Self {
            init_hash,
            s,
            permutations_count: 1,
            poseidon_ptr_indexes: Vec::new(),
        }
    }

    pub fn continuable_hash(&self) -> &BigUint {
        &self.s.0
    }

    pub fn rlc_coeff(&mut self) -> &BigUint {
        // A function to retrieve the random linear combination coefficient after a permutation.
        // Stores the index of the last permutation in the poseidon_ptr_indexes list, to be used to retrieve RLC coefficients later.
        self.poseidon_ptr_indexes.push(self.permutations_count - 1);
        &self.s.1
    }

    pub fn update_sponge_state(&mut self, x: &BigUint, y: &BigUint) {
        self.s = hades_permutation(&(&self.s.0 + x), &(&self.s.1 + y), &self.s.2);
    }

    pub fn hash_element(&mut self, x: &BigUint) -> (&BigUint, &BigUint) {
        let limbs = bigint_split(x, N_LIMBS, &BigUint::from(BASE));
        self.s = hades_permutation(
            &(&self.s.0 + &limbs[0] + BASE * &limbs[1]),
            &(&self.s.1 + &limbs[2] + BASE * &limbs[3]),
            &self.s.2,
        );
        self.permutations_count += 1;
        (&self.s.0, &self.s.1)
    }

    pub fn hash_u256(&mut self, x: &BigUint) -> &BigUint {
        assert!(x < &(BigUint::one() << 256));
        let limbs = bigint_split(x, 2, &(BigUint::one() << 128));
        let (low, high) = (&limbs[0], &limbs[1]);
        self.s = hades_permutation(&(&self.s.0 + low), &(&self.s.1 + high), &self.s.2);
        self.permutations_count += 1;
        &self.s.0
    }

    pub fn hash_u256_multi(&mut self, xs: &[BigUint]) -> &BigUint {
        for x in xs {
            self.hash_u256(x);
        }
        &self.s.0
    }

    pub fn hash_limbs_multi(&mut self, xs: &[BigUint], sparsity: Option<Vec<bool>>) -> &BigUint {
        if let Some(indexes) = sparsity {
            for i in 0..xs.len() {
                if indexes[i] {
                    self.hash_element(&xs[i]);
                }
            }
        } else {
            for i in 0..xs.len() {
                self.hash_element(&xs[i]);
            }
        }
        &self.s.0
    }
}
