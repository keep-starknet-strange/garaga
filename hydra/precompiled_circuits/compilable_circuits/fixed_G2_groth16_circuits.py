from typing import List, Tuple, Union

import hydra.modulo_circuit_structs as structs
from hydra.definitions import BLS12_381_ID, BN254_ID, get_irreducible_poly
from hydra.extension_field_modulo_circuit import PyFelt
from hydra.modulo_circuit_structs import (
    E12D,
    Cairo1SerializableStruct,
    G2Line,
    G2PointCircuit,
    u384,
    u384Array,
)
from hydra.precompiled_circuits import multi_pairing_check
from hydra.precompiled_circuits.compilable_circuits.base import BaseEXTFCircuit


def split_list_into_pairs(
    input: Union[List[PyFelt], Tuple[PyFelt, PyFelt, PyFelt, PyFelt]]
) -> Tuple[Tuple[PyFelt, PyFelt], Tuple[PyFelt, PyFelt]]:
    if input is None:
        return None
    assert len(input) == 4, f"Expected input of length 4, got {len(input)}"
    return (list(input[0:2]), list(input[2:4]))


def parse_precomputed_g1_consts_and_g2_points(
    circuit: multi_pairing_check.MultiPairingCheckCircuit,
    vars: dict,
    n_pairs: int,
    bit_1: bool = False,
) -> list[tuple[list[PyFelt], list[PyFelt]]]:
    current_points = []
    q_or_q_neg_points = [] if bit_1 else None
    for i in range(n_pairs):
        circuit.yInv.append(vars[f"yInv_{i}"])
        circuit.xNegOverY.append(vars[f"xNegOverY_{i}"])
        current_points.append(
            split_list_into_pairs(vars.get(f"Q_{i}", None))
        )  # Return empty list if not present
        if bit_1:
            q_or_q_neg_points.append(
                split_list_into_pairs(
                    vars.get(f"Q_or_Q_neg_{i}", None)
                )  # Return empty list if not present
            )

    return current_points, q_or_q_neg_points


from abc import ABC, abstractmethod
from typing import Callable, Dict, Type, Union


class BaseGroth16Circuit(BaseEXTFCircuit, ABC):
    def __init__(self, name, curve_id, auto_run=True, compilation_mode=1):
        assert compilation_mode == 1, "Compilation mode 1 is required for this circuit"
        self.n_pairs = 3
        super().__init__(
            name=name,
            input_len=None,
            curve_id=curve_id,
            auto_run=auto_run,
            compilation_mode=compilation_mode,
        )
        self.generic_over_curve = True

    def _initialize_circuit(self):
        return multi_pairing_check.MultiPairingCheckCircuit(
            self.name,
            self.curve_id,
            n_pairs=self.n_pairs,
            hash_input=False,
            compilation_mode=self.compilation_mode,
            precompute_lines=True,
            n_points_precomputed_lines=2,
        )

    @property
    @abstractmethod
    def input_map(self) -> Dict[str, Union[Type[Cairo1SerializableStruct], Callable]]:
        """
        Define the input map for the circuit.
        For u384Array, use a tuple (u384Array, size) to specify its size.
        """

    def _base_input_map(self, bit_type):
        input_map = {}

        # Add pair inputs
        for k in range(self.n_pairs - 1):
            input_map[f"yInv_{k}"] = u384
            input_map[f"xNegOverY_{k}"] = u384
            input_map[f"G2_line_{k}"] = G2Line
            if bit_type == "1":
                input_map[f"Q_or_Q_neg_line{k}"] = G2Line
            if bit_type == "00":
                input_map[f"G2_line_2nd_0_{k}"] = G2Line

        # Last pair, not precomputed G2
        input_map[f"yInv_2"] = u384
        input_map[f"xNegOverY_2"] = u384
        input_map[f"Q_2"] = G2PointCircuit
        if bit_type == "1":
            input_map[f"Q_or_Q_neg_2"] = G2PointCircuit

        # Add common inputs
        input_map["lhs_i"] = u384
        input_map["f_i_of_z"] = u384
        input_map["f_i_plus_one"] = E12D

        # Add bit-specific inputs
        if bit_type == "1":
            input_map["c_or_cinv_of_z"] = u384

        input_map["z"] = u384
        input_map["ci"] = u384

        return input_map

    def _process_input(
        self, circuit: multi_pairing_check.MultiPairingCheckCircuit, input
    ):
        vars = {}
        for name, struct_info in self.input_map.items():
            if isinstance(struct_info, tuple) and struct_info[0] == u384Array:
                # Handle u384Array with specified size
                struct_type, size = struct_info
                vars[name] = circuit.write_struct(
                    struct_type(name, elmts=[input.pop(0) for _ in range(size)])
                )
            elif struct_info == G2Line:
                # Internally appended to the precomputed_lines flattened list
                circuit.precomputed_lines.extend(
                    circuit.write_struct(
                        G2Line(name, elmts=[input.pop(0) for _ in range(4)])
                    )
                )
            else:
                struct_type = struct_info
                # For other types, create a temporary instance to get its length
                temp_instance = struct_type(
                    name, None
                )  # Temporary instance with a dummy element
                size = len(temp_instance)
                if size == 1:
                    vars[name] = circuit.write_struct(
                        struct_type(name, elmts=[input.pop(0)])
                    )
                else:
                    # Convert to tuple so that it is Hashable
                    vars[name] = tuple(
                        circuit.write_struct(
                            struct_type(name, elmts=[input.pop(0) for _ in range(size)])
                        )
                    )
        assert len(input) == 0, f"Expected input of length 0, got {len(input)}"
        # Create the precomputed lines generator
        circuit._precomputed_lines_generator = (
            circuit._create_precomputed_lines_generator()
        )
        return vars

    def build_input(self) -> list[PyFelt]:
        total_elements = 0
        for name, struct_info in self.input_map.items():
            if isinstance(struct_info, tuple):
                # This is the u384Array case
                _, size = struct_info
                total_elements += size
            else:
                # For other structs, create a temporary instance to get its length
                temp_instance = struct_info(name, None)
                total_elements += len(temp_instance)

        return [self.field.random() for _ in range(total_elements)]

    def _run_circuit_inner(self, input: list[PyFelt]):
        circuit = self._initialize_circuit()

        vars = self._process_input(circuit, input)
        return self._execute_circuit_logic(circuit, vars)

    @abstractmethod
    def _execute_circuit_logic(self, circuit, vars):
        """
        Implement the circuit logic using the processed input variables.
        """

    def _execute_circuit_bit_logic_base(self, circuit, vars, bit_type):
        n_pairs = self.n_pairs
        assert n_pairs >= 2, f"n_pairs must be >= 2, got {n_pairs}"

        current_points, q_or_q_neg_points = parse_precomputed_g1_consts_and_g2_points(
            circuit, vars, n_pairs, bit_1=(bit_type == "1")
        )

        circuit.create_powers_of_Z(Z=vars["z"], max_degree=11)
        ci_plus_one = circuit.mul(vars["ci"], vars["ci"], f"Compute c_i = (c_(i-1))^2")

        sum_i_prod_k_P = circuit.mul(
            vars["f_i_of_z"],
            vars["f_i_of_z"],
            f"Square f evaluation in Z, the result of previous bit.",
        )

        new_points, sum_i_prod_k_P = self._process_points(
            circuit, current_points, q_or_q_neg_points, sum_i_prod_k_P, bit_type
        )

        if bit_type == "1":
            sum_i_prod_k_P = circuit.mul(sum_i_prod_k_P, vars["c_or_cinv_of_z"])

        f_i_plus_one_of_z = circuit.eval_poly_in_precomputed_Z(
            vars["f_i_plus_one"], poly_name="R"
        )
        new_lhs = circuit.mul(
            ci_plus_one,
            circuit.sub(sum_i_prod_k_P, f_i_plus_one_of_z, f"(Π(i,k) (Pk(z))) - Ri(z)"),
            f"ci * ((Π(i,k) (Pk(z)) - Ri(z))",
        )
        lhs_i_plus_one = circuit.add(
            vars["lhs_i"], new_lhs, f"LHS = LHS + ci * ((Π(i,k) (Pk(z)) - Ri(z))"
        )

        self._extend_output(
            circuit, new_points, f_i_plus_one_of_z, lhs_i_plus_one, ci_plus_one
        )

        return circuit

    def _process_points(
        self, circuit, current_points, q_or_q_neg_points, sum_i_prod_k_P, bit_type
    ):
        new_points = []
        if bit_type == "00":
            for k in range(self.n_pairs):
                T1, l1 = circuit.double_step(current_points[k], k)
                sum_i_prod_k_P = self._multiply_line_evaluations(
                    circuit, sum_i_prod_k_P, [l1], k
                )
                new_points.append(T1)

            sum_i_prod_k_P = circuit.mul(
                sum_i_prod_k_P,
                sum_i_prod_k_P,
                "Compute (f^2 * Π(i,k) (line_i,k(z))) ^ 2 = f^4 * (Π(i,k) (line_i,k(z)))^2",
            )

            new_new_points = []
            for k in range(self.n_pairs):
                T, l2 = circuit.double_step(new_points[k], k)
                sum_i_prod_k_P = self._multiply_line_evaluations(
                    circuit, sum_i_prod_k_P, [l2], k
                )
                new_new_points.append(T)
            return new_new_points, sum_i_prod_k_P
        elif bit_type == "0":
            for k in range(self.n_pairs):
                T, l1 = circuit.double_step(current_points[k], k)
                sum_i_prod_k_P = self._multiply_line_evaluations(
                    circuit, sum_i_prod_k_P, [l1], k
                )
                new_points.append(T)
        elif bit_type == "1":
            for k in range(self.n_pairs):
                T, l1, l2 = circuit.double_and_add_step(
                    current_points[k], q_or_q_neg_points[k], k
                )
                sum_i_prod_k_P = self._multiply_line_evaluations(
                    circuit, sum_i_prod_k_P, [l1, l2], k
                )
                new_points.append(T)
        return new_points, sum_i_prod_k_P

    def _multiply_line_evaluations(self, circuit, sum_i_prod_k_P, lines, k):
        for i, l in enumerate(lines):
            sum_i_prod_k_P = circuit.mul(
                sum_i_prod_k_P,
                circuit.eval_poly_in_precomputed_Z(
                    l, circuit.line_sparsity, f"line_{k}p_{i+1}"
                ),
                f"Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_{k}(z)",
            )
        return sum_i_prod_k_P

    def _extend_output(
        self, circuit, new_points, f_i_plus_one_of_z, lhs_i_plus_one, ci_plus_one
    ):
        last_point = new_points[-1]
        circuit.extend_struct_output(
            G2PointCircuit(
                name=f"Q2",
                elmts=[
                    last_point[0][0],
                    last_point[0][1],
                    last_point[1][0],
                    last_point[1][1],
                ],
            )
        )
        circuit.extend_struct_output(
            u384(name="f_i_plus_one_of_z", elmts=[f_i_plus_one_of_z])
        )
        circuit.extend_struct_output(
            u384(name="lhs_i_plus_one", elmts=[lhs_i_plus_one])
        )
        circuit.extend_struct_output(u384(name="ci_plus_one", elmts=[ci_plus_one]))


class Groth16Bit0Loop(BaseGroth16Circuit):
    def __init__(
        self,
        curve_id: int,
        auto_run: bool = True,
        compilation_mode: int = 1,
    ):
        super().__init__(
            name=f"mpcheck_bit0",
            curve_id=curve_id,
            auto_run=auto_run,
            compilation_mode=compilation_mode,
        )

    @property
    def input_map(self):
        return self._base_input_map("0")

    def _execute_circuit_logic(self, circuit, vars):
        return self._execute_circuit_bit_logic_base(circuit, vars, "0")


class Groth16Bit00Loop(BaseGroth16Circuit):
    def __init__(
        self,
        curve_id: int,
        auto_run: bool = True,
        compilation_mode: int = 1,
    ):
        super().__init__(
            name=f"mpcheck_bit00",
            curve_id=curve_id,
            auto_run=auto_run,
            compilation_mode=compilation_mode,
        )

    @property
    def input_map(self):
        return self._base_input_map("00")

    def _execute_circuit_logic(self, circuit, vars):
        return self._execute_circuit_bit_logic_base(circuit, vars, "00")


class Groth16Bit1Loop(BaseGroth16Circuit):
    def __init__(
        self,
        curve_id: int,
        auto_run: bool = True,
        compilation_mode: int = 1,
    ):
        assert compilation_mode == 1, "Compilation mode 1 is required for this circuit"
        super().__init__(
            name="mpcheck_bit1",
            curve_id=curve_id,
            auto_run=auto_run,
            compilation_mode=compilation_mode,
        )

    @property
    def input_map(self):
        return self._base_input_map("1")

    def _execute_circuit_logic(self, circuit, vars):
        return self._execute_circuit_bit_logic_base(circuit, vars, "1")


class Groth16InitBit(BaseGroth16Circuit):
    def __init__(
        self,
        curve_id: int,
        auto_run: bool = True,
        compilation_mode: int = 1,
    ):
        super().__init__(
            name="groth16_init_bit",
            curve_id=curve_id,
            auto_run=auto_run,
            compilation_mode=compilation_mode,
        )

    @property
    def input_map(self):
        input_map = {}
        for i in range(self.n_pairs - 1):
            input_map[f"yInv_{i}"] = u384
            input_map[f"xNegOverY_{i}"] = u384
            input_map[f"G2_line_{i}"] = G2Line
            if self.curve_id == BLS12_381_ID:
                input_map[f"G2_line_{i}_2"] = G2Line

        input_map[f"yInv_2"] = u384
        input_map[f"xNegOverY_2"] = u384
        input_map[f"Q_2"] = G2PointCircuit

        input_map.update(
            {
                "R_i": E12D,
                "c0": u384,
                "z": u384,
                "c_inv_of_z": u384,
            }
        )
        if self.curve_id == BN254_ID:
            input_map["previous_lhs"] = u384
        return input_map

    def _execute_circuit_logic(self, circuit, vars):
        n_pairs = self.n_pairs
        current_points, _ = parse_precomputed_g1_consts_and_g2_points(
            circuit, vars, n_pairs
        )

        R_i = vars["R_i"]
        c0 = vars["c0"]
        z = vars["z"]
        c_inv_of_z = vars["c_inv_of_z"]
        circuit.create_powers_of_Z(z, max_degree=11)

        f_i_plus_one_of_z = circuit.eval_poly_in_precomputed_Z(R_i, poly_name="R")
        sum_i_prod_k_P_of_z = circuit.mul(
            c_inv_of_z, c_inv_of_z
        )  # At initialisation, f=1/c so f^2 = 1/c^2
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
            previous_lhs = vars["previous_lhs"]
            new_lhs = circuit.add(new_lhs, previous_lhs)

        # OUTPUT
        last_point = new_points[-1]
        circuit.extend_struct_output(
            G2PointCircuit(
                name=f"Q2",
                elmts=[
                    last_point[0][0],
                    last_point[0][1],
                    last_point[1][0],
                    last_point[1][1],
                ],
            )
        )
        circuit.extend_struct_output(u384("new_lhs", elmts=[new_lhs]))
        if self.curve_id == BN254_ID:
            circuit.extend_struct_output(u384("c_i", elmts=[c_i]))
        circuit.extend_struct_output(
            u384("f_i_plus_one_of_z", elmts=[f_i_plus_one_of_z])
        )
        return circuit


class Groth16FinalizeBN(BaseGroth16Circuit):
    def __init__(
        self,
        curve_id: int,
        auto_run: bool = True,
        compilation_mode: int = 1,
    ):
        self.max_q_degree = multi_pairing_check.get_max_Q_degree(curve_id, 3)

        super().__init__(
            name="groth16_finalize_bn",
            curve_id=curve_id,
            auto_run=auto_run,
            compilation_mode=compilation_mode,
        )

    @property
    def input_map(self):
        if self.curve_id == BLS12_381_ID:
            return {}
        input_map = {}
        for i in range(self.n_pairs - 1):
            input_map[f"yInv_{i}"] = u384
            input_map[f"xNegOverY_{i}"] = u384
            input_map[f"line_1_{i}"] = G2Line
            input_map[f"line_2_{i}"] = G2Line

        input_map[f"original_Q2"] = G2PointCircuit
        input_map[f"yInv_2"] = u384
        input_map[f"xNegOverY_2"] = u384
        input_map[f"Q_2"] = G2PointCircuit
        input_map.update(
            {
                "R_n_minus_2": E12D,
                "R_n_minus_1": E12D,
                "c_n_minus_3": u384,
                "w_of_z": u384,
                "z": u384,
                "c_inv_frob_1_of_z": u384,
                "c_frob_2_of_z": u384,
                "c_inv_frob_3_of_z": u384,
                "previous_lhs": u384,
                "R_n_minus_3_of_z": u384,
                "Q": (structs.u384Array, self.max_q_degree + 1),
            }
        )
        return input_map

    def _execute_circuit_logic(
        self, circuit: multi_pairing_check.MultiPairingCheckCircuit, vars
    ):
        if self.curve_id == BLS12_381_ID:
            return circuit

        n_pairs = self.n_pairs
        current_points = []
        for k in range(n_pairs):
            circuit.Q.append(split_list_into_pairs(vars.get(f"original_Q{k}", None)))
            circuit.yInv.append(vars[f"yInv_{k}"])
            circuit.xNegOverY.append(vars[f"xNegOverY_{k}"])
            current_points.append(split_list_into_pairs(vars.get(f"Q_{k}", None)))
        print(
            f"FInalize BNcurrent points : {current_points} len : {len(current_points)}"
        )
        circuit.create_powers_of_Z(vars["z"], max_degree=self.max_q_degree)

        c_n_minus_2 = circuit.square(vars["c_n_minus_3"])
        c_n_minus_1 = circuit.square(c_n_minus_2)

        R_n_minus_2_of_z = circuit.eval_poly_in_precomputed_Z(
            vars["R_n_minus_2"], poly_name="R_n_minus_2"
        )
        R_n_minus_1_of_z = circuit.eval_poly_in_precomputed_Z(
            vars["R_n_minus_1"], poly_name="R_n_minus_1"
        )

        # Relation n-2 : f * lines
        prod_k_P_of_z_n_minus_2 = vars["R_n_minus_3_of_z"]  # Init

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
        prod_k_P_of_z_n_minus_1 = circuit.mul(
            R_n_minus_2_of_z, vars["c_inv_frob_1_of_z"]
        )
        prod_k_P_of_z_n_minus_1 = circuit.mul(
            prod_k_P_of_z_n_minus_1, vars["c_frob_2_of_z"]
        )
        prod_k_P_of_z_n_minus_1 = circuit.mul(
            prod_k_P_of_z_n_minus_1, vars["c_inv_frob_3_of_z"]
        )
        prod_k_P_of_z_n_minus_1 = circuit.mul(prod_k_P_of_z_n_minus_1, vars["w_of_z"])

        lhs_n_minus_1 = circuit.mul(
            c_n_minus_1,
            circuit.sub(prod_k_P_of_z_n_minus_1, R_n_minus_1_of_z),
            comment=f"c_n_minus_1 * ((Π(n-1,k) (Pk(z)) - R_n_minus_1(z))",
        )

        _final_lhs = circuit.add(vars["previous_lhs"], lhs_n_minus_2)
        final_lhs = circuit.add(_final_lhs, lhs_n_minus_1)

        Q_of_z = circuit.eval_poly_in_precomputed_Z(vars["Q"], poly_name="big_Q")
        P_irr, P_irr_sparsity = circuit.write_sparse_constant_elements(
            get_irreducible_poly(self.curve_id, 12).get_coeffs(),
        )
        P_of_z = circuit.eval_poly_in_precomputed_Z(
            P_irr, P_irr_sparsity, poly_name="P_irr"
        )
        check = circuit.sub(final_lhs, circuit.mul(Q_of_z, P_of_z))

        circuit.extend_struct_output(u384("final_check", elmts=[check]))
        return circuit


class Groth16FinalizeBLS(BaseGroth16Circuit):
    def __init__(
        self,
        curve_id: int,
        auto_run: bool = True,
        compilation_mode: int = 1,
    ):
        self.max_q_degree = multi_pairing_check.get_max_Q_degree(curve_id, 3)
        super().__init__(
            name="groth16_finalize_bls",
            curve_id=curve_id,
            auto_run=auto_run,
            compilation_mode=compilation_mode,
        )

    @property
    def input_map(self):
        return {
            "R_n_minus_1": E12D,
            "c_n_minus_2": u384,
            "w_of_z": u384,
            "z": u384,
            "c_inv_frob_1_of_z": u384,
            "previous_lhs": u384,
            "R_n_minus_2_of_z": u384,
            "Q": (u384Array, self.max_q_degree + 1),
        }

    def _execute_circuit_logic(self, circuit, vars):
        if self.curve_id == BN254_ID:
            return circuit

        circuit.create_powers_of_Z(vars["z"], max_degree=self.max_q_degree)

        c_n_minus_1 = circuit.square(vars["c_n_minus_2"])
        R_n_minus_1_of_z = circuit.eval_poly_in_precomputed_Z(
            vars["R_n_minus_1"], poly_name="R_n_minus_1"
        )

        # Relation n-1 (last one) : f * w * c_inv_frob_1
        prod_k_P_of_z_n_minus_1 = circuit.mul(
            vars["R_n_minus_2_of_z"], vars["c_inv_frob_1_of_z"]
        )
        prod_k_P_of_z_n_minus_1 = circuit.mul(prod_k_P_of_z_n_minus_1, vars["w_of_z"])

        lhs_n_minus_1 = circuit.mul(
            c_n_minus_1,
            circuit.sub(prod_k_P_of_z_n_minus_1, R_n_minus_1_of_z),
            comment=f"c_n_minus_1 * ((Π(n-1,k) (Pk(z)) - R_n_minus_1(z))",
        )

        final_lhs = circuit.add(
            vars["previous_lhs"], lhs_n_minus_1, comment="previous_lhs + lhs_n_minus_1"
        )
        P_irr, P_irr_sparsity = circuit.write_sparse_constant_elements(
            get_irreducible_poly(self.curve_id, 12).get_coeffs()
        )
        P_of_z = circuit.eval_poly_in_precomputed_Z(
            P_irr, P_irr_sparsity, poly_name="P_irr"
        )
        Q_of_z = circuit.eval_poly_in_precomputed_Z(vars["Q"], poly_name="big_Q")

        check = circuit.sub(
            final_lhs,
            circuit.mul(Q_of_z, P_of_z, comment="Q(z) * P(z)"),
            comment="final_lhs - Q(z) * P(z)",
        )

        circuit.extend_struct_output(u384("final_check", elmts=[check]))
        return circuit
