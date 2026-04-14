@AGENTS.md

## Claude Code Specific Workflows

### Pre-commit Checklist

Run before submitting changes:
```bash
cargo fmt -- --check -l
cargo clippy --all-targets -- -D warnings
cargo clippy --all-targets --features rdcore -- -D warnings
cargo test --all-targets
cargo test --all-targets --features rdcore
```

If CLI args or config options were modified, also run `make docs` and include regenerated files.

### Agent Usage

- Use subagents for exploring this codebase; the Rust source files (`blockdev.rs`, `install.rs`, `download.rs`) are large
- When modifying signing keys, follow the rotation pattern in `.opencode/skills/signing-key-rotation/SKILL.md`
- For release preparation, see `.opencode/skills/release-prep/SKILL.md`
