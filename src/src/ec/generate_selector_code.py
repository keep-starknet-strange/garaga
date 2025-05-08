# generate_selector_code.py
import os  # Import os module for path manipulation
import subprocess  # Import subprocess to run scarb fmt
import sys
import textwrap

# Header content including necessary imports, constants, and impls
CAIRO_HEADER = """\
use core::internal::bounded_int;
use core::internal::bounded_int::{AddHelper, BoundedInt, DivRemHelper, MulHelper, UnitInt, upcast};

const TWO: felt252 = 2;
const TWO_UI: UnitInt<TWO> = 2;
const FOUR_UI: UnitInt<FOUR> = 4;
const EIGHT_UI: UnitInt<EIGHT> = 8;
const TWO_NZ_TYPED: NonZero<UnitInt<TWO>> = 2;
const FOUR_NZ_TYPED: NonZero<UnitInt<FOUR>> = 4;
const POW128_DIV_2: felt252 = 0x7fffffffffffffffffffffffffffffff; // ((2^128-1) // 2)
const POW128_DIV_4: felt252 = 0x3fffffffffffffffffffffffffffffff; // ((2^128-1) // 4)
const POW128: felt252 = 0x100000000000000000000000000000000;

const FOUR: felt252 = 4;
const EIGHT: felt252 = 8;


pub type u15_bi = BoundedInt<0, { 15 }>;
pub type u12_bi = BoundedInt<0, { 12 }>;
pub type u1_bi = BoundedInt<0, { 1 }>;
pub type u2_bi = BoundedInt<0, { 2 }>;
pub type u3_bi = BoundedInt<0, { 3 }>;
pub type u4_bi = BoundedInt<0, { 4 }>;
pub type u5_bi = BoundedInt<0, { 5 }>;
pub type u6_bi = BoundedInt<0, { 6 }>;
pub type u7_bi = BoundedInt<0, { 7 }>;
pub type u8_bi = BoundedInt<0, { 8 }>;

impl DivRemU128By2 of DivRemHelper<BoundedInt<0, { POW128 - 1 }>, UnitInt<TWO>> {
    type DivT = BoundedInt<0, { POW128_DIV_2 }>;
    type RemT = u1_bi;
}

impl DivRemU128By4 of DivRemHelper<BoundedInt<0, { POW128 - 1 }>, UnitInt<FOUR>> {
    type DivT = BoundedInt<0, { POW128_DIV_4 }>;
    type RemT = u3_bi;
}

impl MulHelperBitBy2Impl of MulHelper<u1_bi, UnitInt<TWO>> {
    type Result = u2_bi;
}

impl MulHelperBitBy4Impl of MulHelper<u1_bi, UnitInt<FOUR>> {
    type Result = u4_bi;
}

impl MulHelperBit3By4Impl of MulHelper<u3_bi, UnitInt<FOUR>> {
    type Result = u12_bi;
}

impl MulHelperBitBy8Impl of MulHelper<u1_bi, UnitInt<EIGHT>> {
    type Result = u8_bi;
}

impl AddHelperU1ByU2Impl of AddHelper<u1_bi, u2_bi> {
    type Result = u3_bi;
}

impl AddHelperU3ByU4Impl of AddHelper<u3_bi, u4_bi> {
    type Result = u7_bi;
}

impl AddHelperU7ByU8Impl of AddHelper<u7_bi, u8_bi> {
    type Result = u15_bi;
}

impl AddHelperU3ByU12Impl of AddHelper<u3_bi, u12_bi> {
    type Result = u15_bi;
}

"""  # Removed extra newline for cleaner concatenation


# Define the new helper function as a string first
CAIRO_HELPER_FUNCTION = """\
#[inline(always)]
fn _extract_and_calculate_selector_bit_inlined(
    mut u1: BoundedInt<0, { POW128 - 1 }>,
    mut u2: BoundedInt<0, { POW128 - 1 }>,
    mut v1: BoundedInt<0, { POW128 - 1 }>,
    mut v2: BoundedInt<0, { POW128 - 1 }>,
) -> (BoundedInt<0, { POW128 - 1 }>, BoundedInt<0, { POW128 - 1 }>, BoundedInt<0, { POW128 - 1 }>, BoundedInt<0, { POW128 - 1 }>, u15_bi) {
    let (qu1, u1b) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2, u2b) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1, v1b) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2, v2b) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1);
    u2 = upcast(qu2);
    v1 = upcast(qv1);
    v2 = upcast(qv2);
    let selector: u15_bi = bounded_int::add(bounded_int::add(bounded_int::add(u1b, bounded_int::mul(u2b, TWO_UI)),bounded_int::mul(v1b, FOUR_UI)),bounded_int::mul(v2b, EIGHT_UI));
    return (u1, u2, v1, v2, selector);
}

#[inline(always)]
fn _extract_and_calculate_selector_bit_inlined_fake_glv(
    mut s1: BoundedInt<0, { POW128 - 1 }>,
    mut s2: BoundedInt<0, { POW128 - 1 }>,
) -> (
    BoundedInt<0, { POW128 - 1 }>,
    BoundedInt<0, { POW128 - 1 }>,
    u15_bi,
) {
    let (qs1, s1b) = bounded_int::div_rem(s1, FOUR_NZ_TYPED);
    let (qs2, s2b) = bounded_int::div_rem(s2, FOUR_NZ_TYPED);
    s1 = upcast(qs1);
    s2 = upcast(qs2);
    let selector: u15_bi = bounded_int::add(
        s1b,
        bounded_int::mul(s2b, FOUR_UI),
    );
    return (s1, s2, selector);
}

"""


def generate_build_selectors_inlined(n_bits: int) -> str:
    """
    Generates a complete Cairo module string containing the
    build_selectors_inlined function, which calls an inlined helper
    for its main loop.

    Args:
        n_bits: The number of bits, determining the loop count.

    Returns:
        A string containing the complete generated Cairo module code.

    Raises:
        ValueError: If n_bits is not positive.
    """
    if n_bits <= 0:
        raise ValueError("n_bits must be positive")

    code = [
        "#[inline(always)]",
        "pub fn build_selectors_inlined(_u1: u128, _u2: u128, _v1: u128, _v2: u128) -> (Span<usize>, u128, u128, u128, u128) {",
        "    // Generated code for n_bits = {}".format(n_bits),
        "    let mut selectors: Array<usize> = array![];",
        "",
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

    for i in range(n_bits - 2):
        code.extend(
            [
                f"    let (u1, u2, v1, v2, selector_{i}) = _extract_and_calculate_selector_bit_inlined(u1, u2, v1, v2);",
                f"    selectors.append(upcast(selector_{i}));",
            ]
        )

    code.extend(
        [
            f"    let (_, _, _, _, selector_{n_bits - 2}) = _extract_and_calculate_selector_bit_inlined(u1, u2, v1, v2);",
            f"    selectors.append(upcast(selector_{n_bits - 2}));",
        ]
    )

    code.append(
        "    return (selectors.span(), upcast(u1lsb), upcast(u2lsb), upcast(v1lsb), upcast(v2lsb));"
    )
    code.append("}")

    function_body_str = "\n".join(code[1:])
    indented_body = textwrap.indent(function_body_str, "    ")
    generated_function_code = code[0] + "\n" + indented_body

    # Combine header, helper function, and main generated function
    return CAIRO_HEADER + "\n" + CAIRO_HELPER_FUNCTION + "\n" + generated_function_code


def generate_build_selectors_inlined_fake_glv(n_bits: int = 128) -> str:
    """
    Generates a complete Cairo module string containing the
    build_selectors_inlined function, which calls an inlined helper
    for its main loop.

    Args:
        n_bits: The number of bits, determining the loop count.

    Returns:
        A string containing the complete generated Cairo module code.

    Raises:
        ValueError: If n_bits is not positive.
    """
    if n_bits <= 0:
        raise ValueError("n_bits must be positive")

    code = [
        "#[inline(always)]",
        "pub fn build_selectors_inlined_fake_glv(_s1: u128, _s2: u128) -> (Span<usize>, u128, u128) {",
        "    // Generated code for n_bits = {}".format(n_bits),
        "    let mut selectors: Array<usize> = array![];",
        "",
        "    let mut s1: BoundedInt<0, { POW128 - 1 }> = upcast(_s1);",
        "    let mut s2: BoundedInt<0, { POW128 - 1 }> = upcast(_s2);",
        "",
        "    // Initial division and remainder to get LSBs",
        "    let (qs1, s1lsb) = bounded_int::div_rem(s1, TWO_NZ_TYPED);",
        "    let (qs2, s2lsb) = bounded_int::div_rem(s2, TWO_NZ_TYPED);",
        "    s1 = upcast(qs1);",
        "    s2 = upcast(qs2);",
        "",
        f"    // Inlined loop (63 2-bit iterations for 128 bits)",
    ]

    for i in range(63):
        code.extend(
            [
                f"    let (s1, s2, selector_{i}) = _extract_and_calculate_selector_bit_inlined_fake_glv(s1, s2);",
                f"    selectors.append(upcast(selector_{i}));",
            ]
        )
        if i == 0:
            code.extend(
                [
                    "    // Correction for the last bits 2-1.",
                    "    selectors.append(16);",
                ]
            )
    code.extend(
        [
            "// At this point s1, and s2 are the MSB (last bit).",
            "   if s1 != 0 {",
            "    if s2 != 0 {",
            "        // 11 T2 index : 10",
            "        selectors.append(10);",
            "    } else {",
            "        // 10 T12 index : 6",
            "        selectors.append(6);",
            "    }",
            "   } else {",
            "    if s2 != 0 {",
            "        // 01 T15 index : 9",
            "        selectors.append(9);",
            "    } else {",
            "        // 00 T5 index : 5",
            "        selectors.append(5);",
            "    }",
            "   }",
            "    return (selectors.span(), upcast(s1lsb), upcast(s2lsb));",
        ]
    )
    code.append("}")

    function_body_str = "\n".join(code[1:])
    indented_body = textwrap.indent(function_body_str, "    ")
    generated_function_code = code[0] + "\n" + indented_body

    # Combine header, helper function, and main generated function
    return generated_function_code


def generate_double_and_add_n(n_points: int) -> str:
    """
    Generates Cairo code for a double_and_add function variant that processes
    n_points additions.
    Assumes necessary imports (G1Point, CircuitElement, CircuitInput, CircuitModulus,
    circuit_add, circuit_sub, circuit_mul, circuit_inverse, etc.) are in scope.

    Args:
        n_points: The number of Q points to add (e.g., 1, 2, 4, 8).

    Returns:
        A string containing the generated Cairo function code.
    """
    if n_points not in [1, 2, 4, 8]:  # Or check if it's a power of 2
        raise ValueError(
            "n_points must be 1, 2, 4, or 8 for this specific generator pattern"
        )

    func_name = f"double_and_add_{n_points}"
    if n_points == 1:
        func_name = "double_and_add"  # Match original naming for n=1

    # Function signature
    q_params = [f"q{i}: G1Point" for i in range(n_points)]
    signature = f"pub fn {func_name}(p: G1Point, {', '.join(q_params)}, modulus: CircuitModulus) -> G1Point {{"

    lines = ["#[inline(always)]", signature]

    # CircuitElement inputs
    lines.append(f"    let px = CircuitElement::<CircuitInput<0>> {{}}; ")
    lines.append(f"    let py = CircuitElement::<CircuitInput<1>> {{}}; ")
    for i in range(n_points):
        lines.append(
            f"    let q{i}x = CircuitElement::<CircuitInput<{2 + 2*i}>> {{}}; "
        )
        lines.append(
            f"    let q{i}y = CircuitElement::<CircuitInput<{3 + 2*i}>> {{}}; "
        )
    lines.append("")

    current_px = "px"
    current_py = "py"
    next_tx = ""
    next_ty = ""

    # Doubling and Adding loop
    for i in range(n_points):
        lines.append(f"    // --- Step {i+1}: (2 * CurrentP) + Q{i} --- ")
        qix = f"q{i}x"
        qiy = f"q{i}y"

        # Compute λ1 = (qiy - current_py) / (qix - current_px)
        lines.append(f"    let num_lambda1_{i} = circuit_sub({qiy}, {current_py});")
        lines.append(f"    let den_lambda1_{i} = circuit_sub({qix}, {current_px});")
        lines.append(
            f"    let lambda1_{i} = circuit_mul(num_lambda1_{i}, circuit_inverse(den_lambda1_{i}));"
        )
        lines.append("")

        # Compute x2 = λ1² - current_px - qix
        lines.append(f"    let lambda1_sq_{i} = circuit_mul(lambda1_{i}, lambda1_{i});")
        lines.append(f"    let x2_{i} = circuit_sub(lambda1_sq_{i}, {current_px});")
        lines.append(f"    let x2_{i} = circuit_sub(x2_{i}, {qix});")
        lines.append("")

        # Compute -λ2 = λ1 + 2 * current_py / (x2 - current_px)
        lines.append(f"    let den_lambda2_{i} = circuit_sub(x2_{i}, {current_px});")
        lines.append(
            f"    let num_lambda2_{i} = circuit_add({current_py}, {current_py});"
        )
        lines.append(
            f"    let term2_lambda2_{i} = circuit_mul(num_lambda2_{i}, circuit_inverse(den_lambda2_{i}));"
        )
        lines.append(
            f"    let lambda2_{i} = circuit_add(lambda1_{i}, term2_lambda2_{i});"
        )
        lines.append("")

        # Compute intermediate Tx = (-λ2)² - current_px - x2
        lines.append(f"    let lambda2_sq_{i} = circuit_mul(lambda2_{i}, lambda2_{i});")
        lines.append(
            f"    let tx_temp_{i} = circuit_sub(lambda2_sq_{i}, {current_px});"
        )
        next_tx = f"T{i+1}x"
        lines.append(f"    let {next_tx} = circuit_sub(tx_temp_{i}, x2_{i});")
        lines.append("")

        # Compute intermediate Ty = -λ2 * (Tx - current_px) - current_py
        lines.append(f"    let tx_sub_px_{i} = circuit_sub({next_tx}, {current_px});")
        lines.append(f"    let term1_ty_{i} = circuit_mul(lambda2_{i}, tx_sub_px_{i});")
        next_ty = f"T{i+1}y"
        lines.append(
            f"    let {next_ty} = circuit_sub(term1_ty_{i}, {current_py});"
        )  # Note: lambda2 corresponds to -lambda2 in standard formulas
        lines.append("")

        # Update current P for the next iteration
        current_px = next_tx
        current_py = next_ty

    # Final outputs and evaluation
    final_x = current_px
    final_y = current_py
    lines.append(f"    let outputs = ({final_x}, {final_y})")
    lines.append(f"        .new_inputs()")
    lines.append(f"        .next_2(p.x)")
    lines.append(f"        .next_2(p.y)")
    for i in range(n_points):
        lines.append(f"        .next_2(q{i}.x)")
        lines.append(f"        .next_2(q{i}.y)")
    lines.append(f"        .done_2()")
    lines.append(f"        .eval(modulus)")
    lines.append(f"        .expect('{func_name} failed');")
    lines.append("")
    lines.append(
        f"    return G1Point {{ x: outputs.get_output({final_x}), y: outputs.get_output({final_y}) }};"
    )
    lines.append("}")

    # Join lines with proper indentation
    # Indent lines starting from the third line (index 2)
    indented_body = textwrap.indent("\n".join(lines[2:]), "    ")
    return "\n".join(lines[:2]) + "\n" + indented_body


if __name__ == "__main__":
    # Example usage: Generate selectors.cairo with n_bits=71 (default/example)
    # To generate double_and_add_8, you might run this script differently
    # or integrate argument parsing. For now, demonstrating selector generation.

    # --- Selector Generation ---
    try:
        n_bits_arg = 73  # Default or example value
        if len(sys.argv) > 1:
            try:
                n_bits_arg = int(sys.argv[1])
            except ValueError:
                print(
                    "Warning: Invalid integer for n_bits, using default {}. Usage: python ... <n_bits>".format(
                        n_bits_arg
                    )
                )

        if n_bits_arg < 1:
            raise ValueError("n_bits must be at least 1")

        # Generate the complete Cairo code for selectors
        generated_cairo_code_selectors = generate_build_selectors_inlined(n_bits_arg)
        generated_cairo_code_selectors_fake_glv = (
            generate_build_selectors_inlined_fake_glv()
        )
        # Define the output file path
        output_file_path_selectors = "src/src/ec/selectors.cairo"

        # Write the generated code to the file
        with open(output_file_path_selectors, "w") as f:
            f.write(
                generated_cairo_code_selectors
                + "\n\n"
                + generated_cairo_code_selectors_fake_glv
            )

        print(
            f"Successfully generated Cairo code to {output_file_path_selectors} for n_bits = {n_bits_arg}"
        )

        # Format the generated file using scarb fmt
        try:
            print(
                f"Attempting to format {output_file_path_selectors} using scarb fmt..."
            )
            process = subprocess.run(
                ["scarb", "fmt", output_file_path_selectors],
                check=True,
                capture_output=True,
                text=True,
            )
            print("Formatting successful.")
        except FileNotFoundError:
            print(
                "Error: 'scarb' command not found. Please ensure Scarb is installed and in your PATH."
            )
        except subprocess.CalledProcessError as e:
            print(f"Error during formatting: {e}")
            print(f"scarb fmt stdout:\n{e.stdout}")
            print(f"scarb fmt stderr:\n{e.stderr}")

    except ValueError as e:
        print(f"Error generating selectors: {e}")
        # Decide if we should exit here or continue to double_and_add generation
    except Exception as e:
        print(f"An unexpected error occurred during selector generation: {e}")

    print("\n" + "-" * 20 + "\n")

    # --- Double and Add 8 Generation (Example) ---
    try:
        n_points_to_gen = 8
        print(f"Generating Cairo code for double_and_add_{n_points_to_gen}...")
        generated_double_add_code = generate_double_and_add_n(n_points_to_gen)

        # Print the generated code to console (or write to a file)
        print(f"\n// --- Generated code for double_and_add_{n_points_to_gen} ---")
        print("// Add this function to your ec_ops.cairo or similar file.")
        print(
            "// Ensure necessary imports and structs (G1Point, CircuitElement, etc.) are available."
        )
        print(generated_double_add_code)

        # Example: Write to a separate file
        # output_file_path_double_add = f"src/src/ec/double_and_add_{n_points_to_gen}_generated.cairo"
        # with open(output_file_path_double_add, 'w') as f:
        #     f.write("// NOTE: This file needs imports like G1Point, circuit ops etc.\n")
        #     f.write(generated_double_add_code)
        # print(f"\nCode also written to {output_file_path_double_add}")
        # # Optionally format this file too
        # try:
        #     subprocess.run(["scarb", "fmt", output_file_path_double_add], check=True)
        # except Exception as fmt_e:
        #     print(f"Could not format {output_file_path_double_add}: {fmt_e}")

    except ValueError as e:
        print(f"Error generating double_and_add: {e}")
    except Exception as e:
        print(f"An unexpected error occurred during double_and_add generation: {e}")
        sys.exit(1)
