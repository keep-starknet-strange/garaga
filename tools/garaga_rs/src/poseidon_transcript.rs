use crate::io::parse_field_elements_from_list;
use lambdaworks_crypto::hash::poseidon::{starknet::PoseidonCairoStark252, Poseidon};
use lambdaworks_math::field::{
    element::FieldElement, fields::fft_friendly::stark_252_prime_field::Stark252PrimeField,
};
use num_bigint::BigUint;

const BASE_96_FELT252: FieldElement<Stark252PrimeField> =
    FieldElement::from_hex_unchecked("0x1000000000000000000000000");

pub struct CairoPoseidonTranscript {
    pub init_hash: FieldElement<Stark252PrimeField>,
    pub state: [FieldElement<Stark252PrimeField>; 3],
}

pub fn bigint_split_4_96(x: &BigUint) -> [FieldElement<Stark252PrimeField>; 4] {
    let one = &BigUint::from(1usize);
    assert!(x < &(one << 384));
    let base = one << 96;
    let mask = &(base - one);
    let limbs = [x & mask, (x >> 96) & mask, (x >> 192) & mask, x >> 288];
    let elems = parse_field_elements_from_list::<Stark252PrimeField>(&limbs).unwrap();
    [elems[0], elems[1], elems[2], elems[3]]
}

pub fn bigint_split_2_128(x: &BigUint) -> [FieldElement<Stark252PrimeField>; 2] {
    let one = &BigUint::from(1usize);
    assert!(x < &(one << 256));
    let base = one << 128;
    let mask = &(base - one);
    let limbs = [x & mask, x >> 128];
    let elems = parse_field_elements_from_list::<Stark252PrimeField>(&limbs).unwrap();
    [elems[0], elems[1]]
}

impl CairoPoseidonTranscript {
    pub fn new(init_hash: FieldElement<Stark252PrimeField>) -> Self {
        let mut state = [init_hash, FieldElement::zero(), FieldElement::one()];
        PoseidonCairoStark252::hades_permutation(&mut state);
        Self { init_hash, state }
    }

    pub fn continuable_hash(&self) -> FieldElement<Stark252PrimeField> {
        self.state[0]
    }

    pub fn rlc_coeff(&mut self) -> FieldElement<Stark252PrimeField> {
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
        x: &BigUint,
    ) -> (
        FieldElement<Stark252PrimeField>,
        FieldElement<Stark252PrimeField>,
    ) {
        let elems = bigint_split_4_96(x);
        self.state[0] += elems[0] + BASE_96_FELT252 * elems[1];
        self.state[1] += elems[2] + BASE_96_FELT252 * elems[3];
        PoseidonCairoStark252::hades_permutation(&mut self.state);
        (self.state[0], self.state[1])
    }

    pub fn hash_u256(&mut self, x: &BigUint) -> FieldElement<Stark252PrimeField> {
        let elems = bigint_split_2_128(x);
        self.state[0] += elems[0];
        self.state[1] += elems[1];
        PoseidonCairoStark252::hades_permutation(&mut self.state);
        self.state[0]
    }

    pub fn hash_u256_multi(&mut self, xs: &[BigUint]) -> FieldElement<Stark252PrimeField> {
        for x in xs {
            self.hash_u256(x);
        }
        self.state[0]
    }

    pub fn hash_limbs_multi(&mut self, xs: &[BigUint], sparsity: Option<&[bool]>) {
        if let Some(sparsity) = sparsity {
            assert_eq!(xs.len(), sparsity.len());
            for i in 0..xs.len() {
                if sparsity[i] {
                    self.hash_element(&xs[i]);
                }
            }
        } else {
            for x in xs {
                self.hash_element(x);
            }
        }
    }
}

#[cfg(test)]
mod tests {
    use super::CairoPoseidonTranscript;
    use lambdaworks_math::field::element::FieldElement;
    use num_bigint::BigUint;

    #[test]
    fn test_hash_element() {
        let values = vec![
            "11104976625974322414992515260237855724255768622271447502939221706321239646163926750529079402619769361141474851372384",
            "3967829709048026487667605767879663147330695847448860299062651717898165991149219471605164102628080243401554871141161",
            "20542379293379792421624641272746453190479316725484729966518436208854994615297484525229284199372356175508316843532962",
            "17650899844399818850216658397857397433150932740144581357248968616099085471799047373874018729030516138169880851496140",
            "23153291335322918391032655582853912472568833796263669034103198103796686482485894027826714525281391374850320336394313",
            "32367456268301553665798368340615053510284603246272143427825701218738172825017097170094900631328955480180538273877253",
        ];
        let values = values
            .iter()
            .map(|s| BigUint::parse_bytes(s.as_bytes(), 10).unwrap())
            .collect::<Vec<BigUint>>();
        let mut transcript = CairoPoseidonTranscript::new(FieldElement::one());
        for value in values {
            transcript.hash_element(&value);
        }
        let expected_res = transcript.continuable_hash();
        assert_eq!(
            expected_res,
            FieldElement::from_hex(
                "1028bcbbe4e9dd667f81f2b28324f4f73abadd9101d3d3dd55cda0db20a1a0b"
            )
            .unwrap()
        );
    }

    #[test]
    fn test_hash_u256() {
        let values = vec![
            "11104976625974322414992515260237855724255768622271447502939221706321239646163926750529079402619769361141474851372384",
            "3967829709048026487667605767879663147330695847448860299062651717898165991149219471605164102628080243401554871141161",
            "20542379293379792421624641272746453190479316725484729966518436208854994615297484525229284199372356175508316843532962",
            "17650899844399818850216658397857397433150932740144581357248968616099085471799047373874018729030516138169880851496140",
            "23153291335322918391032655582853912472568833796263669034103198103796686482485894027826714525281391374850320336394313",
            "32367456268301553665798368340615053510284603246272143427825701218738172825017097170094900631328955480180538273877253",
        ];
        let values = values
            .iter()
            .map(|s| BigUint::parse_bytes(s.as_bytes(), 10).unwrap())
            .collect::<Vec<BigUint>>();
        let mut transcript = CairoPoseidonTranscript::new(FieldElement::one());
        for value in values {
            transcript.hash_u256(&(value % (BigUint::from(1usize) << 256)));
        }
        let expected_res = transcript.continuable_hash();
        assert_eq!(
            expected_res,
            FieldElement::from_hex(
                "208cbc82b04dc4b1d48ccc53b1d756493ea79b1f0a836bc0f3163ea249dfb13"
            )
            .unwrap()
        );
    }
}
