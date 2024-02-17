from starkware.cairo.common.registers import get_label_location


    func get_sample_circuit(id: felt) -> (
    constants_ptr: felt*,
    add_offsets_ptr: felt*,
    mul_offsets_ptr: felt*,
    left_assert_eq_offsets_ptr: felt*,
    right_assert_eq_offsets_ptr: felt*,
    poseidon_indexes_ptr: felt*,
    constants_ptr_len: felt,
    add_mod_n: felt,
    mul_mod_n: felt,
    commitments_len: felt,
    assert_eq_len: felt,
    N_Euclidean_equations: felt,
) {
    if (id == 1) {
        return get_sample_circuit_1_non_interactive_circuit();
    } else {
        return (
            cast(0, felt*),
            cast(0, felt*),
            cast(0, felt*),
            cast(0, felt*),
            cast(0, felt*),
            cast(0, felt*),
            0,
            0,
            0,
            0,
            0,
            0,
        );
    }
}
func get_sample_circuit_1_non_interactive_circuit()->(constants_ptr:felt*, add_offsets_ptr:felt*, mul_offsets_ptr:felt*, left_assert_eq_offsets_ptr:felt*, right_assert_eq_offsets_ptr:felt*, poseidon_indexes_ptr:felt*, constants_ptr_len:felt, add_mod_n:felt, mul_mod_n:felt, commitments_len:felt, assert_eq_len:felt, N_Euclidean_equations:felt,){
alloc_locals;
let constants_ptr_len = 5;
let add_mod_n = 29;
let mul_mod_n = 36;
let commitments_len = 17;
let assert_eq_len = 0;
let N_Euclidean_equations = 2;
let (constants_ptr:felt*) = get_label_location(constants_ptr_loc);
let (add_offsets_ptr:felt*) = get_label_location(add_offsets_ptr_loc);
let (mul_offsets_ptr:felt*) = get_label_location(mul_offsets_ptr_loc);
let (left_assert_eq_offsets_ptr:felt*) = get_label_location(left_assert_eq_offsets_ptr_loc);
let (right_assert_eq_offsets_ptr:felt*) = get_label_location(right_assert_eq_offsets_ptr_loc);
let (poseidon_indexes_ptr:felt*) = get_label_location(poseidon_indexes_ptr_loc);
return (constants_ptr, add_offsets_ptr, mul_offsets_ptr, left_assert_eq_offsets_ptr, right_assert_eq_offsets_ptr, poseidon_indexes_ptr, constants_ptr_len, add_mod_n, mul_mod_n, commitments_len, assert_eq_len, N_Euclidean_equations);
	 constants_ptr_loc:
	 dw 0;
	 dw 0;
	 dw 0;
	 dw 0;
	 dw 1;
	 dw 0;
	 dw 0;
	 dw 0;
	 dw 32324006162389411176778628422;
	 dw 57042285082623239461879769745;
	 dw 3486998266802970665;
	 dw 0;
	 dw 82;
	 dw 0;
	 dw 0;
	 dw 0;
	 dw 32324006162389411176778628405;
	 dw 57042285082623239461879769745;
	 dw 3486998266802970665;
	 dw 0;

	 add_offsets_ptr_loc:
	 dw 20;
	 dw 122;
	 dw 126;

	 dw 126;
	 dw 130;
	 dw 134;

	 dw 134;
	 dw 138;
	 dw 142;

	 dw 142;
	 dw 146;
	 dw 150;

	 dw 150;
	 dw 154;
	 dw 158;

	 dw 20;
	 dw 162;
	 dw 166;

	 dw 166;
	 dw 170;
	 dw 174;

	 dw 174;
	 dw 178;
	 dw 182;

	 dw 182;
	 dw 186;
	 dw 190;

	 dw 190;
	 dw 194;
	 dw 198;

	 dw 0;
	 dw 206;
	 dw 210;

	 dw 0;
	 dw 214;
	 dw 218;

	 dw 0;
	 dw 222;
	 dw 226;

	 dw 0;
	 dw 230;
	 dw 234;

	 dw 0;
	 dw 238;
	 dw 242;

	 dw 0;
	 dw 246;
	 dw 250;

	 dw 0;
	 dw 254;
	 dw 258;

	 dw 68;
	 dw 262;
	 dw 266;

	 dw 266;
	 dw 270;
	 dw 274;

	 dw 274;
	 dw 278;
	 dw 282;

	 dw 282;
	 dw 286;
	 dw 290;

	 dw 12;
	 dw 294;
	 dw 298;

	 dw 298;
	 dw 302;
	 dw 306;

	 dw 218;
	 dw 310;
	 dw 314;

	 dw 314;
	 dw 318;
	 dw 322;

	 dw 322;
	 dw 326;
	 dw 330;

	 dw 330;
	 dw 334;
	 dw 338;

	 dw 338;
	 dw 342;
	 dw 346;

	 dw 350;
	 dw 346;
	 dw 354;

	 mul_offsets_ptr_loc:
	 dw 88;
	 dw 88;
	 dw 98;

	 dw 98;
	 dw 88;
	 dw 102;

	 dw 102;
	 dw 88;
	 dw 106;

	 dw 106;
	 dw 88;
	 dw 110;

	 dw 110;
	 dw 88;
	 dw 114;

	 dw 114;
	 dw 88;
	 dw 118;

	 dw 24;
	 dw 88;
	 dw 122;

	 dw 28;
	 dw 98;
	 dw 130;

	 dw 32;
	 dw 102;
	 dw 138;

	 dw 36;
	 dw 106;
	 dw 146;

	 dw 40;
	 dw 110;
	 dw 154;

	 dw 24;
	 dw 88;
	 dw 162;

	 dw 28;
	 dw 98;
	 dw 170;

	 dw 32;
	 dw 102;
	 dw 178;

	 dw 36;
	 dw 106;
	 dw 186;

	 dw 40;
	 dw 110;
	 dw 194;

	 dw 158;
	 dw 198;
	 dw 202;

	 dw 93;
	 dw 202;
	 dw 206;

	 dw 93;
	 dw 44;
	 dw 214;

	 dw 93;
	 dw 48;
	 dw 222;

	 dw 93;
	 dw 52;
	 dw 230;

	 dw 93;
	 dw 56;
	 dw 238;

	 dw 93;
	 dw 60;
	 dw 246;

	 dw 93;
	 dw 64;
	 dw 254;

	 dw 72;
	 dw 88;
	 dw 262;

	 dw 76;
	 dw 98;
	 dw 270;

	 dw 80;
	 dw 102;
	 dw 278;

	 dw 84;
	 dw 106;
	 dw 286;

	 dw 16;
	 dw 102;
	 dw 294;

	 dw 4;
	 dw 114;
	 dw 302;

	 dw 226;
	 dw 88;
	 dw 310;

	 dw 234;
	 dw 98;
	 dw 318;

	 dw 242;
	 dw 102;
	 dw 326;

	 dw 250;
	 dw 106;
	 dw 334;

	 dw 258;
	 dw 110;
	 dw 342;

	 dw 290;
	 dw 306;
	 dw 350;

	 left_assert_eq_offsets_ptr_loc:
	 right_assert_eq_offsets_ptr_loc:
	 poseidon_indexes_ptr_loc:
	 dw 11;
	 dw 23;

}
