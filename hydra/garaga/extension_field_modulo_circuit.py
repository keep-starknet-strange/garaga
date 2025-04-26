from dataclasses import dataclass, field
from enum import Enum

from garaga.algebra import Polynomial, PyFelt
from garaga.definitions import N_LIMBS, get_irreducible_poly
from garaga.hints.extf_mul import (
    nondeterministic_extension_field_div,
    nondeterministic_extension_field_mul_divmod,
)
from garaga.modulo_circuit import BATCH_SIZE, ModuloCircuitElement, WriteOps
from garaga.poseidon_transcript import CairoPoseidonTranscript
from garaga.precompiled_circuits.fp2 import Fp2Circuits

POSEIDON_BUILTIN_SIZE = 6
POSEIDON_OUTPUT_S1_INDEX = 4


# Represents the state of the accumulation of the equation
#  c_i * Π(Pi(z)) = c_i*Q_i*P + c_i*R_i inside the circuit.
# Only store ci*Π(Pi(z)) (as Emulated Field Element) and ci*R_i (as Polynomial)
@dataclass(slots=True)
class EuclideanPolyAccumulator:
    lhs: ModuloCircuitElement
    R: list[ModuloCircuitElement]
    R_evaluated: ModuloCircuitElement


class AccPolyInstructionType(Enum):
    MUL = "MUL"
    DIV = "DIV"
    SQUARE_TORUS = "SQUARE_TORUS"


@dataclass(slots=True)
class AccumulatePolyInstructions:
    Pis: list[list[list[ModuloCircuitElement]]] = field(default_factory=list)
    Qis: list[Polynomial] = field(default_factory=list)
    Ris: list[list[ModuloCircuitElement]] = field(default_factory=list)
    Ps_sparsities: list[None | list[list[int]]] = field(default_factory=list)
    r_sparsities: list[None | list[int]] = field(default_factory=list)
    types: list[AccPolyInstructionType] = field(default_factory=list)
    n: int = field(default=0)
    rlc_coeffs: list[ModuloCircuitElement] = field(default_factory=list)
    Pis_of_Z: list[ModuloCircuitElement] = field(default_factory=list)

    def append(
        self,
        type: AccPolyInstructionType,
        Pis: list[list[ModuloCircuitElement]],
        Q: Polynomial,
        R: list[ModuloCircuitElement],
        Ps_sparsities: None | list[list[int] | None] = None,
        r_sparsity: None | list[int] = None,
    ):
        if type != AccPolyInstructionType.MUL:
            assert len(Pis) == 2
        self.types.append(type)
        self.Pis.append(Pis)
        self.Qis.append(Q)
        self.Ris.append(R)
        self.Ps_sparsities.append(Ps_sparsities)
        self.r_sparsities.append(r_sparsity)
        self.n += 1


class ExtensionFieldModuloCircuit(Fp2Circuits):
    def __init__(
        self,
        name: str,
        curve_id: int,
        extension_degree: int,
        init_hash: int = None,
        hash_input: bool = True,
        compilation_mode: int = 0,
        generic_circuit: bool = False,
    ) -> None:
        super().__init__(
            name=name,
            curve_id=curve_id,
            compilation_mode=compilation_mode,
            generic_circuit=generic_circuit,
        )
        self.class_name = "ExtensionFieldModuloCircuit"
        self.extension_degree = extension_degree
        self.z_powers: list[ModuloCircuitElement] = []
        self.acc: list[EuclideanPolyAccumulator] = [
            self._init_accumulator(self.extension_degree),
            self._init_accumulator(self.extension_degree * 2),
        ]
        self.hash_input = hash_input
        self.transcript: CairoPoseidonTranscript = CairoPoseidonTranscript(
            init_hash=(
                int.from_bytes(self.name.encode(), "big")
                if init_hash is None
                else init_hash
            )
        )
        self.z_powers: list[ModuloCircuitElement] = []
        self.ops_counter = {
            "Circuit": self.name,
            "EXTF_SQUARE": 0,
            "EXTF_MUL_DENSE": 0,
            # "EXTF_DIV": 0,
        }
        self.accumulate_poly_instructions: list[AccumulatePolyInstructions] = [
            AccumulatePolyInstructions(),
            AccumulatePolyInstructions(),
        ]

    def _init_accumulator(self, extension_degree: int = None):
        extension_degree = extension_degree or self.extension_degree
        # Todo : Add compilation mode 1 support
        if self.compilation_mode == 1:
            return EuclideanPolyAccumulator(
                lhs=None,
                R=[None] * extension_degree,
                R_evaluated=None,
            )
        else:
            return EuclideanPolyAccumulator(
                lhs=self.set_or_get_constant(0),
                R=[None] * extension_degree,
                R_evaluated=self.set_or_get_constant(0),
            )

    @property
    def commitments(self):
        return [
            self.values_segment.segment_stacks[WriteOps.COMMIT][offset].felt
            for offset in sorted(self.values_segment.segment_stacks[WriteOps.COMMIT])
        ]

    @property
    def circuit_input(self):
        return [
            self.values_segment.segment_stacks[WriteOps.INPUT][offset].felt
            for offset in sorted(self.values_segment.segment_stacks[WriteOps.INPUT])
        ]

    def create_lines_z_powers(self, z: PyFelt, add_extf_power: bool = False):
        """
        Create powers of z for the evaluation of lines functions and the irreducible polynomial if add_extf_power is True.
        """
        powers = [z]  # z^1 at index 0
        if self.curve_id == 0:
            powers.append(self.square(z, "compute z^2"))  # z^2 at index 1
            powers.append(self.mul(powers[-1], z, "compute z^3"))  # z^3 at index 2
            powers.append(None)  # No z^4 at index 3
            powers.append(None)  # No z^5 at index 4
            powers.append(self.square(powers[2], "compute z^6"))  # z^6 at index 5
            powers.append(self.mul(powers[5], z, "compute z^7"))  # z^7 at index 6
            powers.append(None)  # No z^8 at index 7
            powers.append(
                self.mul(powers[6], powers[1], "compute z^9")
            )  # z^9 at index 8
            if add_extf_power:
                # Need to add z^12 :
                # z^12 = z^9 * z^3
                powers.append(None)  # No z^10 at index 9
                powers.append(None)  # No z^11 at index 10
                powers.append(self.mul(powers[8], powers[2], "compute z^12"))
            self.z_powers = powers

        elif self.curve_id == 1:
            # Need z^2, z^3, z^6, Z^8:
            powers.append(self.square(z, "compute z^2"))  # z^2 at index 1
            powers.append(self.mul(powers[-1], z, "compute z^3"))  # z^3 at index 2
            powers.append(None)  # No z^4 at index 3
            powers.append(None)  # No z^5 at index 4
            powers.append(self.square(powers[2], "compute z^6"))  # z^6 at index 5
            powers.append(None)  # No z^7 at index 6
            powers.append(
                self.mul(powers[5], powers[1], "compute z^8")
            )  # z^8 at index 7
            self.z_powers = powers
            if add_extf_power:
                # Need to add z^12 :
                # z^12 = z^7 * z^5
                powers.append(None)  # No z^9 at index 8
                powers.append(None)  # No z^10 at index 9
                powers.append(None)  # No z^11 at index 10
                powers.append(self.mul(powers[7], powers[4], "compute z^12"))
        else:
            raise ValueError(f"Invalid curve id: {self.curve_id}")

    def create_powers_of_Z(
        self,
        Z: PyFelt | ModuloCircuitElement,
        max_degree: int = None,
    ) -> list[ModuloCircuitElement]:
        if max_degree is None:
            max_degree = self.extension_degree
        if isinstance(Z, PyFelt):
            Z = self.write_cairo_native_felt(Z)
        elif isinstance(Z, int):
            Z = self.write_cairo_native_felt(self.field(Z))
        elif isinstance(Z, ModuloCircuitElement):
            pass
        else:
            raise ValueError(f"Invalid type for Z: {type(Z)}")
        powers = [Z]

        for i in range(2, max_degree + 1):
            powers.append(self.mul(powers[-1], powers[0], comment=f"Compute z^{i}"))

        self.z_powers = powers
        return powers

    def eval_poly_in_precomputed_Z(
        self,
        X: list[ModuloCircuitElement],
        sparsity: list[int] = None,
        poly_name: str = None,
    ) -> ModuloCircuitElement:
        """
        Evaluates a polynomial with coefficients `X` at precomputed powers of z.
        X(z) = X_0 + X_1 * z + X_2 * z^2 + ... + X_n * z^n

        If a `sparsity` list is provided, it is used to optimize the evaluation by skipping
        zero coefficients and applying special handling based on sparsity values:
        - A sparsity value of 0 indicates that the corresponding coefficient X_i is zero and should be skipped.
        - A sparsity value of 1 indicates that the corresponding coefficient X_i is non-zero and should be included in the evaluation.
        - A sparsity value of 2 indicates a special case where the term is directly a power of z, implying the coefficient X_i is 1 in this case.

        Parameters:
        - X: list[ModuloCircuitElement] - The coefficients of the polynomial to be evaluated.
        - sparsity: list[int] (optional) - A list indicating the sparsity of the polynomial. If None, the polynomial is treated as fully dense.

        Returns:
        - ModuloCircuitElement: The result of evaluating the polynomial at the precomputed powers of z.
        """
        if poly_name is None:
            poly_name = "UnnamedPoly"

        if sparsity:
            first_non_zero_idx = next(
                (i for i, x in enumerate(sparsity) if x != 0), None
            )
            if first_non_zero_idx == 0:
                match sparsity[0]:
                    case 0:
                        X_of_z = self.set_or_get_constant(0)
                    case 1:
                        X_of_z = X[0]
                    case 2:
                        X_of_z = self.set_or_get_constant(1)
                    case _:
                        raise ValueError(f"Invalid sparsity value: {sparsity[0]}")
            else:
                match sparsity[first_non_zero_idx]:
                    case 0:
                        X_of_z = self.set_or_get_constant(0)
                    case 1:
                        X_of_z = self.mul(
                            X[first_non_zero_idx],
                            self.z_powers[first_non_zero_idx - 1],
                            comment=f"Eval sparse poly {poly_name} step coeff_{first_non_zero_idx} * z^{first_non_zero_idx}",
                        )
                    case 2:
                        X_of_z = self.z_powers[first_non_zero_idx - 1]
                    case _:
                        raise ValueError(f"Invalid sparsity value: {sparsity[0]}")

            for i in range(first_non_zero_idx + 1, len(X)):
                match sparsity[i]:
                    case 1:
                        term = self.mul(
                            X[i],
                            self.z_powers[i - 1],
                            comment=f"Eval sparse poly {poly_name} step coeff_{i} * z^{i}",
                        )
                        add_comment = (
                            f"Eval sparse poly {poly_name} step + coeff_{i} * z^{i}"
                        )
                    case 2:
                        term = self.z_powers[
                            i - 1
                        ]  # In this case, sparsity[i] == 2 => X[i] = 1
                        add_comment = f"Eval sparse poly {poly_name} step + 1*z^{i}"
                    case 0:
                        continue
                    case _:
                        raise ValueError(f"Invalid sparsity value: {sparsity[i]}")
                X_of_z = self.add(
                    X_of_z,
                    term,
                    comment=add_comment,
                )
        else:
            X_of_z = self.eval_poly(X, self.z_powers, poly_name, "z")

        return X_of_z

    def extf_mul(
        self,
        Ps: list[list[ModuloCircuitElement]],
        extension_degree: int,
        Ps_sparsities: list[list[int] | None] = None,
        r_sparsity: list[int] = None,
        acc_index: int = 0,
    ) -> list[ModuloCircuitElement]:
        """
        Multiply in the extension field X * Y mod irreducible_poly
        Commit to R and add an EvalPolyInstruction to the accumulator.
        """
        assert (
            extension_degree > 2
        ), f"extension_degree={extension_degree} <= 2. Use self.mul or self.fp2_square instead."

        if Ps_sparsities is None:
            Ps_sparsities = [None] * len(Ps)
        assert len(Ps_sparsities) == len(
            Ps
        ), f"len(Ps_sparsities)={len(Ps_sparsities)} != len(Ps)={len(Ps)}"

        Q, R = nondeterministic_extension_field_mul_divmod(
            Ps, self.curve_id, extension_degree
        )

        R = self.write_elements(R, WriteOps.COMMIT, r_sparsity)

        if not any(sparsity for sparsity in Ps_sparsities) or not r_sparsity:
            self.ops_counter["EXTF_MUL_DENSE"] += 1

        self.accumulate_poly_instructions[acc_index].append(
            AccPolyInstructionType.MUL,
            Ps,
            Polynomial(Q),
            R,
            Ps_sparsities,
            r_sparsity,
        )
        return R

    def extf_div(
        self,
        X: list[ModuloCircuitElement],
        Y: list[ModuloCircuitElement],
        extension_degree: int,
        acc_index: int = 0,
    ) -> list[ModuloCircuitElement]:
        x_over_y = nondeterministic_extension_field_div(
            X, Y, self.curve_id, extension_degree
        )
        x_over_y = self.write_elements(x_over_y, WriteOps.COMMIT)

        Q, _ = nondeterministic_extension_field_mul_divmod(
            [x_over_y, Y], self.curve_id, extension_degree
        )
        # R should be X
        Q = Polynomial(Q)
        self.accumulate_poly_instructions[acc_index].append(
            AccPolyInstructionType.DIV, Pis=[x_over_y, Y], Q=Q, R=X
        )
        return x_over_y

    def extf_inv(
        self,
        Y: list[ModuloCircuitElement],
        extension_degree: int,
        acc_index: int = 0,
    ) -> list[ModuloCircuitElement]:
        one = [ModuloCircuitElement(self.field(1), -1)] + [
            ModuloCircuitElement(self.field(0), -1)
        ] * (extension_degree - 1)
        y_inv = nondeterministic_extension_field_div(
            one,
            Y,
            self.curve_id,
            extension_degree,
        )
        y_inv = self.write_elements(y_inv, WriteOps.COMMIT)

        Q, _ = nondeterministic_extension_field_mul_divmod(
            [y_inv, Y], self.curve_id, extension_degree
        )
        # R should be One. Passed at mocked modulo circuits element since fully determined by its sparsity.
        Q = Polynomial(Q)
        self.accumulate_poly_instructions[acc_index].append(
            AccPolyInstructionType.DIV,
            Pis=[y_inv, Y],
            Q=Q,
            R=one,
            r_sparsity=[2] + [0] * (extension_degree - 1),
        )
        return y_inv

    def conjugate_e12d(
        self, e12d: list[ModuloCircuitElement]
    ) -> list[ModuloCircuitElement]:
        assert len(e12d) == 12
        return [
            e12d[0],
            self.neg(e12d[1]),
            e12d[2],
            self.neg(e12d[3]),
            e12d[4],
            self.neg(e12d[5]),
            e12d[6],
            self.neg(e12d[7]),
            e12d[8],
            self.neg(e12d[9]),
            e12d[10],
            self.neg(e12d[11]),
        ]

    def update_LHS_state(
        self,
        s1: PyFelt,
        Ps: list[list[ModuloCircuitElement]],
        Ps_sparsities: list[list[int] | None] = None,
        acc_index: int = 0,
    ):
        # Sanity checks for sparsities
        Ps_sparsities = Ps_sparsities or [None] * len(Ps)
        assert len(Ps_sparsities) == len(
            Ps
        ), f"len(Ps_sparsities)={len(Ps_sparsities)} != len(Ps)={len(Ps)}"
        for i, sparsity in enumerate(Ps_sparsities):
            if sparsity:
                assert all(
                    Ps[i][j].value == 0 for j in range(len(Ps[i])) if sparsity[j] == 0
                )
                assert all(
                    Ps[i][j].value == 1 for j in range(len(Ps[i])) if sparsity[j] == 2
                )

        # Evaluate LHS = Π(Pi(z)) inside circuit.
        # i=0
        LHS = self.eval_poly_in_precomputed_Z(Ps[0], Ps_sparsities[0])
        LHS_current_eval = LHS
        # Keep P0(z)
        self.accumulate_poly_instructions[acc_index].Pis_of_Z.append([])
        self.accumulate_poly_instructions[acc_index].Pis_of_Z[-1].append(LHS)
        for i in range(1, len(Ps)):
            if Ps[i - 1] == Ps[i]:
                # Consecutives elements are the same : retrieve previous evaluation.
                LHS_current_eval = self.accumulate_poly_instructions[
                    acc_index
                ].Pis_of_Z[-1][-1]

                # Todo : support smarter analysis to save a few muls

            else:
                LHS_current_eval = self.eval_poly_in_precomputed_Z(
                    Ps[i], Ps_sparsities[i]
                )
            # Keep Pi(z)
            self.accumulate_poly_instructions[acc_index].Pis_of_Z[-1].append(
                LHS_current_eval
            )
            # Update LHS
            LHS = self.mul(LHS, LHS_current_eval)

        ci_XY_of_z = self.mul(s1, LHS, "ci_XY_of_z")

        LHS_acc = self.add(self.acc[acc_index].lhs, ci_XY_of_z, "LHS_acc")

        # Update LHS only.
        self.acc[acc_index] = EuclideanPolyAccumulator(
            lhs=LHS_acc,
            R=self.acc[acc_index].R,
            R_evaluated=self.acc[acc_index].R_evaluated,
        )

        return

    def update_RHS_state(
        self,
        type: AccPolyInstructionType,
        s1: ModuloCircuitElement,
        R: list[ModuloCircuitElement],
        r_sparsity: list[int] = None,
        acc_index: int = 0,
        instruction_index: int = 0,
    ):

        # Find if R_of_z is already computed in the first Pi of the next instruction.
        # In this case we avoid accumulating R as polynomial and can use directly R_of_z with the correct s1.
        if type != AccPolyInstructionType.SQUARE_TORUS:
            if instruction_index + 1 < self.accumulate_poly_instructions[acc_index].n:
                if (
                    self.accumulate_poly_instructions[acc_index].Pis[
                        instruction_index + 1
                    ][0]
                    == R
                ):
                    already_computed_R_of_z = self.accumulate_poly_instructions[
                        acc_index
                    ].Pis_of_Z[instruction_index + 1][0]

                    # Update direclty Rhs_evaluted
                    self.acc[acc_index] = EuclideanPolyAccumulator(
                        lhs=self.acc[acc_index].lhs,
                        R=self.acc[acc_index].R,
                        R_evaluated=self.add(
                            self.acc[acc_index].R_evaluated,
                            self.mul(s1, already_computed_R_of_z),
                        ),
                    )
                    return

        # If not found, computes R_acc = R_acc + s1 * R as a Polynomial inside circuit
        if r_sparsity:
            if type != AccPolyInstructionType.SQUARE_TORUS:
                # Sanity check is already done in square_torus function.
                # If the instruction is SQUARE_TORUS, then R is fully determined by its sparsity, R(x) = x.
                # Actual R value here is the SQ TORUS result.
                # See square torus function for this edge case.
                assert all(R[i].value == 0 for i in range(len(R)) if r_sparsity[i] == 0)
            R_acc = []
            for i, (r_acc, r) in enumerate(zip(self.acc[acc_index].R, R)):
                match r_sparsity[i]:
                    case 1:
                        R_acc.append(self.add(r_acc, self.mul(s1, r)))
                    case 2:
                        R_acc.append(self.add(r_acc, s1))
                    case _:
                        R_acc.append(r_acc)

        else:
            # Computes R_acc = R_acc + s1 * R without sparsity info.
            R_acc = [
                self.add(r_acc, self.mul(s1, r))
                for r_acc, r in zip(self.acc[acc_index].R, R)
            ]
        # Update accumulator state
        self.acc[acc_index] = EuclideanPolyAccumulator(
            lhs=self.acc[acc_index].lhs,
            R=R_acc,
            R_evaluated=self.acc[acc_index].R_evaluated,
        )
        return

    def finalize_circuit(
        self,
        extension_degree: int = None,
    ):
        ######### Flags #########
        extension_degree = extension_degree or self.extension_degree
        double_extension = self.accumulate_poly_instructions[1].n > 0
        acc_indexes = [0, 1] if double_extension else [0]
        #########################

        ################ Get base rlc coefficient c0 ################
        if self.hash_input:
            self.transcript.hash_limbs_multi(self.circuit_input)
        self.transcript.hash_limbs_multi(self.commitments)

        c0 = self.write_cairo_native_felt(self.field(self.transcript.s1))
        ##################################################################
        ################ Compute Qs ################
        Qs = [Polynomial([self.field.zero()]) for _ in range(2)]

        for acc_index in acc_indexes:
            self.accumulate_poly_instructions[acc_index].rlc_coeffs.append(c0)
            # Computes Q = Σ(ci * Qi)
            Qs[acc_index] = self.accumulate_poly_instructions[acc_index].Qis[0] * c0
            for i in range(1, self.accumulate_poly_instructions[acc_index].n):
                self.accumulate_poly_instructions[acc_index].rlc_coeffs.append(
                    self.mul(
                        self.accumulate_poly_instructions[acc_index].rlc_coeffs[i - 1],
                        c0,
                    )
                )
                Qs[acc_index] += (
                    self.accumulate_poly_instructions[acc_index].Qis[i]
                    * self.accumulate_poly_instructions[acc_index].rlc_coeffs[i]
                )
            Qs[acc_index] = Qs[acc_index].get_coeffs()
            # Extend Q with zeros if needed to match the minimal expected degree.
            Qs[acc_index] = Qs[acc_index] + [self.field.zero()] * (
                (acc_index + 1) * extension_degree - 1 - len(Qs[acc_index])
            )
        ##################################################################

        Q = [self.write_elements(Qs[0], WriteOps.COMMIT)]

        compute_z_up_to = max(max(len(Qs[0]), len(Qs[1])) - 1, extension_degree)
        self.big_q_len = len(Q[0])

        self.transcript.hash_limbs_multi(Q[0])
        if double_extension:
            Q.append(self.write_elements(Qs[1], WriteOps.COMMIT))
            self.transcript.hash_limbs_multi(Q[1])
            compute_z_up_to = max(compute_z_up_to, extension_degree * 2)
            self.big_q_len = self.big_q_len + len(Q[1])

        z = self.transcript.continuable_hash

        self.create_powers_of_Z(z, max_degree=compute_z_up_to)

        for acc_index in acc_indexes:
            for i in range(self.accumulate_poly_instructions[acc_index].n):
                self.update_LHS_state(
                    s1=self.accumulate_poly_instructions[acc_index].rlc_coeffs[i],
                    Ps=self.accumulate_poly_instructions[acc_index].Pis[i],
                    Ps_sparsities=self.accumulate_poly_instructions[
                        acc_index
                    ].Ps_sparsities[i],
                    acc_index=acc_index,
                )

            for i in range(self.accumulate_poly_instructions[acc_index].n):
                self.update_RHS_state(
                    type=self.accumulate_poly_instructions[acc_index].types[i],
                    s1=self.accumulate_poly_instructions[acc_index].rlc_coeffs[i],
                    R=self.accumulate_poly_instructions[acc_index].Ris[i],
                    r_sparsity=self.accumulate_poly_instructions[
                        acc_index
                    ].r_sparsities[i],
                    acc_index=acc_index,
                    instruction_index=i,
                )

            Q_of_Z = self.eval_poly_in_precomputed_Z(Q[acc_index])
            P, P_sparsity = self.write_sparse_constant_elements(
                get_irreducible_poly(
                    self.curve_id, (acc_index + 1) * extension_degree
                ).get_coeffs(),
            )
            P_of_z = self.eval_poly_in_precomputed_Z(P, P_sparsity)
            R = self.acc[acc_index].R
            R_of_Z = self.eval_poly_in_precomputed_Z(R)

            lhs = self.acc[acc_index].lhs
            rhs = self.add(
                self.mul(Q_of_Z, P_of_z),
                self.add(R_of_Z, self.acc[acc_index].R_evaluated),
            )
            assert lhs.value == rhs.value, f"{lhs.value} != {rhs.value}, {acc_index}"
            if self.compilation_mode == 0:
                self.sub_and_assert(
                    lhs, rhs, self.set_or_get_constant(self.field.zero())
                )
            else:
                eq_check = self.sub(rhs, lhs)
                self.extend_output([eq_check])
        return True

    def summarize(self):
        add_count, mul_count, assert_eq_count = self.values_segment.summarize()
        summary = {
            "circuit": self.name,
            "MULMOD": mul_count,
            "ADDMOD": add_count,
            "ASSERT_EQ": assert_eq_count,
            "POSEIDON": (
                self.transcript.permutations_count
                if self.transcript.permutations_count > 1
                else 0
            ),
            "RLC": self.accumulate_poly_instructions[0].n
            + self.accumulate_poly_instructions[1].n,
        }

        return summary

    def compile_circuit_cairo_zero(
        self,
        function_name: str = None,
        returns: dict[str] = {
            "felt*": [
                "constants_ptr",
                "add_offsets_ptr",
                "mul_offsets_ptr",
                "output_offsets_ptr",
            ],
            "felt": [
                "constants_ptr_len",
                "input_len",
                "commitments_len",
                "big_Q_len",
                "witnesses_len",
                "output_len",
                "continuous_output",
                "add_mod_n",
                "mul_mod_n",
                "n_assert_eq",
                "N_Euclidean_equations",
                "name",
                "curve_id",
            ],
        },
    ) -> str:
        dw_arrays = self.values_segment.get_dw_lookups()
        name = function_name or self.values_segment.name
        function_name = f"get_{name}_circuit"
        code = f"func {function_name}()->(circuit:{self.class_name}*)" + "{" + "\n"

        code += "alloc_locals;\n"
        code += "let (__fp__, _) = get_fp_and_pc();\n"

        for dw_array_name in returns["felt*"]:
            code += f"let ({dw_array_name}:felt*) = get_label_location({dw_array_name}_loc);\n"

        code += f"let constants_ptr_len = {len(dw_arrays['constants_ptr'])};\n"
        code += f"let input_len = {len(self.values_segment.segment_stacks[WriteOps.INPUT])*N_LIMBS};\n"
        code += f"let commitments_len = {len(self.commitments)*N_LIMBS};\n"
        code += f"let witnesses_len = {len(self.values_segment.segment_stacks[WriteOps.WITNESS])*N_LIMBS};\n"
        code += f"let big_Q_len = {self.big_q_len*N_LIMBS};\n"
        code += f"let output_len = {len(self.output)*N_LIMBS};\n"
        continuous_output = self.continuous_output
        code += f"let continuous_output = {1 if continuous_output else 0};\n"
        code += f"let add_mod_n = {len(dw_arrays['add_offsets_ptr'])};\n"
        code += f"let mul_mod_n = {len(dw_arrays['mul_offsets_ptr'])};\n"
        code += (
            f"let n_assert_eq = {len(self.values_segment.assert_eq_instructions)};\n"
        )
        code += (
            f"let N_Euclidean_equations = {len(dw_arrays['poseidon_indexes_ptr'])};\n"
        )
        code += f"let name = '{self.name}';\n"
        code += f"let curve_id = {self.curve_id};\n"

        code += f"local circuit:ExtensionFieldModuloCircuit = ExtensionFieldModuloCircuit({', '.join(returns['felt*'])}, {', '.join(returns['felt'])});\n"
        code += "return (&circuit,);\n"

        for dw_array_name in returns["felt*"]:
            dw_values = dw_arrays[dw_array_name]
            code += f"\t {dw_array_name}_loc:\n"
            if dw_array_name == "constants_ptr":
                for bigint in dw_values:
                    for limb in bigint:
                        code += f"\t dw {limb};\n"
                code += "\n"

            elif dw_array_name in ["add_offsets_ptr", "mul_offsets_ptr"]:
                num_instructions = len(dw_values)
                instructions_needed = (
                    BATCH_SIZE - (num_instructions % BATCH_SIZE)
                ) % BATCH_SIZE
                for left, right, result, comment in dw_values:
                    code += (
                        f"\t dw {left}; // {comment}\n"
                        + f"\t dw {right};\n"
                        + f"\t dw {result};\n"
                    )
                if instructions_needed > 0:
                    first_triplet = dw_values[0]
                    for _ in range(instructions_needed):
                        code += (
                            f"\t dw {first_triplet[0]};\n"
                            + f"\t dw {first_triplet[1]};\n"
                            + f"\t dw {first_triplet[2]};\n"
                        )
                code += "\n"
            elif dw_array_name in ["output_offsets_ptr"]:
                if continuous_output:
                    code += f"\t dw {dw_values[0]};\n"
                else:
                    for val in dw_values:
                        code += f"\t dw {val};\n"

        code += "\n"
        code += "}\n"
        return code


if __name__ == "__main__":
    pass
