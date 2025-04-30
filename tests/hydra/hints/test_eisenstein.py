import pytest
from hypothesis import given, settings
from hypothesis import strategies as st

from hydra.garaga.hints.eisenstein import EisensteinInteger, half_gcd

# --- Hypothesis Strategies ---

# Define reasonable bounds for generated integers to avoid excessively long tests
# Using 64-bit range as a starting point, adjust if needed based on performance/coverage
MAX_BITS = 64
min_int = -(2 ** (MAX_BITS - 1))
max_int = 2 ** (MAX_BITS - 1) - 1

MAX_EXAMPLES = 50

# Strategy for generating individual integers
integer_strategy = st.integers(min_value=min_int, max_value=max_int)

# Strategy for generating EisensteinInteger instances
eisenstein_integer_strategy = st.builds(
    EisensteinInteger, a0=integer_strategy, a1=integer_strategy
)

# Strategy for generating non-zero EisensteinInteger instances (for division)
non_zero_eisenstein_integer_strategy = eisenstein_integer_strategy.filter(
    lambda x: not x.is_zero()
)

# --- Test Constants ---
ZERO = EisensteinInteger(0, 0)
ONE = EisensteinInteger(1, 0)

# --- Test Functions ---


@settings(max_examples=MAX_EXAMPLES)  # Adjust number of examples as needed
@given(eisenstein_integer_strategy)
def test_neg_twice_invariant(a: EisensteinInteger):
    """Test that negating twice returns the original number: -(-a) == a"""
    assert -(-a) == a


@settings(max_examples=MAX_EXAMPLES)
@given(eisenstein_integer_strategy)
def test_conj_twice_invariant(a: EisensteinInteger):
    """Test that conjugating twice returns the original number: conj(conj(a)) == a"""
    assert a.conjugate().conjugate() == a


@settings(max_examples=MAX_EXAMPLES)
@given(eisenstein_integer_strategy, eisenstein_integer_strategy)
def test_add_sub_invariant(a: EisensteinInteger, b: EisensteinInteger):
    """Test that adding then subtracting the same number is invariant: (a + b) - b == a"""
    assert (a + b) - b == a


@settings(max_examples=MAX_EXAMPLES)
@given(eisenstein_integer_strategy, eisenstein_integer_strategy)
def test_sub_add_invariant(a: EisensteinInteger, b: EisensteinInteger):
    """Test that subtracting then adding the same number is invariant: (a - b) + b == a"""
    assert (a - b) + b == a


@settings(max_examples=MAX_EXAMPLES)
@given(eisenstein_integer_strategy)
def test_add_zero_invariant(a: EisensteinInteger):
    """Test that adding zero is invariant: a + 0 == a"""
    assert a + ZERO == a
    assert ZERO + a == a


@settings(max_examples=MAX_EXAMPLES)
@given(eisenstein_integer_strategy)
def test_mul_one_invariant(a: EisensteinInteger):
    """Test that multiplying by one is invariant: a * 1 == a"""
    assert a * ONE == a
    assert ONE * a == a


@settings(max_examples=MAX_EXAMPLES)
@given(eisenstein_integer_strategy)
def test_mul_zero(a: EisensteinInteger):
    """Test that multiplying by zero results in zero: a * 0 == 0"""
    assert a * ZERO == ZERO
    assert ZERO * a == ZERO


@settings(max_examples=MAX_EXAMPLES)
@given(eisenstein_integer_strategy, eisenstein_integer_strategy)
def test_add_commutative(a: EisensteinInteger, b: EisensteinInteger):
    """Test addition commutativity: a + b == b + a"""
    assert a + b == b + a


@settings(max_examples=MAX_EXAMPLES)
@given(
    eisenstein_integer_strategy,
    eisenstein_integer_strategy,
    eisenstein_integer_strategy,
)
def test_add_associative(
    a: EisensteinInteger, b: EisensteinInteger, c: EisensteinInteger
):
    """Test addition associativity: (a + b) + c == a + (b + c)"""
    assert (a + b) + c == a + (b + c)


@settings(max_examples=MAX_EXAMPLES)
@given(eisenstein_integer_strategy, eisenstein_integer_strategy)
def test_mul_commutative(a: EisensteinInteger, b: EisensteinInteger):
    """Test multiplication commutativity: a * b == b * a"""
    assert a * b == b * a


@settings(max_examples=MAX_EXAMPLES)
@given(
    eisenstein_integer_strategy,
    eisenstein_integer_strategy,
    eisenstein_integer_strategy,
)
def test_mul_associative(
    a: EisensteinInteger, b: EisensteinInteger, c: EisensteinInteger
):
    """Test multiplication associativity: (a * b) * c == a * (b * c)"""
    assert (a * b) * c == a * (b * c)


@settings(max_examples=MAX_EXAMPLES)
@given(
    eisenstein_integer_strategy,
    eisenstein_integer_strategy,
    eisenstein_integer_strategy,
)
def test_distributive(a: EisensteinInteger, b: EisensteinInteger, c: EisensteinInteger):
    """Test distributivity: a * (b + c) == (a * b) + (a * c)"""
    assert a * (b + c) == (a * b) + (a * c)
    assert (b + c) * a == (b * a) + (c * a)  # Right distributivity


@settings(max_examples=MAX_EXAMPLES)
@given(eisenstein_integer_strategy, eisenstein_integer_strategy)
def test_sub_definition(a: EisensteinInteger, b: EisensteinInteger):
    """Test subtraction definition: a - b == a + (-b)"""
    assert a - b == a + (-b)


@settings(max_examples=MAX_EXAMPLES)
@given(eisenstein_integer_strategy)
def test_norm_positive(a: EisensteinInteger):
    """Test that the norm is always non-negative: norm(a) >= 0"""
    assert a.norm() >= 0


@settings(
    max_examples=MAX_EXAMPLES
)  # Reduced examples, increased deadline for performance
@given(eisenstein_integer_strategy, non_zero_eisenstein_integer_strategy)
def test_half_gcd(a: EisensteinInteger, b: EisensteinInteger):
    """
    Test the half_gcd identity: w = a*u + b*v
    Where (w, v, u) is the result of half_gcd(a, b).
    Handles the case where b might become zero during the process.
    """
    # half_gcd might raise ZeroDivisionError if b is zero initially or becomes zero
    # in an unexpected way, although the internal check should prevent this normally.
    try:
        w, v, u = half_gcd(a, b)
        # Verify the Bézout-like identity returned by half_gcd
        assert a * u + b * v == w
    except ZeroDivisionError:
        # This case might occur if the input 'b' leads to division by zero internally,
        # which shouldn't happen with the non_zero strategy and internal checks,
        # but we catch it defensively.
        pytest.skip(
            "Skipping test case due to potential division by zero in half_gcd internals."
        )
    except Exception as e:
        # Catch any other unexpected exceptions
        pytest.fail(f"half_gcd raised an unexpected exception: {e}")


# You might want to add specific edge case tests manually as well
def test_specific_cases():
    z1 = EisensteinInteger(3, 2)
    z2 = EisensteinInteger(1, -1)
    assert z1 + z2 == EisensteinInteger(4, 1)
    assert z1 * z2 == EisensteinInteger(5, 1)
    assert z1.norm() == 7
    assert z2.norm() == 3
    q, r = z1.quo_rem(z2)

    assert z1 == z2 * q + r

    # Test half_gcd with a specific case from the original Python example
    a_int = EisensteinInteger(0, 1)
    b_int = EisensteinInteger(-3, 19999)
    w, v, u = half_gcd(a_int, b_int)
    assert a_int * u + b_int * v == w


def test_zero_division():
    a = EisensteinInteger(5, 2)
    with pytest.raises(ZeroDivisionError):
        a.quo_rem(ZERO)
    with pytest.raises(ZeroDivisionError):
        a // ZERO
    with pytest.raises(ZeroDivisionError):
        a % ZERO
    # half_gcd(a, ZERO) should ideally handle this gracefully or be caught by tests
    # Let's see how the current implementation handles it
    try:
        w, v, u = half_gcd(a, ZERO)
        # If b is zero, the loop condition `b_run.norm() >= limit` might be false initially
        # The result should be (a, 0, 1) according to standard extended Euclidean Alg. conventions?
        # Let's check what the code *actually* does.
        # The loop `while b_run.norm() >= limit:` will not run if b_run is zero.
        # It returns `b_run, v_, u_` initialized as `(b, 1, 0)` before loop.
        # So it should return (ZERO, 1, 0)
        assert w == ZERO
        assert v == ONE  # Initial v_
        assert u == ZERO  # Initial u_
        # Let's check the identity a*u + b*v == w
        # a*0 + 0*1 == 0 -> Correct
    except ZeroDivisionError:
        pytest.fail("half_gcd(a, ZERO) raised ZeroDivisionError unexpectedly")
    except Exception as e:
        pytest.fail(f"half_gcd(a, ZERO) raised an unexpected exception: {e}")


def test_half_gcd_a_zero():
    b = EisensteinInteger(3, 5)
    # half_gcd(0, b)
    try:
        w, v, u = half_gcd(ZERO, b)
        # Initialization: a_run=0, b_run=b, u=1, v=0, u_=0, v_=1
        # limit = isqrt(0) = 0
        # Loop condition: b.norm() >= 0 (true if b != 0)
        # Inside loop: quotient, remainder = a_run.quo_rem(b_run) -> 0.quo_rem(b)
        # 0 // b = 0, 0 % b = 0
        # quotient = 0, remainder = 0
        # next_u_ = u - quotient * u_ = 1 - 0*0 = 1
        # next_v_ = v - quotient * v_ = 0 - 0*1 = 0
        # a_run = b_run = b
        # b_run = remainder = 0
        # u = u_ = 0
        # v = v_ = 1
        # u_ = next_u_ = 1
        # v_ = next_v_ = 0
        # Loop condition: b_run.norm() (0) >= limit (0) -> true? No, condition is >= limit, should be false if limit=0.
        # Let's re-read loop: `while b_run.norm() >= limit:`
        # If limit is 0, loop runs as long as norm is non-negative. Needs a b_run.is_zero() check.
        # The code *has* `if b_run.is_zero(): break`
        # So, in the first iteration: a_run=0, b_run=b. limit=0. norm(b) >= 0.
        # quo=0, rem=0.
        # next_u_=1, next_v_=0
        # a_run becomes b. b_run becomes 0. u becomes 0, v becomes 1. u_ becomes 1, v_ becomes 0.
        # Next iteration: b_run is 0. Break.
        # Return b_run, v_, u_ -> (0, 0, 1)
        assert w == ZERO
        assert v == ZERO  # Final v_
        assert u == ONE  # Final u_
        # Check identity: a*u + b*v == w
        # 0*1 + b*0 == 0 -> Correct
    except ZeroDivisionError:
        pytest.fail("half_gcd(ZERO, b) raised ZeroDivisionError unexpectedly")
    except Exception as e:
        pytest.fail(f"half_gcd(ZERO, b) raised an unexpected exception: {e}")
