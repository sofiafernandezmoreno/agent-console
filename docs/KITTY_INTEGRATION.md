# Kitty integration (experimental)

This branch introduces a minimal external Kitty launcher for Claude Code and Codex.

## Requirements
- Linux desktop with Kitty installed
- `claude` and/or `codex` authenticated and available on PATH

## Usage

```bash
bash scripts/launch-kitty-agent.sh claude /absolute/path/to/repo
bash scripts/launch-kitty-agent.sh codex /absolute/path/to/repo
```

The launcher runs each agent in a new Kitty window with the project as its working directory. It does **not** connect the Agent Console UI, share conversations, transfer provider usage limits, or arrange Git worktrees. When running agents simultaneously on the same repository, use isolated worktrees to prevent editing collisions.

## Security
- Only `claude` or `codex` are accepted.
- Paths are passed as arguments, never evaluated as shell code.
- No bypass-permissions flags are added.
- No network listener or remote control is enabled.
- Permissions, sandbox, and login behavior remain the responsibility of each CLI.

## Next iteration
Add a Tauri command and an explicit button to launch the selected session's project in Kitty. Avoid launching shells from the React frontend and validate all arguments in Rust.
