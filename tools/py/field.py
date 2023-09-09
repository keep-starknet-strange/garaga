def xgcd(x, y):
    old_r, r = (x, y)
    old_s, s = (1, 0)
    old_t, t = (0, 1)

    while r != 0:
        quotient = old_r // r
        old_r, r = (r, old_r - quotient * r)
        old_s, s = (s, old_s - quotient * s)
        old_t, t = (t, old_t - quotient * t)

    return old_s, old_t, old_r  # a, b, g


class BaseFieldElement:
    def __init__(self, value, field):
        self.value = value
        self.field = field

    def __add__(self, right):
        return self.field.add(self, right)

    def __mul__(self, right):
        return self.field.multiply(self, right)

    def __sub__(self, right):
        return self.field.subtract(self, right)

    def __truediv__(self, right):
        return self.field.divide(self, right)

    def __neg__(self):
        return self.field.negate(self)

    def inverse(self):
        return self.field.inverse(self)

    # modular exponentiation -- be sure to encapsulate in parentheses!
    def __xor__(self, exponent):
        acc = BaseFieldElement(1, self.field)
        val = BaseFieldElement(self.value, self.field)
        for i in reversed(range(len(bin(exponent)[2:]))):
            acc = acc * acc
            if (1 << i) & exponent != 0:
                acc = acc * val
        return acc

    def __eq__(self, other):
        return self.value == other.value

    def __neq__(self, other):
        return self.value != other.value

    def __str__(self):
        return str(self.value)

    def __bytes__(self):
        return bytes(str(self).encode())

    def is_zero(self):
        if self.value == 0:
            return True
        else:
            return False

    def has_order_po2(self, order):
        assert order & (order - 1) == 0
        if self == self.field.one() and order == 1:
            return True
        return (self ^ order) == self.field.one() and not (
            self ^ (order // 2)
        ) == self.field.one()

    def __hash__(self):
        return self.value


class BaseField:
    def __init__(self, p):
        self.p = p

    def lift(self, bfe):
        return bfe

    def zero(self):
        return BaseFieldElement(0, self)

    def one(self):
        return BaseFieldElement(1, self)

    def multiply(self, left, right):
        return BaseFieldElement((left.value * right.value) % self.p, self)

    def add(self, left, right):
        return BaseFieldElement((left.value + right.value) % self.p, self)

    def subtract(self, left, right):
        return BaseFieldElement((self.p + left.value - right.value) % self.p, self)

    def negate(self, operand):
        return BaseFieldElement((self.p - operand.value) % self.p, self)

    def inverse(self, operand):
        a, b, g = xgcd(operand.value, self.p)
        return BaseFieldElement(((a % self.p) + self.p) % self.p, self)

    def divide(self, left, right):
        assert not right.is_zero(), "divide by zero"
        a, b, g = xgcd(right.value, self.p)
        return BaseFieldElement(left.value * a % self.p, self)

    def main():
        # p = 2^64 - 2^32 + 1
        #   = 1 + 3 * 5 * 17 * 257 * 65537 * 2^32
        #   = 1 + 4294967295 * 2^32
        p = 18446744069414584321  # 2^64 - 2^32 + 1
        return BaseField(p)

    def generator(self):
        assert self.p == 1 + (1 << 64) - (
            1 << 32
        ), "Do not know generator for other fields beyond 2^64 - 2^32 + 1"
        return BaseFieldElement(7, self)

    def primitive_nth_root(self, n):
        if self.p == 1 + (1 << 64) - (1 << 32):
            assert (
                n <= 1 << 32 and (n & (n - 1)) == 0
            ), "Field does not have nth root of unity where n > 2^32 or not power of two."
            # 1753635133440165772
            # = 7^4294967295 mod p
            # = 7*(3 * 5 * 17 * 257 * 65537) mod p
            root = BaseFieldElement(1753635133440165772, self)
            order = 1 << 32
            while order != n:
                root = root ^ 2
                order = order / 2
            return root
        else:
            assert False, "Unknown field, can't return root of unity."

    def sample(self, byte_array):
        acc = 0
        for b in byte_array:
            acc = (acc << 8) ^ int(b)
        return BaseFieldElement(acc % self.p, self)

    def __call__(self, integer):
        return BaseFieldElement(integer % self.p, self)
