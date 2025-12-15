fn main(x: Field, y: pub Field, z: pub Field, k: pub Field) -> pub Field {
    assert(x != y);
    assert(z != k);
    z + k
}

#[test]
fn test_main() {
    main(1, 2, 3, 4);

    // Uncomment to make test fail
    // main(1, 1);
}
