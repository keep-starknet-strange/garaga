#!venv/bin/python3
import os


def gen_hints_document(
    root_folder: str,
    repo_base_url: str = "https://github.com/keep-starknet-strange/garaga",
    output_file: str = "docs/hints_document.md",
):
    data = {}
    for dirpath, dirnames, filenames in os.walk(root_folder):
        for filename in filenames:
            if filename.endswith(".cairo"):
                print(f"dirpath: {dirpath}, dirnames: {dirnames}, filename: {filename}")
                file_path = os.path.join(dirpath, filename)
                hints = find_hints(file_path)
                data[file_path] = hints
    print(data.keys())
    with open(output_file, "w") as md_file:
        for filepath, hints in data.items():
            relative_path = os.path.relpath(filepath, root_folder)
            github_file_url = f"{repo_base_url}/blob/main/{root_folder}/{relative_path.replace(os.sep, '/')}"
            md_file.write(f"## File: [{filepath}]({github_file_url})\n\n")
            for func_name, hints_list in hints.items():
                md_file.write(f"### func: {func_name}\n\n")  # Function name as a header
                for hint in hints_list:
                    start_line, end_line = hint["lines"]
                    line_range = f"Lines {start_line}-{end_line}"
                    github_line_url = f"{github_file_url}#L{start_line}-L{end_line}"
                    md_file.write(f"- **[{line_range}]({github_line_url})**\n\n")
                    md_file.write(
                        f"```python\n{hint['content']}\n```\n\n"
                    )  # Hint content in a code block
    return data


def find_hints(cairo_file_path: str):
    def find_function_context(i: int, lines: list):
        while i >= 0 and "func" not in lines[i]:
            i -= 1
        if i >= 0:
            func_line = lines[i]
            name = func_line.split("func")[1]
            name = name.split("(")[0].split("{")[0].strip()
            return name
        else:
            return "Unknown"

    with open(cairo_file_path, "r") as f:
        lines = f.readlines()
        max_index = len(lines) - 1
        i = 0

        res = {}
        while i <= max_index:
            if "%{" in lines[i]:
                if "%}" in lines[i]:
                    # This is a one-line hint
                    hint_content = lines[i].split("%{")[1].split("%}")[0].strip()
                    func_name = find_function_context(i, lines)
                    if func_name not in res:
                        res[func_name] = []
                    res[func_name].append({"lines": (i, i), "content": hint_content})
                    i += 1

                else:
                    hint_start = i
                    func_name = find_function_context(hint_start, lines)
                    hint_content = ""
                    i += 1
                    leading_spaces = len(lines[i]) - len(lines[i].lstrip(" "))

                    while i <= max_index and "%}" not in lines[i]:
                        hint_content += lines[i][leading_spaces:]
                        i += 1
                    hint_end = i
                    if func_name not in res:
                        res[func_name] = []
                    res[func_name].append(
                        {"lines": (hint_start, hint_end), "content": hint_content}
                    )
            else:
                i += 1

        return res


if __name__ == "__main__":
    folder = "src/fustat/"
    gen_hints_document(folder)
