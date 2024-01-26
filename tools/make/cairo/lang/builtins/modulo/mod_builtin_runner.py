import operator
from math import ceil
from typing import Any, Dict, List, Optional, Tuple

from starkware.cairo.lang.builtins.modulo.instance_def import (
    AddModInstanceDef,
    ModInstanceDef,
    MulModInstanceDef,
)
from starkware.cairo.lang.vm.builtin_runner import SimpleBuiltinRunner
from starkware.cairo.lang.vm.relocatable import MaybeRelocatable, RelocatableValue
from starkware.cairo.lang.vm.utils import MemorySegmentRelocatableAddresses
from starkware.python.math_utils import div_mod, safe_div

# The maximum n value that the function fill_memory accepts.
MAX_N = 100000

INPUT_NAMES = [
    "p0",
    "p1",
    "p2",
    "p3",
    "values_ptr",
    "offsets_ptr",
    "n",
]

MEMORY_VAR_NAMES = [
    "a_offset",
    "b_offset",
    "c_offset",
    "a0",
    "a1",
    "a2",
    "a3",
    "b0",
    "b1",
    "b2",
    "b3",
    "c0",
    "c1",
    "c2",
    "c3",
]

INPUT_CELLS = len(INPUT_NAMES)
ADDITIONAL_MEMORY_UNITS = len(MEMORY_VAR_NAMES)


class ModBuiltinRunner(SimpleBuiltinRunner):
    def __init__(self, name: str, included: bool, instance_def: ModInstanceDef):
        super().__init__(
            name=name,
            included=included,
            ratio=None if instance_def is None else instance_def.ratio,
            cells_per_instance=INPUT_CELLS,
            n_input_cells=INPUT_CELLS,
            additional_memory_units_per_instance=ADDITIONAL_MEMORY_UNITS,
        )
        self.instance_def: ModInstanceDef = instance_def
        self.zero_value: Optional[RelocatableValue] = None

    def get_instance_def(self):
        return self.instance_def

    def get_memory_accesses(self, runner):
        """
        Returns memory accesses for the builtin on all segments, including values and offsets
        addresses. Used by the cairo_runner to check for memory holes.
        """
        segment_size = runner.segments.get_segment_size(self.base.segment_index)
        n_instances = ceil(segment_size / self.cells_per_instance)
        res = set()
        for instance in range(n_instances):
            offsets_ptr_addr = (
                self.base + instance * self.n_input_cells + INPUT_NAMES.index("offsets_ptr")
            )
            offsets_addr = runner.vm_memory[offsets_ptr_addr]
            values_ptr_addr = (
                self.base + instance * self.n_input_cells + INPUT_NAMES.index("values_ptr")
            )
            values_addr = runner.vm_memory[values_ptr_addr]
            for i in range(3 * self.instance_def.batch_size):
                offset_addr = offsets_addr + i
                res.add(offset_addr)
                offset = runner.vm_memory[offset_addr]
                for j in range(self.instance_def.n_words):
                    res.add(values_addr + offset + j)
        return super().get_memory_accesses(runner).union(res)

    def initialize_segments(self, runner):
        super().initialize_segments(runner)
        self.zero_value = runner.segments.add_zero_segment(self.instance_def.n_words)

    def finalize_segments(self, runner):
        super().finalize_segments(runner)
        runner.segments.finalize_zero_segment()

    def get_memory_segment_addresses(self, runner):
        assert self.zero_value is not None, "Uninitialized self.zero_value."
        return super().get_memory_segment_addresses(runner) | {
            f"{self.name}_zero_value": MemorySegmentRelocatableAddresses(
                begin_addr=self.zero_value,
                stop_ptr=self.zero_value + self.instance_def.n_words,
            ),
        }

    # The structure of the values in the returned dictionary is of the form:
    # {keys = INPUT_NAMES, "batch": {index_in_batch: {keys = MEMORY_VAR_NAMES}}}.
    def air_private_input(self, runner) -> Dict[str, Any]:
        assert self.base is not None, "Uninitialized self.base."
        res: Dict[int, Any] = {}
        values_addr_per_instance = {}
        offsets_addr_per_instance = {}
        for addr, val in runner.vm_memory.items():
            if (
                not isinstance(addr, RelocatableValue)
                or addr.segment_index != self.base.segment_index
            ):
                continue

            assert isinstance(val, int)
            idx, typ = divmod(addr.offset, INPUT_CELLS)
            res.setdefault(idx, {"index": idx})[INPUT_NAMES[typ]] = hex(val)
            if typ == INPUT_NAMES.index("values_ptr"):
                values_addr_per_instance[idx] = val
            if typ == INPUT_NAMES.index("offsets_ptr"):
                offsets_addr_per_instance[idx] = val

        for idx, offsets_addr in offsets_addr_per_instance.items():
            for index_in_batch in range(self.instance_def.batch_size):
                for i, s in enumerate("abc"):
                    offset = runner.vm_memory[offsets_addr + i + 3 * index_in_batch]
                    res[idx]["batch"][index_in_batch][f"{s}_offset"] = hex(offset)
                    assert idx in values_addr_per_instance
                    values_addr = values_addr_per_instance[idx]
                    for d in range(self.instance_def.n_words):
                        value = runner.vm_memory[values_addr + offset + d]
                        res[idx]["batch"][index_in_batch][f"{s}{d}"] = hex(value)

        for index, item in res.items():
            for name in INPUT_NAMES:
                assert name in item, f"Missing input '{name}' of {self.name} instance {index}."
            for index_in_batch in range(self.instance_def.batch_size):
                for name in MEMORY_VAR_NAMES:
                    assert name in item["batch"][index_in_batch], (
                        f"Missing memory variable '{name}' of {self.name} instance {index}, "
                        + f"batch {index_in_batch}."
                    )

        return {self.name: sorted(res.values(), key=lambda item: item["index"])}

    def read_n_words_value(self, memory, addr) -> Tuple[List[int], Optional[int]]:
        """
        Reads self.instance_def.n_words from memory, starting at address=addr.
        Returns the words and the value if all words are in memory.
        Verifies that all words are integers and are bounded by 2**self.instance_def.word_bit_len.
        """
        if addr not in memory:
            return [], None

        words: List[int] = []
        value = 0
        for i in range(self.instance_def.n_words):
            addr_i = addr + i
            if addr_i not in memory:
                return words, None
            word = memory[addr_i]
            assert isinstance(word, int), (
                f"Expected integer at address {addr_i}. " + f"Got: {word}."
            )
            assert word < 2**self.instance_def.word_bit_len, (
                f"Expected integer at address {addr_i} to be smaller than "
                + f"2^{self.instance_def.word_bit_len}. Got: {word}."
            )
            words.append(word)
            value += word * 2 ** (self.instance_def.word_bit_len * i)

        return words, value

    def run_security_checks(self, runner, op):
        super().run_security_checks(runner)
        segment_size = runner.segments.get_segment_used_size(self.base.segment_index)
        n_instances = ceil(segment_size / self.cells_per_instance)

        prev_inputs = None
        for instance in range(n_instances):
            inputs = self.read_inputs(runner.vm_memory, self.base + instance * self.n_input_cells)
            if prev_inputs is not None and prev_inputs["n"] > self.instance_def.batch_size:
                assert all(
                    inputs[f"p{i}"] == prev_inputs[f"p{i}"]
                    for i in range(self.instance_def.n_words)
                )
                assert inputs["values_ptr"] == prev_inputs["values_ptr"]
                assert (
                    inputs["offsets_ptr"]
                    == prev_inputs["offsets_ptr"] + 3 * self.instance_def.batch_size
                )
                assert inputs["n"] == prev_inputs["n"] - self.instance_def.batch_size
            assert isinstance(inputs["p"], int)
            for index_in_batch in range(self.instance_def.batch_size):
                values = self.read_memory_vars(
                    runner.vm_memory, inputs["values_ptr"], inputs["offsets_ptr"], index_in_batch
                )
                assert op(values["a"], values["b"]) % inputs["p"] == values["c"] % inputs["p"], (
                    f"{self.name} builtin: Expected a {op} b == c (mod p). Got: "
                    + f"instance={instance}, batch={index_in_batch}, inputs={inputs}, "
                    + f"values={values}."
                )
            prev_inputs = inputs
        if prev_inputs is not None:
            assert prev_inputs["n"] == self.instance_def.batch_size

    def read_inputs(self, memory, addr) -> Dict[str, MaybeRelocatable]:
        """
        Reads the inputs to the builtin (see INPUT_NAMES) from the memory at address=addr.
        Returns a dictionary from input name to its value. Asserts that it exists in memory.
        Returns also the value of p, not just its words.
        """
        inputs = {}
        inputs["values_ptr"] = memory[addr + INPUT_NAMES.index("values_ptr")]
        assert isinstance(inputs["values_ptr"], RelocatableValue), (
            f"{self.name} builtin: Expected RelocatableValue at address "
            + f"{addr + INPUT_NAMES.index('values_ptr')}. Got: {inputs['values_ptr']}."
        )
        inputs["offsets_ptr"] = memory[addr + INPUT_NAMES.index("offsets_ptr")]
        assert isinstance(inputs["offsets_ptr"], RelocatableValue), (
            f"{self.name} builtin: Expected RelocatableValue at address "
            + f"{addr + INPUT_NAMES.index('offsets_ptr')}. Got: {inputs['offsets_ptr']}."
        )
        inputs["n"] = memory[addr + INPUT_NAMES.index("n")]
        assert isinstance(inputs["n"], int), (
            f"{self.name} builtin: Expected integer at address "
            + f"{addr + INPUT_NAMES.index('n')}. Got: {inputs['n']}."
        )
        assert inputs["n"] >= 1, f"{self.name} builtin: Expected n >= 1. Got: {inputs['n']}."
        p_addr = addr + INPUT_NAMES.index("p0")
        words, value = self.read_n_words_value(memory, p_addr)
        assert (
            value is not None
        ), f"{self.name} builtin: Missing value at address {p_addr + len(words)}."
        inputs["p"] = value
        for d, w in enumerate(words):
            inputs[f"p{d}"] = w
        return inputs

    def read_memory_vars(self, memory, values_ptr, offsets_ptr, index_in_batch) -> Dict[str, int]:
        """
        Reads the memory variables to the builtin (see MEMORY_VAR_NAMES) from the memory given
        the inputs (specifically, values_ptr and offsets_ptr).
        Returns a dictionary from memory variable name to its value. Asserts if it doesn't exist in
        memory. Returns also the values of a, b, and c, not just their words.
        """
        memory_vars = {}
        for i, s in enumerate("abc"):
            offset = memory[offsets_ptr + i + 3 * index_in_batch]
            assert isinstance(offset, int), (
                f"{self.name} builtin: Expected integer at address "
                + f"{offsets_ptr + i}. Got: {offset}."
            )
            memory_vars[f"{s}_offset"] = offset
            value_addr = values_ptr + offset
            words, value = self.read_n_words_value(memory, value_addr)
            assert (
                value is not None
            ), f"{self.name} builtin: Missing value at address {value_addr + len(words)}."
            memory_vars[s] = value
            for d, w in enumerate(words):
                memory_vars[f"{s}{d}"] = w
        return memory_vars

    @staticmethod
    def fill_memory(
        memory,
        add_mod: Optional[Tuple[RelocatableValue, "AddModBuiltinRunner", int]],
        mul_mod: Optional[Tuple[RelocatableValue, "MulModBuiltinRunner", int]],
    ):
        """
        Fills the memory with inputs to the builtin instances based on the inputs to the
        first instance, pads the offsets table to fit the number of operations writen in the
        input to the first instance, and caculates missing values in the values table.

        For each builtin, the given tuple is of the form (builtin_ptr, builtin_runner, n),
        where n is the number of operations in the offsets table (i.e., the length of the
        offsets table is 3*n).

        The number of operations written to the input of the first instance n' should be at
        least n and a multiple of batch_size. Previous offsets are copied to the end of the
        offsets table to make its length 3n'.
        """
        # Check that the instance definitions of the builtins are the same.
        if add_mod and mul_mod:
            assert (
                add_mod[1].instance_def.n_words == mul_mod[1].instance_def.n_words
                and add_mod[1].instance_def.word_bit_len == mul_mod[1].instance_def.word_bit_len
            ), f"add_mod and mul_mod builtins must have the same n_words and word_bit_len."

        # Fill the inputs to the builtins.
        add_mod_inputs = {}
        mul_mod_inputs = {}
        if add_mod:
            add_mod_inputs = add_mod[1].read_inputs(memory, add_mod[0])
            add_mod[1].fill_inputs(memory, add_mod[0], add_mod_inputs)
            add_mod[1].fill_offsets(
                memory, add_mod_inputs, add_mod[2], add_mod_inputs["n"] - add_mod[2]
            )
        if mul_mod:
            mul_mod_inputs = mul_mod[1].read_inputs(memory, mul_mod[0])
            mul_mod[1].fill_inputs(memory, mul_mod[0], mul_mod_inputs)
            mul_mod[1].fill_offsets(
                memory, mul_mod_inputs, mul_mod[2], mul_mod_inputs["n"] - mul_mod[2]
            )

        # Get one of the builtin runners - the rest of this function doesn't depend on batch_size.
        mod_builtin = add_mod if add_mod else mul_mod
        assert mod_builtin is not None, "At least one of add_mod and mul_mod must be given."
        mod_runner = mod_builtin[1]
        assert isinstance(mod_runner, ModBuiltinRunner)

        # Fill the values table.
        add_mod_n = add_mod[2] if add_mod else 0
        mul_mod_n = mul_mod[2] if mul_mod else 0
        add_mod_index = 0
        mul_mod_index = 0
        while add_mod_index < add_mod_n or mul_mod_index < mul_mod_n:
            if add_mod_index < add_mod_n and mod_runner.fill_value(
                memory,
                add_mod_inputs,
                add_mod_index,
                operator.add,
                operator.sub,
            ):
                add_mod_index += 1
            elif mul_mod_index < mul_mod_n and mod_runner.fill_value(
                memory,
                mul_mod_inputs,
                mul_mod_index,
                operator.mul,
                lambda a, b: div_mod(a, b, mul_mod_inputs["p"]),
            ):
                mul_mod_index += 1
            else:
                raise Exception(
                    f"Could not fill the values table, "
                    + f"add_mod_index={add_mod_index}, mul_mod_index={mul_mod_index}"
                )

    # Fills the inputs to the instances of the builtin given the inputs to the first instance.
    def fill_inputs(self, memory, builtin_ptr, inputs):
        assert inputs["n"] <= MAX_N, f"{self.name} builtin: n must be <= {MAX_N}"
        n_instances = safe_div(inputs["n"], self.instance_def.batch_size)
        for instance in range(1, n_instances):
            instance_ptr = builtin_ptr + instance * len(INPUT_NAMES)
            for i in range(self.instance_def.n_words):
                memory[instance_ptr + INPUT_NAMES.index(f"p{i}")] = inputs[f"p{i}"]
            memory[instance_ptr + INPUT_NAMES.index("values_ptr")] = inputs["values_ptr"]
            memory[instance_ptr + INPUT_NAMES.index("offsets_ptr")] = (
                inputs["offsets_ptr"] + 3 * instance * self.instance_def.batch_size
            )
            memory[instance_ptr + INPUT_NAMES.index("n")] = (
                inputs["n"] - instance * self.instance_def.batch_size
            )

    # Copies the first offsets in the offsets table to its end, n_copies times.
    def fill_offsets(self, memory, inputs, index, n_copies):
        offsets = {}
        for i, s in enumerate("abc"):
            s_offset = memory[inputs["offsets_ptr"] + i]
            offsets[s] = s_offset
        for i in range(n_copies):
            for j, s in enumerate("abc"):
                memory[inputs["offsets_ptr"] + 3 * (index + i) + j] = offsets[s]

    # Fills a value in the values table, if exactly one value is missing.
    # Returns true on success or if all values are already known.
    def fill_value(self, memory, inputs, index, op, inv_op) -> bool:
        values = {}
        addresses = {}
        for i, s in enumerate("abc"):
            s_offset = memory[inputs["offsets_ptr"] + 3 * index + i]
            addresses[s] = inputs["values_ptr"] + s_offset
            if inputs["values_ptr"] + s_offset in memory:
                _words, value = self.read_n_words_value(memory, inputs["values_ptr"] + s_offset)
                if value is not None:
                    values[s] = value

        if all(s in values for s in "abc"):
            # All values are already known.
            return True

        # Deduce c from a and b and write it to memory.
        if "c" not in values and "a" in values and "b" in values:
            value = op(values["a"], values["b"]) % inputs["p"]
            self.write_n_words_value(memory, addresses["c"], value)
            return True
        # Deduce b from a and c and write it to memory.
        if "b" not in values and "a" in values and "c" in values:
            value = inv_op(values["c"], values["a"]) % inputs["p"]
            self.write_n_words_value(memory, addresses["b"], value)
            return True
        # Deduce a from b and c and write it to memory.
        if "a" not in values and "b" in values and "c" in values:
            value = inv_op(values["c"], values["b"]) % inputs["p"]
            self.write_n_words_value(memory, addresses["a"], value)
            return True

        return False

    def write_n_words_value(self, memory, addr, value):
        """
        Given a value, writes its n_words to memory, starting at address=addr.
        """
        shift = 2**self.instance_def.word_bit_len
        value_copy = value
        for i in range(self.instance_def.n_words):
            word = value_copy % shift
            # The following line will raise InconsistentMemoryError if the address is already in
            # memory and a different value is written.
            memory[addr + i] = word
            value_copy //= shift
        assert value_copy == 0


class AddModBuiltinRunner(ModBuiltinRunner):
    def __init__(self, included: bool, instance_def: AddModInstanceDef):
        super().__init__(
            name="add_mod",
            included=included,
            instance_def=instance_def,
        )

    def run_security_checks(self, runner):
        super().run_security_checks(runner, operator.add)


class MulModBuiltinRunner(ModBuiltinRunner):
    def __init__(self, included: bool, instance_def: MulModInstanceDef):
        super().__init__(
            name="mul_mod",
            included=included,
            instance_def=instance_def,
        )

    def run_security_checks(self, runner):
        super().run_security_checks(runner, operator.mul)
