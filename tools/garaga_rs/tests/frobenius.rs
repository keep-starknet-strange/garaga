use algebra::extf_mul::{direct_to_tower, from_e12, to_e12, tower_to_direct};
use algebra::g1point::G1Point;
use algebra::g2point::G2Point;
use algebra::polynomial::Polynomial;
use definitions::{BLS12381PrimeField, BN254PrimeField, CurveID};
use garaga_rs::{algebra, definitions, frobenius, pairing::multi_pairing_check};
use lambdaworks_math::elliptic_curve::short_weierstrass::curves::{
    bls12_381::field_extension as bls, bn_254::field_extension as bn,
};
use lambdaworks_math::field::element::FieldElement;

macro_rules! check_curve {
    ($name:ident, $field:ty, $extension:ident, $prime:expr, $curve:expr, $powers:expr) => {
        #[test]
        fn $name() {
            type F = $field;
            let maps = frobenius::get_frobenius_maps_ext_degree_12::<F>($curve);
            let mut fixtures: Vec<Vec<u64>> =
                vec![vec![], vec![0], vec![1], vec![5], vec![1, 2], vec![0, 0, 1]];
            for degree in 0..12 {
                let mut monomial = vec![0; degree + 1];
                monomial[degree] = 1;
                fixtures.push(monomial);
                fixtures.push((0..=degree).map(|i| (i * i + 3 * i + 7) as u64).collect());
            }
            for coefficients in fixtures {
                let x = Polynomial::<F>::new(
                    coefficients.into_iter().map(FieldElement::from).collect(),
                );
                let tower = direct_to_tower(&x.get_coefficients_ext_degree(12), 12);
                let tower = to_e12::<
                    F,
                    $extension::Degree2ExtensionField,
                    $extension::Degree6ExtensionField,
                    $extension::Degree12ExtensionField,
                >(tower.try_into().unwrap());
                for power in $powers {
                    let mut expected = tower.clone();
                    for _ in 0..power {
                        expected = expected.pow($prime);
                    }
                    let expected = from_e12::<
                        F,
                        $extension::Degree2ExtensionField,
                        $extension::Degree6ExtensionField,
                        $extension::Degree12ExtensionField,
                    >(expected);
                    let expected = tower_to_direct(&expected, 12);
                    let actual = frobenius::frobenius(&maps, &x, power, 12);
                    assert_eq!(
                        actual.get_coefficients_ext_degree(12),
                        expected,
                        "curve {:?}, power {}, input {:?}",
                        $curve,
                        power,
                        x.coefficients
                    );
                }
            }
        }
    };
}
check_curve!(
    bn254_frobenius_matches_tower_powers,
    BN254PrimeField,
    bn,
    bn::BN254_PRIME_FIELD_ORDER,
    CurveID::BN254,
    [1, 2, 3]
);
check_curve!(
    bls381_frobenius_matches_tower_powers,
    BLS12381PrimeField,
    bls,
    bls::BLS12381_PRIME_FIELD_ORDER,
    CurveID::BLS12_381,
    [1]
);

macro_rules! cancellation {
    ($name:ident, $field:ty, $extension:ident) => {
        #[test]
        fn $name() {
            type F = $field;
            let p = G1Point::<F>::generator();
            let q = G2Point::<F, $extension::Degree2ExtensionField>::generator();
            let ps = [p.clone(), p.neg()];
            let qs = [q.clone(), q];
            let result = multi_pairing_check::multi_pairing_check::<
                F,
                $extension::Degree2ExtensionField,
                $extension::Degree6ExtensionField,
                $extension::Degree12ExtensionField,
            >(&ps, &qs, &None);
            assert_eq!(
                result.0.get_coefficients_ext_degree(12),
                Polynomial::<F>::one().get_coefficients_ext_degree(12)
            );
        }
    };
}
cancellation!(bn254_generator_cancellation_pairing, BN254PrimeField, bn);
cancellation!(
    bls381_generator_cancellation_pairing,
    BLS12381PrimeField,
    bls
);
