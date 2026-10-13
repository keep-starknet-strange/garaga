import random
from types import SimpleNamespace

import pytest
from garaga.precompiled_circuits import all_circuits as generator

FAMILIES = sorted({info["filename"] for info in generator.ALL_CAIRO_CIRCUITS.values()})


@pytest.fixture(scope="module")
def full_generation(tmp_path_factory):
    output = tmp_path_factory.mktemp("full-circuits")
    random_state = random.getstate()
    try:
        with pytest.MonkeyPatch.context() as patch:
            patch.setattr(
                generator, "format_cairo_files_in_parallel", lambda *args: None
            )
            random.seed(0)
            generator.main(str(output) + "/", generator.ALL_CAIRO_CIRCUITS)
    finally:
        random.setstate(random_state)
    return {path.stem: path.read_bytes() for path in output.glob("*.cairo")}


@pytest.fixture(autouse=True)
def preserve_random_state():
    random_state = random.getstate()
    yield
    random.setstate(random_state)


@pytest.mark.parametrize(
    "families", [[family] for family in FAMILIES] + [["rsa", "ec", "rsa"]]
)
def test_selected_families_match_full_generation_and_preserve_neighbors(
    monkeypatch, tmp_path, full_generation, families
):
    for family, content in full_generation.items():
        (tmp_path / f"{family}.cairo").write_bytes(content)
    before = {
        path: (path.read_bytes(), path.stat().st_mtime_ns)
        for path in tmp_path.glob("*.cairo")
    }
    formatted = []
    compiled = []
    compile_circuit = generator.compile_circuit

    def compile_selected(curve_id, circuit_class, params, mode):
        compiled.append((curve_id, circuit_class, params))
        return compile_circuit(curve_id, circuit_class, params, mode)

    def format_file(command, **kwargs):
        assert kwargs == {"check": True}
        assert command[:2] == ["scarb", "fmt"]
        formatted.append(command[2])

    monkeypatch.setattr(generator, "subprocess", SimpleNamespace(run=format_file))
    monkeypatch.setattr(generator, "compile_circuit", compile_selected)
    random.seed(0)
    generator.main(str(tmp_path) + "/", generator.ALL_CAIRO_CIRCUITS, only=families)

    assert compiled == [
        (curve_id, info["class"], info["params"])
        for info in generator.ALL_CAIRO_CIRCUITS.values()
        if info["filename"] in families
        for curve_id in info.get(
            "curve_ids", [generator.CurveID.BN254, generator.CurveID.BLS12_381]
        )
    ]
    assert formatted == [
        str(tmp_path / f"{family}.cairo") for family in sorted(set(families))
    ]
    for path, (content, modified_time) in before.items():
        assert path.read_bytes() == content
        if path.stem not in families:
            assert path.stat().st_mtime_ns == modified_time


@pytest.mark.parametrize("families", [[], ["unknown"], ["ec", "unknown"]])
def test_invalid_families_leave_outputs_untouched(tmp_path, families):
    existing = tmp_path / "ec.cairo"
    existing.write_text("Keep this file.\n")
    before = (existing.read_bytes(), existing.stat().st_mtime_ns)

    with pytest.raises(ValueError, match="Select circuit families from"):
        generator.main(str(tmp_path) + "/", generator.ALL_CAIRO_CIRCUITS, only=families)
    assert list(tmp_path.iterdir()) == [existing]
    assert (existing.read_bytes(), existing.stat().st_mtime_ns) == before

    missing = tmp_path / "missing"
    with pytest.raises(ValueError, match="Select circuit families from"):
        generator.main(str(missing) + "/", generator.ALL_CAIRO_CIRCUITS, only=families)
    assert not missing.exists()


@pytest.mark.parametrize(
    ("arguments", "families"),
    [
        ([], None),
        (["--only", "ec"], ["ec"]),
        (["--only", "ec", "rsa"], ["ec", "rsa"]),
        (["--only", "ec", "--only", "rsa"], ["ec", "rsa"]),
    ],
)
def test_cli_selects_families_and_preserves_default(monkeypatch, arguments, families):
    calls = []
    monkeypatch.setattr(generator, "main", lambda **kwargs: calls.append(kwargs))
    generator.cli(arguments)

    assert calls == [
        {
            "PRECOMPILED_CIRCUITS_DIR": "src/src/circuits/",
            "CIRCUITS_TO_COMPILE": generator.ALL_CAIRO_CIRCUITS,
            "compilation_mode": 1,
            "only": families,
        }
    ]


@pytest.mark.parametrize(
    "arguments", [["--only", "unknown"], ["--only", "ec", "unknown"], ["--only"]]
)
def test_cli_rejects_invalid_families_before_generation(
    monkeypatch, tmp_path, arguments
):
    monkeypatch.chdir(tmp_path)
    monkeypatch.setattr(
        generator, "main", lambda **kwargs: pytest.fail("Generation ran")
    )

    with pytest.raises(SystemExit) as error:
        generator.cli(arguments)
    assert error.value.code == 2
    assert not (tmp_path / "src").exists()
