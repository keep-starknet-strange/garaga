use super::mmr::leaf_index_to_mt_index_and_peak_index;

#[test]
fn test_leaf_index_to_mt_index_and_peak_index() {
    // 1 leaf
    let (mt_index, peak_index) = leaf_index_to_mt_index_and_peak_index(0, 1);
    assert(mt_index == 1, "1 leaf mt_index should be 1");
    assert(peak_index == 0, "1 leaf peak_index should be 0");

    // 2 leafs
    let (mt_index, peak_index) = leaf_index_to_mt_index_and_peak_index(0, 2);
    assert(mt_index == 2, "2 leafs - first leaf mt_index should be 2");
    assert(peak_index == 0, "2 leafs - first leaf peak_index should be 0");
    let (mt_index, peak_index) = leaf_index_to_mt_index_and_peak_index(1, 2);
    assert(mt_index == 3, "2 leafs - second leaf mt_index should be 3");
    assert(peak_index == 0, "2 leafs - second leaf peak_index should be 0");

    // 3 leafs
    let (mt_index, peak_index) = leaf_index_to_mt_index_and_peak_index(0, 3);
    assert(mt_index == 2, "3 leafs - first leaf mt_index should be 2");
    assert(peak_index == 0, "3 leafs - first leaf peak_index should be 0");
    let (mt_index, peak_index) = leaf_index_to_mt_index_and_peak_index(1, 3);
    assert(mt_index == 3, "3 leafs - second leaf mt_index should be 3");
    assert(peak_index == 0, "3 leafs - second leaf peak_index should be 0");
    let (mt_index, peak_index) = leaf_index_to_mt_index_and_peak_index(2, 3);
    assert(mt_index == 1, "3 leafs - third leaf mt_index should be 1");
    assert(peak_index == 1, "3 leafs - third leaf peak_index should be 1");

    // 4 leafs
    let (mt_index, peak_index) = leaf_index_to_mt_index_and_peak_index(0, 4);
    assert(mt_index == 4, "4 leafs - first leaf mt_index should be 4");
    assert(peak_index == 0, "4 leafs - first leaf peak_index should be 0");
    let (mt_index, peak_index) = leaf_index_to_mt_index_and_peak_index(1, 4);
    assert(mt_index == 5, "4 leafs - second leaf mt_index should be 5");
    assert(peak_index == 0, "4 leafs - second leaf peak_index should be 0");
    let (mt_index, peak_index) = leaf_index_to_mt_index_and_peak_index(2, 4);
    assert(mt_index == 6, "4 leafs - third leaf mt_index should be 6");
    assert(peak_index == 0, "4 leafs - third leaf peak_index should be 0");
    let (mt_index, peak_index) = leaf_index_to_mt_index_and_peak_index(3, 4);
    assert(mt_index == 7, "4 leafs - fourth leaf mt_index should be 7");
    assert(peak_index == 0, "4 leafs - fourth leaf peak_index should be 0");

    // 14 leafs
    let (mt_index, peak_index) = leaf_index_to_mt_index_and_peak_index(0, 14);
    assert(mt_index == 8, "14 leafs - first leaf mt_index should be 8");
    assert(peak_index == 0, "14 leafs - first leaf peak_index should be 0");
    let (mt_index, peak_index) = leaf_index_to_mt_index_and_peak_index(7, 14);
    assert(mt_index == 15, "14 leafs - eighth leaf mt_index should be 15");
    assert(peak_index == 0, "14 leafs - eighth leaf peak_index should be 0");
    let (mt_index, peak_index) = leaf_index_to_mt_index_and_peak_index(8, 14);
    assert(mt_index == 4, "14 leafs - ninth leaf mt_index should be 4");
    assert(peak_index == 1, "14 leafs - ninth leaf peak_index should be 1");

    // 32 leafs
    for i in 0..32 {
        let (mt_index, peak_index) = leaf_index_to_mt_index_and_peak_index(i, 32);
        assert(mt_index == 32 + i, "32 leafs - mt_index should be 32 + i");
        assert(peak_index == 0, "32 leafs - peak_index should be 0");
    }

    // 33 leafs
    for i in 0..32 {
        let (mt_index, peak_index) = leaf_index_to_mt_index_and_peak_index(i, 33);
        assert(mt_index == 32 + i, "33 leafs - first 32 leaves mt_index should be 32 + i");
        assert(peak_index == 0, "33 leafs - first 32 leaves peak_index should be 0");
    }
    let (mt_index, peak_index) = leaf_index_to_mt_index_and_peak_index(32, 33);
    assert(mt_index == 1, "33 leafs - last leaf mt_index should be 1");
    assert(peak_index == 1, "33 leafs - last leaf peak_index should be 1");

    // 34 leafs
    for i in 0..32 {
        let (mt_index, peak_index) = leaf_index_to_mt_index_and_peak_index(i, 34);
        assert(mt_index == 32 + i, "34 leafs - first 32 leaves mt_index should be 32 + i");
        assert(peak_index == 0, "34 leafs - first 32 leaves peak_index should be 0");
    }
    let (mt_index, peak_index) = leaf_index_to_mt_index_and_peak_index(32, 34);
    assert(mt_index == 2, "34 leafs - 33rd leaf mt_index should be 2");
    assert(peak_index == 1, "34 leafs - 33rd leaf peak_index should be 1");
    let (mt_index, peak_index) = leaf_index_to_mt_index_and_peak_index(33, 34);
    assert(mt_index == 3, "34 leafs - 34th leaf mt_index should be 3");
    assert(peak_index == 1, "34 leafs - 34th leaf peak_index should be 1");
}
