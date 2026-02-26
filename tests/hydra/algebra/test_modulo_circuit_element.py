"""Tests for ModuloCircuitElement magic methods."""

import pytest

from garaga.algebra import ModuloCircuitElement, PyFelt
from garaga.modulo_circuit import ModuloCircuit


class TestModuloCircuitElementMagicMethods:
    """Test suite for ModuloCircuitElement arithmetic magic methods."""

    def test_addition(self):
        """Test __add__ magic method."""
        circuit = ModuloCircuit("test", curve_id=0)
        a = circuit.write_element(5)
        b = circuit.write_element(3)

        c = a + b

        assert c.value == 8
        assert c.circuit is circuit

    def test_addition_commutativity(self):
        """Test that addition is commutative."""
        circuit = ModuloCircuit("test", curve_id=0)
        a = circuit.write_element(7)
        b = circuit.write_element(11)

        assert (a + b).value == (b + a).value

    def test_radd(self):
        """Test __radd__ magic method."""
        circuit = ModuloCircuit("test", curve_id=0)
        a = circuit.write_element(5)
        b = circuit.write_element(3)

        # This exercises __radd__ when left operand doesn't have __add__
        c = a + b
        assert c.value == 8

    def test_subtraction(self):
        """Test __sub__ magic method."""
        circuit = ModuloCircuit("test", curve_id=0)
        a = circuit.write_element(10)
        b = circuit.write_element(3)

        c = a - b

        assert c.value == 7
        assert c.circuit is circuit

    def test_subtraction_negative_result(self):
        """Test subtraction resulting in modular wrap-around."""
        circuit = ModuloCircuit("test", curve_id=0)
        a = circuit.write_element(3)
        b = circuit.write_element(10)

        c = a - b

        # Result should be p - 7 (modular arithmetic)
        expected = (circuit.field.p - 7) % circuit.field.p
        assert c.value == expected

    def test_rsub(self):
        """Test __rsub__ magic method."""
        circuit = ModuloCircuit("test", curve_id=0)
        a = circuit.write_element(10)
        b = circuit.write_element(3)

        # a - b = 7, b - a = p - 7
        c = a - b
        d = b - a

        assert c.value == 7
        assert d.value == (circuit.field.p - 7) % circuit.field.p

    def test_multiplication(self):
        """Test __mul__ magic method."""
        circuit = ModuloCircuit("test", curve_id=0)
        a = circuit.write_element(5)
        b = circuit.write_element(3)

        c = a * b

        assert c.value == 15
        assert c.circuit is circuit

    def test_multiplication_commutativity(self):
        """Test that multiplication is commutative."""
        circuit = ModuloCircuit("test", curve_id=0)
        a = circuit.write_element(7)
        b = circuit.write_element(11)

        assert (a * b).value == (b * a).value

    def test_rmul(self):
        """Test __rmul__ magic method."""
        circuit = ModuloCircuit("test", curve_id=0)
        a = circuit.write_element(5)
        b = circuit.write_element(3)

        c = a * b
        assert c.value == 15

    def test_division(self):
        """Test __truediv__ magic method."""
        circuit = ModuloCircuit("test", curve_id=0)
        a = circuit.write_element(15)
        b = circuit.write_element(3)

        c = a / b

        assert c.value == 5
        assert c.circuit is circuit

    def test_division_modular(self):
        """Test division with modular inverse."""
        circuit = ModuloCircuit("test", curve_id=0)
        a = circuit.write_element(5)
        b = circuit.write_element(3)

        c = a / b

        # Verify: c * b = a (mod p)
        check = c * b
        assert check.value == 5

    def test_negation(self):
        """Test __neg__ magic method."""
        circuit = ModuloCircuit("test", curve_id=0)
        a = circuit.write_element(5)

        b = -a

        expected = (circuit.field.p - 5) % circuit.field.p
        assert b.value == expected
        assert b.circuit is circuit

    def test_negation_zero(self):
        """Test negation of zero."""
        circuit = ModuloCircuit("test", curve_id=0)
        a = circuit.write_element(0)

        b = -a

        assert b.value == 0

    def test_double_negation(self):
        """Test that double negation returns original value."""
        circuit = ModuloCircuit("test", curve_id=0)
        a = circuit.write_element(42)

        b = -(-a)

        assert b.value == 42

    def test_chained_operations(self):
        """Test chaining multiple operations."""
        circuit = ModuloCircuit("test", curve_id=0)
        a = circuit.write_element(10)
        b = circuit.write_element(3)
        c = circuit.write_element(2)

        # (a + b) * c = (10 + 3) * 2 = 26
        result = (a + b) * c

        assert result.value == 26

    def test_complex_expression(self):
        """Test a more complex arithmetic expression."""
        circuit = ModuloCircuit("test", curve_id=0)
        a = circuit.write_element(10)
        b = circuit.write_element(5)
        c = circuit.write_element(2)

        # a * b - c = 10 * 5 - 2 = 48
        result = a * b - c

        assert result.value == 48


class TestModuloCircuitElementErrors:
    """Test error handling for ModuloCircuitElement magic methods."""

    def test_cross_circuit_addition_error(self):
        """Test that addition across different circuits raises error."""
        circuit1 = ModuloCircuit("test1", curve_id=0)
        circuit2 = ModuloCircuit("test2", curve_id=0)
        a = circuit1.write_element(5)
        b = circuit2.write_element(3)

        with pytest.raises(ValueError, match="different circuits"):
            _ = a + b

    def test_cross_circuit_subtraction_error(self):
        """Test that subtraction across different circuits raises error."""
        circuit1 = ModuloCircuit("test1", curve_id=0)
        circuit2 = ModuloCircuit("test2", curve_id=0)
        a = circuit1.write_element(5)
        b = circuit2.write_element(3)

        with pytest.raises(ValueError, match="different circuits"):
            _ = a - b

    def test_cross_circuit_multiplication_error(self):
        """Test that multiplication across different circuits raises error."""
        circuit1 = ModuloCircuit("test1", curve_id=0)
        circuit2 = ModuloCircuit("test2", curve_id=0)
        a = circuit1.write_element(5)
        b = circuit2.write_element(3)

        with pytest.raises(ValueError, match="different circuits"):
            _ = a * b

    def test_cross_circuit_division_error(self):
        """Test that division across different circuits raises error."""
        circuit1 = ModuloCircuit("test1", curve_id=0)
        circuit2 = ModuloCircuit("test2", curve_id=0)
        a = circuit1.write_element(5)
        b = circuit2.write_element(3)

        with pytest.raises(ValueError, match="different circuits"):
            _ = a / b

    def test_circuitless_element_addition_error(self):
        """Test that addition on element without circuit raises error."""
        circuit = ModuloCircuit("test", curve_id=0)
        a = circuit.write_element(5)
        standalone = ModuloCircuitElement(PyFelt(10, circuit.field.p), -1)

        with pytest.raises(ValueError, match="without circuit reference"):
            _ = standalone + a

    def test_circuitless_element_subtraction_error(self):
        """Test that subtraction on element without circuit raises error."""
        circuit = ModuloCircuit("test", curve_id=0)
        standalone = ModuloCircuitElement(PyFelt(10, circuit.field.p), -1)

        with pytest.raises(ValueError, match="without circuit reference"):
            _ = standalone - circuit.write_element(5)

    def test_circuitless_element_multiplication_error(self):
        """Test that multiplication on element without circuit raises error."""
        circuit = ModuloCircuit("test", curve_id=0)
        standalone = ModuloCircuitElement(PyFelt(10, circuit.field.p), -1)

        with pytest.raises(ValueError, match="without circuit reference"):
            _ = standalone * circuit.write_element(5)

    def test_circuitless_element_division_error(self):
        """Test that division on element without circuit raises error."""
        circuit = ModuloCircuit("test", curve_id=0)
        standalone = ModuloCircuitElement(PyFelt(10, circuit.field.p), -1)

        with pytest.raises(ValueError, match="without circuit reference"):
            _ = standalone / circuit.write_element(5)

    def test_circuitless_element_negation_error(self):
        """Test that negation on element without circuit raises error."""
        circuit = ModuloCircuit("test", curve_id=0)
        standalone = ModuloCircuitElement(PyFelt(10, circuit.field.p), -1)

        with pytest.raises(ValueError, match="without circuit reference"):
            _ = -standalone


class TestModuloCircuitUUID:
    """Test ModuloCircuit UUID functionality."""

    def test_circuits_have_unique_uuids(self):
        """Test that different circuits have different UUIDs."""
        circuit1 = ModuloCircuit("test1", curve_id=0)
        circuit2 = ModuloCircuit("test2", curve_id=0)

        assert circuit1.uuid != circuit2.uuid

    def test_uuid_is_string(self):
        """Test that UUID is a string."""
        circuit = ModuloCircuit("test", curve_id=0)

        assert isinstance(circuit.uuid, str)
        assert len(circuit.uuid) == 36  # Standard UUID length with hyphens


class TestModuloCircuitElementCircuitReference:
    """Test ModuloCircuitElement circuit reference."""

    def test_write_element_sets_circuit_reference(self):
        """Test that write_element sets the circuit reference."""
        circuit = ModuloCircuit("test", curve_id=0)
        a = circuit.write_element(5)

        assert a.circuit is circuit

    def test_standalone_element_has_no_circuit(self):
        """Test that standalone element has no circuit reference."""
        circuit = ModuloCircuit("test", curve_id=0)
        standalone = ModuloCircuitElement(PyFelt(10, circuit.field.p), -1)

        assert standalone.circuit is None

    def test_result_element_has_circuit_reference(self):
        """Test that result of operation has circuit reference."""
        circuit = ModuloCircuit("test", curve_id=0)
        a = circuit.write_element(5)
        b = circuit.write_element(3)

        c = a + b

        assert c.circuit is circuit
