pub struct BaseField {
    p: u64,
}

impl BaseField {
    pub fn new(p: u64) -> Self {
        Self { p }
    }

    pub fn call(&self, integer: u64) -> PyFelt {
        PyFelt::new(integer % self.p, self.p)
    }

    pub fn zero(&self) -> PyFelt {
        PyFelt::new(0, self.p)
    }

    pub fn one(&self) -> PyFelt {
        PyFelt::new(1, self.p)
    }

    pub fn random(&self) -> PyFelt {
        use rand::Rng;
        let mut rng = rand::thread_rng();
        PyFelt::new(rng.gen_range(0..self.p), self.p)
    }
}
