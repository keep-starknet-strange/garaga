use lambdaworks_crypto::hash::poseidon::{starknet::PoseidonCairoStark252, Poseidon};
use lambdaworks_math::field::{
    element::FieldElement, fields::fft_friendly::stark_252_prime_field::Stark252PrimeField,
};

pub struct CairoPoseidonTranscript {
    pub init_hash: FieldElement<Stark252PrimeField>,
    pub state: Vec<FieldElement<Stark252PrimeField>>,
    pub permutations_count: usize,
    pub poseidon_ptr_indexes: Vec<usize>,
}

impl CairoPoseidonTranscript {
    pub fn new(init_hash: FieldElement<Stark252PrimeField>) -> Self {
        let mut state = vec![init_hash, FieldElement::zero(), FieldElement::one()];
        PoseidonCairoStark252::hades_permutation(&mut state);
        Self {
            init_hash,
            state,
            permutations_count: 1,
            poseidon_ptr_indexes: Vec::new(),
        }
    }

    pub fn continuable_hash(&self) -> FieldElement<Stark252PrimeField> {
        self.state[0]
    }

    pub fn rlc_coeff(&mut self) -> FieldElement<Stark252PrimeField> {
        // A function to retrieve the random linear combination coefficient after a permutation.
        // Stores the index of the last permutation in the poseidon_ptr_indexes list, to be used to retrieve RLC coefficients later.
        self.poseidon_ptr_indexes.push(self.permutations_count - 1);
        self.state[1]
    }

    pub fn update_sponge_state(
        &mut self,
        x: FieldElement<Stark252PrimeField>,
        y: FieldElement<Stark252PrimeField>,
    ) {
        self.state[0] += x;
        self.state[1] += y;
        PoseidonCairoStark252::hades_permutation(&mut self.state);
    }

    pub fn hash_element(
        &mut self,
        x: FieldElement<Stark252PrimeField>,
    ) -> (
        FieldElement<Stark252PrimeField>,
        FieldElement<Stark252PrimeField>,
    ) {
        let base = FieldElement::<Stark252PrimeField>::one().pow(192usize);
        let high = x / base;
        let low = x - high * base;
        self.state[0] += low;
        self.state[1] += high;
        PoseidonCairoStark252::hades_permutation(&mut self.state);
        self.permutations_count += 1;
        (self.state[0], self.state[1])
    }

    pub fn hash_u256(
        &mut self,
        x: FieldElement<Stark252PrimeField>,
    ) -> FieldElement<Stark252PrimeField> {
        let base = FieldElement::<Stark252PrimeField>::one().pow(128usize);
        let high = x / base;
        let low = x - high * base;
        self.state[0] += low;
        self.state[1] += high;
        PoseidonCairoStark252::hades_permutation(&mut self.state);
        self.permutations_count += 1;
        self.state[0]
    }

    pub fn hash_u256_multi(
        &mut self,
        xs: &[FieldElement<Stark252PrimeField>],
    ) -> FieldElement<Stark252PrimeField> {
        for x in xs {
            self.hash_u256(*x);
        }
        self.state[0]
    }

    pub fn hash_limbs_multi(
        &mut self,
        xs: &[FieldElement<Stark252PrimeField>],
        sparsity: Option<&[bool]>,
    ) -> FieldElement<Stark252PrimeField> {
        if let Some(sparsity) = sparsity {
            assert_eq!(xs.len(), sparsity.len());
            for i in 0..xs.len() {
                if sparsity[i] {
                    self.hash_element(xs[i]);
                }
            }
        } else {
            for i in 0..xs.len() {
                self.hash_element(xs[i]);
            }
        }
        self.state[0]
    }
}
