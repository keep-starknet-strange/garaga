use risc0_zkvm::guest::env;

fn main() {
    // reads the public bounds and private n provided by the Host
    let l: u32 = env::read();
    let u: u32 = env::read();
    let n: u32 = env::read();

    // sanity check for the bounds
    assert!(l <= n && n < u);

    // performs the computation
    let fib_n: u32 = fibonacci(n);

    fn fibonacci(n: u32) -> u32 {
        let mut a = 0;
        let mut b = 1;
        for _ in 0..n {
            (a, b) = (b, a + b);
        }
        a
    }

    // writes the public inputs and output to the journal
    env::commit(&l);
    env::commit(&u);
    env::commit(&fib_n);
}
