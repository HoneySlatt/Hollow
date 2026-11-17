# 0019. The lock screen answers Yuna's ping from the thread that draws it

- Status: Accepted
- Date: 2026-11-17

## Context

[ADR-0016](0016-recovering-a-locked-session.md) recovers a locked session whose locker is dead,
but none of its layers covered a locker alive and frozen: its interface's thread blocked, it is
not dead, so nothing relieves it, and logind's `Unlock` goes to it.

Yuna's ADR-0087 answers that case. Yuna pings the locker through `xdg_wm_base` when the lock
begins and when the owner presses a key or moves the pointer on the lock screen, never on a
timer. A locker that does not answer within about ten seconds counts as dead: Yuna ends its
connection, and ADR-0016's path follows. Yuna asks Hollow that its locker bind `xdg_wm_base` and
answer the ping "from a thread that never blocks".

A thread kept apart only to answer pings would answer while the lock screen is frozen, and the
check would never find what it is for.

## Decision

The owner chose, on 2026-11-17, to accept Yuna's need with one precision:

- **`hollow` binds `xdg_wm_base` and answers Yuna's ping.**
- **The answer comes from the thread that draws the lock screen**, never from a thread kept apart
  for it. That thread never waits on a disk, the network or D-Bus
  ([`AGENTS.md`](../../AGENTS.md#architecture-rules)), so a lock screen that works always answers,
  and one that is frozen does not.
- **uwui's session-lock target answers the ping when it reads the connection's events**: the
  precision joins Hollow's need of that target ([`needs.md`](../needs.md#uwui), row 9).

## Alternatives considered

- **Accept the need as Yuna wrote it**: nothing to add; but a later change could answer from a
  thread apart and make the check useless without anyone seeing it.
- **Decline it**: nothing to build; but a frozen lock screen keeps the owner out of the session.

## Consequences

- A lock screen busy for longer than Yuna's delay is counted dead by mistake. It costs a relief by
  a restarted `hollow`, never the lock (Yuna's ADR-0087).
- Stage 3 tests that a lock screen whose thread is blocked stops answering, and that one at work
  answers within the delay.

## Validation and reconsideration

Evidence at the time: Yuna's ADR-0087 and reasoning; no code. Proposed again if Stage 3 measures
the lock screen's thread busy for longer than Yuna's delay in normal use.
