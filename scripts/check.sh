#!/usr/bin/env bash
# Runs every automated check of the definition of done (AGENTS.md). CI runs this script unchanged,
# inside the project's development shell (flake.nix), which provides every tool used here.
# Hollow has no code yet (ADR-0002): these are the documents' checks. The Rust checks (format,
# lints, tests, documentation, dependencies, benchmarks) join them with Stage 1's first code.
set -euo pipefail
cd "$(dirname "$0")/.."

step() { printf '\n==> %s\n' "$*"; }
fail() { printf 'FAIL: %s\n' "$*" >&2; exit 1; }

words() { wc -w < "$1" | tr -d ' '; }

step "lengths of the files read at every session"
[ "$(words AGENTS.md)" -le 1500 ] || fail "AGENTS.md has $(words AGENTS.md) words, over 1,500"
[ "$(words docs/PLAN.md)" -le 2000 ] || fail "docs/PLAN.md has $(words docs/PLAN.md) words, over 2,000"

step "every ADR is in the index, and every ADR in the index exists"
for adr in docs/adr/[0-9][0-9][0-9][0-9]-*.md; do
    name=$(basename "$adr")
    [ "$name" = 0000-template.md ] && continue
    grep -qF "($name)" docs/adr/README.md || fail "$name is missing from docs/adr/README.md"
    grep -q '^- Status: ' "$adr" || fail "$name has no status line"
    grep -q '^- Date: [0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}$' "$adr" || fail "$name has no date line"
done
for name in $(grep -o '([0-9]\{4\}-[^)]*\.md)' docs/adr/README.md | tr -d '()'); do
    [ -f "docs/adr/$name" ] || fail "docs/adr/README.md lists $name, which does not exist"
done

step "no home or runtime paths in tracked files (the git hook refuses the other private terms)"
if git grep -n -I -E '/home/[a-z]|/run/user/[0-9]' -- ':!scripts/check.sh'; then
    fail "a tracked file names a personal path"
fi

# Links between the Markdown files, offline; the development shell provides lychee.
step "links"
git ls-files -z '*.md' | xargs -0 lychee --offline --include-fragments --no-progress

step "all checks passed"
