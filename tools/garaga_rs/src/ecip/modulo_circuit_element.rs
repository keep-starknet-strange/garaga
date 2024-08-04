#[derive(Debug, Clone)]
pub struct ModuloCircuitElement {
    emulated_felt: PyFelt,
    offset: u64,
}

impl ModuloCircuitElement {
    pub fn new(emulated_felt: PyFelt, offset: u64) -> Self {
        Self { emulated_felt, offset }
    }

    pub fn value(&self) -> u64 {
        self.emulated_felt.value
    }

    pub fn p(&self) -> u64 {
        self.emulated_felt.p
    }

    pub fn felt(&self) -> &PyFelt {
        &self.emulated_felt
    }
}
