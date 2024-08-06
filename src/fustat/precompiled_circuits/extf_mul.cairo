from starkware.cairo.common.registers import get_fp_and_pc, get_label_location
from modulo_circuit import (
    ExtensionFieldModuloCircuit,
    ModuloCircuit,
    get_void_modulo_circuit,
    get_void_extension_field_modulo_circuit,
)
from definitions import bn, bls

func get_FP12_MUL_circuit(curve_id: felt) -> (circuit: ExtensionFieldModuloCircuit*) {
    if (curve_id == bn.CURVE_ID) {
        return get_BN254_FP12_MUL_circuit();
    }
    if (curve_id == bls.CURVE_ID) {
        return get_BLS12_381_FP12_MUL_circuit();
    }
    return get_void_extension_field_modulo_circuit();
}
func get_BLS12_381_FP12_MUL_circuit() -> (circuit: ExtensionFieldModuloCircuit*) {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    let (constants_ptr: felt*) = get_label_location(constants_ptr_loc);
    let (add_offsets_ptr: felt*) = get_label_location(add_offsets_ptr_loc);
    let (mul_offsets_ptr: felt*) = get_label_location(mul_offsets_ptr_loc);
    let (output_offsets_ptr: felt*) = get_label_location(output_offsets_ptr_loc);
    let (poseidon_indexes_ptr: felt*) = get_label_location(poseidon_indexes_ptr_loc);
    let constants_ptr_len = 3;
    let input_len = 96;
    let commitments_len = 92;
    let witnesses_len = 0;
    let output_len = 48;
    let continuous_output = 1;
    let add_mod_n = 49;
    let mul_mod_n = 70;
    let n_assert_eq = 1;
    let N_Euclidean_equations = 1;
    let name = 'fp12_mul';
    let curve_id = 1;
    local circuit: ExtensionFieldModuloCircuit = ExtensionFieldModuloCircuit(
        constants_ptr,
        add_offsets_ptr,
        mul_offsets_ptr,
        output_offsets_ptr,
        poseidon_indexes_ptr,
        constants_ptr_len,
        input_len,
        commitments_len,
        witnesses_len,
        output_len,
        continuous_output,
        add_mod_n,
        mul_mod_n,
        n_assert_eq,
        N_Euclidean_equations,
        name,
        curve_id,
    );
    return (&circuit,);

    constants_ptr_loc:
    dw 0;
    dw 0;
    dw 0;
    dw 0;
    dw 2;
    dw 0;
    dw 0;
    dw 0;
    dw 54880396502181392957329877673;
    dw 31935979117156477062286671870;
    dw 20826981314825584179608359615;
    dw 8047903782086192180586325942;

    add_offsets_ptr_loc:
    dw 12;  // Eval UnnamedPoly step + (coeff_1 * z^1)
    dw 254;
    dw 258;
    dw 258;  // Eval UnnamedPoly step + (coeff_2 * z^2)
    dw 262;
    dw 266;
    dw 266;  // Eval UnnamedPoly step + (coeff_3 * z^3)
    dw 270;
    dw 274;
    dw 274;  // Eval UnnamedPoly step + (coeff_4 * z^4)
    dw 278;
    dw 282;
    dw 282;  // Eval UnnamedPoly step + (coeff_5 * z^5)
    dw 286;
    dw 290;
    dw 290;  // Eval UnnamedPoly step + (coeff_6 * z^6)
    dw 294;
    dw 298;
    dw 298;  // Eval UnnamedPoly step + (coeff_7 * z^7)
    dw 302;
    dw 306;
    dw 306;  // Eval UnnamedPoly step + (coeff_8 * z^8)
    dw 310;
    dw 314;
    dw 314;  // Eval UnnamedPoly step + (coeff_9 * z^9)
    dw 318;
    dw 322;
    dw 322;  // Eval UnnamedPoly step + (coeff_10 * z^10)
    dw 326;
    dw 330;
    dw 330;  // Eval UnnamedPoly step + (coeff_11 * z^11)
    dw 334;
    dw 338;
    dw 60;  // Eval UnnamedPoly step + (coeff_1 * z^1)
    dw 342;
    dw 346;
    dw 346;  // Eval UnnamedPoly step + (coeff_2 * z^2)
    dw 350;
    dw 354;
    dw 354;  // Eval UnnamedPoly step + (coeff_3 * z^3)
    dw 358;
    dw 362;
    dw 362;  // Eval UnnamedPoly step + (coeff_4 * z^4)
    dw 366;
    dw 370;
    dw 370;  // Eval UnnamedPoly step + (coeff_5 * z^5)
    dw 374;
    dw 378;
    dw 378;  // Eval UnnamedPoly step + (coeff_6 * z^6)
    dw 382;
    dw 386;
    dw 386;  // Eval UnnamedPoly step + (coeff_7 * z^7)
    dw 390;
    dw 394;
    dw 394;  // Eval UnnamedPoly step + (coeff_8 * z^8)
    dw 398;
    dw 402;
    dw 402;  // Eval UnnamedPoly step + (coeff_9 * z^9)
    dw 406;
    dw 410;
    dw 410;  // Eval UnnamedPoly step + (coeff_10 * z^10)
    dw 414;
    dw 418;
    dw 418;  // Eval UnnamedPoly step + (coeff_11 * z^11)
    dw 422;
    dw 426;
    dw 0;  // LHS_acc
    dw 434;
    dw 438;
    dw 156;  // Eval UnnamedPoly step + (coeff_1 * z^1)
    dw 490;
    dw 494;
    dw 494;  // Eval UnnamedPoly step + (coeff_2 * z^2)
    dw 498;
    dw 502;
    dw 502;  // Eval UnnamedPoly step + (coeff_3 * z^3)
    dw 506;
    dw 510;
    dw 510;  // Eval UnnamedPoly step + (coeff_4 * z^4)
    dw 514;
    dw 518;
    dw 518;  // Eval UnnamedPoly step + (coeff_5 * z^5)
    dw 522;
    dw 526;
    dw 526;  // Eval UnnamedPoly step + (coeff_6 * z^6)
    dw 530;
    dw 534;
    dw 534;  // Eval UnnamedPoly step + (coeff_7 * z^7)
    dw 538;
    dw 542;
    dw 542;  // Eval UnnamedPoly step + (coeff_8 * z^8)
    dw 546;
    dw 550;
    dw 550;  // Eval UnnamedPoly step + (coeff_9 * z^9)
    dw 554;
    dw 558;
    dw 558;  // Eval UnnamedPoly step + (coeff_10 * z^10)
    dw 562;
    dw 566;
    dw 4;  // Eval sparse poly UnnamedPoly step + coeff_6 * z^6
    dw 570;
    dw 574;
    dw 574;  // Eval sparse poly UnnamedPoly step + 1*z^12
    dw 250;
    dw 578;
    dw 442;  // Eval UnnamedPoly step + (coeff_1 * z^1)
    dw 582;
    dw 586;
    dw 586;  // Eval UnnamedPoly step + (coeff_2 * z^2)
    dw 590;
    dw 594;
    dw 594;  // Eval UnnamedPoly step + (coeff_3 * z^3)
    dw 598;
    dw 602;
    dw 602;  // Eval UnnamedPoly step + (coeff_4 * z^4)
    dw 606;
    dw 610;
    dw 610;  // Eval UnnamedPoly step + (coeff_5 * z^5)
    dw 614;
    dw 618;
    dw 618;  // Eval UnnamedPoly step + (coeff_6 * z^6)
    dw 622;
    dw 626;
    dw 626;  // Eval UnnamedPoly step + (coeff_7 * z^7)
    dw 630;
    dw 634;
    dw 634;  // Eval UnnamedPoly step + (coeff_8 * z^8)
    dw 638;
    dw 642;
    dw 642;  // Eval UnnamedPoly step + (coeff_9 * z^9)
    dw 646;
    dw 650;
    dw 650;  // Eval UnnamedPoly step + (coeff_10 * z^10)
    dw 654;
    dw 658;
    dw 658;  // Eval UnnamedPoly step + (coeff_11 * z^11)
    dw 662;
    dw 666;
    dw 666;  // None
    dw 0;
    dw 674;
    dw 670;  // None
    dw 674;
    dw 678;
    dw 0;  // None
    dw 678;
    dw 438;

    mul_offsets_ptr_loc:
    dw 205;  // Compute z^2
    dw 205;
    dw 210;
    dw 210;  // Compute z^3
    dw 205;
    dw 214;
    dw 214;  // Compute z^4
    dw 205;
    dw 218;
    dw 218;  // Compute z^5
    dw 205;
    dw 222;
    dw 222;  // Compute z^6
    dw 205;
    dw 226;
    dw 226;  // Compute z^7
    dw 205;
    dw 230;
    dw 230;  // Compute z^8
    dw 205;
    dw 234;
    dw 234;  // Compute z^9
    dw 205;
    dw 238;
    dw 238;  // Compute z^10
    dw 205;
    dw 242;
    dw 242;  // Compute z^11
    dw 205;
    dw 246;
    dw 246;  // Compute z^12
    dw 205;
    dw 250;
    dw 16;  // Eval UnnamedPoly step coeff_1 * z^1
    dw 205;
    dw 254;
    dw 20;  // Eval UnnamedPoly step coeff_2 * z^2
    dw 210;
    dw 262;
    dw 24;  // Eval UnnamedPoly step coeff_3 * z^3
    dw 214;
    dw 270;
    dw 28;  // Eval UnnamedPoly step coeff_4 * z^4
    dw 218;
    dw 278;
    dw 32;  // Eval UnnamedPoly step coeff_5 * z^5
    dw 222;
    dw 286;
    dw 36;  // Eval UnnamedPoly step coeff_6 * z^6
    dw 226;
    dw 294;
    dw 40;  // Eval UnnamedPoly step coeff_7 * z^7
    dw 230;
    dw 302;
    dw 44;  // Eval UnnamedPoly step coeff_8 * z^8
    dw 234;
    dw 310;
    dw 48;  // Eval UnnamedPoly step coeff_9 * z^9
    dw 238;
    dw 318;
    dw 52;  // Eval UnnamedPoly step coeff_10 * z^10
    dw 242;
    dw 326;
    dw 56;  // Eval UnnamedPoly step coeff_11 * z^11
    dw 246;
    dw 334;
    dw 64;  // Eval UnnamedPoly step coeff_1 * z^1
    dw 205;
    dw 342;
    dw 68;  // Eval UnnamedPoly step coeff_2 * z^2
    dw 210;
    dw 350;
    dw 72;  // Eval UnnamedPoly step coeff_3 * z^3
    dw 214;
    dw 358;
    dw 76;  // Eval UnnamedPoly step coeff_4 * z^4
    dw 218;
    dw 366;
    dw 80;  // Eval UnnamedPoly step coeff_5 * z^5
    dw 222;
    dw 374;
    dw 84;  // Eval UnnamedPoly step coeff_6 * z^6
    dw 226;
    dw 382;
    dw 88;  // Eval UnnamedPoly step coeff_7 * z^7
    dw 230;
    dw 390;
    dw 92;  // Eval UnnamedPoly step coeff_8 * z^8
    dw 234;
    dw 398;
    dw 96;  // Eval UnnamedPoly step coeff_9 * z^9
    dw 238;
    dw 406;
    dw 100;  // Eval UnnamedPoly step coeff_10 * z^10
    dw 242;
    dw 414;
    dw 104;  // Eval UnnamedPoly step coeff_11 * z^11
    dw 246;
    dw 422;
    dw 338;  // None
    dw 426;
    dw 430;
    dw 200;  // ci_XY_of_z
    dw 430;
    dw 434;
    dw 200;  // None
    dw 108;
    dw 442;
    dw 200;  // None
    dw 112;
    dw 446;
    dw 200;  // None
    dw 116;
    dw 450;
    dw 200;  // None
    dw 120;
    dw 454;
    dw 200;  // None
    dw 124;
    dw 458;
    dw 200;  // None
    dw 128;
    dw 462;
    dw 200;  // None
    dw 132;
    dw 466;
    dw 200;  // None
    dw 136;
    dw 470;
    dw 200;  // None
    dw 140;
    dw 474;
    dw 200;  // None
    dw 144;
    dw 478;
    dw 200;  // None
    dw 148;
    dw 482;
    dw 200;  // None
    dw 152;
    dw 486;
    dw 160;  // Eval UnnamedPoly step coeff_1 * z^1
    dw 205;
    dw 490;
    dw 164;  // Eval UnnamedPoly step coeff_2 * z^2
    dw 210;
    dw 498;
    dw 168;  // Eval UnnamedPoly step coeff_3 * z^3
    dw 214;
    dw 506;
    dw 172;  // Eval UnnamedPoly step coeff_4 * z^4
    dw 218;
    dw 514;
    dw 176;  // Eval UnnamedPoly step coeff_5 * z^5
    dw 222;
    dw 522;
    dw 180;  // Eval UnnamedPoly step coeff_6 * z^6
    dw 226;
    dw 530;
    dw 184;  // Eval UnnamedPoly step coeff_7 * z^7
    dw 230;
    dw 538;
    dw 188;  // Eval UnnamedPoly step coeff_8 * z^8
    dw 234;
    dw 546;
    dw 192;  // Eval UnnamedPoly step coeff_9 * z^9
    dw 238;
    dw 554;
    dw 196;  // Eval UnnamedPoly step coeff_10 * z^10
    dw 242;
    dw 562;
    dw 8;  // Eval sparse poly UnnamedPoly step coeff_6 * z^6
    dw 226;
    dw 570;
    dw 446;  // Eval UnnamedPoly step coeff_1 * z^1
    dw 205;
    dw 582;
    dw 450;  // Eval UnnamedPoly step coeff_2 * z^2
    dw 210;
    dw 590;
    dw 454;  // Eval UnnamedPoly step coeff_3 * z^3
    dw 214;
    dw 598;
    dw 458;  // Eval UnnamedPoly step coeff_4 * z^4
    dw 218;
    dw 606;
    dw 462;  // Eval UnnamedPoly step coeff_5 * z^5
    dw 222;
    dw 614;
    dw 466;  // Eval UnnamedPoly step coeff_6 * z^6
    dw 226;
    dw 622;
    dw 470;  // Eval UnnamedPoly step coeff_7 * z^7
    dw 230;
    dw 630;
    dw 474;  // Eval UnnamedPoly step coeff_8 * z^8
    dw 234;
    dw 638;
    dw 478;  // Eval UnnamedPoly step coeff_9 * z^9
    dw 238;
    dw 646;
    dw 482;  // Eval UnnamedPoly step coeff_10 * z^10
    dw 242;
    dw 654;
    dw 486;  // Eval UnnamedPoly step coeff_11 * z^11
    dw 246;
    dw 662;
    dw 566;  // None
    dw 578;
    dw 670;

    output_offsets_ptr_loc:
    dw 108;

    poseidon_indexes_ptr_loc:
    dw 220;
}

func get_BN254_FP12_MUL_circuit() -> (circuit: ExtensionFieldModuloCircuit*) {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    let (constants_ptr: felt*) = get_label_location(constants_ptr_loc);
    let (add_offsets_ptr: felt*) = get_label_location(add_offsets_ptr_loc);
    let (mul_offsets_ptr: felt*) = get_label_location(mul_offsets_ptr_loc);
    let (output_offsets_ptr: felt*) = get_label_location(output_offsets_ptr_loc);
    let (poseidon_indexes_ptr: felt*) = get_label_location(poseidon_indexes_ptr_loc);
    let constants_ptr_len = 3;
    let input_len = 96;
    let commitments_len = 92;
    let witnesses_len = 0;
    let output_len = 48;
    let continuous_output = 1;
    let add_mod_n = 49;
    let mul_mod_n = 70;
    let n_assert_eq = 1;
    let N_Euclidean_equations = 1;
    let name = 'fp12_mul';
    let curve_id = 0;
    local circuit: ExtensionFieldModuloCircuit = ExtensionFieldModuloCircuit(
        constants_ptr,
        add_offsets_ptr,
        mul_offsets_ptr,
        output_offsets_ptr,
        poseidon_indexes_ptr,
        constants_ptr_len,
        input_len,
        commitments_len,
        witnesses_len,
        output_len,
        continuous_output,
        add_mod_n,
        mul_mod_n,
        n_assert_eq,
        N_Euclidean_equations,
        name,
        curve_id,
    );
    return (&circuit,);

    constants_ptr_loc:
    dw 0;
    dw 0;
    dw 0;
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
    dw 12;  // Eval UnnamedPoly step + (coeff_1 * z^1)
    dw 254;
    dw 258;
    dw 258;  // Eval UnnamedPoly step + (coeff_2 * z^2)
    dw 262;
    dw 266;
    dw 266;  // Eval UnnamedPoly step + (coeff_3 * z^3)
    dw 270;
    dw 274;
    dw 274;  // Eval UnnamedPoly step + (coeff_4 * z^4)
    dw 278;
    dw 282;
    dw 282;  // Eval UnnamedPoly step + (coeff_5 * z^5)
    dw 286;
    dw 290;
    dw 290;  // Eval UnnamedPoly step + (coeff_6 * z^6)
    dw 294;
    dw 298;
    dw 298;  // Eval UnnamedPoly step + (coeff_7 * z^7)
    dw 302;
    dw 306;
    dw 306;  // Eval UnnamedPoly step + (coeff_8 * z^8)
    dw 310;
    dw 314;
    dw 314;  // Eval UnnamedPoly step + (coeff_9 * z^9)
    dw 318;
    dw 322;
    dw 322;  // Eval UnnamedPoly step + (coeff_10 * z^10)
    dw 326;
    dw 330;
    dw 330;  // Eval UnnamedPoly step + (coeff_11 * z^11)
    dw 334;
    dw 338;
    dw 60;  // Eval UnnamedPoly step + (coeff_1 * z^1)
    dw 342;
    dw 346;
    dw 346;  // Eval UnnamedPoly step + (coeff_2 * z^2)
    dw 350;
    dw 354;
    dw 354;  // Eval UnnamedPoly step + (coeff_3 * z^3)
    dw 358;
    dw 362;
    dw 362;  // Eval UnnamedPoly step + (coeff_4 * z^4)
    dw 366;
    dw 370;
    dw 370;  // Eval UnnamedPoly step + (coeff_5 * z^5)
    dw 374;
    dw 378;
    dw 378;  // Eval UnnamedPoly step + (coeff_6 * z^6)
    dw 382;
    dw 386;
    dw 386;  // Eval UnnamedPoly step + (coeff_7 * z^7)
    dw 390;
    dw 394;
    dw 394;  // Eval UnnamedPoly step + (coeff_8 * z^8)
    dw 398;
    dw 402;
    dw 402;  // Eval UnnamedPoly step + (coeff_9 * z^9)
    dw 406;
    dw 410;
    dw 410;  // Eval UnnamedPoly step + (coeff_10 * z^10)
    dw 414;
    dw 418;
    dw 418;  // Eval UnnamedPoly step + (coeff_11 * z^11)
    dw 422;
    dw 426;
    dw 0;  // LHS_acc
    dw 434;
    dw 438;
    dw 156;  // Eval UnnamedPoly step + (coeff_1 * z^1)
    dw 490;
    dw 494;
    dw 494;  // Eval UnnamedPoly step + (coeff_2 * z^2)
    dw 498;
    dw 502;
    dw 502;  // Eval UnnamedPoly step + (coeff_3 * z^3)
    dw 506;
    dw 510;
    dw 510;  // Eval UnnamedPoly step + (coeff_4 * z^4)
    dw 514;
    dw 518;
    dw 518;  // Eval UnnamedPoly step + (coeff_5 * z^5)
    dw 522;
    dw 526;
    dw 526;  // Eval UnnamedPoly step + (coeff_6 * z^6)
    dw 530;
    dw 534;
    dw 534;  // Eval UnnamedPoly step + (coeff_7 * z^7)
    dw 538;
    dw 542;
    dw 542;  // Eval UnnamedPoly step + (coeff_8 * z^8)
    dw 546;
    dw 550;
    dw 550;  // Eval UnnamedPoly step + (coeff_9 * z^9)
    dw 554;
    dw 558;
    dw 558;  // Eval UnnamedPoly step + (coeff_10 * z^10)
    dw 562;
    dw 566;
    dw 4;  // Eval sparse poly UnnamedPoly step + coeff_6 * z^6
    dw 570;
    dw 574;
    dw 574;  // Eval sparse poly UnnamedPoly step + 1*z^12
    dw 250;
    dw 578;
    dw 442;  // Eval UnnamedPoly step + (coeff_1 * z^1)
    dw 582;
    dw 586;
    dw 586;  // Eval UnnamedPoly step + (coeff_2 * z^2)
    dw 590;
    dw 594;
    dw 594;  // Eval UnnamedPoly step + (coeff_3 * z^3)
    dw 598;
    dw 602;
    dw 602;  // Eval UnnamedPoly step + (coeff_4 * z^4)
    dw 606;
    dw 610;
    dw 610;  // Eval UnnamedPoly step + (coeff_5 * z^5)
    dw 614;
    dw 618;
    dw 618;  // Eval UnnamedPoly step + (coeff_6 * z^6)
    dw 622;
    dw 626;
    dw 626;  // Eval UnnamedPoly step + (coeff_7 * z^7)
    dw 630;
    dw 634;
    dw 634;  // Eval UnnamedPoly step + (coeff_8 * z^8)
    dw 638;
    dw 642;
    dw 642;  // Eval UnnamedPoly step + (coeff_9 * z^9)
    dw 646;
    dw 650;
    dw 650;  // Eval UnnamedPoly step + (coeff_10 * z^10)
    dw 654;
    dw 658;
    dw 658;  // Eval UnnamedPoly step + (coeff_11 * z^11)
    dw 662;
    dw 666;
    dw 666;  // None
    dw 0;
    dw 674;
    dw 670;  // None
    dw 674;
    dw 678;
    dw 0;  // None
    dw 678;
    dw 438;

    mul_offsets_ptr_loc:
    dw 205;  // Compute z^2
    dw 205;
    dw 210;
    dw 210;  // Compute z^3
    dw 205;
    dw 214;
    dw 214;  // Compute z^4
    dw 205;
    dw 218;
    dw 218;  // Compute z^5
    dw 205;
    dw 222;
    dw 222;  // Compute z^6
    dw 205;
    dw 226;
    dw 226;  // Compute z^7
    dw 205;
    dw 230;
    dw 230;  // Compute z^8
    dw 205;
    dw 234;
    dw 234;  // Compute z^9
    dw 205;
    dw 238;
    dw 238;  // Compute z^10
    dw 205;
    dw 242;
    dw 242;  // Compute z^11
    dw 205;
    dw 246;
    dw 246;  // Compute z^12
    dw 205;
    dw 250;
    dw 16;  // Eval UnnamedPoly step coeff_1 * z^1
    dw 205;
    dw 254;
    dw 20;  // Eval UnnamedPoly step coeff_2 * z^2
    dw 210;
    dw 262;
    dw 24;  // Eval UnnamedPoly step coeff_3 * z^3
    dw 214;
    dw 270;
    dw 28;  // Eval UnnamedPoly step coeff_4 * z^4
    dw 218;
    dw 278;
    dw 32;  // Eval UnnamedPoly step coeff_5 * z^5
    dw 222;
    dw 286;
    dw 36;  // Eval UnnamedPoly step coeff_6 * z^6
    dw 226;
    dw 294;
    dw 40;  // Eval UnnamedPoly step coeff_7 * z^7
    dw 230;
    dw 302;
    dw 44;  // Eval UnnamedPoly step coeff_8 * z^8
    dw 234;
    dw 310;
    dw 48;  // Eval UnnamedPoly step coeff_9 * z^9
    dw 238;
    dw 318;
    dw 52;  // Eval UnnamedPoly step coeff_10 * z^10
    dw 242;
    dw 326;
    dw 56;  // Eval UnnamedPoly step coeff_11 * z^11
    dw 246;
    dw 334;
    dw 64;  // Eval UnnamedPoly step coeff_1 * z^1
    dw 205;
    dw 342;
    dw 68;  // Eval UnnamedPoly step coeff_2 * z^2
    dw 210;
    dw 350;
    dw 72;  // Eval UnnamedPoly step coeff_3 * z^3
    dw 214;
    dw 358;
    dw 76;  // Eval UnnamedPoly step coeff_4 * z^4
    dw 218;
    dw 366;
    dw 80;  // Eval UnnamedPoly step coeff_5 * z^5
    dw 222;
    dw 374;
    dw 84;  // Eval UnnamedPoly step coeff_6 * z^6
    dw 226;
    dw 382;
    dw 88;  // Eval UnnamedPoly step coeff_7 * z^7
    dw 230;
    dw 390;
    dw 92;  // Eval UnnamedPoly step coeff_8 * z^8
    dw 234;
    dw 398;
    dw 96;  // Eval UnnamedPoly step coeff_9 * z^9
    dw 238;
    dw 406;
    dw 100;  // Eval UnnamedPoly step coeff_10 * z^10
    dw 242;
    dw 414;
    dw 104;  // Eval UnnamedPoly step coeff_11 * z^11
    dw 246;
    dw 422;
    dw 338;  // None
    dw 426;
    dw 430;
    dw 200;  // ci_XY_of_z
    dw 430;
    dw 434;
    dw 200;  // None
    dw 108;
    dw 442;
    dw 200;  // None
    dw 112;
    dw 446;
    dw 200;  // None
    dw 116;
    dw 450;
    dw 200;  // None
    dw 120;
    dw 454;
    dw 200;  // None
    dw 124;
    dw 458;
    dw 200;  // None
    dw 128;
    dw 462;
    dw 200;  // None
    dw 132;
    dw 466;
    dw 200;  // None
    dw 136;
    dw 470;
    dw 200;  // None
    dw 140;
    dw 474;
    dw 200;  // None
    dw 144;
    dw 478;
    dw 200;  // None
    dw 148;
    dw 482;
    dw 200;  // None
    dw 152;
    dw 486;
    dw 160;  // Eval UnnamedPoly step coeff_1 * z^1
    dw 205;
    dw 490;
    dw 164;  // Eval UnnamedPoly step coeff_2 * z^2
    dw 210;
    dw 498;
    dw 168;  // Eval UnnamedPoly step coeff_3 * z^3
    dw 214;
    dw 506;
    dw 172;  // Eval UnnamedPoly step coeff_4 * z^4
    dw 218;
    dw 514;
    dw 176;  // Eval UnnamedPoly step coeff_5 * z^5
    dw 222;
    dw 522;
    dw 180;  // Eval UnnamedPoly step coeff_6 * z^6
    dw 226;
    dw 530;
    dw 184;  // Eval UnnamedPoly step coeff_7 * z^7
    dw 230;
    dw 538;
    dw 188;  // Eval UnnamedPoly step coeff_8 * z^8
    dw 234;
    dw 546;
    dw 192;  // Eval UnnamedPoly step coeff_9 * z^9
    dw 238;
    dw 554;
    dw 196;  // Eval UnnamedPoly step coeff_10 * z^10
    dw 242;
    dw 562;
    dw 8;  // Eval sparse poly UnnamedPoly step coeff_6 * z^6
    dw 226;
    dw 570;
    dw 446;  // Eval UnnamedPoly step coeff_1 * z^1
    dw 205;
    dw 582;
    dw 450;  // Eval UnnamedPoly step coeff_2 * z^2
    dw 210;
    dw 590;
    dw 454;  // Eval UnnamedPoly step coeff_3 * z^3
    dw 214;
    dw 598;
    dw 458;  // Eval UnnamedPoly step coeff_4 * z^4
    dw 218;
    dw 606;
    dw 462;  // Eval UnnamedPoly step coeff_5 * z^5
    dw 222;
    dw 614;
    dw 466;  // Eval UnnamedPoly step coeff_6 * z^6
    dw 226;
    dw 622;
    dw 470;  // Eval UnnamedPoly step coeff_7 * z^7
    dw 230;
    dw 630;
    dw 474;  // Eval UnnamedPoly step coeff_8 * z^8
    dw 234;
    dw 638;
    dw 478;  // Eval UnnamedPoly step coeff_9 * z^9
    dw 238;
    dw 646;
    dw 482;  // Eval UnnamedPoly step coeff_10 * z^10
    dw 242;
    dw 654;
    dw 486;  // Eval UnnamedPoly step coeff_11 * z^11
    dw 246;
    dw 662;
    dw 566;  // None
    dw 578;
    dw 670;

    output_offsets_ptr_loc:
    dw 108;

    poseidon_indexes_ptr_loc:
    dw 220;
}
