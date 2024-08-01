from random import randint

import hydra.modulo_circuit_structs as structs
from hydra.definitions import (
    BLS12_381_ID,
    BN254_ID,
    STARK,
    CurveID,
    G1Point,
    G2Point,
    get_irreducible_poly,
)
from hydra.extension_field_modulo_circuit import (
    ExtensionFieldModuloCircuit,
    ModuloCircuit,
    ModuloCircuitElement,
    PyFelt,
)
from hydra.modulo_circuit_structs import (
    E12D,
    BLSProcessedPair,
    BNProcessedPair,
    G1PointCircuit,
    G2PointCircuit,
    MillerLoopResultScalingFactor,
    u384,
)
from hydra.precompiled_circuits import multi_pairing_check
from hydra.precompiled_circuits.compilable_circuits.base import BaseEXTFCircuit


class Groth16Bit0Loop(BaseEXTFCircuit):
    def __init__(
        self,
        curve_id: int,
        auto_run: bool = True,
        compilation_mode: int = 1,
    ):
        assert compilation_mode == 1, "Compilation mode 1 is required for this circuit"
        self.n_pairs = 3
        super().__init__(
            name=f"groth16_bit0",
            input_len=None,
            curve_id=curve_id,
            auto_run=auto_run,
            compilation_mode=compilation_mode,
        )
        self.generic_over_curve = True

    def build_input(self) -> list[PyFelt]:
        input = []
        # First we generate the input corresponding to the two pairs of points with the fixed G2 points:
        # The precomputed yInv and xNegOverY, and the lines R0, R1 in Fp2.
        for _ in range(self.n_pairs - 1):
            p = G1Point.gen_random_point(CurveID(self.curve_id))
            yInv = self.field(p.y).__inv__()
            xNegOverY = -self.field(p.x) * yInv
            r0a0 = self.field.random()
            r0a1 = self.field.random()
            r1a0 = self.field.random()
            r1a1 = self.field.random()
            input.extend([yInv, xNegOverY, r0a0, r0a1, r1a0, r1a1])
        # Then we add yInv and xNegOverY for the last G1 point, and the current G2 point, on which we are going to compute the line. (Not fixed)

        p = G1Point.gen_random_point(CurveID(self.curve_id))
        current_q2 = G2Point.gen_random_point(CurveID(self.curve_id))
        yInv = self.field(p.y).__inv__()
        xNegOverY = -self.field(p.x) * yInv
        input.extend(
            [
                yInv,
                xNegOverY,
                self.field(current_q2.x[0]),
                self.field(current_q2.x[1]),
                self.field(current_q2.y[0]),
                self.field(current_q2.y[1]),
            ]
        )
        # The rest is similar to the case where all points are not fixed.
        input.append(
            self.field.random()
        )  # LHS accumulation = Sum(ci*(prod(Pi,j)-Ri)(z))
        input.append(self.field.random())  # R(i-1)(z) = f(i-1)(z) for miller loop.
        input.extend([self.field.random() for _ in range(12)])  # Ri = new_f
        input.append(self.field.random())  # ci_minus_one
        input.append(self.field(randint(0, STARK - 1)))  # z
        return input

    def _run_circuit_inner(self, input: list[PyFelt]):
        n_pairs = self.n_pairs
        assert n_pairs >= 2, f"n_pairs must be >= 2, got {n_pairs}"
        circuit: multi_pairing_check.MultiPairingCheckCircuit = (
            multi_pairing_check.MultiPairingCheckCircuit(
                self.name,
                self.curve_id,
                n_pairs=n_pairs,
                hash_input=False,
                compilation_mode=self.compilation_mode,
                precompute_lines=True,
                n_points_precomputed_lines=n_pairs - 1,
            )
        )
        # Parse (yInv, xNegOverY, R0, R1) * n_pairs
        current_points = []
        current_lines = []
        for i in range(n_pairs - 1):
            circuit.yInv.append(
                circuit.write_struct(u384(name=f"yInv_{i}", elmts=[input.pop(0)]))
            )
            circuit.xNegOverY.append(
                circuit.write_struct(u384(name=f"xNegOverY_{i}", elmts=[input.pop(0)]))
            )
            current_lines.extend(
                circuit.write_struct(
                    structs.G2Line(
                        name=f"line{i}",
                        elmts=[input.pop(0), input.pop(0), input.pop(0), input.pop(0)],
                    )
                )
            )
        # Last G1 point yInv and xNegOverY
        circuit.yInv.append(
            circuit.write_struct(u384(name=f"yInv_{n_pairs}", elmts=[input.pop(0)]))
        )
        circuit.xNegOverY.append(
            circuit.write_struct(
                u384(name=f"xNegOverY_{n_pairs}", elmts=[input.pop(0)])
            )
        )

        lhs_i = circuit.write_struct(u384(name="lhs_i", elmts=[input.pop(0)]))
        f_i_of_z: ModuloCircuitElement = circuit.write_struct(
            u384(name="f_i_of_z", elmts=[input.pop(0)])
        )

        # f_i_plus_one is R as the result E12 for this bit.
        f_i_plus_one: list[ModuloCircuitElement] = circuit.write_struct(
            E12D(name="f_i_plus_one", elmts=[input.pop(0) for _ in range(12)])
        )
        ci = circuit.write_struct(u384(name="ci", elmts=[input.pop(0)]))
        assert len(input) == 1, f"Input should be empty now"

        circuit.create_powers_of_Z(
            circuit.write_struct(u384(name="z", elmts=[input.pop(0)])), max_degree=11
        )
        ci_plus_one = circuit.mul(ci, ci, f"Compute c_i = (c_(i-1))^2")

        assert len(input) == 0, f"Input should be empty now"
        assert len(current_points) == n_pairs

        sum_i_prod_k_P = circuit.mul(
            f_i_of_z, f_i_of_z, f"Square f evaluation in Z, the result of previous bit."
        )
        new_points = []
        for k in range(n_pairs):
            T, l1 = circuit.double_step(current_points[k], k)
            sum_i_prod_k_P = circuit.mul(
                sum_i_prod_k_P,
                circuit.eval_poly_in_precomputed_Z(l1, circuit.line_sparsity),
                f"Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_{k}(z)",
            )

            new_points.append(T)

        f_i_plus_one_of_z = circuit.eval_poly_in_precomputed_Z(f_i_plus_one)
        new_lhs = circuit.mul(
            ci_plus_one,
            circuit.sub(sum_i_prod_k_P, f_i_plus_one_of_z, f"(Π(i,k) (Pk(z))) - Ri(z)"),
            f"ci * ((Π(i,k) (Pk(z)) - Ri(z))",
        )
        lhs_i_plus_one = circuit.add(
            lhs_i, new_lhs, f"LHS = LHS + ci * ((Π(i,k) (Pk(z)) - Ri(z))"
        )
        for i, point in enumerate(new_points):
            # circuit.extend_output(point[0])
            # circuit.extend_output(point[1])
            circuit.extend_struct_output(
                G2PointCircuit(
                    name=f"Q{i}",
                    elmts=[point[0][0], point[0][1], point[1][0], point[1][1]],
                )
            )
        circuit.extend_struct_output(
            u384(name="f_i_plus_one_of_z", elmts=[f_i_plus_one_of_z])
        )
        circuit.extend_struct_output(
            u384(name="lhs_i_plus_one", elmts=[lhs_i_plus_one])
        )
        circuit.extend_struct_output(u384(name="ci_plus_one", elmts=[ci_plus_one]))

        return circuit


class MPCheckBit00Loop(BaseEXTFCircuit):
    def __init__(
        self,
        curve_id: int,
        n_pairs: int = 0,
        auto_run: bool = True,
        compilation_mode: int = 1,
    ):
        assert compilation_mode == 1, "Compilation mode 1 is required for this circuit"
        self.n_pairs = n_pairs
        super().__init__(
            name=f"mpcheck_bit00",
            input_len=None,
            curve_id=curve_id,
            auto_run=auto_run,
            compilation_mode=compilation_mode,
        )
        self.generic_over_curve = True

    def build_input(self) -> list[PyFelt]:
        input = []
        for _ in range(self.n_pairs):
            p = G1Point.gen_random_point(CurveID(self.curve_id))
            current_q = G2Point.gen_random_point(CurveID(self.curve_id))
            yInv = self.field(p.y).__inv__()
            xNegOverY = -self.field(p.x) * yInv
            input.extend(
                [
                    yInv,
                    xNegOverY,
                    self.field(current_q.x[0]),
                    self.field(current_q.x[1]),
                    self.field(current_q.y[0]),
                    self.field(current_q.y[1]),
                ]
            )

        input.append(
            self.field.random()
        )  # LHS accumulation = Sum(ci*(prod(Pi,j)-Ri)(z))
        input.append(self.field.random())  # R(i-1)(z) = f(i-1)(z) for miller loop.
        input.extend([self.field.random() for _ in range(12)])  # Ri = new_f
        input.append(self.field.random())  # ci_minus_one
        input.append(self.field(randint(0, STARK - 1)))  # z
        return input

    def _run_circuit_inner(self, input: list[PyFelt]):
        n_pairs = self.n_pairs
        assert n_pairs >= 2, f"n_pairs must be >= 2, got {n_pairs}"
        circuit: multi_pairing_check.MultiPairingCheckCircuit = (
            multi_pairing_check.MultiPairingCheckCircuit(
                self.name,
                self.curve_id,
                n_pairs=n_pairs,
                hash_input=False,
                compilation_mode=self.compilation_mode,
            )
        )
        # Parse (yInv, xNegOverY, Qx0, Qx1, Qy0, Qy1) * n_pairs
        current_points = []
        for i in range(n_pairs):
            circuit.yInv.append(
                circuit.write_struct(u384(name=f"yInv_{i}", elmts=[input.pop(0)]))
            )
            circuit.xNegOverY.append(
                circuit.write_struct(u384(name=f"xNegOverY_{i}", elmts=[input.pop(0)]))
            )
            current_pt = circuit.write_struct(
                G2PointCircuit(
                    name=f"Q{i}",
                    elmts=[input.pop(0), input.pop(0), input.pop(0), input.pop(0)],
                )
            )
            current_points.append(
                [
                    current_pt[0],
                    current_pt[1],
                ],
                [
                    current_pt[2],
                    current_pt[3],
                ],
            )

        lhs_i = circuit.write_struct(u384(name="lhs_i", elmts=[input.pop(0)]))
        f_i_of_z: ModuloCircuitElement = circuit.write_struct(
            u384(name="f_i_of_z", elmts=[input.pop(0)])
        )

        # f_i_plus_one is R as the result E12 for this bit.
        f_i_plus_one: list[ModuloCircuitElement] = circuit.write_struct(
            E12D(name="f_i_plus_one", elmts=[input.pop(0) for _ in range(12)])
        )
        ci = circuit.write_struct(u384(name="ci", elmts=[input.pop(0)]))
        assert len(input) == 1, f"Input should be empty now"

        circuit.create_powers_of_Z(
            circuit.write_struct(u384(name="z", elmts=[input.pop(0)])), max_degree=11
        )
        ci_plus_one = circuit.mul(ci, ci, f"Compute c_i = (c_(i-1))^2")

        assert len(input) == 0, f"Input should be empty now"
        assert len(current_points) == n_pairs

        sum_i_prod_k_P = circuit.mul(
            f_i_of_z, f_i_of_z, f"Square f evaluation in Z, the result of previous bit."
        )
        new_points = []
        for k in range(n_pairs):
            T, l1 = circuit.double_step(current_points[k], k)
            sum_i_prod_k_P = circuit.mul(
                sum_i_prod_k_P,
                circuit.eval_poly_in_precomputed_Z(
                    l1, circuit.line_sparsity, f"line_{k}"
                ),
                f"Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_{k}(z)",
            )

            new_points.append(T)

        sum_i_prod_k_P = circuit.mul(
            sum_i_prod_k_P,
            sum_i_prod_k_P,
            "Compute (f^2 * Π(i,k) (line_i,k(z))) ^ 2 = f^4 * (Π(i,k) (line_i,k(z)))^2",
        )

        new_new_points = []
        for k in range(n_pairs):
            T, l1 = circuit.double_step(new_points[k], k)
            sum_i_prod_k_P = circuit.mul(
                sum_i_prod_k_P,
                circuit.eval_poly_in_precomputed_Z(
                    l1, circuit.line_sparsity, f"line_{k}"
                ),
                f"Mul (f^4 * (Π(i,k) (line_i,k(z)))^2) * line_i+1_{k}(z)",
            )

            new_new_points.append(T)

        f_i_plus_one_of_z = circuit.eval_poly_in_precomputed_Z(
            f_i_plus_one, poly_name="R"
        )
        new_lhs = circuit.mul(
            ci_plus_one,
            circuit.sub(sum_i_prod_k_P, f_i_plus_one_of_z, f"(Π(i,k) (Pk(z))) - Ri(z)"),
            f"ci * ((Π(i,k) (Pk(z)) - Ri(z))",
        )
        lhs_i_plus_one = circuit.add(
            lhs_i, new_lhs, f"LHS = LHS + ci * ((Π(i,k) (Pk(z)) - Ri(z))"
        )
        for i, point in enumerate(new_new_points):
            # circuit.extend_output(point[0])
            # circuit.extend_output(point[1])
            circuit.extend_struct_output(
                G2PointCircuit(
                    name=f"Q{i}",
                    elmts=[point[0][0], point[0][1], point[1][0], point[1][1]],
                )
            )
        circuit.extend_struct_output(
            u384(name="f_i_plus_one_of_z", elmts=[f_i_plus_one_of_z])
        )
        circuit.extend_struct_output(
            u384(name="lhs_i_plus_one", elmts=[lhs_i_plus_one])
        )
        circuit.extend_struct_output(u384(name="ci_plus_one", elmts=[ci_plus_one]))

        return circuit


class MPCheckBit1Loop(BaseEXTFCircuit):
    def __init__(
        self,
        curve_id: int,
        n_pairs: int = 0,
        auto_run: bool = True,
        compilation_mode: int = 1,
    ):
        assert compilation_mode == 1, "Compilation mode 1 is required for this circuit"
        self.n_pairs = n_pairs
        super().__init__(
            name="mpcheck_bit1",
            input_len=None,
            curve_id=curve_id,
            auto_run=auto_run,
            compilation_mode=compilation_mode,
        )
        self.generic_over_curve = True

    def build_input(self) -> list[PyFelt]:
        """
        - (PyInv, PxNegOverY, Qx0, Qx1, Qy0, Qy1) * (n_pairs)
        - LHS = sum(ci*prod(Pi,j))(z) (1 u384)
        - sum (ci_-1*Ri_-1) (12 u384)
        - f:E12 (12 u384)
        - z (1 u384)
        - ci (1 u384)
        """
        input = []
        for _ in range(self.n_pairs):
            p = G1Point.gen_random_point(CurveID(self.curve_id))
            current_q = G2Point.gen_random_point(CurveID(self.curve_id))
            q_or_q_neg = G2Point.gen_random_point(CurveID(self.curve_id))
            yInv = self.field(p.y).__inv__()
            xNegOverY = -self.field(p.x) * yInv
            input.extend(
                [
                    yInv,
                    xNegOverY,
                    self.field(current_q.x[0]),
                    self.field(current_q.x[1]),
                    self.field(current_q.y[0]),
                    self.field(current_q.y[1]),
                    self.field(q_or_q_neg.x[0]),
                    self.field(q_or_q_neg.x[1]),
                    self.field(q_or_q_neg.y[0]),
                    self.field(q_or_q_neg.y[1]),
                ]
            )

        input.append(
            self.field.random()
        )  # LHS accumulation = Sum(ci*(prod(Pi,j)-Ri)(z))
        input.append(self.field.random())  # R(i-1)(z) = f(i-1)(z) for miller loop.
        input.extend([self.field.random() for _ in range(12)])  # Ri = new_f
        input.append(self.field.random())  # c_or_cinv_of_z
        input.append(self.field(randint(0, STARK - 1)))  # z
        input.append(self.field.random())  # ci
        return input

    def _run_circuit_inner(self, input: list[PyFelt]):
        n_pairs = self.n_pairs
        assert n_pairs >= 2, f"n_pairs must be >= 2, got {n_pairs}"
        circuit: multi_pairing_check.MultiPairingCheckCircuit = (
            multi_pairing_check.MultiPairingCheckCircuit(
                self.name,
                self.curve_id,
                n_pairs=n_pairs,
                hash_input=False,
                compilation_mode=self.compilation_mode,
            )
        )
        current_points = []
        q_or_q_neg_points = []
        for i in range(n_pairs):
            circuit.yInv.append(
                circuit.write_struct(u384(name=f"yInv_{i}", elmts=[input.pop(0)]))
            )
            circuit.xNegOverY.append(
                circuit.write_struct(u384(name=f"xNegOverY_{i}", elmts=[input.pop(0)]))
            )
            curr_pt = circuit.write_struct(
                G2PointCircuit(
                    name=f"Q{i}",
                    elmts=[input.pop(0), input.pop(0), input.pop(0), input.pop(0)],
                )
            )
            current_points.append(
                (
                    [
                        curr_pt[0],
                        curr_pt[1],
                    ],
                    [
                        curr_pt[2],
                        curr_pt[3],
                    ],
                )
            )
            q_or_q_neg_pt = circuit.write_struct(
                G2PointCircuit(
                    name=f"Q_or_Qneg_{i}",
                    elmts=[input.pop(0), input.pop(0), input.pop(0), input.pop(0)],
                )
            )
            q_or_q_neg_points.append(
                (
                    [
                        q_or_q_neg_pt[0],
                        q_or_q_neg_pt[1],
                    ],
                    [
                        q_or_q_neg_pt[2],
                        q_or_q_neg_pt[3],
                    ],
                )
            )

        lhs_i = circuit.write_struct(u384(name="lhs_i", elmts=[input.pop(0)]))
        f_i_of_z: ModuloCircuitElement = circuit.write_struct(
            u384(name="f_i_of_z", elmts=[input.pop(0)])
        )

        f_i_plus_one: list[ModuloCircuitElement] = circuit.write_struct(
            E12D(name="f_i_plus_one", elmts=[input.pop(0) for _ in range(12)])
        )
        c_or_cinv_of_z: ModuloCircuitElement = circuit.write_struct(
            u384(name="c_or_cinv_of_z", elmts=[input.pop(0)])
        )
        circuit.create_powers_of_Z(
            circuit.write_struct(u384(name="z", elmts=[input.pop(0)])), max_degree=11
        )
        assert len(input) == 1, f"Input should be empty now"

        ci = circuit.write_struct(u384(name="ci", elmts=[input.pop(0)]))
        ci_plus_one = circuit.mul(ci, ci)

        assert len(input) == 0, f"Input should be empty now"
        assert len(current_points) == n_pairs

        sum_i_prod_k_P_of_z = circuit.mul(
            f_i_of_z, f_i_of_z
        )  # Square f evaluation in Z, the result of previous bit.
        new_points = []

        for k in range(n_pairs):
            T, l1, l2 = circuit.double_and_add_step(
                current_points[k], q_or_q_neg_points[k], k
            )
            sum_i_prod_k_P_of_z = circuit.mul(
                sum_i_prod_k_P_of_z,
                circuit.eval_poly_in_precomputed_Z(
                    l1, circuit.line_sparsity, f"line_{k}p_1"
                ),
            )
            sum_i_prod_k_P_of_z = circuit.mul(
                sum_i_prod_k_P_of_z,
                circuit.eval_poly_in_precomputed_Z(
                    l2, circuit.line_sparsity, f"line_{k}p_2"
                ),
            )
            new_points.append(T)

        sum_i_prod_k_P_of_z = circuit.mul(sum_i_prod_k_P_of_z, c_or_cinv_of_z)

        f_i_plus_one_of_z = circuit.eval_poly_in_precomputed_Z(
            f_i_plus_one, poly_name="R"
        )
        new_lhs = circuit.mul(
            ci_plus_one,
            circuit.sub(sum_i_prod_k_P_of_z, f_i_plus_one_of_z),
            comment=f"ci * ((Π(i,k) (Pk(z)) - Ri(z))",
        )
        lhs_i_plus_one = circuit.add(lhs_i, new_lhs)

        for i, point in enumerate(new_points):
            circuit.extend_struct_output(
                G2PointCircuit(
                    name=f"Q{i}",
                    elmts=[point[0][0], point[0][1], point[1][0], point[1][1]],
                )
            )

        circuit.extend_struct_output(
            u384(name="f_i_plus_one_of_z", elmts=[f_i_plus_one_of_z])
        )
        circuit.extend_struct_output(
            u384(name="lhs_i_plus_one", elmts=[lhs_i_plus_one])
        )
        circuit.extend_struct_output(u384(name="ci_plus_one", elmts=[ci_plus_one]))

        return circuit


class MPCheckPreparePairs(BaseEXTFCircuit):
    """
    This circuit is used to prepare points for the multi-pairing check.
    For BN curve, it will compute yInv and xNegOverY for each point + negate the y of the G2 point.
    For BLS curve, it will only compute yInv and xNegOverY for each point.
    """

    def __init__(
        self,
        curve_id: int,
        n_pairs: int = 0,
        auto_run: bool = True,
        compilation_mode: int = 1,
    ):
        assert compilation_mode == 1, "Compilation mode 1 is required for this circuit"
        self.n_pairs = n_pairs
        super().__init__(
            name="mpcheck_prepare_points",
            input_len=None,
            curve_id=curve_id,
            auto_run=auto_run,
            compilation_mode=compilation_mode,
        )
        self.generic_over_curve = True

    def build_input(self) -> list[PyFelt]:
        """
        - ((Px, Py) + (Qy0, Qy1) if BN curve) * (n_pairs)
        """
        input = []
        for _ in range(self.n_pairs):
            p = G1Point.gen_random_point(CurveID(self.curve_id))
            q = G2Point.gen_random_point(CurveID(self.curve_id))
            input.extend(
                [
                    self.field(p.x),
                    self.field(p.y),
                ]
            )
            if self.curve_id == BN254_ID:
                input.extend(
                    [
                        self.field(q.y[0]),
                        self.field(q.y[1]),
                    ]
                )
        return input

    def _run_circuit_inner(self, input: list[PyFelt]):
        n_pairs = self.n_pairs
        circuit: ModuloCircuit = ModuloCircuit(
            self.name,
            self.curve_id,
            compilation_mode=self.compilation_mode,
        )
        for i in range(n_pairs):
            x, y = circuit.write_struct(
                G1PointCircuit(name=f"p_{i}", elmts=[input.pop(0), input.pop(0)])
            )
            yInv = circuit.inv(y)
            xNegOverY = circuit.neg(circuit.mul(x, yInv))

            if self.curve_id == BN254_ID:
                Qy0 = circuit.write_struct(u384(name=f"Qy0_{i}", elmts=[input.pop(0)]))
                Qy1 = circuit.write_struct(u384(name=f"Qy1_{i}", elmts=[input.pop(0)]))
                Qyneg0 = circuit.neg(Qy0)
                Qyneg1 = circuit.neg(Qy1)
                circuit.extend_struct_output(
                    BNProcessedPair(
                        name=f"p_{i}", elmts=[yInv, xNegOverY, Qyneg0, Qyneg1]
                    )
                )
            else:
                circuit.extend_struct_output(
                    BLSProcessedPair(name=f"p_{i}", elmts=[yInv, xNegOverY])
                )

        return circuit


class MPCheckPrepareLambdaRootEvaluations(BaseEXTFCircuit):
    def __init__(self, curve_id: int, auto_run: bool = True, compilation_mode: int = 1):
        assert compilation_mode == 1, "Compilation mode 1 is required for this circuit"
        super().__init__(
            name="mpcheck_lambda_root_eval",
            input_len=None,
            curve_id=curve_id,
            auto_run=auto_run,
            compilation_mode=compilation_mode,
        )

    def build_input(self) -> list[PyFelt]:
        input = []
        input.extend([self.field.random() for _ in range(12)])  # lambda_root
        input.append(self.field.random())  # z
        input.extend([self.field.random() for _ in range(6)])  # w - scaling factor
        if self.curve_id == BN254_ID:
            input.extend([self.field.random() for _ in range(12)])  # c_inv
            input.append(self.field.random())  # c_0
        return input

    def _run_circuit_inner(self, input: list[PyFelt]):
        circuit = multi_pairing_check.MultiPairingCheckCircuit(
            name=self.name,
            curve_id=self.curve_id,
            n_pairs=2,  # Unused
            hash_input=False,
            compilation_mode=self.compilation_mode,
        )
        c_or_c_inv = circuit.write_struct(
            E12D(
                name=(
                    f"lambda_root_inverse"
                    if self.curve_id == BLS12_381_ID
                    else "lambda_root"
                ),
                elmts=[input.pop(0) for _ in range(12)],
            )
        )
        z = circuit.write_struct(u384(name="z", elmts=[input.pop(0)]))
        circuit.create_powers_of_Z(z, max_degree=11)

        if self.curve_id == BLS12_381_ID:
            # Conjugate c_inverse for BLS.
            c_or_c_inv = circuit.conjugate_e12d(c_or_c_inv)

        c_or_c_inv_of_z = circuit.eval_poly_in_precomputed_Z(
            c_or_c_inv, poly_name=f"C_inv" if self.curve_id == BLS12_381_ID else "C"
        )
        circuit.extend_struct_output(
            u384(
                name="c_inv_of_z" if self.curve_id == BLS12_381_ID else "c_of_z",
                elmts=[c_or_c_inv_of_z],
            )
        )

        scaling_factor_sparsity = [
            1,
            0,
            1,
            0,
            1,
            0,
            1,
            0,
            1,
            0,
            1,
            0,
        ]  # E6 subfield within E12 : to_direct(E6.random + w * E6.zero)

        scaling_factor_compressed = circuit.write_struct(
            MillerLoopResultScalingFactor(
                name="scaling_factor", elmts=[input.pop(0) for _ in range(6)]
            )
        )
        scaling_factor = [
            scaling_factor_compressed[0],
            None,
            scaling_factor_compressed[1],
            None,
            scaling_factor_compressed[2],
            None,
            scaling_factor_compressed[3],
            None,
            scaling_factor_compressed[4],
            None,
            scaling_factor_compressed[5],
            None,
        ]

        scaling_factor_of_z = circuit.eval_poly_in_precomputed_Z(
            scaling_factor, sparsity=scaling_factor_sparsity, poly_name="W"
        )

        circuit.extend_struct_output(
            u384("scaling_factor_of_z", elmts=[scaling_factor_of_z])
        )

        if self.curve_id == BLS12_381_ID:
            c_inv = c_or_c_inv
            # Compute needed frobenius:
            c_inv_frob_1 = circuit.frobenius(c_inv, 1)
            c_inv_frob_1_of_z = circuit.eval_poly_in_precomputed_Z(
                c_inv_frob_1, poly_name="C_inv_frob_1"
            )
            circuit.extend_struct_output(
                u384("c_inv_frob_1_of_z", elmts=[c_inv_frob_1_of_z])
            )
        elif self.curve_id == BN254_ID:
            c = c_or_c_inv
            c_of_z = c_or_c_inv_of_z
            c_inv = circuit.write_struct(
                E12D(name="c_inv", elmts=[input.pop(0) for _ in range(12)])
            )
            c_0 = circuit.write_struct(u384(name="c_0", elmts=[input.pop(0)]))
            c_inv_of_z = circuit.eval_poly_in_precomputed_Z(c_inv, poly_name=f"C_inv")
            circuit.extend_struct_output(u384(name="c_inv_of_z", elmts=[c_inv_of_z]))
            lhs = circuit.sub(
                circuit.mul(c_of_z, c_inv_of_z),
                circuit.set_or_get_constant(1),
                comment="c_of_z * c_inv_of_z - 1",
            )
            lhs = circuit.mul(lhs, c_0, comment="c_0 * (c_of_z * c_inv_of_z - 1)")
            circuit.extend_struct_output(u384("lhs", elmts=[lhs]))

            # Compute needed frobenius:
            c_inv_frob_1 = circuit.frobenius(c_inv, 1)
            c_frob_2 = circuit.frobenius(c, 2)
            c_inv_frob_3 = circuit.frobenius(c_inv, 3)

            c_inv_frob_1_of_z = circuit.eval_poly_in_precomputed_Z(
                c_inv_frob_1, poly_name="C_inv_frob_1"
            )
            c_frob_2_of_z = circuit.eval_poly_in_precomputed_Z(
                c_frob_2, poly_name="C_frob_2"
            )
            c_inv_frob_3_of_z = circuit.eval_poly_in_precomputed_Z(
                c_inv_frob_3, poly_name="C_inv_frob_3"
            )

            circuit.extend_struct_output(
                u384("c_inv_frob_1_of_z", elmts=[c_inv_frob_1_of_z])
            )
            circuit.extend_struct_output(u384("c_frob_2_of_z", elmts=[c_frob_2_of_z]))
            circuit.extend_struct_output(
                u384("c_inv_frob_3_of_z", elmts=[c_inv_frob_3_of_z])
            )

        return circuit


class MPCheckInitBit(BaseEXTFCircuit):
    def __init__(
        self,
        curve_id: int,
        n_pairs: int,
        auto_run: bool = True,
        compilation_mode: int = 1,
    ):
        assert compilation_mode == 1, "Compilation mode 1 is required for this circuit"
        assert 2 <= n_pairs <= 3, f"n_pairs must be between 2 and 3, got {n_pairs}"
        self.n_pairs = n_pairs
        super().__init__(
            name="mpcheck_init_bit",
            input_len=None,
            curve_id=curve_id,
            auto_run=auto_run,
            compilation_mode=compilation_mode,
        )

    def build_input(self) -> list[PyFelt]:
        input = []
        for _ in range(self.n_pairs):
            p = G1Point.gen_random_point(CurveID(self.curve_id))
            current_q = G2Point.gen_random_point(CurveID(self.curve_id))
            yInv = self.field(p.y).__inv__()
            xNegOverY = -self.field(p.x) * yInv
            input.extend(
                [
                    yInv,
                    xNegOverY,
                    self.field(current_q.x[0]),
                    self.field(current_q.x[1]),
                    self.field(current_q.y[0]),
                    self.field(current_q.y[1]),
                ]
            )

        input.extend([self.field.random() for _ in range(12)])  # Ri = new_f
        input.append(self.field.random())  # c0
        input.append(self.field.random())  # z
        input.append(
            self.field.random()
        )  # c_inv_of_z (BN) or conjugate(c_inv)_of_z (BLS)

        if self.curve_id == BN254_ID:
            input.append(self.field.random())  # previous_lhs
        return input

    def _run_circuit_inner(self, input: list[PyFelt]):
        n_pairs = self.n_pairs
        circuit: multi_pairing_check.MultiPairingCheckCircuit = (
            multi_pairing_check.MultiPairingCheckCircuit(
                self.name,
                self.curve_id,
                n_pairs=n_pairs,
                hash_input=False,
                compilation_mode=self.compilation_mode,
            )
        )
        current_points = []
        for i in range(n_pairs):
            circuit.yInv.append(
                circuit.write_struct(u384(name=f"yInv_{i}", elmts=[input.pop(0)]))
            )
            circuit.xNegOverY.append(
                circuit.write_struct(u384(name=f"xNegOverY_{i}", elmts=[input.pop(0)]))
            )
            curr_pt = circuit.write_struct(
                G2PointCircuit(
                    name=f"Q{i}",
                    elmts=[input.pop(0), input.pop(0), input.pop(0), input.pop(0)],
                )
            )
            current_points.append(
                (
                    [
                        curr_pt[0],
                        curr_pt[1],
                    ],
                    [
                        curr_pt[2],
                        curr_pt[3],
                    ],
                )
            )

        R_i = circuit.write_struct(E12D("R_i", elmts=[input.pop(0) for _ in range(12)]))
        c0 = circuit.write_struct(u384("c0", elmts=[input.pop(0)]))
        z = circuit.write_struct(u384("z", elmts=[input.pop(0)]))
        c_inv_of_z = circuit.write_struct(u384("c_inv_of_z", elmts=[input.pop(0)]))
        circuit.create_powers_of_Z(z, max_degree=11)

        f_i_plus_one_of_z = circuit.eval_poly_in_precomputed_Z(R_i, poly_name="R")
        sum_i_prod_k_P_of_z = circuit.mul(
            c_inv_of_z, c_inv_of_z
        )  # # At initialisation, f=1/c so f^2 = 1/c^2
        new_points = []
        if self.curve_id == BN254_ID:
            c_i = circuit.mul(
                c0, c0
            )  # Second relation for BN at init bit, need to update c_i.
            for k in range(n_pairs):
                T, l1 = circuit.double_step(current_points[k], k)
                sum_i_prod_k_P_of_z = circuit.mul(
                    sum_i_prod_k_P_of_z,
                    circuit.eval_poly_in_precomputed_Z(
                        l1, circuit.line_sparsity, f"line_{k}p_1"
                    ),
                )
                new_points.append(T)
        elif self.curve_id == BLS12_381_ID:
            c_i = c0  # first relation for BLS at init bit, no need to update c_i.
            # bit +1:  multiply f^2 by 1/c
            sum_i_prod_k_P_of_z = circuit.mul(c_inv_of_z, sum_i_prod_k_P_of_z)
            for k in range(n_pairs):
                T, l1, l2 = circuit.triple_step(current_points[k], k)
                sum_i_prod_k_P_of_z = circuit.mul(
                    sum_i_prod_k_P_of_z,
                    circuit.eval_poly_in_precomputed_Z(
                        l1, circuit.line_sparsity, f"line_{k}p_1"
                    ),
                )
                sum_i_prod_k_P_of_z = circuit.mul(
                    sum_i_prod_k_P_of_z,
                    circuit.eval_poly_in_precomputed_Z(
                        l2, circuit.line_sparsity, f"line_{k}p_2"
                    ),
                )
                new_points.append(T)

        new_lhs = circuit.mul(
            c_i,
            circuit.sub(sum_i_prod_k_P_of_z, f_i_plus_one_of_z),
            comment=f"ci * ((Π(i,k) (Pk(z)) - Ri(z))",
        )

        if self.curve_id == BLS12_381_ID:
            new_lhs = new_lhs
        elif self.curve_id == BN254_ID:
            previous_lhs = circuit.write_struct(
                u384("previous_lhs", elmts=[input.pop(0)])
            )
            new_lhs = circuit.add(new_lhs, previous_lhs)

        # OUTPUT
        for i, point in enumerate(new_points):
            circuit.extend_struct_output(
                G2PointCircuit(
                    name=f"Q{i}",
                    elmts=[point[0][0], point[0][1], point[1][0], point[1][1]],
                )
            )
        circuit.extend_struct_output(u384("new_lhs", elmts=[new_lhs]))
        if self.curve_id == BN254_ID:
            circuit.extend_struct_output(u384("c_i", elmts=[c_i]))
        circuit.extend_struct_output(
            u384("f_i_plus_one_of_z", elmts=[f_i_plus_one_of_z])
        )
        return circuit


class MPCheckFinalizeBN(BaseEXTFCircuit):
    def __init__(
        self,
        curve_id: int,
        n_pairs: int,
        auto_run: bool = True,
        compilation_mode: int = 1,
    ):
        assert compilation_mode == 1, "Compilation mode 1 is required for this circuit"
        assert 2 <= n_pairs <= 3, f"n_pairs must be between 2 and 3, got {n_pairs}"
        self.n_pairs = n_pairs
        self.max_q_degree = multi_pairing_check.get_max_Q_degree(curve_id, self.n_pairs)

        super().__init__(
            name="mpcheck_finalize_bn",
            input_len=None,
            curve_id=curve_id,
            auto_run=auto_run,
            compilation_mode=compilation_mode,
        )

    def build_input(self) -> list[PyFelt]:
        if self.curve_id == BLS12_381_ID:
            return []
        input = []
        for _ in range(self.n_pairs):
            original_p = G1Point.gen_random_point(CurveID(self.curve_id))
            original_q = G2Point.gen_random_point(CurveID(self.curve_id))
            yInv = self.field(original_p.y).__inv__()
            xNegOverY = -self.field(original_p.x) * yInv
            current_q = G2Point.gen_random_point(CurveID(self.curve_id))

            input.extend(
                [
                    self.field(original_q.x[0]),
                    self.field(original_q.x[1]),
                    self.field(original_q.y[0]),
                    self.field(original_q.y[1]),
                    yInv,
                    xNegOverY,
                    self.field(current_q.x[0]),
                    self.field(current_q.x[1]),
                    self.field(current_q.y[0]),
                    self.field(current_q.y[1]),
                ]
            )

        input.extend([self.field.random() for _ in range(12)])  # Ri = new_f
        input.extend([self.field.random() for _ in range(12)])  # Ri = new_f

        input.append(self.field.random())  # c_i-1
        input.append(self.field.random())  # z
        input.append(self.field.random())  # w_of_z
        input.append(self.field.random())  # c_inv_frob_1_of_z
        input.append(self.field.random())  # c_frob_2_of_z
        input.append(self.field.random())  # c_inv_frob_3_of_z
        input.append(self.field.random())  # previous_lhs
        input.append(self.field.random())  # R_n_minus_3_of_z

        input.extend([self.field.random() for _ in range(self.max_q_degree + 1)])
        return input

    def _run_circuit_inner(self, input: list[PyFelt]):
        n_pairs = self.n_pairs
        circuit: multi_pairing_check.MultiPairingCheckCircuit = (
            multi_pairing_check.MultiPairingCheckCircuit(
                self.name,
                self.curve_id,
                n_pairs=n_pairs,
                hash_input=False,
                compilation_mode=self.compilation_mode,
            )
        )
        if self.curve_id == BLS12_381_ID:
            return circuit

        current_points = []
        for k in range(n_pairs):
            original_Q = circuit.write_struct(
                G2PointCircuit(
                    name=f"original_Q{k}",
                    elmts=[input.pop(0), input.pop(0), input.pop(0), input.pop(0)],
                )
            )
            circuit.Q.append(
                ([original_Q[0], original_Q[1]], [original_Q[2], original_Q[3]])
            )
            yInv_k = circuit.write_struct(u384(f"yInv_{k}", elmts=[input.pop(0)]))
            xNegOverY_k = circuit.write_struct(
                u384(f"xNegOverY_{k}", elmts=[input.pop(0)])
            )
            circuit.yInv.append(yInv_k)
            circuit.xNegOverY.append(xNegOverY_k)
            curr_pt = circuit.write_struct(
                G2PointCircuit(
                    name=f"Q{k}",
                    elmts=[input.pop(0), input.pop(0), input.pop(0), input.pop(0)],
                )
            )
            current_points.append(
                (
                    [
                        curr_pt[0],
                        curr_pt[1],
                    ],
                    [
                        curr_pt[2],
                        curr_pt[3],
                    ],
                )
            )

        R_n_minus_2 = circuit.write_struct(
            E12D("R_n_minus_2", elmts=[input.pop(0) for _ in range(12)])
        )
        R_n_minus_1 = circuit.write_struct(
            E12D("R_n_minus_1", elmts=[input.pop(0) for _ in range(12)])
        )
        c_n_minus_3 = circuit.write_struct(u384("c_n_minus_3", elmts=[input.pop(0)]))
        w_of_z = circuit.write_struct(u384("w_of_z", elmts=[input.pop(0)]))
        z = circuit.write_struct(u384("z", elmts=[input.pop(0)]))
        c_inv_frob_1_of_z = circuit.write_struct(
            u384("c_inv_frob_1_of_z", elmts=[input.pop(0)])
        )
        c_frob_2_of_z = circuit.write_struct(
            u384("c_frob_2_of_z", elmts=[input.pop(0)])
        )
        c_inv_frob_3_of_z = circuit.write_struct(
            u384("c_inv_frob_3_of_z", elmts=[input.pop(0)])
        )
        previous_lhs = circuit.write_struct(u384("previous_lhs", elmts=[input.pop(0)]))
        R_n_minus_3_of_z = circuit.write_struct(
            u384("R_n_minus_3_of_z", elmts=[input.pop(0)])
        )
        Q = circuit.write_struct(
            structs.u384Array(
                "Q", elmts=[input.pop(0) for _ in range(self.max_q_degree + 1)]
            )
        )

        circuit.create_powers_of_Z(z, max_degree=self.max_q_degree)

        c_n_minus_2 = circuit.mul(c_n_minus_3, c_n_minus_3)
        c_n_minus_1 = circuit.mul(c_n_minus_2, c_n_minus_2)

        R_n_minus_2_of_z = circuit.eval_poly_in_precomputed_Z(
            R_n_minus_2, poly_name="R_n_minus_2"
        )
        R_n_minus_1_of_z = circuit.eval_poly_in_precomputed_Z(
            R_n_minus_1, poly_name="R_n_minus_1"
        )

        # Relation n-2 : f * lines
        prod_k_P_of_z_n_minus_2 = R_n_minus_3_of_z  # Init
        lines = circuit.bn254_finalize_step(current_points)
        for l in lines:
            prod_k_P_of_z_n_minus_2 = circuit.mul(
                prod_k_P_of_z_n_minus_2,
                circuit.eval_poly_in_precomputed_Z(
                    l, circuit.line_sparsity, f"line_{k}"
                ),
            )

        lhs_n_minus_2 = circuit.mul(
            c_n_minus_2,
            circuit.sub(prod_k_P_of_z_n_minus_2, R_n_minus_2_of_z),
            comment=f"c_n_minus_2 * ((Π(n-2,k) (Pk(z)) - R_n_minus_2(z))",
        )

        # Relation n-1 (last one) : f * w * c_inv_frob_1 * c_frob_2 * c_inv_frob_3
        prod_k_P_of_z_n_minus_1 = circuit.mul(R_n_minus_2_of_z, c_inv_frob_1_of_z)
        prod_k_P_of_z_n_minus_1 = circuit.mul(prod_k_P_of_z_n_minus_1, c_frob_2_of_z)
        prod_k_P_of_z_n_minus_1 = circuit.mul(
            prod_k_P_of_z_n_minus_1, c_inv_frob_3_of_z
        )
        prod_k_P_of_z_n_minus_1 = circuit.mul(prod_k_P_of_z_n_minus_1, w_of_z)

        lhs_n_minus_1 = circuit.mul(
            c_n_minus_1,
            circuit.sub(prod_k_P_of_z_n_minus_1, R_n_minus_1_of_z),
            comment=f"c_n_minus_1 * ((Π(n-1,k) (Pk(z)) - R_n_minus_1(z))",
        )

        _final_lhs = circuit.add(previous_lhs, lhs_n_minus_2)
        final_lhs = circuit.add(_final_lhs, lhs_n_minus_1)

        Q_of_z = circuit.eval_poly_in_precomputed_Z(Q, poly_name="big_Q")
        P_irr, P_irr_sparsity = circuit.write_sparse_constant_elements(
            get_irreducible_poly(self.curve_id, 12).get_coeffs(),
        )
        P_of_z = circuit.eval_poly_in_precomputed_Z(
            P_irr, P_irr_sparsity, poly_name="P_irr"
        )
        check = circuit.sub(final_lhs, circuit.mul(Q_of_z, P_of_z))

        circuit.extend_struct_output(u384("final_check", elmts=[check]))
        return circuit


class MPCheckFinalizeBLS(BaseEXTFCircuit):
    def __init__(
        self,
        curve_id: int,
        n_pairs: int,
        # include_m: bool,
        auto_run: bool = True,
        compilation_mode: int = 1,
    ):
        assert compilation_mode == 1, "Compilation mode 1 is required for this circuit"
        assert 2 <= n_pairs <= 3, f"n_pairs must be between 2 and 3, got {n_pairs}"
        self.n_pairs = n_pairs
        self.max_q_degree = multi_pairing_check.get_max_Q_degree(curve_id, self.n_pairs)

        super().__init__(
            name="mpcheck_finalize_bls",
            input_len=None,
            curve_id=curve_id,
            auto_run=auto_run,
            compilation_mode=compilation_mode,
        )

    def build_input(self) -> list[PyFelt]:
        if self.curve_id == BN254_ID:
            return []
        input = []

        input.extend([self.field.random() for _ in range(12)])  # R_n_minus_1

        input.append(self.field.random())  # c_i-1
        input.append(self.field.random())  # z
        input.append(self.field.random())  # w_of_z
        input.append(self.field.random())  # c_inv_frob_1_of_z
        input.append(self.field.random())  # previous_lhs
        input.append(self.field.random())  # R_n_minus_2_of_z

        input.extend([self.field.random() for _ in range(self.max_q_degree + 1)])
        return input

    def _run_circuit_inner(self, input: list[PyFelt]):
        n_pairs = self.n_pairs
        circuit: multi_pairing_check.MultiPairingCheckCircuit = (
            multi_pairing_check.MultiPairingCheckCircuit(
                self.name,
                self.curve_id,
                n_pairs=n_pairs,
                hash_input=False,
                compilation_mode=self.compilation_mode,
            )
        )
        if self.curve_id == BN254_ID:
            return circuit

        R_n_minus_1 = circuit.write_struct(
            E12D("R_n_minus_1", elmts=[input.pop(0) for _ in range(12)])
        )
        c_n_minus_2 = circuit.write_struct(u384("c_n_minus_2", elmts=[input.pop(0)]))
        w_of_z = circuit.write_struct(u384("w_of_z", elmts=[input.pop(0)]))
        z = circuit.write_struct(u384("z", elmts=[input.pop(0)]))
        c_inv_frob_1_of_z = circuit.write_struct(
            u384("c_inv_frob_1_of_z", elmts=[input.pop(0)])
        )
        previous_lhs = circuit.write_struct(u384("previous_lhs", elmts=[input.pop(0)]))
        R_n_minus_2_of_z = circuit.write_struct(
            u384("R_n_minus_2_of_z", elmts=[input.pop(0)])
        )
        Q = circuit.write_struct(
            structs.u384Array(
                "Q", elmts=[input.pop(0) for _ in range(self.max_q_degree + 1)]
            )
        )

        circuit.create_powers_of_Z(z, max_degree=self.max_q_degree)

        c_n_minus_1 = circuit.mul(c_n_minus_2, c_n_minus_2)

        R_n_minus_1_of_z = circuit.eval_poly_in_precomputed_Z(
            R_n_minus_1, poly_name="R_n_minus_1"
        )

        # Relation n-1 (last one) : f * w * c_inv_frob_1
        prod_k_P_of_z_n_minus_1 = circuit.mul(R_n_minus_2_of_z, c_inv_frob_1_of_z)
        prod_k_P_of_z_n_minus_1 = circuit.mul(prod_k_P_of_z_n_minus_1, w_of_z)

        lhs_n_minus_1 = circuit.mul(
            c_n_minus_1,
            circuit.sub(prod_k_P_of_z_n_minus_1, R_n_minus_1_of_z),
            comment=f"c_n_minus_1 * ((Π(n-1,k) (Pk(z)) - R_n_minus_1(z))",
        )

        final_lhs = circuit.add(
            previous_lhs, lhs_n_minus_1, comment="previous_lhs + lhs_n_minus_1"
        )
        P_irr, P_irr_sparsity = circuit.write_sparse_constant_elements(
            get_irreducible_poly(self.curve_id, 12).get_coeffs(),
        )
        P_of_z = circuit.eval_poly_in_precomputed_Z(
            P_irr, P_irr_sparsity, poly_name="P_irr"
        )

        Q_of_z = circuit.eval_poly_in_precomputed_Z(Q, poly_name="big_Q")

        check = circuit.sub(
            final_lhs,
            circuit.mul(Q_of_z, P_of_z, comment="Q(z) * P(z)"),
            comment="final_lhs - Q(z) * P(z)",
        )

        circuit.extend_struct_output(u384("final_check", elmts=[check]))
        return circuit


class FP12MulAssertOne(BaseEXTFCircuit):
    def __init__(
        self,
        curve_id: int,
        auto_run: bool = True,
        init_hash: int = None,
        compilation_mode: int = 0,
    ):
        super().__init__(
            "fp12_mul_assert_one", None, curve_id, auto_run, init_hash, compilation_mode
        )

    def build_input(self) -> list[PyFelt]:
        input = []
        input.extend([self.field.random() for _ in range(12)])  # X
        input.extend([self.field.random() for _ in range(12)])  # Y
        input.extend([self.field.random() for _ in range(11)])  # Q
        # R is known to be 1.
        input.append(self.field.random())  # z

        return input

    def _run_circuit_inner(self, input: list[PyFelt]) -> ExtensionFieldModuloCircuit:
        circuit = ExtensionFieldModuloCircuit(
            self.name,
            self.curve_id,
            extension_degree=12,
            init_hash=self.init_hash,
            compilation_mode=self.compilation_mode,
        )
        X = circuit.write_struct(E12D("X", elmts=[input.pop(0) for _ in range(12)]))
        Y = circuit.write_struct(E12D("Y", elmts=[input.pop(0) for _ in range(12)]))
        Q = circuit.write_struct(
            structs.E12DMulQuotient("Q", elmts=[input.pop(0) for _ in range(11)])
        )
        assert len(input) == 1
        z = circuit.write_struct(u384("z", elmts=[input.pop(0)]))
        assert len(input) == 0
        circuit.create_powers_of_Z(z, max_degree=12)
        P_irr, P_irr_sparsity = circuit.write_sparse_constant_elements(
            get_irreducible_poly(self.curve_id, 12).get_coeffs(),
        )
        P_of_z = circuit.eval_poly_in_precomputed_Z(
            P_irr, P_irr_sparsity, poly_name="P_irr"
        )
        Q_of_z = circuit.eval_poly_in_precomputed_Z(Q, poly_name="Q")
        R_of_z = circuit.set_or_get_constant(1)

        X_of_z = circuit.eval_poly_in_precomputed_Z(X, poly_name="X")
        Y_of_z = circuit.eval_poly_in_precomputed_Z(Y, poly_name="Y")
        check = circuit.sub(
            circuit.mul(X_of_z, Y_of_z, comment="X(z) * Y(z)"),
            circuit.mul(Q_of_z, P_of_z, comment="Q(z) * P(z)"),
            comment="(X(z) * Y(z)) - (Q(z) * P(z))",
        )
        check = circuit.sub(check, R_of_z, comment="(X(z) * Y(z) - Q(z) * P(z)) - 1")
        circuit.extend_struct_output(u384("check", elmts=[check]))

        return circuit
