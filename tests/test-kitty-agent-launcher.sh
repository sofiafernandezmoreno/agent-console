#!/usr/bin/env bash
set -euo pipefail
script="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/scripts/launch-kitty-agent.sh"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
mkdir -p "$tmp/bin" "$tmp/project with spaces"
cat > "$tmp/bin/kitty" <<'MOCK'
#!/usr/bin/env bash
printf '%s\n' "$@" > "$KITTY_CAPTURE"
MOCK
cat > "$tmp/bin/claude" <<'MOCK'
#!/usr/bin/env bash
exit 0
MOCK
cp "$tmp/bin/claude" "$tmp/bin/codex"
chmod +x "$tmp/bin/"*
export KITTY_CAPTURE="$tmp/args"
export PATH="$tmp/bin:$PATH"
if bash "$script" invalid "$tmp/project with spaces" >/dev/null 2>&1; then echo "FAIL invalid agent"; exit 1; fi
if bash "$script" claude "$tmp/missing" >/dev/null 2>&1; then echo "FAIL missing directory"; exit 1; fi
bash "$script" codex "$tmp/project with spaces"
grep -Fx -- '--directory' "$tmp/args" >/dev/null
grep -Fx -- "$tmp/project with spaces" "$tmp/args" >/dev/null
grep -Fx -- 'codex' "$tmp/args" >/dev/null
echo 'PASS: Kitty launcher validates agents and preserves path arguments'
