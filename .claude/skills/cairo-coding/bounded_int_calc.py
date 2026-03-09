#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Bounded Integer Implementation Calculator

Computes exact type bounds for Cairo BoundedInt helper trait implementations.
Outputs ready-to-paste Cairo code.

Usage:
    python3 bounded_int_calc.py add <a_lo> <a_hi> <b_lo> <b_hi> [--name NAME]
    python3 bounded_int_calc.py sub <a_lo> <a_hi> <b_lo> <b_hi> [--name NAME]
    python3 bounded_int_calc.py mul <a_lo> <a_hi> <b_lo> <b_hi> [--name NAME]
    python3 bounded_int_calc.py div <a_lo> <a_hi> <b_lo> <b_hi> [--name NAME]
"""

import argparse
import sys

# felt252 prime (for validation)
FELT252_PRIME = 0x800000000000011000000000000000000000000000000000000000000000001


def validate_felt252(value: int, name: str) -> None:
    """Warn if value exceeds felt252 range."""
    if value < 0:
        # Negative values are represented as P - |value| in felt252
        if abs(value) >= FELT252_PRIME:
            print(f"WARNING: {name} = {value} exceeds felt252 range!", file=sys.stderr)
    elif value >= FELT252_PRIME:
        print(f"WARNING: {name} = {value} exceeds felt252 range!", file=sys.stderr)


def format_bound(value: int) -> str:
    """Format a bound value, handling negatives."""
    if value < 0:
        return str(value)
    return str(value)


def calc_add(a_lo: int, a_hi: int, b_lo: int, b_hi: int) -> tuple[int, int]:
    """Calculate addition bounds: [a_lo + b_lo, a_hi + b_hi]"""
    result_lo = a_lo + b_lo
    result_hi = a_hi + b_hi
    return result_lo, result_hi


def calc_sub(a_lo: int, a_hi: int, b_lo: int, b_hi: int) -> tuple[int, int]:
    """Calculate subtraction bounds: [a_lo - b_hi, a_hi - b_lo]"""
    result_lo = a_lo - b_hi
    result_hi = a_hi - b_lo
    return result_lo, result_hi


def calc_mul(a_lo: int, a_hi: int, b_lo: int, b_hi: int) -> tuple[int, int]:
    """
    Calculate multiplication bounds.
    For unsigned: [a_lo * b_lo, a_hi * b_hi]
    For signed/mixed: evaluate all corners.
    """
    corners = [
        a_lo * b_lo,
        a_lo * b_hi,
        a_hi * b_lo,
        a_hi * b_hi,
    ]
    return min(corners), max(corners)


def calc_div(
    a_lo: int, a_hi: int, b_lo: int, b_hi: int
) -> tuple[tuple[int, int], tuple[int, int]]:
    """
    Calculate division bounds.
    Quotient: [a_lo // b_hi, a_hi // b_lo]
    Remainder: [0, b_hi - 1]

    Note: Cairo's bounded_int_div_rem requires non-negative dividends.
    """
    if b_lo <= 0:
        print("ERROR: Divisor lower bound must be positive!", file=sys.stderr)
        sys.exit(1)

    if a_lo < 0:
        print(
            "ERROR: Dividend lower bound must be non-negative! Cairo's bounded_int_div_rem does not support negative dividends.",
            file=sys.stderr,
        )
        sys.exit(1)

    quot_lo = a_lo // b_hi
    quot_hi = a_hi // b_lo
    rem_lo = 0
    rem_hi = b_hi - 1

    return (quot_lo, quot_hi), (rem_lo, rem_hi)


def generate_add_impl(a_lo: int, a_hi: int, b_lo: int, b_hi: int, name: str) -> str:
    result_lo, result_hi = calc_add(a_lo, a_hi, b_lo, b_hi)

    validate_felt252(result_lo, "Result min")
    validate_felt252(result_hi, "Result max")

    return f"""impl {name} of AddHelper<BoundedInt<{format_bound(a_lo)}, {format_bound(a_hi)}>, BoundedInt<{format_bound(b_lo)}, {format_bound(b_hi)}>> {{
    type Result = BoundedInt<{format_bound(result_lo)}, {format_bound(result_hi)}>;
}}"""


def generate_sub_impl(a_lo: int, a_hi: int, b_lo: int, b_hi: int, name: str) -> str:
    result_lo, result_hi = calc_sub(a_lo, a_hi, b_lo, b_hi)

    validate_felt252(result_lo, "Result min")
    validate_felt252(result_hi, "Result max")

    return f"""impl {name} of SubHelper<BoundedInt<{format_bound(a_lo)}, {format_bound(a_hi)}>, BoundedInt<{format_bound(b_lo)}, {format_bound(b_hi)}>> {{
    type Result = BoundedInt<{format_bound(result_lo)}, {format_bound(result_hi)}>;
}}"""


def generate_mul_impl(a_lo: int, a_hi: int, b_lo: int, b_hi: int, name: str) -> str:
    result_lo, result_hi = calc_mul(a_lo, a_hi, b_lo, b_hi)

    validate_felt252(result_lo, "Result min")
    validate_felt252(result_hi, "Result max")

    return f"""impl {name} of MulHelper<BoundedInt<{format_bound(a_lo)}, {format_bound(a_hi)}>, BoundedInt<{format_bound(b_lo)}, {format_bound(b_hi)}>> {{
    type Result = BoundedInt<{format_bound(result_lo)}, {format_bound(result_hi)}>;
}}"""


def generate_div_impl(a_lo: int, a_hi: int, b_lo: int, b_hi: int, name: str) -> str:
    (quot_lo, quot_hi), (rem_lo, rem_hi) = calc_div(a_lo, a_hi, b_lo, b_hi)

    validate_felt252(quot_lo, "Quotient min")
    validate_felt252(quot_hi, "Quotient max")
    validate_felt252(rem_lo, "Remainder min")
    validate_felt252(rem_hi, "Remainder max")

    return f"""impl {name} of DivRemHelper<BoundedInt<{format_bound(a_lo)}, {format_bound(a_hi)}>, BoundedInt<{format_bound(b_lo)}, {format_bound(b_hi)}>> {{
    type DivT = BoundedInt<{format_bound(quot_lo)}, {format_bound(quot_hi)}>;
    type RemT = BoundedInt<{format_bound(rem_lo)}, {format_bound(rem_hi)}>;
}}"""


def main():
    parser = argparse.ArgumentParser(
        description="Calculate BoundedInt helper trait implementations",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
    # Addition: [0, 12288] + [0, 12288]
    python3 bounded_int_calc.py add 0 12288 0 12288

    # Subtraction: [0, 12288] - [0, 12288]
    python3 bounded_int_calc.py sub 0 12288 0 12288

    # Multiplication: [0, 12288] * [0, 12288]
    python3 bounded_int_calc.py mul 0 12288 0 12288

    # Division: [128, 255] / [3, 8]
    python3 bounded_int_calc.py div 128 255 3 8

    # Custom impl name
    python3 bounded_int_calc.py mul 0 12288 0 12288 --name Zq12289MulHelper
        """,
    )

    subparsers = parser.add_subparsers(dest="operation", required=True)

    # Add command
    add_parser = subparsers.add_parser(
        "add", help="Addition: [a_lo, a_hi] + [b_lo, b_hi]"
    )
    add_parser.add_argument("a_lo", type=int, help="Lower bound of first operand")
    add_parser.add_argument("a_hi", type=int, help="Upper bound of first operand")
    add_parser.add_argument("b_lo", type=int, help="Lower bound of second operand")
    add_parser.add_argument("b_hi", type=int, help="Upper bound of second operand")
    add_parser.add_argument("--name", default="AddImpl", help="Name for the impl")

    # Sub command
    sub_parser = subparsers.add_parser(
        "sub", help="Subtraction: [a_lo, a_hi] - [b_lo, b_hi]"
    )
    sub_parser.add_argument("a_lo", type=int, help="Lower bound of first operand")
    sub_parser.add_argument("a_hi", type=int, help="Upper bound of first operand")
    sub_parser.add_argument("b_lo", type=int, help="Lower bound of second operand")
    sub_parser.add_argument("b_hi", type=int, help="Upper bound of second operand")
    sub_parser.add_argument("--name", default="SubImpl", help="Name for the impl")

    # Mul command
    mul_parser = subparsers.add_parser(
        "mul", help="Multiplication: [a_lo, a_hi] * [b_lo, b_hi]"
    )
    mul_parser.add_argument("a_lo", type=int, help="Lower bound of first operand")
    mul_parser.add_argument("a_hi", type=int, help="Upper bound of first operand")
    mul_parser.add_argument("b_lo", type=int, help="Lower bound of second operand")
    mul_parser.add_argument("b_hi", type=int, help="Upper bound of second operand")
    mul_parser.add_argument("--name", default="MulImpl", help="Name for the impl")

    # Div command
    div_parser = subparsers.add_parser(
        "div", help="Division: [a_lo, a_hi] / [b_lo, b_hi]"
    )
    div_parser.add_argument("a_lo", type=int, help="Lower bound of dividend")
    div_parser.add_argument("a_hi", type=int, help="Upper bound of dividend")
    div_parser.add_argument(
        "b_lo", type=int, help="Lower bound of divisor (must be > 0)"
    )
    div_parser.add_argument("b_hi", type=int, help="Upper bound of divisor")
    div_parser.add_argument("--name", default="DivRemImpl", help="Name for the impl")

    args = parser.parse_args()

    if args.operation == "add":
        print(generate_add_impl(args.a_lo, args.a_hi, args.b_lo, args.b_hi, args.name))
    elif args.operation == "sub":
        print(generate_sub_impl(args.a_lo, args.a_hi, args.b_lo, args.b_hi, args.name))
    elif args.operation == "mul":
        print(generate_mul_impl(args.a_lo, args.a_hi, args.b_lo, args.b_hi, args.name))
    elif args.operation == "div":
        print(generate_div_impl(args.a_lo, args.a_hi, args.b_lo, args.b_hi, args.name))


if __name__ == "__main__":
    main()
