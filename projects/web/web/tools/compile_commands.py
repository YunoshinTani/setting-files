"""Generate a local clangd database for Web CGIs; never build or publish anything."""
import argparse
import json
import os
from pathlib import Path
import re
import shlex
import shutil
import subprocess
import sys
import tempfile


def run(arguments, **options):
    compiler_env = {**os.environ, "LC_ALL": "C", "LANG": "C"}
    result = subprocess.run(arguments, capture_output=True, timeout=30, env=compiler_env, **options)
    if result.returncode:
        raise ValueError(result.stderr.decode("utf-8", "replace").strip())
    return result


def compiler_path(explicit, name):
    if explicit:
        candidate = Path(shutil.which(explicit) or explicit)
    elif os.name == "nt":
        # These CGIs use POSIX APIs; UCRT/MinGW is not equivalent to MSYS2 usr GCC.
        candidate = Path(os.environ.get("MSYS2_ROOT", "C:/msys64")) / "usr/bin" / (name + ".exe")
    else:
        candidate = Path(shutil.which(name) or name)
    if not candidate.is_file():
        raise ValueError(f"Compiler not found: {candidate}. Install GCC or specify --cc/--cxx.")
    return candidate.resolve()


def system_flags(compiler, language):
    target = run([str(compiler), "-dumpmachine"]).stdout.decode().strip()
    result = run([str(compiler), "-E", "-x", language, "-v", "-"], input=b"")
    directories = []
    active = False
    for line in result.stderr.decode("utf-8", "replace").splitlines():
        if "#include <...> search starts here:" in line:
            active = True
            continue
        if active and "End of search list." in line:
            break
        if not active:
            continue
        name = line.strip().removesuffix(" (framework directory)")
        if os.name == "nt" and name.startswith("/"):
            cygpath = compiler.parent / "cygpath.exe"
            if not cygpath.is_file():
                raise ValueError("MSYS2 path conversion requires cygpath.exe beside GCC")
            name = run([str(cygpath), "-m", name]).stdout.decode("utf-8").strip()
        path = Path(name).resolve()
        if not path.is_dir():
            raise ValueError("Compiler reported a missing system header directory: " + str(path))
        directories.append(path.as_posix())
    if not re.fullmatch(r"[A-Za-z0-9_.-]+", target) or not directories:
        raise ValueError("Could not detect GCC target or system headers")
    # Clang-specific analysis flags: GCC itself is not invoked with --target.
    return ["--target=" + target, *[flag for path in directories for flag in ("-isystem", path)]]


def make_flags(makefile, variable):
    values = []
    assigned = False
    text = makefile.read_text(encoding="utf-8").replace("\\\n", " ")
    for line in text.splitlines():
        match = re.match(r"^" + variable + r"\s*(\+=|:=|\?=|=)\s*(.*)$", line)
        if not match:
            continue
        value = match.group(2)
        if "$" in value or "`" in value:
            raise ValueError(f"{makefile}: use explicit {variable} flags for clangd generation")
        if match.group(1) == "?=" and assigned:
            continue
        tokens = shlex.split(value, comments=True)
        if match.group(1) == "+=":
            values += tokens
        else:
            values = tokens
        assigned = True
    return values


def generate(root, cc, cxx):
    web = root / "web"
    if not web.is_dir():
        raise ValueError("Workspace must contain web/ with the CGI Makefiles")
    c_flags, cpp_flags = system_flags(cc, "c"), system_flags(cxx, "c++")
    records = []
    for site in sorted(web.iterdir()):
        makefile = site / "Makefile"
        if not makefile.is_file() or not (site / "src").is_dir():
            continue
        includes = make_flags(makefile, "CPPFLAGS")
        for source in sorted((site / "src").iterdir()):
            if source.suffix not in (".c", ".cc", ".cpp", ".cxx"):
                continue
            is_c = source.suffix == ".c"
            flags = make_flags(makefile, "CFLAGS" if is_c else "CXXFLAGS")
            if not flags:
                raise ValueError("Missing language flags in " + str(makefile))
            local = ["-Iapp"] if os.name == "nt" and (site / "app/crypt.h").is_file() else []
            output = site / "build" / (source.stem + ".o")
            records.append({"directory": site.as_posix(), "file": source.as_posix(),
                            "arguments": [(cc if is_c else cxx).as_posix(),
                                          *(c_flags if is_c else cpp_flags), *includes, *local, *flags,
                                          "-c", source.as_posix(), "-o", output.as_posix()]})
    unit = web / "tests/common_test.cc"
    if unit.is_file() and (web / "share/Makefile").is_file():
        records.append({"directory": web.as_posix(), "file": unit.as_posix(),
                        "arguments": [cxx.as_posix(), *cpp_flags, "-Icommon/include", "-Ishare/include",
                                      *(["-Ishare/app"] if os.name == "nt" else []),
                                      *make_flags(web / "share/Makefile", "CXXFLAGS"), "-c", unit.as_posix()]})
    if not records:
        raise ValueError("No CGI C/C++ source files found")
    target = root / "compile_commands.json"
    contents = (json.dumps(records, indent=2, ensure_ascii=False) + "\n").encode("utf-8")
    descriptor, name = tempfile.mkstemp(prefix=".compile-commands-", dir=root)
    try:
        with os.fdopen(descriptor, "wb") as output:
            output.write(contents)
        os.replace(name, target)
    finally:
        Path(name).unlink(missing_ok=True)
    print(f"Updated {target}: {len(records)} translation units. No binaries or server changes.")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--workspace", type=Path, default=Path(__file__).resolve().parents[2])
    parser.add_argument("--cc", help="POSIX GCC C compiler")
    parser.add_argument("--cxx", help="POSIX GCC C++ compiler")
    args = parser.parse_args()
    try:
        generate(args.workspace.resolve(), compiler_path(args.cc, "gcc"), compiler_path(args.cxx, "g++"))
    except (OSError, ValueError, subprocess.SubprocessError) as error:
        print("clangd configuration error: " + str(error), file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
