use k256::elliptic_curve::ops::Invert;
use k256::elliptic_curve::Field;
use k256::Scalar;
use std::cmp::max;
use std::ops::{Add, Mul, Sub};

pub fn reduce<T>(v: &[T]) -> (Vec<T>, Vec<T>)
where
    T: Copy,
{
    let res0 = v
        .iter()
        .enumerate()
        .filter(|(i, _)| *i as i32 % 2 == 0)
        .map(|(_, x)| *x)
        .collect::<Vec<T>>();

    let res1 = v
        .iter()
        .enumerate()
        .filter(|(i, _)| *i as i32 % 2 == 1)
        .map(|(_, x)| *x)
        .collect::<Vec<T>>();

    (res0, res1)
}

pub fn vector_extend<T>(v: &[T], n: usize) -> Vec<T>
where
    T: Copy + Default,
{
    (0..n)
        .map(|i| if i < v.len() { v[i] } else { T::default() })
        .collect::<Vec<T>>()
}

pub fn weight_vector_mul<T>(a: &[T], b: &[Scalar], weight: &Scalar) -> T
where
    T: Copy + Default + Mul<Scalar, Output = T> + Add<Output = T>,
{
    let mut exp = Scalar::ONE;
    let mut result = T::default();

    let a_ext = vector_extend(a, max(a.len(), b.len()));
    let b_ext = &vector_extend(b, max(a.len(), b.len()));

    a_ext.iter().zip(b_ext).for_each(|(a_val, b_val)| {
        exp = exp.mul(weight);
        result = result.add(a_val.mul(b_val.mul(&exp)));
    });

    result
}

pub fn vector_mul<T>(a: &[T], b: &[Scalar]) -> T
where
    T: Copy + Default + Mul<Scalar, Output = T> + Add<Output = T>,
{
    let mut result = T::default();

    let a_ext = &vector_extend(a, max(a.len(), b.len()));
    let b_ext = &vector_extend(b, max(a.len(), b.len()));

    a_ext.iter().zip(b_ext).for_each(|(a_val, b_val)| {
        result = result.add(a_val.mul(*b_val));
    });

    result
}

pub fn vector_mul_on_scalar<'a, T>(a: &[T], s: &'a Scalar) -> Vec<T>
where
    T: Copy + Mul<&'a Scalar, Output = T>,
{
    a.iter().map(|x| x.mul(s)).collect::<Vec<T>>()
}

pub fn vector_add<T>(a: &[T], b: &[T]) -> Vec<T>
where
    T: Copy + Default + Add<Output = T>,
{
    let a_ext = &vector_extend(a, max(a.len(), b.len()));
    let b_ext = &vector_extend(b, max(a.len(), b.len()));
    a_ext
        .iter()
        .zip(b_ext)
        .map(|(a_val, b_val)| a_val.add(*b_val))
        .collect::<Vec<T>>()
}

pub fn vector_sub<'a, T>(a: &'a [T], b: &'a [T]) -> Vec<T>
where
    T: Copy + Default + Sub<Output = T>,
{
    let a_ext = &vector_extend(a, max(a.len(), b.len()));
    let b_ext = &vector_extend(b, max(a.len(), b.len()));
    a_ext
        .iter()
        .zip(b_ext)
        .map(|(a_val, b_val)| a_val.sub(*b_val))
        .collect::<Vec<T>>()
}

pub fn e(v: &Scalar, n: usize) -> Vec<Scalar> {
    let mut buf = Scalar::ONE;

    (0..n)
        .map(|_| {
            let val = buf;
            buf = buf.mul(v);
            val
        })
        .collect::<Vec<Scalar>>()
}

pub fn pow(s: &Scalar, n: usize) -> Scalar {
    s.pow_vartime([n as u64])
}

#[allow(dead_code)]
pub fn vector_hadamard_mul<T>(a: &[T], b: &[Scalar]) -> Vec<T>
where
    T: Copy + Default + Mul<Scalar, Output = T>,
{
    let a_ext = &vector_extend(a, max(a.len(), b.len()));
    let b_ext = &vector_extend(b, max(a.len(), b.len()));
    a_ext
        .iter()
        .zip(b_ext)
        .map(|(a_val, b_val)| a_val.mul(*b_val))
        .collect::<Vec<T>>()
}

pub fn vector_tensor_mul<'a, T>(a: &'a [T], b: &'a [Scalar]) -> Vec<T>
where
    T: Copy + Mul<&'a Scalar, Output = T>,
{
    b.iter()
        .map(|x| vector_mul_on_scalar(a, x))
        .collect::<Vec<Vec<T>>>()
        .concat()
}

pub fn diag_inv(x: &Scalar, n: usize) -> Vec<Vec<Scalar>> {
    let x_inv = x.invert_vartime().unwrap();
    let mut val = Scalar::ONE;

    (0..n)
        .map(|i| {
            (0..n)
                .map(|j| {
                    if i == j {
                        val = val.mul(x_inv);
                        val
                    } else {
                        Scalar::ZERO
                    }
                })
                .collect::<Vec<Scalar>>()
        })
        .collect::<Vec<Vec<Scalar>>>()
}

pub fn vector_mul_on_matrix<T>(a: &[T], m: &[Vec<Scalar>]) -> Vec<T>
where
    T: Copy + Default + Mul<Scalar, Output = T> + Add<Output = T>,
{
    (0..m[0].len())
        .map(|j| {
            let column = m.iter().map(|row| row[j]).collect::<Vec<Scalar>>();
            vector_mul(a, &column)
        })
        .collect::<Vec<T>>()
}

#[allow(dead_code)]
pub fn matrix_mul_on_vector<T>(a: &[T], m: &[Vec<Scalar>]) -> Vec<T>
where
    T: Copy + Default + Mul<Scalar, Output = T> + Add<Output = T>,
{
    m.iter().map(|v| vector_mul(a, v)).collect::<Vec<T>>()
}

pub fn minus<T>(v: &T) -> T
where
    T: Copy + Mul<Scalar, Output = T>,
{
    v.mul(Scalar::ZERO.sub(&Scalar::ONE))
}
