from abc import ABC, abstractmethod
from typing import Dict, List, Optional, Tuple, Type, Union

import garaga.modulo_circuit_structs as structs
from garaga.definitions import BLS12_381_ID
from garaga.modulo_circuit import ModuloCircuit, PyFelt
from garaga.modulo_circuit_structs import (
    Cairo1SerializableStruct,
    G2Line,
    G2PointCircuit,
    u384,
    u384Array,
)
from garaga.precompiled_circuits.compilable_circuits.base import (
    BaseEXTFCircuit,
    BaseModuloCircuit,
)
from garaga.precompiled_circuits.miller_tower import MillerTowerCircuit


def split_4_sized_object_into_tuple_of_2_size(
    input: Union[List[PyFelt], Tuple[PyFelt, PyFelt, PyFelt, PyFelt]]
) -> Optional[Tuple[List[PyFelt], List[PyFelt]]]:
    if input is None:
        return None
    assert len(input) == 4, f"Expected input of length 4, got {len(input)}"
    return (list(input[0:2]), list(input[2:4]))


def parse_precomputed_g1_consts_and_g2_points(
    circuit: MillerTowerCircuit,
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


class BaseTowerMillerLoop(BaseEXTFCircuit, ABC):
    def __init__(
        self,
        name,
        curve_id,
        auto_run=True,
        compilation_mode=1,
        n_pairs: int = 1,
    ):
        assert compilation_mode == 1, "Compilation mode 1 is required for this circuit"
        self.n_pairs = n_pairs
        super().__init__(
            name=name,
            curve_id=curve_id,
            auto_run=auto_run,
            compilation_mode=compilation_mode,
        )
        self.generic_over_curve = True

    def _initialize_circuit(self):
        return MillerTowerCircuit(
            self.name,
            self.curve_id,
            n_pairs=self.n_pairs,
            compilation_mode=self.compilation_mode,
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
        Base input map for the bit 0 and 1
        """
        input_map = {}

        for k in range(self.n_pairs):
            input_map[f"yInv_{k}"] = u384
            input_map[f"xNegOverY_{k}"] = u384
            input_map[f"Q_{k}"] = G2PointCircuit
            if bit_type == "1":
                input_map[f"Q_or_Q_neg_{k}"] = G2PointCircuit

        # Add common inputs
        input_map["M_i"] = structs.E12T

        return input_map

    def _process_input(self, circuit: MillerTowerCircuit, input: list[PyFelt]) -> dict:
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

    def _execute_circuit_bit_logic_base(
        self, circuit: MillerTowerCircuit, vars, bit_type
    ):
        n_pairs = self.n_pairs
        assert n_pairs >= 1, f"n_pairs must be >= 1, got {n_pairs}"

        current_points, q_or_q_neg_points = parse_precomputed_g1_consts_and_g2_points(
            circuit, vars, n_pairs, bit_1=(bit_type == "1")
        )

        Mi_sq = circuit.fp12_square(vars["M_i"])

        new_points, Mi_plus_one = self._process_points(
            circuit, current_points, q_or_q_neg_points, Mi_sq, bit_type
        )

        self._extend_output(circuit, new_points, Mi_plus_one)

        return circuit

    def _process_points(
        self,
        circuit: MillerTowerCircuit,
        current_points,
        q_or_q_neg_points,
        sum_i_prod_k_P,
        bit_type,
    ):
        new_points = []
        if bit_type == "0":
            for k in range(self.n_pairs):
                T, (lineR0, lineR1) = circuit._double(current_points[k], k)
                line = circuit.eval_tower_line(
                    lineR0 + lineR1, circuit.yInv[k], circuit.xNegOverY[k]
                )
                sum_i_prod_k_P = self._multiply_line_evaluations(
                    circuit, sum_i_prod_k_P, [line], k
                )
                new_points.append(T)
        elif bit_type == "1":
            for k in range(self.n_pairs):
                # T, l1, l2 = circuit.double_and_add_step(
                #     current_points[k], q_or_q_neg_points[k], k
                # )
                T, (line1R0, line1R1), (line2R0, line2R1) = circuit._double_and_add(
                    current_points[k], q_or_q_neg_points[k], k
                )
                line1 = circuit.eval_tower_line(
                    line1R0 + line1R1, circuit.yInv[k], circuit.xNegOverY[k]
                )
                line2 = circuit.eval_tower_line(
                    line2R0 + line2R1, circuit.yInv[k], circuit.xNegOverY[k]
                )
                sum_i_prod_k_P = self._multiply_line_evaluations(
                    circuit, sum_i_prod_k_P, [line1, line2], k
                )
                new_points.append(T)

        return new_points, sum_i_prod_k_P

    def _multiply_line_evaluations(
        self,
        circuit: MillerTowerCircuit,
        sum_i_prod_k_P,
        lines,
        k,
    ):
        for i, l in enumerate(lines):
            sum_i_prod_k_P = circuit.mul_by_line_tower(sum_i_prod_k_P, l)
        return sum_i_prod_k_P

    def _extend_output(self, circuit: ModuloCircuit, new_points, Mi_plus_one):
        circuit.exact_output_refs_needed = []
        for i, point in enumerate(new_points):
            sum_coords = circuit.sum(
                [point[0][0], point[0][1], point[1][0], point[1][1]]
            )
            circuit.exact_output_refs_needed.append(sum_coords)

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
            structs.E12T(name="Mi_plus_one", elmts=Mi_plus_one)
        )
        circuit.exact_output_refs_needed.extend(Mi_plus_one)


class TowerMillerBit0(BaseTowerMillerLoop):
    def __init__(
        self,
        curve_id: int,
        n_pairs: int,
        auto_run: bool = True,
        compilation_mode: int = 1,
    ):
        super().__init__(
            name=f"tower_miller_bit0_{n_pairs}P",
            curve_id=curve_id,
            n_pairs=n_pairs,
            auto_run=auto_run,
            compilation_mode=compilation_mode,
        )

    @property
    def input_map(self):
        return self._base_input_map("0")

    def _execute_circuit_logic(self, circuit, vars) -> ModuloCircuit:
        return self._execute_circuit_bit_logic_base(circuit, vars, "0")


class TowerMillerBit1(BaseTowerMillerLoop):
    def __init__(
        self,
        curve_id: int,
        auto_run: bool = True,
        n_pairs: int = 1,
        compilation_mode: int = 1,
    ):
        assert compilation_mode == 1, "Compilation mode 1 is required for this circuit"
        super().__init__(
            name=f"tower_miller_bit1_{n_pairs}P",
            curve_id=curve_id,
            n_pairs=n_pairs,
            auto_run=auto_run,
            compilation_mode=compilation_mode,
        )

    @property
    def input_map(self):
        return self._base_input_map("1")

    def _execute_circuit_logic(self, circuit, vars) -> ModuloCircuit:
        return self._execute_circuit_bit_logic_base(circuit, vars, "1")


class TowerMillerInitBit(BaseTowerMillerLoop):
    def __init__(
        self,
        curve_id: int,
        auto_run: bool = True,
        compilation_mode: int = 1,
        n_pairs: int = 3,
    ):
        super().__init__(
            name=f"tower_miller_init_bit_{n_pairs}P",
            curve_id=curve_id,
            n_pairs=n_pairs,
            auto_run=auto_run,
            compilation_mode=compilation_mode,
        )

    @property
    def input_map(self):
        if self.curve_id == BLS12_381_ID:
            input_map = {}
            for k in range(self.n_pairs):
                input_map[f"yInv_{k}"] = u384
                input_map[f"xNegOverY_{k}"] = u384
                input_map[f"Q_{k}"] = G2PointCircuit
            return input_map
        else:
            raise NotImplementedError(f"Curve {self.curve_id} not implemented")

    def _execute_circuit_logic(
        self, circuit: MillerTowerCircuit, vars
    ) -> ModuloCircuit:
        n_pairs = self.n_pairs
        assert n_pairs == 1, f"Only implemented for 1 pair for now, got {n_pairs}"

        current_points, q_or_q_neg_points = parse_precomputed_g1_consts_and_g2_points(
            circuit, vars, n_pairs, bit_1=False
        )

        new_points = []
        for k in range(self.n_pairs):
            T, (line1R0, line1R1), (line2R0, line2R1) = circuit._triple(
                current_points[k], k
            )

            line1 = circuit.eval_tower_line(
                line1R0 + line1R1, circuit.yInv[k], circuit.xNegOverY[k]
            )
            line2 = circuit.eval_tower_line(
                line2R0 + line2R1, circuit.yInv[k], circuit.xNegOverY[k]
            )
            # result.C0.B0 = prodLines[0]
            # 		result.C0.B1 = prodLines[1]
            # 		result.C0.B2 = prodLines[2]
            # 		result.C1.B1 = prodLines[3]
            # 		result.C1.B2 = prodLines[4]
            ll = circuit.mul_line_by_line_tower(line1, line2)

            new_points.append(T)

        for i, point in enumerate(new_points):
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

        circuit.extend_struct_output(structs.u384(name="c0b0a0", elmts=[ll[0]]))
        circuit.extend_struct_output(structs.u384(name="c0b0a1", elmts=[ll[1]]))
        circuit.extend_struct_output(structs.u384(name="c0b1a0", elmts=[ll[2]]))
        circuit.extend_struct_output(structs.u384(name="c0b1a1", elmts=[ll[3]]))
        circuit.extend_struct_output(structs.u384(name="c0b2a0", elmts=[ll[4]]))
        circuit.extend_struct_output(structs.u384(name="c0b2a1", elmts=[ll[5]]))
        circuit.extend_struct_output(structs.u384(name="c1b1a0", elmts=[ll[6]]))
        circuit.extend_struct_output(structs.u384(name="c1b1a1", elmts=[ll[7]]))
        circuit.extend_struct_output(structs.u384(name="c1b2a0", elmts=[ll[8]]))
        circuit.extend_struct_output(structs.u384(name="c1b2a1", elmts=[ll[9]]))

        return circuit


class TowerMillerFinalizeBN(BaseTowerMillerLoop):
    def __init__(
        self,
        curve_id: int,
        auto_run: bool = True,
        n_pairs: int = 1,
        compilation_mode: int = 1,
    ):

        super().__init__(
            name=f"tower_miller_finalize_bn_{n_pairs}P",
            curve_id=curve_id,
            n_pairs=n_pairs,
            auto_run=auto_run,
            compilation_mode=compilation_mode,
        )

    @property
    def input_map(self):
        if self.curve_id == BLS12_381_ID:
            return {}
        input_map = {}

        for i in range(self.n_pairs):
            input_map[f"original_Q{i}"] = G2PointCircuit
            input_map[f"yInv_{i}"] = u384
            input_map[f"xNegOverY_{i}"] = u384
            input_map[f"Q_{i}"] = G2PointCircuit

        input_map["Mi"] = structs.E12T

        return input_map

    def _execute_circuit_logic(self, circuit: MillerTowerCircuit, vars):
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

        Mi = vars["Mi"]

        lines = circuit._bn254_finalize_step(current_points)

        for l in lines:
            ((l1r0, l1r1), (l2r0, l2r1)) = l

            l1_eval = circuit.eval_tower_line(
                l1r0 + l1r1, circuit.yInv[k], circuit.xNegOverY[k]
            )
            l2_eval = circuit.eval_tower_line(
                l2r0 + l2r1, circuit.yInv[k], circuit.xNegOverY[k]
            )

            ll = circuit.mul_line_by_line_tower(l1_eval, l2_eval)

            ll_full = ll + [
                circuit.set_or_get_constant(0),
                circuit.set_or_get_constant(0),
            ]

            Mi = circuit.fp12_mul(Mi, ll_full)

        circuit.extend_struct_output(structs.E12T("Mi", elmts=Mi))
        return circuit


class E12TMulCircuit(BaseEXTFCircuit):
    def __init__(
        self,
        curve_id: int,
        auto_run: bool = True,
        init_hash: int = None,
        compilation_mode: int = 0,
    ):
        super().__init__("e12t_mul", curve_id, auto_run, init_hash, compilation_mode)

    def build_input(self) -> list[PyFelt]:
        input = []
        input.extend([self.field.random() for _ in range(12)])  # X
        input.extend([self.field.random() for _ in range(12)])  # Y

        return input

    def _run_circuit_inner(self, input: list[PyFelt]) -> MillerTowerCircuit:
        circuit = MillerTowerCircuit(self.name, self.curve_id, n_pairs=None)
        X = circuit.write_struct(
            structs.E12T("X", elmts=[input.pop(0) for _ in range(12)])
        )
        Y = circuit.write_struct(
            structs.E12T("Y", elmts=[input.pop(0) for _ in range(12)])
        )
        res = circuit.fp12_mul(X, Y)
        circuit.extend_struct_output(structs.E12T("res", elmts=res))

        return circuit


class FP6NegCircuit(BaseModuloCircuit):
    def __init__(
        self,
        curve_id: int,
        auto_run: bool = True,
        compilation_mode: int = 1,
    ):
        super().__init__("fp6_neg", curve_id, auto_run, compilation_mode)

    def build_input(self) -> list[PyFelt]:
        input = []
        input.extend([self.field.random() for _ in range(6)])

        return input

    def _run_circuit_inner(self, input: list[PyFelt]) -> ModuloCircuit:
        circuit = ModuloCircuit(
            self.name,
            self.curve_id,
            generic_circuit=True,
            compilation_mode=self.compilation_mode,
        )

        fp6 = [
            circuit.write_struct(structs.u384(name="b0a0", elmts=[input.pop(0)])),
            circuit.write_struct(structs.u384(name="b0a1", elmts=[input.pop(0)])),
            circuit.write_struct(structs.u384(name="b1a0", elmts=[input.pop(0)])),
            circuit.write_struct(structs.u384(name="b1a1", elmts=[input.pop(0)])),
            circuit.write_struct(structs.u384(name="b2a0", elmts=[input.pop(0)])),
            circuit.write_struct(structs.u384(name="b2a1", elmts=[input.pop(0)])),
        ]

        res = [circuit.neg(fp6[i]) for i in range(6)]

        circuit.extend_struct_output(structs.u384(name="r0", elmts=[res[0]]))
        circuit.extend_struct_output(structs.u384(name="r1", elmts=[res[1]]))
        circuit.extend_struct_output(structs.u384(name="r2", elmts=[res[2]]))
        circuit.extend_struct_output(structs.u384(name="r3", elmts=[res[3]]))
        circuit.extend_struct_output(structs.u384(name="r4", elmts=[res[4]]))
        circuit.extend_struct_output(structs.u384(name="r5", elmts=[res[5]]))

        return circuit


class E12TInverseCircuit(BaseEXTFCircuit):
    def __init__(
        self,
        curve_id: int,
        auto_run: bool = True,
        init_hash: int = None,
        compilation_mode: int = 0,
    ):
        super().__init__(
            "e12t_inverse", curve_id, auto_run, init_hash, compilation_mode
        )

    def build_input(self) -> list[PyFelt]:
        input = []
        input.extend([self.field.random() for _ in range(12)])  # M

        return input

    def _run_circuit_inner(self, input: list[PyFelt]) -> ModuloCircuit:
        circuit = MillerTowerCircuit(self.name, self.curve_id, n_pairs=None)
        M = circuit.write_struct(
            structs.E12T("M", elmts=[input.pop(0) for _ in range(12)])
        )
        res = circuit.fp12_inverse(M)
        circuit.extend_struct_output(structs.E12T("res", elmts=res))

        return circuit


class E12TFrobeniusCircuit(BaseEXTFCircuit):
    def __init__(
        self,
        curve_id: int,
        auto_run: bool = True,
        init_hash: int = None,
        compilation_mode: int = 1,
    ):
        super().__init__(
            "e12t_frobenius", curve_id, auto_run, init_hash, compilation_mode
        )

    def build_input(self) -> list[PyFelt]:
        input = []
        input.extend([self.field.random() for _ in range(12)])  # M

        return input

    def _run_circuit_inner(self, input: list[PyFelt]) -> ModuloCircuit:
        circuit = MillerTowerCircuit(self.name, self.curve_id, n_pairs=None)
        M = circuit.write_struct(
            structs.E12T("M", elmts=[input.pop(0) for _ in range(12)])
        )
        res = circuit.fp12_frob(M)
        circuit.extend_struct_output(structs.E12T("res", elmts=res))

        return circuit


class E12TFrobeniusSquareCircuit(BaseEXTFCircuit):
    def __init__(
        self,
        curve_id: int,
        auto_run: bool = True,
        init_hash: int = None,
        compilation_mode: int = 0,
    ):
        super().__init__(
            "e12t_frobenius_square", curve_id, auto_run, init_hash, compilation_mode
        )

    def build_input(self) -> list[PyFelt]:
        input = []
        input.extend([self.field.random() for _ in range(12)])  # M

        return input

    def _run_circuit_inner(self, input: list[PyFelt]) -> ModuloCircuit:
        circuit = MillerTowerCircuit(self.name, self.curve_id, n_pairs=None)
        M = circuit.write_struct(
            structs.E12T("M", elmts=[input.pop(0) for _ in range(12)])
        )
        res = circuit.fp12_frob_square(M)
        circuit.extend_struct_output(structs.E12T("res", elmts=res))

        return circuit


class E12TFrobeniusCubeCircuit(BaseEXTFCircuit):
    def __init__(
        self,
        curve_id: int,
        auto_run: bool = True,
        init_hash: int = None,
        compilation_mode: int = 0,
    ):
        super().__init__(
            "e12t_frobenius_cube", curve_id, auto_run, init_hash, compilation_mode
        )

    def build_input(self) -> list[PyFelt]:
        input = []
        input.extend([self.field.random() for _ in range(12)])  # M

        return input

    def _run_circuit_inner(self, input: list[PyFelt]) -> ModuloCircuit:
        circuit = MillerTowerCircuit(self.name, self.curve_id, n_pairs=None)
        M = circuit.write_struct(
            structs.E12T("M", elmts=[input.pop(0) for _ in range(12)])
        )
        res = circuit.fp12_frob_cube(M)
        circuit.extend_struct_output(structs.E12T("res", elmts=res))

        return circuit


class E12TCyclotomicSquareCircuit(BaseEXTFCircuit):
    def __init__(
        self,
        curve_id: int,
        auto_run: bool = True,
        init_hash: int = None,
        compilation_mode: int = 0,
    ):
        super().__init__(
            "e12t_cyclotomic_square", curve_id, auto_run, init_hash, compilation_mode
        )

    def build_input(self) -> list[PyFelt]:
        input = []
        input.extend([self.field.random() for _ in range(12)])  # M

        return input

    def _run_circuit_inner(self, input: list[PyFelt]) -> ModuloCircuit:
        circuit = MillerTowerCircuit(self.name, self.curve_id, n_pairs=None)
        M = circuit.write_struct(
            structs.E12T("M", elmts=[input.pop(0) for _ in range(12)])
        )
        res = circuit.fp12_cyclotomic_square(M)
        circuit.extend_struct_output(structs.E12T("res", elmts=res))

        return circuit


class E12TCyclotomicSquareCompressedCircuit(BaseEXTFCircuit):
    def __init__(
        self,
        curve_id: int,
        auto_run: bool = True,
        init_hash: int = None,
        compilation_mode: int = 0,
    ):
        super().__init__(
            "e12t_cyclo_square_compressed",
            curve_id,
            auto_run,
            init_hash,
            compilation_mode,
        )

    def build_input(self) -> list[PyFelt]:
        input = []
        input.extend([self.field.random() for _ in range(8)])

        return input

    def _run_circuit_inner(self, input: list[PyFelt]) -> ModuloCircuit:
        circuit = MillerTowerCircuit(self.name, self.curve_id, n_pairs=None)
        xc0b1a0 = circuit.write_struct(
            structs.u384(name="xc0b1a0", elmts=[input.pop(0)])
        )
        xc0b1a1 = circuit.write_struct(
            structs.u384(name="xc0b1a1", elmts=[input.pop(0)])
        )
        xc0b2a0 = circuit.write_struct(
            structs.u384(name="xc0b2a0", elmts=[input.pop(0)])
        )
        xc0b2a1 = circuit.write_struct(
            structs.u384(name="xc0b2a1", elmts=[input.pop(0)])
        )
        xc1b0a0 = circuit.write_struct(
            structs.u384(name="xc1b0a0", elmts=[input.pop(0)])
        )
        xc1b0a1 = circuit.write_struct(
            structs.u384(name="xc1b0a1", elmts=[input.pop(0)])
        )
        xc1b2a0 = circuit.write_struct(
            structs.u384(name="xc1b2a0", elmts=[input.pop(0)])
        )
        xc1b2a1 = circuit.write_struct(
            structs.u384(name="xc1b2a1", elmts=[input.pop(0)])
        )
        res = circuit.fp12_cyclotomic_square_compressed(
            [xc0b1a0, xc0b1a1],
            [xc0b2a0, xc0b2a1],
            [xc1b0a0, xc1b0a1],
            [xc1b2a0, xc1b2a1],
        )
        assert len(res) == 8
        circuit.extend_struct_output(structs.u384(name="xc0b1a0", elmts=[res[0]]))
        circuit.extend_struct_output(structs.u384(name="xc0b1a1", elmts=[res[1]]))
        circuit.extend_struct_output(structs.u384(name="xc0b2a0", elmts=[res[2]]))
        circuit.extend_struct_output(structs.u384(name="xc0b2a1", elmts=[res[3]]))
        circuit.extend_struct_output(structs.u384(name="xc1b0a0", elmts=[res[4]]))
        circuit.extend_struct_output(structs.u384(name="xc1b0a1", elmts=[res[5]]))
        circuit.extend_struct_output(structs.u384(name="xc1b2a0", elmts=[res[6]]))
        circuit.extend_struct_output(structs.u384(name="xc1b2a1", elmts=[res[7]]))

        return circuit


class E12TDecompressKarabinaPtIZCircuit(BaseEXTFCircuit):
    def __init__(
        self,
        curve_id: int,
        auto_run: bool = True,
        init_hash: int = None,
        compilation_mode: int = 0,
    ):
        super().__init__(
            "e12t_decomp_karabina_I_Z", curve_id, auto_run, init_hash, compilation_mode
        )

    def build_input(self) -> list[PyFelt]:
        input = []
        input.extend([self.field.random() for _ in range(4)])

        return input

    def _run_circuit_inner(self, input: list[PyFelt]) -> ModuloCircuit:
        circuit = MillerTowerCircuit(self.name, self.curve_id, n_pairs=None)
        xc0b1a0 = circuit.write_struct(
            structs.u384(name="xc0b1a0", elmts=[input.pop(0)])
        )
        xc0b1a1 = circuit.write_struct(
            structs.u384(name="xc0b1a1", elmts=[input.pop(0)])
        )
        xc1b2a0 = circuit.write_struct(
            structs.u384(name="xc1b2a0", elmts=[input.pop(0)])
        )
        xc1b2a1 = circuit.write_struct(
            structs.u384(name="xc1b2a1", elmts=[input.pop(0)])
        )
        res = circuit.fp12_decompress_karabina_pt_I_c1b2_Z(
            [xc0b1a0, xc0b1a1], [xc1b2a0, xc1b2a1]
        )
        circuit.extend_struct_output(structs.u384(name="res0", elmts=[res[0]]))
        circuit.extend_struct_output(structs.u384(name="res1", elmts=[res[1]]))

        return circuit


class E12TDecompressKarabinaPtINZCircuit(BaseEXTFCircuit):
    def __init__(
        self,
        curve_id: int,
        auto_run: bool = True,
        init_hash: int = None,
        compilation_mode: int = 0,
    ):
        super().__init__(
            "e12t_decomp_karabina_I_NZ", curve_id, auto_run, init_hash, compilation_mode
        )

    def build_input(self) -> list[PyFelt]:
        input = []
        input.extend([self.field.random() for _ in range(8)])

        return input

    def _run_circuit_inner(self, input: list[PyFelt]) -> ModuloCircuit:
        circuit = MillerTowerCircuit(self.name, self.curve_id, n_pairs=None)
        xc0b1a0 = circuit.write_struct(
            structs.u384(name="xc0b1a0", elmts=[input.pop(0)])
        )
        xc0b1a1 = circuit.write_struct(
            structs.u384(name="xc0b1a1", elmts=[input.pop(0)])
        )
        xc0b2a0 = circuit.write_struct(
            structs.u384(name="xc0b2a0", elmts=[input.pop(0)])
        )
        xc0b2a1 = circuit.write_struct(
            structs.u384(name="xc0b2a1", elmts=[input.pop(0)])
        )
        xc1b0a0 = circuit.write_struct(
            structs.u384(name="xc1b0a0", elmts=[input.pop(0)])
        )
        xc1b0a1 = circuit.write_struct(
            structs.u384(name="xc1b0a1", elmts=[input.pop(0)])
        )
        xc1b2a0 = circuit.write_struct(
            structs.u384(name="xc1b2a0", elmts=[input.pop(0)])
        )
        xc1b2a1 = circuit.write_struct(
            structs.u384(name="xc1b2a1", elmts=[input.pop(0)])
        )

        t0, t1 = circuit.fp12_decompress_karabina_pt_I_c1b2_NZ(
            [xc0b1a0, xc0b1a1],
            [xc0b2a0, xc0b2a1],
            [xc1b0a0, xc1b0a1],
            [xc1b2a0, xc1b2a1],
        )
        circuit.extend_struct_output(structs.u384(name="t0a0", elmts=[t0[0]]))
        circuit.extend_struct_output(structs.u384(name="t0a1", elmts=[t0[1]]))
        circuit.extend_struct_output(structs.u384(name="t1a0", elmts=[t1[0]]))
        circuit.extend_struct_output(structs.u384(name="t1a1", elmts=[t1[1]]))

        return circuit


class E12TDecompressKarabinaPtIICircuit(BaseEXTFCircuit):
    def __init__(
        self,
        curve_id: int,
        auto_run: bool = True,
        init_hash: int = None,
        compilation_mode: int = 0,
    ):
        super().__init__(
            "e12t_decomp_karabina_II", curve_id, auto_run, init_hash, compilation_mode
        )

    def build_input(self) -> list[PyFelt]:
        input = []
        input.extend([self.field.random() for _ in range(12)])

        return input

    def _run_circuit_inner(self, input: list[PyFelt]) -> ModuloCircuit:
        circuit = MillerTowerCircuit(self.name, self.curve_id, n_pairs=None)
        t0a0 = circuit.write_struct(structs.u384(name="t0a0", elmts=[input.pop(0)]))
        t0a1 = circuit.write_struct(structs.u384(name="t0a1", elmts=[input.pop(0)]))
        t1a0 = circuit.write_struct(structs.u384(name="t1a0", elmts=[input.pop(0)]))
        t1a1 = circuit.write_struct(structs.u384(name="t1a1", elmts=[input.pop(0)]))
        xc0b1a0 = circuit.write_struct(
            structs.u384(name="xc0b1a0", elmts=[input.pop(0)])
        )
        xc0b1a1 = circuit.write_struct(
            structs.u384(name="xc0b1a1", elmts=[input.pop(0)])
        )
        xc0b2a0 = circuit.write_struct(
            structs.u384(name="xc0b2a0", elmts=[input.pop(0)])
        )
        xc0b2a1 = circuit.write_struct(
            structs.u384(name="xc0b2a1", elmts=[input.pop(0)])
        )
        xc1b0a0 = circuit.write_struct(
            structs.u384(name="xc1b0a0", elmts=[input.pop(0)])
        )
        xc1b0a1 = circuit.write_struct(
            structs.u384(name="xc1b0a1", elmts=[input.pop(0)])
        )
        xc1b2a0 = circuit.write_struct(
            structs.u384(name="xc1b2a0", elmts=[input.pop(0)])
        )
        xc1b2a1 = circuit.write_struct(
            structs.u384(name="xc1b2a1", elmts=[input.pop(0)])
        )

        zc0b0, zc1b1 = circuit.fp12_decompress_karabina_pt_II(
            [t0a0, t0a1],
            [t1a0, t1a1],
            [xc0b1a0, xc0b1a1],
            [xc0b2a0, xc0b2a1],
            [xc1b0a0, xc1b0a1],
            [xc1b2a0, xc1b2a1],
        )
        circuit.extend_struct_output(structs.u384(name="zc0b0a0", elmts=[zc0b0[0]]))
        circuit.extend_struct_output(structs.u384(name="zc0b0a1", elmts=[zc0b0[1]]))
        circuit.extend_struct_output(structs.u384(name="zc1b1a0", elmts=[zc1b1[0]]))
        circuit.extend_struct_output(structs.u384(name="zc1b1a1", elmts=[zc1b1[1]]))

        return circuit
