import pytest
from garaga.curves import CurveID, ProofSystem


@pytest.mark.parametrize(
    "proof_system, curve_id",
    [
        (ProofSystem.Groth16, CurveID.BN254),
        (ProofSystem.Groth16, CurveID.BLS12_381),
        (ProofSystem.UltraKeccakZKHonk, CurveID.BN254),
    ],
)
def test_get_proving_system_curve(proof_system: ProofSystem, curve_id: CurveID):
    assert CurveID.get_proving_system_curve(curve_id.value, proof_system) == curve_id


def test_get_proving_system_curve_rejects_unsupported_curve():
    with pytest.raises(ValueError, match="Invalid curve ID for UltraKeccakZKHonk"):
        CurveID.get_proving_system_curve(
            CurveID.BLS12_381.value, ProofSystem.UltraKeccakZKHonk
        )
