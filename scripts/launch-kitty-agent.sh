#!/usr/bin/env bash
# Open Claude Code or Codex in Kitty without shell interpolation.
set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo "Usage: $0 <claude|codex> <project-directory>" >&2
  exit 2
fi

agent="$1"
case "$agent" in
  claude|codex) ;;
  *) echo "Unsupported agent: $agent" >&2; exit 2 ;;
esac

if [[ ! -d "$2" ]]; then
  echo "Project directory not found: $2" >&2
  exit 2
fi

project="$(cd -- "$2" && pwd -P)"
command -v kitty >/dev/null || { echo "Kitty not found" >&2; exit 127; }
command -v "$agent" >/dev/null || { echo "$agent not found" >&2; exit 127; }

exec kitty --directory "$project" --title "Agent Console - $agent" "$agent"
