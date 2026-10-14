import json
import random
from concurrent.futures import ThreadPoolExecutor
from types import SimpleNamespace

import pytest
from garaga.starknet.tests_and_calldata_generators import test_writer as writer


@pytest.fixture(autouse=True)
def preserve_random_state():
    state = random.getstate()
    yield
    random.setstate(state)


@pytest.mark.parametrize("fail", [False, True])
def test_all_tests_owns_and_closes_one_shared_pool(monkeypatch, tmp_path, fail):
    monkeypatch.chdir(tmp_path)
    output = tmp_path / writer.TESTS_DIR
    output.mkdir(parents=True)
    pools = []
    received = []

    class Pool(ThreadPoolExecutor):
        def __init__(self):
            super().__init__(max_workers=1)
            pools.append(self)

    def write_file(file_path, header, generators, curves, executor, **kwargs):
        received.append(executor)
        assert kwargs == {"seed": 0}
        if fail:
            raise ValueError("Fixture failed")

    def eddsa_file(executor):
        received.append(executor)
        return "EdDSA fixture\n"

    monkeypatch.setattr(writer.concurrent.futures, "ProcessPoolExecutor", Pool)
    monkeypatch.setattr(writer, "write_test_file", write_file)
    monkeypatch.setattr(writer, "generate_eddsa_test_file", eddsa_file)
    monkeypatch.setattr(writer, "generate_rsa_test_file", lambda: "RSA fixture\n")
    monkeypatch.setattr(
        writer, "subprocess", SimpleNamespace(run=lambda *a, **kw: None)
    )

    if fail:
        with pytest.raises(ValueError, match="Fixture failed"):
            writer.write_all_tests()
    else:
        writer.write_all_tests()
        assert (output / "eddsa_tests.cairo").read_text() == "EdDSA fixture\n"
        assert (output / "rsa_tests.cairo").read_text() == "RSA fixture\n"

    assert len(pools) == 1
    assert received == pools * (1 if fail else 6)
    with pytest.raises(RuntimeError, match="cannot schedule"):
        pools[0].submit(lambda: None)


def test_file_writer_preserves_order_and_keeps_shared_pool_open(monkeypatch, tmp_path):
    monkeypatch.setattr(writer, "TESTS_DIR", str(tmp_path))

    def fixture(curve, value, seed):
        return f"{curve}:{value}:{seed}"

    with ThreadPoolExecutor(max_workers=2) as executor:
        writer.write_test_file(
            "first.cairo",
            " header ",
            [(fixture, [(2,), (1,)])],
            [0, 1],
            executor,
            seed=7,
        )
        writer.write_test_file(
            "second.cairo", "second", [(fixture, [(3,)])], [2], executor
        )
        assert executor.submit(lambda: "still open").result() == "still open"

    assert (tmp_path / "first.cairo").read_bytes() == (
        b"header\n0:2:7\n0:1:7\n1:2:7\n1:1:7\n"
    )
    assert (tmp_path / "second.cairo").read_bytes() == b"second\n2:3:0\n"


def test_eddsa_writer_preserves_vector_order_and_keeps_shared_pool_open(
    monkeypatch, tmp_path
):
    monkeypatch.chdir(tmp_path)
    (tmp_path / "tests").mkdir()
    (tmp_path / "tests/ed25519_test_vectors.json").write_text(json.dumps([0, 1, 2, 3]))
    monkeypatch.setattr(
        writer, "generate_test", lambda index, vector: f"{index}:{vector}\n"
    )
    monkeypatch.setattr(
        writer.concurrent.futures,
        "as_completed",
        lambda futures: reversed(list(futures)),
    )

    with ThreadPoolExecutor(max_workers=2) as executor:
        code = writer.generate_eddsa_test_file(executor)
        assert executor.submit(lambda: "still open").result() == "still open"

    assert code.endswith("0:0\n1:2\n")
