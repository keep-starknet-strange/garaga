use garaga::definitions::u384;
use garaga::hashes::poseidon_hash_2_bn254;
use mutator_set::mutator_set_contract::{
    IMutatorSetContractDispatcher, IMutatorSetContractDispatcherTrait,
};
// use mutator_set::IMutatorSetContractSafeDispatcher;

use snforge_std::{ContractClassTrait, DeclareResultTrait, declare};
use starknet::ContractAddress;

fn deploy_contract(name: ByteArray) -> ContractAddress {
    let contract = declare(name).unwrap().contract_class();
    let (contract_address, _) = contract.deploy(@ArrayTrait::new()).unwrap();
    contract_address
}

#[test]
fn test_poseidon_hash_2_bn254() {
    let first_leaf: u256 = 'hello_world';
    let first_leaf_u384: u384 = first_leaf.into();
    let _ = poseidon_hash_2_bn254(
        first_leaf_u384, u384 { limb0: 42, limb1: 0, limb2: 0, limb3: 0 },
    );
}


#[test]
fn test_append_leaf_aocl() {
    let contract_address = deploy_contract("MutatorSetContract");

    let dispatcher = IMutatorSetContractDispatcher { contract_address };

    // Initial state (1 leaf)
    let n_leaves_aocl_before = dispatcher.get_n_leaves_aocl();
    let peaks_before = dispatcher.get_peaks_aocl();
    let n_peaks_before = dispatcher.get_n_peaks_aocl();
    assert(n_leaves_aocl_before == 1, 'Invalid n_leaves_aocl');
    assert(n_peaks_before == 1, 'Invalid n_peaks');
    assert(peaks_before == array![0], 'Invalid peaks_before');

    // Append second leaf
    dispatcher.append_leaf_aocl(0);
    // println!("Appended second leaf");
    let n_leaves_aocl_after = dispatcher.get_n_leaves_aocl();
    let n_peaks_after = dispatcher.get_n_peaks_aocl();
    assert(n_leaves_aocl_after == 2, 'Invalid n_leaves_aocl');
    assert(n_peaks_after == 1, 'Invalid n_peaks');
    let peaks_after = dispatcher.get_peaks_aocl();
    assert(
        peaks_after == array![0x2098f5fb9e239eab3ceac3f27b81e481dc3124d55ffed523a839ee8446b64864],
        'Invalid peaks_after',
    );

    // Append third leaf
    dispatcher.append_leaf_aocl(0);
    // println!("Appended third leaf");

    let n_leaves_aocl_after = dispatcher.get_n_leaves_aocl();
    let n_peaks_after = dispatcher.get_n_peaks_aocl();
    assert(n_leaves_aocl_after == 3, 'Invalid n_leaves_aocl');
    assert(n_peaks_after == 2, 'Invalid n_peaks');

    let peaks_after = dispatcher.get_peaks_aocl();
    assert(
        peaks_after == array![
            0x2098f5fb9e239eab3ceac3f27b81e481dc3124d55ffed523a839ee8446b64864, 0,
        ],
        'Invalid peaks_after',
    );

    // Append 4th leaf :

    // println!("---Appending leaf {}----", 4);
    dispatcher.append_leaf_aocl(0);
    let n_leaves_aocl_after = dispatcher.get_n_leaves_aocl();
    assert(n_leaves_aocl_after == 4, 'Invalid n_leaves_aocl');
    let n_peaks_after = dispatcher.get_n_peaks_aocl();
    assert(n_peaks_after == 1, 'Invalid n_peaks_4');
    let peaks_after = dispatcher.get_peaks_aocl();

    assert(
        peaks_after == array![0x1069673dcdb12263df301a6ff584a7ec261a44cb9dc68df067a4774460b1f1e1],
        'Invalid peaks_after_4',
    );

    // println!("---Appending leaf 5----");
    dispatcher.append_leaf_aocl(0);
    let n_leaves_aocl_after = dispatcher.get_n_leaves_aocl();
    assert(n_leaves_aocl_after == 5, 'Invalid n_leaves_aocl');
    let n_peaks_after = dispatcher.get_n_peaks_aocl();
    assert(n_peaks_after == 2, 'Invalid n_peaks_5');
    let peaks_after = dispatcher.get_peaks_aocl();

    assert_eq!(
        peaks_after, array![0x1069673dcdb12263df301a6ff584a7ec261a44cb9dc68df067a4774460b1f1e1, 0],
    );

    for _ in 6..14_usize {
        // println!("Appending leaf {}", i);
        dispatcher.append_leaf_aocl(0);
        // let n_leaves_aocl_after = dispatcher.get_n_leaves_aocl();
    // println!("       LOOP: n_leaves_aocl: {}", n_leaves_aocl_after);
    }

    let n_leaves_aocl_after = dispatcher.get_n_leaves_aocl();
    let n_peaks_after = dispatcher.get_n_peaks_aocl();
    assert(n_leaves_aocl_after == 13, 'Invalid n_leaves_aocl');
    assert(n_peaks_after == 3, 'Invalid n_peaks');

    let peaks_after = dispatcher.get_peaks_aocl();

    assert(
        peaks_after == array![
            0x18f43331537ee2af2e3d758d50f72106467c6eea50371dd528d57eb2b856d238,
            0x1069673dcdb12263df301a6ff584a7ec261a44cb9dc68df067a4774460b1f1e1, 0,
        ],
        'Invalid peaks_after',
    );
}
// #[test]
// #[feature("safe_dispatcher")]
// fn test_cannot_increase_balance_with_zero_value() {
//     let contract_address = deploy_contract("HelloStarknet");

//     let safe_dispatcher = IHelloStarknetSafeDispatcher { contract_address };

//     let balance_before = safe_dispatcher.get_balance().unwrap();
//     assert(balance_before == 0, 'Invalid balance');

//     match safe_dispatcher.increase_balance(0) {
//         Result::Ok(_) => core::panic_with_felt252('Should have panicked'),
//         Result::Err(panic_data) => {
//             assert(*panic_data.at(0) == 'Amount cannot be 0', *panic_data.at(0));
//         },
//     };
// }


