# 0008. Configuration in KDL

- Status: Accepted
- Date: 2026-11-14

## Context

Yuna's configuration is KDL 2.0 (Yuna's ADR-0008), and uwui reads its layouts in KDL with a reader
of its own that keeps the author's order and comments. Noctalia and Wayle use TOML, and keep what
their interface changes in a second file, so that the hand-written one stays untouched.

## Decision

The owner chose, on 2026-11-14:

- **Hollow's configuration is KDL 2.0**, read by the same reader as uwui and Yuna, once that
  reader is chosen for the three projects.
- **It reloads live**; an error is shown with its line and column, and never stops Hollow, which
  keeps the last valid configuration.
- **The owner's file is the owner's.** What Hollow remembers by itself (do not disturb, the last
  theme, the bar's state) lives in a state file under the XDG state folder, versioned.
- **A file written by Nix** is a link into the store, replaced at each switch: live reload follows
  the link.

## Alternatives considered

- **TOML**: widespread, but a second language beside Yuna's and uwui's.

## Consequences

- The choice of reader waits for uwui's and Yuna's.
