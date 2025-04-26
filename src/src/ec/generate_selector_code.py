# generate_selector_code.py
import os  # Import os module for path manipulation
import subprocess  # Import subprocess to run scarb fmt
import sys
import textwrap

# Header content including necessary imports, constants, and impls
CAIRO_HEADER = """\
use core::internal::bounded_int;
use core::internal::bounded_int::{BoundedInt, DivRemHelper, UnitInt, upcast};



const TWO: felt252 = 2;
const TWO_NZ_TYPED: NonZero<UnitInt<TWO>> = 2;
const POW128_DIV_2: felt252 = 0x7fffffffffffffffffffffffffffffff; // ((2^128-1) // 2)
const POW128: felt252 = 0x100000000000000000000000000000000;

impl DivRemU128By2 of DivRemHelper<BoundedInt<0, { POW128 - 1 }>, UnitInt<TWO>> {
    type DivT = BoundedInt<0, { POW128_DIV_2 }>;
    type RemT = BoundedInt<0, { TWO - 1 }>;
}

"""  # Removed extra newline for cleaner concatenation


def generate_build_selectors_inlined(n_bits: int) -> str:
    """
    Generates a complete Cairo module string containing the
    build_selectors_inlined function with its main loop inlined.

    Args:
        n_bits: The number of bits, determining the loop unrolling count.

    Returns:
        A string containing the complete generated Cairo module code.

    Raises:
        ValueError: If n_bits is not positive.
    """
    if n_bits <= 0:
        raise ValueError("n_bits must be positive")

    # Function code generation logic remains the same
    code = [
        "#[inline(always)]",
        # Adjusted function signature to remove n_bits as it's now baked in
        "pub fn build_selectors_inlined(_u1: u128, _u2: u128, _v1: u128, _v2: u128) -> (Span<usize>, u128, u128, u128, u128) {",
        "    // Generated code for n_bits = {}".format(n_bits),
        "    let mut selectors: Array<usize> = array![];",
        "",
        "    // Use BoundedInt for calculations",
        "    let mut u1: BoundedInt<0, { POW128 - 1 }> = upcast(_u1);",
        "    let mut u2: BoundedInt<0, { POW128 - 1 }> = upcast(_u2);",
        "    let mut v1: BoundedInt<0, { POW128 - 1 }> = upcast(_v1);",
        "    let mut v2: BoundedInt<0, { POW128 - 1 }> = upcast(_v2);",
        "",
        "    // Initial division and remainder to get LSBs",
        "    let (qu1, u1lsb) = bounded_int::div_rem(u1, TWO_NZ_TYPED);",
        "    let (qu2, u2lsb) = bounded_int::div_rem(u2, TWO_NZ_TYPED);",
        "    let (qv1, v1lsb) = bounded_int::div_rem(v1, TWO_NZ_TYPED);",
        "    let (qv2, v2lsb) = bounded_int::div_rem(v2, TWO_NZ_TYPED);",
        "    u1 = upcast(qu1);",
        "    u2 = upcast(qu2);",
        "    v1 = upcast(qv1);",
        "    v2 = upcast(qv2);",
        "",
        f"    // Inlined loop ({n_bits - 1} iterations)",
    ]

    for i in range(n_bits - 1):
        code.extend(
            [
                f"    // --- Iteration {i} ---",
                f"    let (qu1_{i}, u1b_{i}) = bounded_int::div_rem(u1, TWO_NZ_TYPED);",
                f"    let (qu2_{i}, u2b_{i}) = bounded_int::div_rem(u2, TWO_NZ_TYPED);",
                f"    let (qv1_{i}, v1b_{i}) = bounded_int::div_rem(v1, TWO_NZ_TYPED);",
                f"    let (qv2_{i}, v2b_{i}) = bounded_int::div_rem(v2, TWO_NZ_TYPED);",
                f"    u1 = upcast(qu1_{i});",
                f"    u2 = upcast(qu2_{i});",
                f"    v1 = upcast(qv1_{i});",
                f"    v2 = upcast(qv2_{i});",
                "",
                f"    let selector_{i}: felt252 = u1b_{i}.into() + 2 * u2b_{i}.into() + 4 * v1b_{i}.into() + 8 * v2b_{i}.into();",
                f"    let selector_{i}_usize: usize = selector_{i}.try_into().unwrap();",
                f"    selectors.append(selector_{i}_usize);",
                "",
            ]
        )

    code.append(
        "    return (selectors.span(), upcast(u1lsb), upcast(u2lsb), upcast(v1lsb), upcast(v2lsb));"
    )
    code.append("}")  # Close function definition

    # Indent the function body properly (lines after the signature)
    # Need to handle the case where n_bits=1 (no loop iterations) - indexing starts correctly
    function_body_str = "\n".join(
        code[1:]
    )  # Get all lines except the #[inline(always)]
    indented_body = textwrap.indent(function_body_str, "    ")

    # Combine function attribute, signature with indented body
    generated_function_code = (
        code[0] + "\n" + indented_body
    )  # Add back #[inline(always)]

    # Combine header and generated function
    return CAIRO_HEADER + "\n" + generated_function_code


if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python src/src/ec/generate_selector_code.py <n_bits>")
        sys.exit(1)

    try:
        n_bits_arg = int(sys.argv[1])
        if n_bits_arg < 1:
            raise ValueError("n_bits must be at least 1")

        # Generate the complete Cairo code
        generated_cairo_code = generate_build_selectors_inlined(n_bits_arg)

        # Define the output file path (relative to workspace root assumed)
        output_file_path = "src/src/ec/selectors.cairo"

        # Write the generated code to the file
        with open(output_file_path, "w") as f:
            f.write(generated_cairo_code)

        print(
            f"Successfully generated Cairo code to {output_file_path} for n_bits = {n_bits_arg}"
        )

        # Format the generated file using scarb fmt
        try:
            print(f"Attempting to format {output_file_path} using scarb fmt...")
            # Use shell=True for simplicity if scarb is in PATH, otherwise specify full path
            # Check=True raises CalledProcessError if scarb fmt fails
            process = subprocess.run(
                ["scarb", "fmt", output_file_path],
                check=True,
                capture_output=True,
                text=True,
            )
            print("Formatting successful.")
            # Optionally print scarb fmt output/stderr
            # print(process.stdout)
            # print(process.stderr)
        except FileNotFoundError:
            print(
                "Error: 'scarb' command not found. Please ensure Scarb is installed and in your PATH."
            )
        except subprocess.CalledProcessError as e:
            print(f"Error during formatting: {e}")
            print(f"scarb fmt stdout:\n{e.stdout}")
            print(f"scarb fmt stderr:\n{e.stderr}")
            # Decide if this should be a fatal error
            # sys.exit(1)

    except ValueError as e:
        print(f"Error: {e}")
        sys.exit(1)
    except Exception as e:
        print(f"An unexpected error occurred: {e}")
        sys.exit(1)
