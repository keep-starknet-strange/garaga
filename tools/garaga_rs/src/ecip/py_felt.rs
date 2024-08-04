#[derive(Debug, Clone, PartialEq, Eq)]
pub struct PyFelt {
    value: u64,
    p: u64,
}

impl PyFelt {
    pub fn new(value: u64, p: u64) -> Self {
        Self { value: value % p, p }
    }

    pub fn felt(&self) -> &Self {
        self
    }

    pub fn inv(&self) -> Self {
        Self::new(modinverse(self.value, self.p), self.p)
    }
}

// Helper function for modular inverse (assuming `modinverse` is defined somewhere in your code)
fn modinverse(a: u64, p: u64) -> u64 {
    // Extended Euclidean Algorithm to find the modular inverse
    let mut m0 = p;
    let mut y = 0;
    let mut x = 1;

    if p == 1 {
        return 0;
    }

    let mut a = a;
    while a > 1 {
        let q = a / p;
        let mut t = p;

        p = a % p;
        a = t;
        t = y;

        y = x - q * y;
        x = t;
    }

    if x < 0 {
        x += m0;
    }

    x
}

// Implementing basic operations for PyFelt
impl std::ops::Add for PyFelt {
    type Output = PyFelt;

    fn add(self, other: PyFelt) -> PyFelt {
        PyFelt::new((self.value + other.value) % self.p, self.p)
    }
}

impl std::ops::Sub for PyFelt {
    type Output = PyFelt;

    fn sub(self, other: PyFelt) -> PyFelt {
        PyFelt::new((self.value + self.p - other.value) % self.p, self.p)
    }
}

impl std::ops::Neg for PyFelt {
    type Output = PyFelt;

    fn neg(self) -> PyFelt {
        PyFelt::new(self.p - self.value, self.p)
    }
}

impl std::ops::Mul for PyFelt {
    type Output = PyFelt;

    fn mul(self, other: PyFelt) -> PyFelt {
        PyFelt::new((self.value * other.value) % self.p, self.p)
    }
}

impl std::ops::Div for PyFelt {
    type Output = PyFelt;

    fn div(self, other: PyFelt) -> PyFelt {
        self * other.inv()
    }
}

impl std::ops::Rem for PyFelt {
    type Output = PyFelt;

    fn rem(self, other: PyFelt) -> PyFelt {
        PyFelt::new(self.value % other.value, self.p)
    }
}

impl std::fmt::Display for PyFelt {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        let p_str = format!("0x{:x}", self.p);
        let p_display = if p_str.len() > 10 {
            format!("{}...{}", &p_str[..6], &p_str[p_str.len() - 4..])
        } else {
            p_str
        };
        write!(f, "PyFelt({}, {})", self.value, p_display)
    }
}
