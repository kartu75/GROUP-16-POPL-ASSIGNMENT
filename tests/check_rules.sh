#!/usr/bin/env bash

# check_rules.sh
# Statically checks code/<ID>_q1.pl, code/<ID>_q2.pl, code/<ID>_q3.rkt, code/<ID>_q4.rkt

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$REPO_ROOT" || exit 1

exec python3 - "$@" << 'EOF'
import sys
import os
import re
import glob

# Detect group ID
group_id = os.environ.get("GROUP_ID")
if not group_id:
    matches = glob.glob("code/*_q1.pl")
    if matches:
        base = os.path.basename(matches[0])
        group_id = base.split("_")[0]
    else:
        group_id = "16"

if len(sys.argv) > 1:
    target_files = sys.argv[1:]
    explicit = True
else:
    target_files = [
        f"code/{group_id}_q1.pl",
        f"code/{group_id}_q2.pl",
        f"code/{group_id}_q3.rkt",
        f"code/{group_id}_q4.rkt",
    ]
    explicit = False

problems = []

# Prolog forbidden predicates:
# assert, asserta, assertz, retract, b_setval, nb_setval, initialization, halt
PROLOG_FORBIDDEN = [
    "assert", "asserta", "assertz", "retract", "retractall",
    "b_setval", "nb_setval", "initialization", "halt"
]
prolog_pred_regex = re.compile(
    r"(?<![a-zA-Z0-9_])(" + "|".join(re.escape(w) for w in PROLOG_FORBIDDEN) + r")(?![a-zA-Z0-9_])"
)
prolog_allowed_modules = re.compile(r"use_module\s*\(\s*library\s*\(\s*(lists|apply|yall|aggregate)\s*\)")

def check_prolog(filepath):
    try:
        with open(filepath, "r", encoding="utf-8") as f:
            content = f.read()
    except Exception as e:
        problems.append(f"{filepath}:1: could not read file: {e}")
        return

    lines = content.splitlines()
    in_block_comment = False

    for lineno, raw_line in enumerate(lines, start=1):
        clean_chars = []
        i = 0
        n = len(raw_line)
        in_sq = False
        in_dq = False

        while i < n:
            if in_block_comment:
                if raw_line[i:i+2] == "*/":
                    in_block_comment = False
                    i += 2
                else:
                    i += 1
                continue

            c = raw_line[i]
            if c == "'" and not in_dq:
                in_sq = not in_sq
                clean_chars.append(c)
                i += 1
            elif c == '"' and not in_sq:
                in_dq = not in_dq
                clean_chars.append(c)
                i += 1
            elif not in_sq and not in_dq:
                if raw_line[i:i+2] == "/*":
                    in_block_comment = True
                    i += 2
                    continue
                elif c == "%":
                    # Line comment: remainder of line is comment
                    break
                else:
                    clean_chars.append(c)
                    i += 1
            else:
                clean_chars.append(c)
                i += 1

        code_line = "".join(clean_chars)

        # 1. Check forbidden predicates
        for match in prolog_pred_regex.finditer(code_line):
            pred = match.group(1)
            problems.append(f"{filepath}:{lineno}: forbidden Prolog predicate: {pred}")

        # 2. Check use_module of disallowed libraries
        if "use_module" in code_line:
            for um_match in re.finditer(r"use_module\s*\([^)]*\)", code_line):
                call_text = um_match.group(0)
                if not prolog_allowed_modules.search(call_text):
                    problems.append(f"{filepath}:{lineno}: forbidden use_module library (only lists, apply, yall, aggregate allowed)")

# Racket forbidden calls:
# set!, vector, make-hash, hash, string, length, append, reverse, map, filter,
# member, memq, list-ref, list-tail, add1, sub1, equal?, eqv?, list?, for, do,
# printf, displayln, print
RACKET_FORBIDDEN = [
    "set!", "vector", "make-hash", "hash", "string", "length",
    "append", "reverse", "map", "filter", "member", "memq",
    "list-ref", "list-tail", "add1", "sub1", "equal?", "eqv?",
    "list?", "for", "do", "printf", "displayln", "print"
]
rkt_call_patterns = [
    (name, re.compile(r"(?:[\(\[]\s*|\x27)" + re.escape(name) + r"(?=[()\s\[\]{}\";\x27]|$)"))
    for name in RACKET_FORBIDDEN
]

def check_racket(filepath):
    try:
        with open(filepath, "r", encoding="utf-8") as f:
            content = f.read()
    except Exception as e:
        problems.append(f"{filepath}:1: could not read file: {e}")
        return

    lines = content.splitlines()

    # Rule 1: first line is not #lang racket/base
    if not lines or lines[0].strip() != "#lang racket/base":
        problems.append(f"{filepath}:1: first line is not #lang racket/base")

    # Rule 2: forbidden calls on each line (skipping comments and string literals)
    for lineno, raw_line in enumerate(lines, start=1):
        clean_chars = []
        in_str = False
        escaped = False
        for c in raw_line:
            if in_str:
                clean_chars.append(" ")
                if escaped:
                    escaped = False
                elif c == "\\":
                    escaped = True
                elif c == '"':
                    in_str = False
            else:
                if c == '"':
                    in_str = True
                    clean_chars.append(" ")
                elif c == ';':
                    break
                else:
                    clean_chars.append(c)
        code_line = "".join(clean_chars)

        for name, pattern in rkt_call_patterns:
            if pattern.search(code_line):
                problems.append(f"{filepath}:{lineno}: forbidden call: {name}")

    # Rule 3: top-level expressions that are not a define
    depth = 0
    in_str = False
    escaped = False
    in_line_comment = False
    block_comment_depth = 0

    i = 0
    n = len(content)
    cur_line = 1

    # Skip line 1 (#lang racket/base)
    first_nl = content.find("\n")
    if first_nl != -1:
        i = first_nl + 1
        cur_line = 2
    else:
        i = n

    while i < n:
        c = content[i]
        if c == "\n":
            cur_line += 1
            in_line_comment = False
            i += 1
            continue

        if in_line_comment:
            i += 1
            continue

        if block_comment_depth > 0:
            if content[i:i+2] == "#|":
                block_comment_depth += 1
                i += 2
            elif content[i:i+2] == "|#":
                block_comment_depth -= 1
                i += 2
            else:
                i += 1
            continue

        if in_str:
            if escaped:
                escaped = False
            elif c == "\\":
                escaped = True
            elif c == '"':
                in_str = False
            i += 1
            continue

        if c == ";":
            in_line_comment = True
            i += 1
            continue

        if content[i:i+2] == "#|":
            block_comment_depth = 1
            i += 2
            continue

        if c == '"':
            if depth == 0:
                problems.append(f"{filepath}:{cur_line}: top-level expression is not a define: string literal")
            in_str = True
            i += 1
            continue

        if c in "([":
            if depth == 0:
                j = i + 1
                while j < n and content[j] in " \t\r\n":
                    j += 1
                k = j
                while k < n and content[k] not in " \t\r\n()[]{}\";":
                    k += 1
                head = content[j:k]
                if head != "define":
                    expr_snippet = content[i:min(i+30, n)].splitlines()[0]
                    problems.append(f"{filepath}:{cur_line}: top-level expression is not a define: {expr_snippet}")
            depth += 1
            i += 1
            continue

        if c in ")]":
            if depth > 0:
                depth -= 1
            i += 1
            continue

        if depth == 0:
            if c not in " \t\r\n":
                k = i
                while k < n and content[k] not in " \t\r\n()[]{}\";":
                    k += 1
                token = content[i:k]
                problems.append(f"{filepath}:{cur_line}: top-level expression is not a define: {token}")
                i = k
                continue

        i += 1

for fpath in target_files:
    if not os.path.isfile(fpath):
        if explicit:
            problems.append(f"{fpath}:1: file not found")
        continue

    if fpath.endswith(".pl"):
        check_prolog(fpath)
    elif fpath.endswith(".rkt"):
        check_racket(fpath)

for prob in problems:
    print(prob)

if problems:
    sys.exit(1)
sys.exit(0)
EOF
