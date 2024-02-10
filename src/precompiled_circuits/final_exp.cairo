func BN254_final_exp() -> (add_offsets_ptr: felt*, mul_offsets_ptr: felt*) {
    return (0, 0);
}

func BLS12_381_final_exp() -> (add_offsets_ptr: felt*, mul_offsets_ptr: felt*) {
    return (0, 0);
}

func get_GaragaBN254FinalExp_non_interactive_circuit() -> (
    constants: felt*,
    add_offsets: felt*,
    mul_offsets: felt*,
    left_assert_eq_offsets: felt*,
    right_assert_eq_offsets: felt*,
    poseidon_ptr_indexes,
) {
    let (constants_ptr: felt*) = get_label_location(constants_loc);
    let (add_offsets_ptr: felt*) = get_label_location(add_offsets_loc);
    let (mul_offsets_ptr: felt*) = get_label_location(mul_offsets_loc);
    let (left_assert_eq_offsets_ptr: felt*) = get_label_location(left_assert_eq_offsets_loc);
    let (right_assert_eq_offsets_ptr: felt*) = get_label_location(right_assert_eq_offsets_loc);
    let (poseidon_ptr_indexes_ptr: felt*) = get_label_location(poseidon_ptr_indexes_loc);
    return (
        constants_ptr,
        add_offsets_ptr,
        mul_offsets_ptr,
        left_assert_eq_offsets_ptr,
        right_assert_eq_offsets_ptr,
        poseidon_ptr_indexes,
    );

    constants_loc:
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

    add_offsets_loc:
    dw 40;
    dw 40;
    dw 94;

    dw 44;
    dw 44;
    dw 98;

    dw 48;
    dw 48;
    dw 102;

    dw 52;
    dw 52;
    dw 106;

    dw 56;
    dw 56;
    dw 110;

    dw 60;
    dw 60;
    dw 114;

    dw 94;
    dw 118;
    dw 142;

    dw 98;
    dw 122;
    dw 146;

    dw 102;
    dw 126;
    dw 150;

    dw 106;
    dw 130;
    dw 154;

    dw 110;
    dw 134;
    dw 158;

    dw 114;
    dw 138;
    dw 162;

    dw 12;
    dw 166;
    dw 170;

    dw 170;
    dw 174;
    dw 178;

    dw 178;
    dw 182;
    dw 186;

    dw 186;
    dw 190;
    dw 194;

    dw 194;
    dw 198;
    dw 202;

    dw 142;
    dw 206;
    dw 210;

    dw 210;
    dw 214;
    dw 218;

    dw 218;
    dw 222;
    dw 226;

    dw 226;
    dw 230;
    dw 234;

    dw 234;
    dw 238;
    dw 242;

    dw 0;
    dw 250;
    dw 254;

    dw 0;
    dw 69;
    dw 258;

    mul_offsets_loc:
    dw 64;
    dw 64;
    dw 74;

    dw 74;
    dw 64;
    dw 78;

    dw 78;
    dw 64;
    dw 82;

    dw 82;
    dw 64;
    dw 86;

    dw 86;
    dw 64;
    dw 90;

    dw 12;
    dw 8;
    dw 118;

    dw 16;
    dw 8;
    dw 122;

    dw 20;
    dw 8;
    dw 126;

    dw 24;
    dw 8;
    dw 130;

    dw 28;
    dw 8;
    dw 134;

    dw 32;
    dw 8;
    dw 138;

    dw 16;
    dw 74;
    dw 166;

    dw 20;
    dw 78;
    dw 174;

    dw 24;
    dw 82;
    dw 182;

    dw 28;
    dw 86;
    dw 190;

    dw 32;
    dw 90;
    dw 198;

    dw 146;
    dw 74;
    dw 206;

    dw 150;
    dw 78;
    dw 214;

    dw 154;
    dw 82;
    dw 222;

    dw 158;
    dw 86;
    dw 230;

    dw 162;
    dw 90;
    dw 238;

    dw 202;
    dw 242;
    dw 246;

    dw 69;
    dw 246;
    dw 250;

    left_assert_eq_offsets_loc:
    dw 36;
    dw 37;
    dw 38;
    dw 39;

    right_assert_eq_offsets_loc:
    dw 4;
    dw 5;
    dw 6;
    dw 7;

    poseidon_ptr_indexes_loc:
}
