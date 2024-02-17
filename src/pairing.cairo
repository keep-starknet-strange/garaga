from starkware.cairo.common.registers import get_fp_and_pc
from starkware.cairo.common.memcpy import memcpy
from starkware.cairo.common.cairo_builtins import PoseidonBuiltin, ModBuiltin, UInt384
from starkware.cairo.common.modulo import run_mod_p_circuit
from src.definitions import get_P, E12D, ExtFCircuitInfo, get_final_exp_circuit
from src.utils import (
    get_Z_and_RLC_from_transcript,
    write_felts_to_value_segment,
    assert_limbs_at_index_are_equal,
)

func multi_miller_loop{
    range_check96_ptr: felt*, add_mod_ptr: ModBuiltin*, mul_mod_ptr: ModBuiltin*
}() -> E12D {
}
