# coreos-installer

Installer for Fedora CoreOS (FCOS) and Red Hat Enterprise Linux CoreOS (RHCOS). Handles OS installation to disk, image download/verification, live ISO customization, and PXE boot configuration.

## Tech Stack

- **Language**: Rust (edition 2021, MSRV 1.85.0)
- **Build**: Cargo + Makefile
- **Key Dependencies**: clap (CLI), reqwest (HTTP), openssl, nmstate, serde, anyhow
- **Testing**: `cargo test` + shell-based integration tests
- **Linting**: `cargo fmt` + `cargo clippy`
- **Features**: `rdcore` (initrd-only binary), `docgen` (man page generation)

## Architecture

```
src/                 # Main library and binary source
  main.rs            # coreos-installer entry point
  lib.rs             # Library root (libcoreinst)
  bin/rdcore/        # rdcore binary (initrd helper)
  cmdline/           # CLI argument definitions (clap derive)
  io/                # I/O utilities
  live/              # Live ISO/PXE operations
  osmet/             # OS metal image handling
  s390x/             # s390x architecture-specific code
  blockdev.rs        # Block device operations
  install.rs         # Core installation logic
  download.rs        # Image download logic
  signing-keys.asc   # Embedded Fedora GPG signing keys
dracut/50rdcore/     # Dracut module for rdcore
systemd/             # systemd service/target/generator units
man/                 # Generated man pages (do not edit directly)
data/                # Generated example config (do not edit directly)
docs/                # Documentation site (Jekyll)
  cmd/               # Generated command reference (do not edit directly)
fixtures/            # Test fixtures (ISO, initrd, verify, customize)
tests/               # Integration test scripts
scripts/             # Helper scripts for installed system
```

## Build Commands

- `make` - Build debug (includes `docgen` feature)
- `make RELEASE=1` - Build release
- `cargo test --all-targets` - Run unit tests
- `cargo test --all-targets --features rdcore` - Run tests with rdcore
- `tests/images.sh` - Run image integration tests
- `cargo fmt -- --check -l` - Check formatting
- `cargo clippy --all-targets -- -D warnings` - Lint (warnings are errors)
- `cargo clippy --all-targets --features rdcore -- -D warnings` - Lint with rdcore
- `make docs` - Regenerate man pages and command docs

## Code Style

- Standard `rustfmt` formatting (no custom config)
- `cargo clippy` with `-D warnings` (all warnings are errors)
- Use `anyhow` for error handling with context via `.context()` / `.with_context()`
- Errors wrapped with `thiserror` for library-level types

## Testing

- Run `cargo test --all-targets` and `cargo test --all-targets --features rdcore` before submitting
- Run `cargo fmt -- --check -l` and `cargo clippy --all-targets -- -D warnings` for lint checks
- `tests/help.sh` checks help text line length
- `tests/docs-config-file.sh` verifies config file docs are up to date
- CI tests on both x86_64 and s390x architectures

## Generated Files (Do Not Edit Manually)

- `man/*.8` - Regenerate with `make docs`
- `data/example-config.yaml` - Regenerate with `make docs`
- `docs/cmd/*.md` - Regenerate with `make docs`

## Commit Conventions

**Format**: `component: description`

Examples from history:
- `signing-keys: add Fedora 45 key`
- `install: add unit tests`
- `blockdev: add support for dm-integrity's new UUID naming scheme`
- `cargo: update dependencies`
- `ci: adjust copy for coreos-installer`
- `docs/release-notes: update for release 0.26.0`

**Style**:
- Imperative mood, lowercase
- Component is the affected module/area (e.g., `install`, `blockdev`, `cargo`, `ci`, `signing-keys`)
- No file extensions in component names
- Dependency bumps use `build(deps):` (automated by Dependabot)

## Important Rules

- `src/signing-keys.asc` contains Fedora GPG signing keys; rotate per Fedora release cycle
- The `rdcore` binary is only useful inside a CoreOS initrd; gate with the `rdcore` feature
- s390x-specific code lives in `src/s390x/` with conditional dependencies in `Cargo.toml`
- After modifying CLI args or config options, run `make docs` to regenerate docs/man pages
- CI runs in Fedora containers, not bare Ubuntu runners
