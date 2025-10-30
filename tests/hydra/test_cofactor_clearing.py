import garaga.modulo_circuit_structs as structs
from garaga.curves import CURVES, PyFelt
from garaga.modulo_circuit import WriteOps
from hydra.garaga.precompiled_circuits.cofactor_clearing import (
    FastG2CofactorClearing,
    G1CofactorClearing,
    SlowG2CofactorClearing,
)


def test_cofactor_clearing():
    # Initialize circuit
    circuit = FastG2CofactorClearing(name="cofactor_clearing", curve_id=1)

    # Input values
    values = [
        PyFelt(
            3789617024712504402204306620295003375951143917889162928515122476381982967144814366712031831841518399614182231387665,
            CURVES[1].p,
        ),
        PyFelt(
            1467567314213963969852279817989131104935039564231603908576814773321528757289376676761397368853965316423532584391899,
            CURVES[1].p,
        ),
        PyFelt(
            1292375129422168617658520396283100687686347104559592203462491249161639006037671760603453326853098986903549775136448,
            CURVES[1].p,
        ),
        PyFelt(
            306655960768766438834866368706782505873384691666290681181893693450298456233972904889955517117016529975705729523733,
            CURVES[1].p,
        ),
    ]

    # Write struct and get coordinates
    px0, px1, py0, py1 = circuit.write_struct(
        structs.G2PointCircuit("G2", values), WriteOps.INPUT
    )

    # Run cofactor clearing
    result = circuit.clear_cofactor(([px0, px1], [py0, py1]))
    print(result)

    # Assert x coordinates
    assert (
        result[0][0].emulated_felt.value
        == 3553105769882656599146811322193073462254184878577379981354181602459568891247079537874757677386646278295787021209189
    )
    assert (
        result[0][1].emulated_felt.value
        == 214383232028397026483172293507406653308736549333914058501039576182920645751681896937109061242049824624418352241545
    )

    # Assert y coordinates
    assert (
        result[1][0].emulated_felt.value
        == 3739747178790495019675321498823208242976352322769291665915571365507822310651678949551185523146598688776619260961478
    )
    assert (
        result[1][1].emulated_felt.value
        == 2892856738085945244799268348340138656888776287206503012318583837503972113824639536543638524553710065178322083313320
    )

    # Test slow cofactor clearing produces same results
    slow_circuit = SlowG2CofactorClearing(name="slow_co_clear", curve_id=1)

    # Write struct and get coordinates
    slow_px0, slow_px1, slow_py0, slow_py1 = slow_circuit.write_struct(
        structs.G2PointCircuit("G2", values), WriteOps.INPUT
    )

    # Run slow cofactor clearing
    slow_result = slow_circuit.clear_cofactor(
        ([slow_px0, slow_px1], [slow_py0, slow_py1])
    )

    # Assert results match fast implementation
    assert slow_result[0][0].emulated_felt.value == result[0][0].emulated_felt.value
    assert slow_result[0][1].emulated_felt.value == result[0][1].emulated_felt.value
    assert slow_result[1][0].emulated_felt.value == result[1][0].emulated_felt.value
    assert slow_result[1][1].emulated_felt.value == result[1][1].emulated_felt.value


def test_cofactor_clearing_g1():
    circuit = G1CofactorClearing(name="cofactor_clearing", curve_id=1)
    val_x = circuit.write_element(
        circuit.field(
            3789617024712504402204306620295003375951143917889162928515122476381982967144814366712031831841518399614182231387665
        )
    )

    val_y = circuit.write_element(
        circuit.field(
            1292375129422168617658520396283100687686347104559592203462491249161639006037671760603453326853098986903549775136448
        )
    )

    x, y = circuit.clear_cofactor((val_x, val_y))
    assert (
        x.emulated_felt.value
        == 124653168926536040050712523694358620626733702681766514335826706855268535061758110145263289951074346182616444645930
    )
    assert (
        y.emulated_felt.value
        == 1763117104256928975303050316870512727100973588519940064853641891041664131774050255702157308774582078610333186925605
    )
