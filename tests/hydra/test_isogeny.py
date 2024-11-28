from garaga.modulo_circuit import WriteOps
from hydra.garaga.precompiled_circuits.isogeny import IsogenyG2


def test_isogeny_g2():
    # Initialize circuit
    circuit = IsogenyG2("isogeny", 1)  # BLS12-381

    # Input coordinates
    field_x = circuit.write_elements(
        [
            circuit.field(
                169519152402139697623491793754012113789032894758910773796231348501731795490199910990796174115277871812568749679080
            ),
            circuit.field(
                1728095456082680609005278389175634228411286941580472237217092659287996601824281397719739792814994738024437208024916
            ),
        ],
        WriteOps.INPUT,
    )

    field_y = circuit.write_elements(
        [
            circuit.field(
                921899175962300040840420456901482071750200770271137541308616448315528969776376924836021205171957295791079922974103
            ),
            circuit.field(
                3684633599184560222490700115577520911020962810206788383522966831012065752604210815152740734710545831758791724608234
            ),
        ],
        WriteOps.INPUT,
    )

    # Run isogeny calculation
    x_affine, y_affine = circuit.run_isogeny_g2(field_x, field_y)

    # Expected values for x_affine coordinates
    expected_x = [
        3789617024712504402204306620295003375951143917889162928515122476381982967144814366712031831841518399614182231387665,
        1467567314213963969852279817989131104935039564231603908576814773321528757289376676761397368853965316423532584391899,
    ]

    # Expected values for y_affine coordinates
    expected_y = [
        1292375129422168617658520396283100687686347104559592203462491249161639006037671760603453326853098986903549775136448,
        306655960768766438834866368706782505873384691666290681181893693450298456233972904889955517117016529975705729523733,
    ]

    # Assert x coordinates match
    assert len(x_affine) == 2, "Expected x_affine to have 2 coordinates"
    assert (
        x_affine[0].emulated_felt.value == expected_x[0]
    ), "First x coordinate doesn't match"
    assert (
        x_affine[1].emulated_felt.value == expected_x[1]
    ), "Second x coordinate doesn't match"

    # Assert y coordinates match
    assert len(y_affine) == 2, "Expected y_affine to have 2 coordinates"
    assert (
        y_affine[0].emulated_felt.value == expected_y[0]
    ), "First y coordinate doesn't match"
    assert (
        y_affine[1].emulated_felt.value == expected_y[1]
    ), "Second y coordinate doesn't match"
