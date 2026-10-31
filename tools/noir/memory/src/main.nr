fn main(index: u32, value: u64, expected: pub u64) {
    assert(index < 4);
    let table = [11_u64, 17, 23, 31];
    let mut memory = [1_u64, 2, 3, 4];
    memory[index] = value;
    let next = (index + 1) % 4;
    assert(table[index] + memory[index] + memory[next] == expected);
}
