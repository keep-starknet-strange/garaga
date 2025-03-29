// Return the number of trailing ones in a 64-bit unsigned integer.
// Ex : trailing_ones(0b111) = 3
// The number of parents that need to be added when a new leaf is inserted (using the # of leaves
// before insertion)
// Ex if n=1 leaf, trailing_ones(1) = 1, when adding a new leave, 1 parent will be created.
pub fn trailing_ones(n: u64) -> usize {
    if n == 0 {
        return 0;
    }
    let mut count = 0;
    let (mut n, mut mod_n) = DivRem::div_rem(n, 2);
    while mod_n != 0 {
        let (_n, _mod_n) = DivRem::div_rem(n, 2);
        n = _n;
        mod_n = _mod_n;
        count += 1;
    }
    return count;
}

#[cfg(test)]
mod tests {
    use super::trailing_ones;
    #[test]
    fn test_trailing_ones() {
        assert(trailing_ones(7) == 3, 'Invalid trailing_ones');
        assert(trailing_ones(11) == 2, 'Invalid trailing_ones');
        assert(trailing_ones(0) == 0, 'Invalid trailing_ones');
        assert(trailing_ones(1) == 1, 'Invalid trailing_ones');
        assert(trailing_ones(2) == 0, 'Invalid trailing_ones');
        assert(trailing_ones(3) == 2, 'Invalid trailing_ones');
        assert(trailing_ones(9) == 1, 'Invalid trailing_ones');
        assert(trailing_ones(5) == 1, 'Invalid trailing_ones');
        assert(trailing_ones(6) == 0, 'Invalid trailing_ones');
    }
}
