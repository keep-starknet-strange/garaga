from abc import ABC, abstractmethod
from typing import Dict, List, Optional, Tuple, Type, Union

import garaga.modulo_circuit_structs as structs
from garaga.curves import BLS12_381_ID, BN254_ID, get_irreducible_poly
from garaga.extension_field_modulo_circuit import ExtensionFieldModuloCircuit, PyFelt
from garaga.modulo_circuit import ModuloCircuit
from garaga.modulo_circuit_structs import (
    E12D,
    BLSProcessedPair,
    BNProcessedPair,
    Cairo1SerializableStruct,
    G1PointCircuit,
    G2Line,
    G2PointCircuit,
    MillerLoopResultScalingFactor,
    u384,
    u384Array,
)
from garaga.precompiled_circuits import multi_pairing_check
from garaga.precompiled_circuits.compilable_circuits.base import BaseEXTFCircuit


def split_4_sized_object_into_tuple_of_2_size(
    input: Union[List[PyFelt], Tuple[PyFelt, PyFelt, PyFelt, PyFelt]],
) -> Optional[Tuple[List[PyFelt], List[PyFelt]]]:
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
            split_4_sized_object_into_tuple_of_2_size(vars.get(f"Q_{i}", None))
        )  # Return empty list if not present
        if bit_1:
            q_or_q_neg_points.append(
                split_4_sized_object_into_tuple_of_2_size(
                    vars.get(f"Q_or_Q_neg_{i}", None)
                )  # Return empty list if not present
            )

    return current_points, q_or_q_neg_points


class BaseFixedG2PointsMPCheck(BaseEXTFCircuit, ABC):
    def __init__(
        self,
        name,
        curve_id,
        n_pairs: int,
        n_fixed_g2: int,
        auto_run=True,
        compilation_mode=1,
    ):
        assert compilation_mode == 1, "Compilation mode 1 is required for this circuit"
        if n_pairs and "mp_check_prepare_pairs" not in name:
            assert (
                2 <= n_pairs
            ), f"Multi-pairing check requires at least 2 pairs, got {n_pairs}"

        if n_fixed_g2:
            assert (
                0 <= n_fixed_g2 <= n_pairs
            ), f"Number of fixed G2 points must be between 0 and {n_pairs}, got {n_fixed_g2}"

        self.n_pairs = n_pairs
        self.n_fixed_g2 = n_fixed_g2
        super().__init__(
            name=name,
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
            n_points_precomputed_lines=self.n_fixed_g2,
        )

    @property
    @abstractmethod
    def input_map(
        self,
    ) -> Dict[
        str,
        Union[
            Type[Cairo1SerializableStruct], Tuple[Type[Cairo1SerializableStruct], int]
        ],
    ]:
        """
        Define the input map for the circuit in a dict.
        The key will be the name of the input variable, also used in the signature of the compiled Cairo code.
        The value will be either a Cairo1SerializableStruct type (which defines the struct in the Cairo code),
            or a tuple of the type and its size (for Array-like types).
        The reason behind this is that each Cairo1SerializableStruct defines the __len__ method, but for the
        array-like structs we need to specify the size in advance.
        """

    def _base_input_map(self, bit_type: str) -> dict:
        """
        Base input map for the bit 0, 1, 00, 01, and 10 cases.
        """
        input_map = {}

        # Add pair inputs
        for k in range(self.n_fixed_g2):
            input_map[f"yInv_{k}"] = u384
            input_map[f"xNegOverY_{k}"] = u384
            input_map[f"G2_line_dbl_{k}"] = G2Line
            if bit_type in ("1"):
                input_map[f"G2_line_add_{k}"] = G2Line
            if bit_type == "10":
                input_map[f"G2_line_add_1_{k}"] = G2Line
                input_map[f"G2_line_dbl_0_{k}"] = G2Line
            if bit_type == "01":
                input_map[f"G2_line_dbl_1{k}"] = G2Line
                input_map[f"G2_line_add_1{k}"] = G2Line
            if bit_type == "00":
                input_map[f"G2_line_2nd_0_{k}"] = G2Line

        for k in range(self.n_fixed_g2, self.n_pairs):
            input_map[f"yInv_{k}"] = u384
            input_map[f"xNegOverY_{k}"] = u384
            input_map[f"Q_{k}"] = G2PointCircuit
            if bit_type in ("1", "01", "10"):
                input_map[f"Q_or_Q_neg_{k}"] = G2PointCircuit

        # Add common inputs
        input_map["lhs_i"] = u384
        input_map["f_i_of_z"] = u384
        input_map["f_i_plus_one_of_z"] = u384

        # Add bit-specific inputs
        if bit_type in ("1", "01", "10"):
            input_map["c_or_cinv_of_z"] = u384

        input_map["z"] = u384
        input_map["c1"] = u384

        return input_map

    def _process_input(
        self, circuit: multi_pairing_check.MultiPairingCheckCircuit, input: list[PyFelt]
    ) -> dict:
        """
        Method responsible for deserializing the input list of elements into the variables in the input map,
        and writing them to the circuit.
        The input list is expected to be in the same order as the input map.
        Since we use Python 3.10, the input map dict is ordered.
        Returns a vars dict with the same keys as the input map, but with the values being the instances of the structs,
        each struct holding ModuloCircuitElement(s).
        """
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
        """
        Extends the base method of BaseModuloCircuit, by reading the input map and returning a list of random elements of the total expected size.
        """
        total_elements = 0
        for name, struct_info in self.input_map.items():
            if isinstance(struct_info, tuple):
                # Array-like case
                _, size = struct_info
                total_elements += size
            else:
                # For other structs, create a temporary instance to get its length
                temp_instance = struct_info(name, None)
                total_elements += len(temp_instance)

        return [self.field.random() for _ in range(total_elements)]

    def _run_circuit_inner(self, input: list[PyFelt]) -> ModuloCircuit:
        circuit = self._initialize_circuit()

        vars = self._process_input(circuit, input)
        return self._execute_circuit_logic(circuit, vars)

    @abstractmethod
    def _execute_circuit_logic(self, circuit, vars) -> ModuloCircuit:
        """
        Implement the circuit logic using the processed input variables.
        """

    def _execute_circuit_bit_logic_base(self, circuit: ModuloCircuit, vars, bit_type):
        n_pairs = self.n_pairs
        assert n_pairs >= 2, f"n_pairs must be >= 2, got {n_pairs}"

        current_points, q_or_q_neg_points = parse_precomputed_g1_consts_and_g2_points(
            circuit,
            vars,
            n_pairs,
            bit_1=(bit_type == "1" or bit_type == "01" or bit_type == "10"),
        )

        circuit.create_lines_z_powers(vars["z"])

        sum_i_prod_k_P = circuit.mul(
            vars["f_i_of_z"],
            vars["f_i_of_z"],
            "Square f evaluation in Z, the result of previous bit.",
        )

        new_points, sum_i_prod_k_P = self._process_points(
            circuit, current_points, q_or_q_neg_points, sum_i_prod_k_P, bit_type
        )

        if bit_type in ("1", "01"):
            sum_i_prod_k_P = circuit.mul(sum_i_prod_k_P, vars["c_or_cinv_of_z"])
        elif bit_type == "10":
            sum_i_prod_k_P = circuit.mul(
                sum_i_prod_k_P, circuit.square(vars["c_or_cinv_of_z"])
            )

        f_i_plus_one_of_z = vars["f_i_plus_one_of_z"]

        new_lhs = circuit.sub(
            sum_i_prod_k_P, f_i_plus_one_of_z, "(Π(i,k) (Pk(z))) - Ri(z)"
        )

        lhs_i_plus_one = circuit.add(
            circuit.mul(vars["c1"], vars["lhs_i"]),
            new_lhs,
            "LHS = c1 * LHS + ((Π(i,k) (Pk(z)) - Ri(z))",
        )

        self._extend_output(circuit, new_points, lhs_i_plus_one)

        return circuit

    def _process_points(
        self,
        circuit: multi_pairing_check.MultiPairingCheckCircuit,
        current_points,
        q_or_q_neg_points,
        sum_i_prod_k_P,
        bit_type,
    ):
        new_points = []
        if bit_type == "00":
            for k in range(self.n_pairs):
                T1, line_poly_1 = circuit.double_step(current_points[k], k)
                sum_i_prod_k_P = self._multiply_line_evaluations(
                    circuit, sum_i_prod_k_P, [line_poly_1], k
                )
                new_points.append(T1)

            sum_i_prod_k_P = circuit.mul(
                sum_i_prod_k_P,
                sum_i_prod_k_P,
                "Compute (f^2 * Π(i,k) (line_i,k(z))) ^ 2 = f^4 * (Π(i,k) (line_i,k(z)))^2",
            )

            new_new_points = []
            for k in range(self.n_pairs):
                T, line_poly_2 = circuit.double_step(new_points[k], k)
                sum_i_prod_k_P = self._multiply_line_evaluations(
                    circuit, sum_i_prod_k_P, [line_poly_2], k
                )
                new_new_points.append(T)
            return new_new_points, sum_i_prod_k_P
        elif bit_type == "01":
            for k in range(self.n_pairs):
                T, line_poly_1 = circuit.double_step(current_points[k], k)
                sum_i_prod_k_P = self._multiply_line_evaluations(
                    circuit, sum_i_prod_k_P, [line_poly_1], k
                )
                new_points.append(T)

            sum_i_prod_k_P = circuit.mul(
                sum_i_prod_k_P,
                sum_i_prod_k_P,
                "Compute (f^2 * Π(i,k) (line_i,k(z))) ^ 2 = f^4 * (Π(i,k) (line_i,k(z)))^2",
            )

            new_new_points = []
            for k in range(self.n_pairs):
                T, line_poly_1, line_poly_2 = circuit.double_and_add_step(
                    new_points[k], q_or_q_neg_points[k], k
                )
                sum_i_prod_k_P = self._multiply_line_evaluations(
                    circuit, sum_i_prod_k_P, [line_poly_1, line_poly_2], k
                )
                new_new_points.append(T)

            return new_new_points, sum_i_prod_k_P

        elif bit_type == "10":
            for k in range(self.n_pairs):
                T, line_poly_1, line_poly_2 = circuit.double_and_add_step(
                    current_points[k], q_or_q_neg_points[k], k
                )
                sum_i_prod_k_P = self._multiply_line_evaluations(
                    circuit, sum_i_prod_k_P, [line_poly_1, line_poly_2], k
                )
                new_points.append(T)

            sum_i_prod_k_P = circuit.mul(
                sum_i_prod_k_P,
                sum_i_prod_k_P,
                "Compute (f^2 * Π(i,k) (line_i,k(z))) ^ 2 = f^4 * (Π(i,k) (line_i,k(z)))^2",
            )
            new_new_points = []
            for k in range(self.n_pairs):
                T, line_poly_1 = circuit.double_step(new_points[k], k)
                sum_i_prod_k_P = self._multiply_line_evaluations(
                    circuit, sum_i_prod_k_P, [line_poly_1], k
                )
                new_new_points.append(T)
            return new_new_points, sum_i_prod_k_P
        elif bit_type == "0":
            for k in range(self.n_pairs):
                T, line_poly_1 = circuit.double_step(current_points[k], k)
                sum_i_prod_k_P = self._multiply_line_evaluations(
                    circuit, sum_i_prod_k_P, [line_poly_1], k
                )
                new_points.append(T)
        elif bit_type == "1":
            for k in range(self.n_pairs):
                T, line_poly_1, line_poly_2 = circuit.double_and_add_step(
                    current_points[k], q_or_q_neg_points[k], k
                )
                sum_i_prod_k_P = self._multiply_line_evaluations(
                    circuit, sum_i_prod_k_P, [line_poly_1, line_poly_2], k
                )
                new_points.append(T)

        else:
            raise ValueError(f"Invalid bit type: {bit_type}")
        return new_points, sum_i_prod_k_P

    def _multiply_line_evaluations(
        self,
        circuit: multi_pairing_check.MultiPairingCheckCircuit,
        sum_i_prod_k_P,
        line_polynomials,
        k,
    ):
        for i, line_poly in enumerate(line_polynomials):
            sum_i_prod_k_P = circuit.mul(
                sum_i_prod_k_P,
                circuit.eval_poly_in_precomputed_Z(
                    line_poly, circuit.line_sparsity, f"line_{k}p_{i+1}"
                ),
                f"Mul (f(z)^2 * Π_0_k-1(line_k(z))) * line_i_{k}(z)",
            )
        return sum_i_prod_k_P

    def _extend_output(self, circuit, new_points, lhs_i_plus_one):

        last_points = (
            new_points[-(self.n_pairs - self.n_fixed_g2) :]
            if self.n_pairs != self.n_fixed_g2
            else []
        )
        for i, point in enumerate(last_points):
            circuit.extend_struct_output(
                G2PointCircuit(
                    name=f"Q{i}",
                    elmts=[
                        point[0][0],
                        point[0][1],
                        point[1][0],
                        point[1][1],
                    ],
                )
            )
        circuit.extend_struct_output(
            u384(name="lhs_i_plus_one", elmts=[lhs_i_plus_one])
        )


class FixedG2MPCheckBitBase(BaseFixedG2PointsMPCheck):
    """Base class for bit checking circuits with default parameters."""

    BIT_TYPE = None  # Override in subclasses
    DEFAULT_PAIRS = 3
    DEFAULT_FIXED_G2 = 2

    def __init__(
        self,
        curve_id: int,
        n_pairs: int = None,
        n_fixed_g2: int = None,
        auto_run: bool = True,
        compilation_mode: int = 1,
    ):
        assert compilation_mode == 1, "Compilation mode 1 is required for this circuit"
        n_pairs = n_pairs if n_pairs is not None else self.DEFAULT_PAIRS
        n_fixed_g2 = n_fixed_g2 if n_fixed_g2 is not None else self.DEFAULT_FIXED_G2

        super().__init__(
            name=f"mp_check_bit{self.BIT_TYPE}_{n_pairs}P_{n_fixed_g2}F",
            curve_id=curve_id,
            n_pairs=n_pairs,
            n_fixed_g2=n_fixed_g2,
            auto_run=auto_run,
            compilation_mode=compilation_mode,
        )

    @property
    def input_map(self):
        return self._base_input_map(self.BIT_TYPE)

    def _execute_circuit_logic(self, circuit, vars) -> ModuloCircuit:
        return self._execute_circuit_bit_logic_base(circuit, vars, self.BIT_TYPE)


class FixedG2MPCheckBit0(FixedG2MPCheckBitBase):
    BIT_TYPE = "0"


class FixedG2MPCheckBit00(FixedG2MPCheckBitBase):
    BIT_TYPE = "00"


class FixedG2MPCheckBit1(FixedG2MPCheckBitBase):
    BIT_TYPE = "1"


class FixedG2MPCheckBit01(FixedG2MPCheckBitBase):
    BIT_TYPE = "01"


class FixedG2MPCheckBit10(FixedG2MPCheckBitBase):
    BIT_TYPE = "10"


class FixedG2MPCheckInitBit(BaseFixedG2PointsMPCheck):
    def __init__(
        self,
        curve_id: int,
        auto_run: bool = True,
        compilation_mode: int = 1,
        n_pairs: int = 3,
        n_fixed_g2: int = 2,
    ):
        super().__init__(
            name=f"mp_check_init_bit_{n_pairs}P_{n_fixed_g2}F",
            curve_id=curve_id,
            n_pairs=n_pairs,
            n_fixed_g2=n_fixed_g2,
            auto_run=auto_run,
            compilation_mode=compilation_mode,
        )

    @property
    def input_map(self):
        input_map = {}
        for i in range(self.n_fixed_g2):
            input_map[f"yInv_{i}"] = u384
            input_map[f"xNegOverY_{i}"] = u384
            input_map[f"G2_line_{i}"] = G2Line
            if self.curve_id == BLS12_381_ID:
                input_map[f"G2_line_{i}_2"] = G2Line

        for i in range(self.n_fixed_g2, self.n_pairs):
            input_map[f"yInv_{i}"] = u384
            input_map[f"xNegOverY_{i}"] = u384
            input_map[f"Q_{i}"] = G2PointCircuit

        input_map.update(
            {
                "R_i_of_z": u384,
                "z": u384,
                "c_inv_of_z": u384,
            }
        )
        if self.curve_id == BN254_ID:
            input_map["c1"] = u384
            input_map["previous_lhs"] = u384

        return input_map

    def _execute_circuit_logic(self, circuit, vars) -> ModuloCircuit:
        n_pairs = self.n_pairs
        current_points, _ = parse_precomputed_g1_consts_and_g2_points(
            circuit, vars, n_pairs
        )

        z = vars["z"]
        c_inv_of_z = vars["c_inv_of_z"]
        circuit.create_lines_z_powers(z)

        f_i_plus_one_of_z = vars["R_i_of_z"]

        sum_i_prod_k_P_of_z = circuit.mul(
            c_inv_of_z, c_inv_of_z
        )  # At initialisation, f=1/c so f^2 = 1/c^2
        new_points = []
        if self.curve_id == BN254_ID:
            # c_i = circuit.mul(
            #     c0, c0
            # )  # Second relation for BN at init bit, need to update c_i.
            for k in range(n_pairs):
                T, line_poly_1 = circuit.double_step(current_points[k], k)
                sum_i_prod_k_P_of_z = circuit.mul(
                    sum_i_prod_k_P_of_z,
                    circuit.eval_poly_in_precomputed_Z(
                        line_poly_1, circuit.line_sparsity, f"line_{k}p_1"
                    ),
                )
                new_points.append(T)
        elif self.curve_id == BLS12_381_ID:
            # bit +1:  multiply f^2 by 1/c
            sum_i_prod_k_P_of_z = circuit.mul(c_inv_of_z, sum_i_prod_k_P_of_z)
            for k in range(n_pairs):
                T, line_poly_1, line_poly_2 = circuit.triple_step(current_points[k], k)
                sum_i_prod_k_P_of_z = circuit.mul(
                    sum_i_prod_k_P_of_z,
                    circuit.eval_poly_in_precomputed_Z(
                        line_poly_1, circuit.line_sparsity, f"line_{k}p_1"
                    ),
                )
                sum_i_prod_k_P_of_z = circuit.mul(
                    sum_i_prod_k_P_of_z,
                    circuit.eval_poly_in_precomputed_Z(
                        line_poly_2, circuit.line_sparsity, f"line_{k}p_2"
                    ),
                )
                new_points.append(T)

        new_lhs = circuit.sub(
            sum_i_prod_k_P_of_z, f_i_plus_one_of_z, comment="((Π(i,k) (Pk(z)) - Ri(z))"
        )

        if self.curve_id == BLS12_381_ID:
            pass
        elif self.curve_id == BN254_ID:
            c1 = vars["c1"]
            previous_lhs = vars["previous_lhs"]
            new_lhs = circuit.add(new_lhs, circuit.mul(c1, previous_lhs))

        # OUTPUT
        last_points = (
            new_points[-(self.n_pairs - self.n_fixed_g2) :]
            if self.n_fixed_g2 != self.n_pairs
            else []
        )
        for i, point in enumerate(last_points):
            circuit.extend_struct_output(
                G2PointCircuit(
                    name=f"Q{i}",
                    elmts=[
                        point[0][0],
                        point[0][1],
                        point[1][0],
                        point[1][1],
                    ],
                )
            )
        circuit.extend_struct_output(u384("new_lhs", elmts=[new_lhs]))

        return circuit


class MPCheckFinalizeBN(BaseFixedG2PointsMPCheck):
    def __init__(
        self,
        curve_id: int,
        auto_run: bool = True,
        n_pairs: int = 3,
        n_fixed_g2: int = 2,
        compilation_mode: int = 1,
        extra_miller_loop_result: bool = False,
    ):
        self.max_q_degree = multi_pairing_check.get_max_Q_degree(curve_id, n_pairs)
        self.extra_miller_loop_result: bool = extra_miller_loop_result
        if extra_miller_loop_result:
            name = f"mp_check_finalize_{n_pairs}P_{n_fixed_g2}F_EXT_MLR"
        else:
            name = f"mp_check_finalize_{n_pairs}P_{n_fixed_g2}F"
        super().__init__(
            name=name,
            curve_id=curve_id,
            n_pairs=n_pairs,
            n_fixed_g2=n_fixed_g2,
            auto_run=auto_run,
            compilation_mode=compilation_mode,
        )

    @property
    def input_map(self):
        if self.curve_id == BLS12_381_ID:
            return {}
        input_map = {}
        for i in range(self.n_fixed_g2):
            input_map[f"yInv_{i}"] = u384
            input_map[f"xNegOverY_{i}"] = u384
            input_map[f"line_1_{i}"] = G2Line
            input_map[f"line_2_{i}"] = G2Line

        for i in range(self.n_fixed_g2, self.n_pairs):
            input_map[f"original_Q{i}"] = G2PointCircuit
            input_map[f"yInv_{i}"] = u384
            input_map[f"xNegOverY_{i}"] = u384
            input_map[f"Q_{i}"] = G2PointCircuit

        input_map.update(
            {
                "R_n_minus_2_of_z": u384,
                "R_n_minus_1_of_z": u384,
                "c_0": u384,
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
        if self.extra_miller_loop_result:
            input_map["precomputed_miller_loop_result_of_z"] = u384

        return input_map

    def _execute_circuit_logic(
        self, circuit: multi_pairing_check.MultiPairingCheckCircuit, vars
    ):
        if self.curve_id == BLS12_381_ID:
            return circuit

        n_pairs = self.n_pairs
        current_points = []
        for k in range(n_pairs):
            circuit.Q.append(
                split_4_sized_object_into_tuple_of_2_size(
                    vars.get(f"original_Q{k}", None)
                )
            )
            circuit.yInv.append(vars[f"yInv_{k}"])
            circuit.xNegOverY.append(vars[f"xNegOverY_{k}"])
            current_points.append(
                split_4_sized_object_into_tuple_of_2_size(vars.get(f"Q_{k}", None))
            )

        circuit.create_lines_z_powers(vars["z"], add_extf_power=True)

        c_0 = vars["c_0"]

        R_n_minus_2_of_z = vars["R_n_minus_2_of_z"]
        R_n_minus_1_of_z = vars["R_n_minus_1_of_z"]

        # Relation n-2 : f * line polynomials
        prod_k_P_of_z_n_minus_2 = vars["R_n_minus_3_of_z"]  # Init

        line_polynomials = circuit.bn254_finalize_step(current_points)
        for idx, line_poly in enumerate(line_polynomials):
            prod_k_P_of_z_n_minus_2 = circuit.mul(
                prod_k_P_of_z_n_minus_2,
                circuit.eval_poly_in_precomputed_Z(
                    line_poly, circuit.line_sparsity, f"line_{idx}"
                ),
            )

        lhs_n_minus_2 = circuit.sub(
            prod_k_P_of_z_n_minus_2,
            R_n_minus_2_of_z,
            comment="((Π(n-2,k) (Pk(z)) - R_n_minus_2(z))",
        )

        # Relation n-1 (last one) : f * w * c_inv_frob_1 * c_frob_2 * c_inv_frob_3
        # If groth16 mode : * precomputed_miller_loop_result
        prod_k_P_of_z_n_minus_1 = circuit.product(
            [
                R_n_minus_2_of_z,
                vars["c_inv_frob_1_of_z"],
                vars["c_frob_2_of_z"],
                vars["c_inv_frob_3_of_z"],
                vars["w_of_z"],
            ],
        )

        if self.extra_miller_loop_result:
            prod_k_P_of_z_n_minus_1 = circuit.mul(
                prod_k_P_of_z_n_minus_1, vars["precomputed_miller_loop_result_of_z"]
            )

        lhs_n_minus_1 = circuit.sub(
            prod_k_P_of_z_n_minus_1,
            R_n_minus_1_of_z,
            comment="((Π(n-1,k) (Pk(z)) - R_n_minus_1(z))",
        )

        _final_lhs = circuit.add(circuit.mul(c_0, vars["previous_lhs"]), lhs_n_minus_2)
        final_lhs = circuit.add(circuit.mul(c_0, _final_lhs), lhs_n_minus_1)

        Q_of_z = circuit.eval_horner(vars["Q"], z=vars["z"], poly_name="big_Q")
        P_irr, P_irr_sparsity = circuit.write_sparse_constant_elements(
            get_irreducible_poly(self.curve_id, 12).get_coeffs(),
        )
        P_of_z = circuit.eval_poly_in_precomputed_Z(
            P_irr, P_irr_sparsity, poly_name="P_irr"
        )
        check = circuit.sub(final_lhs, circuit.mul(Q_of_z, P_of_z))

        circuit.extend_struct_output(u384("final_check", elmts=[check]))
        return circuit


class MPCheckFinalizeBLS(BaseFixedG2PointsMPCheck):
    def __init__(
        self,
        curve_id: int,
        auto_run: bool = True,
        compilation_mode: int = 1,
        n_pairs: int = 3,
        extra_miller_loop_result: bool = False,
    ):
        self.max_q_degree = multi_pairing_check.get_max_Q_degree(curve_id, n_pairs)
        self.extra_miller_loop_result: bool = extra_miller_loop_result
        if extra_miller_loop_result:
            name = f"mp_check_finalize_{n_pairs}P_EXT_MLR"
        else:
            name = f"mp_check_finalize_{n_pairs}P"
        super().__init__(
            name=name,
            curve_id=curve_id,
            n_pairs=n_pairs,
            n_fixed_g2=None,
            auto_run=auto_run,
            compilation_mode=compilation_mode,
        )

    @property
    def input_map(self):
        input_map = {
            "R_n_minus_1_of_z": u384,
            "c_1": u384,
            "w_of_z": u384,
            "z": u384,
            "c_inv_frob_1_of_z": u384,
            "previous_lhs": u384,
            "R_n_minus_2": E12D,
            "Q": (u384Array, self.max_q_degree + 1),
        }
        if self.extra_miller_loop_result:
            input_map["precomputed_miller_loop_result_of_z"] = u384
        return input_map

    def _execute_circuit_logic(self, circuit: ModuloCircuit, vars) -> ModuloCircuit:
        if self.curve_id == BN254_ID:
            return circuit

        circuit.create_powers_of_Z(vars["z"], max_degree=12)

        c_1 = vars["c_1"]
        R_n_minus_1_of_z = vars["R_n_minus_1_of_z"]

        # Relation n-1 (last one) : f * w * c_inv_frob_1
        R_n_minus_2 = vars["R_n_minus_2"]
        R_n_minus_2_conjugate = circuit.conjugate_e12d(R_n_minus_2)
        R_n_minus_2_conjugate_of_z = circuit.eval_poly_in_precomputed_Z(
            R_n_minus_2_conjugate, poly_name="R_n_minus_2_conjugate"
        )
        prod_k_P_of_z_n_minus_1 = circuit.product(
            [R_n_minus_2_conjugate_of_z, vars["c_inv_frob_1_of_z"], vars["w_of_z"]]
        )

        if self.extra_miller_loop_result:
            prod_k_P_of_z_n_minus_1 = circuit.mul(
                prod_k_P_of_z_n_minus_1, vars["precomputed_miller_loop_result_of_z"]
            )

        lhs_n_minus_1 = circuit.sub(
            prod_k_P_of_z_n_minus_1,
            R_n_minus_1_of_z,
            comment="(Π(n-1,k) (Pk(z)) - R_n_minus_1(z))",
        )

        final_lhs = circuit.add(
            circuit.mul(c_1, vars["previous_lhs"]),
            lhs_n_minus_1,
            comment="c_1 * previous_lhs + lhs_n_minus_1",
        )
        P_irr, P_irr_sparsity = circuit.write_sparse_constant_elements(
            get_irreducible_poly(self.curve_id, 12).get_coeffs()
        )
        P_of_z = circuit.eval_poly_in_precomputed_Z(
            P_irr, P_irr_sparsity, poly_name="P_irr"
        )
        Q_of_z = circuit.eval_horner(vars["Q"], vars["z"], poly_name="big_Q")

        check = circuit.sub(
            final_lhs,
            circuit.mul(Q_of_z, P_of_z, comment="Q(z) * P(z)"),
            comment="final_lhs - Q(z) * P(z)",
        )

        circuit.extend_struct_output(u384("final_check", elmts=[check]))
        return circuit


class MPCheckPreparePairs(BaseFixedG2PointsMPCheck):
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
            name=f"mp_check_prepare_pairs_{n_pairs}P",
            curve_id=curve_id,
            n_pairs=n_pairs,
            n_fixed_g2=None,
            auto_run=auto_run,
            compilation_mode=compilation_mode,
        )
        self.generic_over_curve = True

    @property
    def input_map(self):
        input_map = {}
        for i in range(self.n_pairs):
            input_map[f"p_{i}"] = G1PointCircuit
            if self.curve_id == BN254_ID:
                input_map[f"Qy0_{i}"] = u384
                input_map[f"Qy1_{i}"] = u384
        return input_map

    def _initialize_circuit(self):
        return multi_pairing_check.MultiMillerLoopCircuit(
            self.name,
            self.curve_id,
            n_pairs=self.n_pairs,
            compilation_mode=self.compilation_mode,
        )

    def _execute_circuit_logic(self, circuit, vars) -> ModuloCircuit:
        n_pairs = self.n_pairs
        for i in range(n_pairs):
            p = vars[f"p_{i}"]
            x, y = p
            yInv = circuit.inv(y)
            xNegOverY = circuit.neg(circuit.mul(x, yInv))

            if self.curve_id == BN254_ID:
                Qy0 = vars[f"Qy0_{i}"]
                Qy1 = vars[f"Qy1_{i}"]
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


class InitializeMPCheck(BaseFixedG2PointsMPCheck):
    def __init__(
        self,
        curve_id: int,
        auto_run: bool = True,
        compilation_mode: int = 1,
        extra_miller_loop_result: bool = False,
    ):
        assert compilation_mode == 1, "Compilation mode 1 is required for this circuit"
        self.extra_miller_loop_result: bool = extra_miller_loop_result
        if extra_miller_loop_result:
            name = "initialize_mpcheck_ext_mlr"
        else:
            name = "initialize_mpcheck"
        super().__init__(
            name=name,
            curve_id=curve_id,
            n_pairs=2,  # Mocked value, not used in practice.
            n_fixed_g2=None,
            auto_run=auto_run,
            compilation_mode=compilation_mode,
        )

    @property
    def input_map(self):
        input_map = {
            "lambda_root" if self.curve_id == BN254_ID else "lambda_root_inverse": E12D,
            "z": u384,
            "scaling_factor": MillerLoopResultScalingFactor,
        }
        if self.curve_id == BN254_ID:
            input_map.update(
                {
                    "c_inv": E12D,
                }
            )
        if self.extra_miller_loop_result:
            input_map["precomputed_miller_loop_result"] = E12D
        return input_map

    def _execute_circuit_logic(
        self, circuit: multi_pairing_check.MultiPairingCheckCircuit, vars
    ):
        circuit.create_powers_of_Z(Z=vars["z"], max_degree=11)

        if self.curve_id == BLS12_381_ID:
            self._execute_bls12_381_logic(circuit, vars)
        elif self.curve_id == BN254_ID:
            self._execute_bn254_logic(circuit, vars)

        # Handle shared scaling factor computation (always executed after curve-specific c/c_inv logic)
        self._execute_shared_logic(circuit, vars)

        # Continue with curve-specific frobenius operations
        if self.curve_id == BLS12_381_ID:
            self._execute_bls12_381_frobenius_logic(circuit, vars)
        elif self.curve_id == BN254_ID:
            self._execute_bn254_frobenius_logic(circuit, vars)

        if self.extra_miller_loop_result:
            precomputed_miller_loop_result = vars["precomputed_miller_loop_result"]
            precomputed_miller_loop_result_of_z = circuit.eval_poly_in_precomputed_Z(
                precomputed_miller_loop_result,
                poly_name="precomputed_miller_loop_result",
            )
            circuit.extend_struct_output(
                u384(
                    "precomputed_miller_loop_result_of_z",
                    elmts=[precomputed_miller_loop_result_of_z],
                )
            )

        return circuit

    def _execute_bls12_381_logic(
        self, circuit: multi_pairing_check.MultiPairingCheckCircuit, vars
    ):
        """Handle BLS12-381 specific logic with c_inverse - first part."""
        # Get lambda_root_inverse (c_inverse for BLS12-381)
        lambda_root_inverse = vars["lambda_root_inverse"]

        # Conjugate c_inverse for BLS12-381
        self.c_inv = circuit.conjugate_e12d(lambda_root_inverse)

        # Evaluate c_inverse polynomial at z
        c_inv_of_z = circuit.eval_poly_in_precomputed_Z(self.c_inv, poly_name="C_inv")

        circuit.extend_struct_output(u384(name="c_inv_of_z", elmts=[c_inv_of_z]))

    def _execute_bn254_logic(
        self, circuit: multi_pairing_check.MultiPairingCheckCircuit, vars
    ):
        """Handle BN254 specific logic with c (lambda_root) - first part."""
        # Get lambda_root (c for BN254)
        lambda_root = vars["lambda_root"]
        self.c = lambda_root

        # Evaluate c polynomial at z
        self.c_of_z = circuit.eval_poly_in_precomputed_Z(self.c, poly_name="C")

        circuit.extend_struct_output(u384(name="c_of_z", elmts=[self.c_of_z]))

    def _execute_shared_logic(
        self, circuit: multi_pairing_check.MultiPairingCheckCircuit, vars
    ):
        """Handle shared scaling factor computation for both curves."""
        scaling_factor_sparsity = [1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0]
        scaling_factor_compressed = vars["scaling_factor"]
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

    def _execute_bls12_381_frobenius_logic(
        self, circuit: multi_pairing_check.MultiPairingCheckCircuit, vars
    ):
        """Handle BLS12-381 specific frobenius logic - second part."""
        # Compute frobenius of c_inverse
        c_inv_frob_1 = circuit.frobenius(self.c_inv, 1)
        c_inv_frob_1_conjugate = circuit.conjugate_e12d(c_inv_frob_1)
        c_inv_frob_1_conjugate_of_z = circuit.eval_poly_in_precomputed_Z(
            c_inv_frob_1_conjugate, poly_name="C_inv_frob_1"
        )
        circuit.extend_struct_output(
            u384("c_inv_frob_1_conjugate_of_z", elmts=[c_inv_frob_1_conjugate_of_z])
        )

    def _execute_bn254_frobenius_logic(
        self, circuit: multi_pairing_check.MultiPairingCheckCircuit, vars
    ):
        """Handle BN254 specific frobenius logic - second part."""
        # Additional BN254-specific variables
        c_inv = vars["c_inv"]

        # Evaluate c_inverse polynomial at z
        c_inv_of_z = circuit.eval_poly_in_precomputed_Z(c_inv, poly_name="C_inv")
        circuit.extend_struct_output(u384(name="c_inv_of_z", elmts=[c_inv_of_z]))

        # Compute lhs = c^0 * (c_of_z * c_inv_of_z - 1) (c^0=1)
        lhs = circuit.sub(
            circuit.mul(self.c_of_z, c_inv_of_z),
            circuit.set_or_get_constant(1),
            comment="c_of_z * c_inv_of_z - 1",
        )
        circuit.extend_struct_output(u384("lhs", elmts=[lhs]))

        # Compute frobenius operations for BN254
        c_inv_frob_1 = circuit.frobenius(c_inv, 1)
        c_frob_2 = circuit.frobenius(self.c, 2)
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


class FP12MulAssertOne(BaseEXTFCircuit):
    def __init__(
        self,
        curve_id: int,
        auto_run: bool = True,
        init_hash: int = None,
        compilation_mode: int = 0,
    ):
        super().__init__(
            "fp12_mul_assert_one", curve_id, auto_run, init_hash, compilation_mode
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


class EvalE12D(BaseEXTFCircuit):
    def __init__(
        self,
        curve_id: int,
        auto_run: bool = True,
        init_hash: int = None,
        compilation_mode: int = 0,
    ):
        super().__init__("eval_e12d", curve_id, auto_run, init_hash, compilation_mode)

    def build_input(self) -> list[PyFelt]:
        input = []
        input.extend([self.field.random() for _ in range(12)])  # X
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
        X = circuit.write_struct(E12D("f", elmts=[input.pop(0) for _ in range(12)]))
        z = circuit.write_struct(u384("z", elmts=[input.pop(0)]))
        X_of_z = circuit.eval_horner(X, z, poly_name="X")
        circuit.extend_struct_output(u384("f_of_z", elmts=[X_of_z]))
        return circuit
