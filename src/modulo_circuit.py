from src.algebra import FieldElement, ModuloElement
from src.definitions import STARK


class ModuloCircuit:
    """
    Represents a modulo circuit capable of performing arithmetic operations on base field elements,
    storing constants, and caching powers of base field elements.

    Attributes:
        circuit_name (str): The name of the circuit.
        last_offset (int): The last used offset in the circuit's memory.
        N_LIMBS (int): The number of limbs used in the circuit.
        values_segment (dict[int, BaseFieldElement]): A dictionary mapping offsets to base field elements.
        add_offsets (list[tuple]): A list of tuples representing the offsets involved in addition operations.
        mul_offsets (list[tuple]): A list of tuples representing the offsets involved in multiplication operations.
        constants (dict[str, ModuloElement]): A dictionary mapping constant names to their ModuloElement representations.
    """

    def __init__(self, name: str) -> None:
        self.circuit_name = name
        self.last_offset = 0
        self.N_LIMBS = 4
        self.values_segment: dict[int, FieldElement] = dict()
        self.add_offsets: list[tuple] = []
        self.mul_offsets: list[tuple] = []
        self.constants: dict[str, ModuloElement] = dict()

    def write_element(self, elmt: FieldElement) -> ModuloElement:
        assert type(elmt) == FieldElement, f"Expected FieldElement, got {type(elmt)}"
        self.values_segment[self.last_offset] = elmt
        res = ModuloElement(elmt, self.last_offset)
        self.last_offset += self.N_LIMBS
        return res

    def write_cairo_native_felt(self, value: int):
        assert 0 <= value < STARK
        res = self.write_element(self.field(value))
        self.last_offset += 1
        return res

    def write_elements(self, elmts: list[FieldElement]) -> list[ModuloElement]:
        return [self.write_element(elmt) for elmt in elmts]

    def write_sparse_elements(self, elmts: list[FieldElement]) -> list[ModuloElement]:
        sparsity = [1 if elmt != self.field.zero() else 0 for elmt in elmts]
        return [
            self.write_element(elmt)
            for elmt, not_sparse in zip(elmts, sparsity)
            if not_sparse
        ], sparsity

    def add_constant(self, name: str, value: FieldElement) -> None:
        if name in self.constants:
            raise ValueError(f"Constant '{name}' already exists.")
        self.constants[name] = self.write_element(value)

    def get_constant(self, name: str) -> ModuloElement:
        if name not in self.constants:
            raise ValueError(f"Constant '{name}' does not exist.")
        return self.constants[name]

    def compile_offsets(self) -> str:
        add_offsets = f"{self.circuit_name}_add_offsets:\n"
        mul_offsets = f"{self.circuit_name}_mul_offsets:\n"
        for offset_triplet in self.add_offsets:
            add_offsets += f"\t dw {offset_triplet[0]};\n"
            add_offsets += f"\t dw {offset_triplet[1]};\n"
            add_offsets += f"\t dw {offset_triplet[2]};\n\n"
        for offset_triplet in self.mul_offsets:
            mul_offsets += f"\t dw {offset_triplet[0]};\n"
            mul_offsets += f"\t dw {offset_triplet[1]};\n"
            mul_offsets += f"\t dw {offset_triplet[2]};\n\n"
        return add_offsets + mul_offsets

    def add(self, a: ModuloElement, b: ModuloElement) -> ModuloElement:
        self.add_offsets.append((a.offset, b.offset, self.last_offset))
        return self.write_element(a.elmt + b.elmt)

    def mul(self, a: ModuloElement, b: ModuloElement) -> ModuloElement:
        self.mul_offsets.append((a.offset, b.offset, self.last_offset))
        return (
            self.write_element(a.elmt * b.elmt),
            0,
        )

    def sub(self, a: ModuloElement, b: ModuloElement):
        raise NotImplementedError

    def inv(self, a: ModuloElement):
        raise NotImplementedError

    def div(self, a: ModuloElement, b: ModuloElement):
        raise NotImplementedError

    def _check_sanity(self):
        for a_offset, b_offset, result_offset in self.add_offsets:
            a_value = self.values_segment[a_offset]
            b_value = self.values_segment[b_offset]
            result_value = self.values_segment[result_offset]
            assert result_value == a_value + b_value
        for a_offset, b_offset, result_offset in self.mul_offsets:
            a_value = self.values_segment[a_offset]
            b_value = self.values_segment[b_offset]
            result_value = self.values_segment[result_offset]
            assert result_value == a_value * b_value
        return True


if __name__ == "__main__":
    from src.algebra import BaseField

    field = BaseField(256)
    circuit = ModuloCircuit("test_circuit")
    a = circuit.write_element(field(1))
    b = circuit.write_element(field(2))
    c = circuit.add(a, b)
    d = circuit.mul(c, b)
    x = circuit.write_element(field(42))
    y = circuit.write_element(field(13))
    z = circuit.add(x, y)

    print(c)

    print(d)

    print(circuit.values_segment)
    print(circuit.add_offsets)
    print(circuit.mul_offsets)

    assert circuit._check_sanity()

    print(circuit.compile_offsets())
