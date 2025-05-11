code = ""
for i in range(72):
    code += f"let (u1, u2, v1, v2, selector_{i}) = selectors::_extract_and_calculate_selector_bit_inlined(u1, u2, v1, v2);\n"
    code += f"let Q{71 - i} = *Bs[upcast(selector_{i})];\n"

print(code)
