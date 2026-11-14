# 0012. GPL-3.0-or-later, public from the start

- Status: Accepted
- Date: 2026-11-14

## Context

Yuna is under GPL-3.0-or-later (Yuna's ADR-0009); uwui is under MIT OR Apache-2.0. Hollow is a
program, not a library. Code that any host of uwui needs belongs in uwui (SlimeEngine's
ADR-0266).

## Decision

The owner chose, on 2026-11-14:

- **Hollow's code is under GPL-3.0-or-later**, as Yuna's.
- **The repository is public from its first commit**, on GitHub as `HoneySlatt/Hollow`.
- **Code that any host of uwui needs is written in uwui first**, under uwui's licence, through
  uwui's session. Code written here under the GPL cannot move to uwui once others have contributed
  to it.
- **The logo** (`hollow.svg`, `hollow.png`) is not under the code's licence: its author keeps its
  rights, as Yuna's logo.

## Alternatives considered

- **MIT OR Apache-2.0**, as uwui: anyone could take the code into a closed product, and code would
  move freely to uwui.

## Consequences

- `greetd_ipc` (GPL-3.0-only) is compatible.
- Each dependency's licence is checked against GPL-3.0-or-later.
