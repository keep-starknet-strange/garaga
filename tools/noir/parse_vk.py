import pathlib
from dataclasses import dataclass
from typing import List, Tuple

# VerificationKey(const uint64_t circuit_size,
#                 const uint64_t num_public_inputs,
#                 const uint64_t pub_inputs_offset,
#                 const Commitment& q_m,
#                 const Commitment& q_c,
#                 const Commitment& q_l,
#                 const Commitment& q_r,
#                 const Commitment& q_o,
#                 const Commitment& q_4,
#                 const Commitment& q_arith,
#                 const Commitment& q_delta_range,
#                 const Commitment& q_elliptic,
#                 const Commitment& q_aux,
#                 const Commitment& q_lookup,
#                 const Commitment& sigma_1,
#                 const Commitment& sigma_2,
#                 const Commitment& sigma_3,
#                 const Commitment& sigma_4,
#                 const Commitment& id_1,
#                 const Commitment& id_2,
#                 const Commitment& id_3,
#                 const Commitment& id_4,
#                 const Commitment& table_1,
#                 const Commitment& table_2,
#                 const Commitment& table_3,
#                 const Commitment& table_4,
#                 const Commitment& lagrange_first,
#                 const Commitment& lagrange_last)

#             MSGPACK_FIELDS(circuit_size,
#                    log_circuit_size,
#                    num_public_inputs,
#                    pub_inputs_offset,
#                    q_m,
#                    q_c,
#                    q_l,
#                    q_r,
#                    q_o,
#                    q_4,
#                    q_arith,
#                    q_delta_range,
#                    q_elliptic,
#                    q_aux,
#                    q_lookup,
#                    sigma_1,
#                    sigma_2,
#                    sigma_3,
#                    sigma_4,
#                    id_1,
#                    id_2,
#                    id_3,
#                    id_4,
#                    table_1,
#                    table_2,
#                    table_3,
#                    table_4,
#                    lagrange_first,
#                    lagrange_last);
# };


@dataclass
class VerificationKey:
    circuit_size: int
    log_circuit_size: int
    num_public_inputs: int
    pub_inputs_offset: int
    q_m: int
    # Add other fields as needed

    @classmethod
    def from_file(cls, path: pathlib.Path) -> "VerificationKey":
        with open(path, "rb") as f:  # Open the file in binary mode
            data = f.read()

        print(f"data: {data.hex()}")

        byte_size_map: List[Tuple[str, int]] = [
            ("circuit_size", 8),
            ("log_circuit_size", 8),
            ("num_public_inputs", 8),
            ("pub_inputs_offset", 8),
            ("q_m", 64),
            ("q_c", 64),
            ("q_l", 64),
            ("q_r", 64),
            ("q_o", 64),
            ("q_4", 64),
            ("q_arith", 64),
            ("q_delta_range", 64),
            ("q_elliptic", 64),
            ("q_aux", 64),
            # Add other fields as needed
        ]

        offset = 0
        field_values = {}
        # for field_name, size in byte_size_map:
        #     print(f"field_name: {field_name}, size: {size}")
        #     if size == 64:
        #         x = int.from_bytes(data[offset : offset + 32], byteorder="big")
        #         field = get_base_field(CurveID.GRUMPKIN.value)
        #         a = CURVES[CurveID.GRUMPKIN.value].a
        #         b = CURVES[CurveID.GRUMPKIN.value].b
        #         rhs: PyFelt = field(x) ** 3 + a * x + b

        #         # assert (
        #         #     rhs.is_quad_residue()
        #         # ), f"x: {x} is not a valid x-coordinate on curve {CurveID.BN254}"
        #         y = int.from_bytes(data[offset + 32 : offset + 64], byteorder="big")
        #         pt = G1Point(x, y, CurveID.GRUMPKIN)
        #         print(f"pt: {pt}")
        #         field_values[field_name] = pt
        #     else:
        #         field_values[field_name] = int.from_bytes(
        #             data[offset : offset + size], byteorder="big"
        #         )
        #     offset += size

        return cls(**field_values)


def main():
    path = pathlib.Path(__file__).parent / "hello" / "target" / "vk"

    print(path)
    vk = VerificationKey.from_file(path)
    print(vk)


if __name__ == "__main__":
    main()
