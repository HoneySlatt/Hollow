# 0005. The lock screen

- Status: Accepted; amended by [0016](0016-recovering-a-locked-session.md) (who holds sleep back
  and blanks the outputs)
- Date: 2026-11-14

## Context

`ext-session-lock-v1` keeps the session locked if the locking client dies; the compositor shows
something opaque instead. Its lessons ([survey](../survey.md#lock-and-login)):

- before it, a crash of swaylock unlocked the session (CVE-2022-26530);
- GNOME's lock screen let its screenshot tool show the locked windows (CVE-2023-43090);
- any process on the system bus can send a signal that looks like logind's; hyprlock and Noctalia
  now check the sender;
- logind's sleep delay is 5 seconds by default; a locker must be shown before it ends.

Yuna runs the shell's lock command after its idle delay and before sleep, holding sleep back long
enough to lock (Yuna's ADR-0057). It shows a screen of its own when a locker dies (Yuna's
ADR-0064).

## Decision

- **The lock screen lives in `hollow`** ([ADR-0003](0003-one-process-the-greeter-apart.md)), on
  `ext-session-lock-v1`, drawn by uwui on its session-lock target.
- **Two budgets.** Yuna blanks every output at once, which counts as the locked frame, so sleep
  never waits for an interface. The lock's interface then appears within its own budget
  ([ROADMAP](../ROADMAP.md#quality-bar)).
- **Authentication by password**, through PAM in a helper program
  ([ADR-0003](0003-one-process-the-greeter-apart.md)), with its own PAM service file. Each attempt
  lasts at least half a second, as COSMIC's. The keyboard layout is shown and can be changed.
- **logind's signals are checked** against logind's unique name.
- **The lock screen has its own on-screen keyboard** on the Deck, and no input method.
- **The lock screen shows no notification's content**, and lets no agent in.

## Alternatives considered

- **A lock screen in its own process, started on demand** (swaylock, KDE): its own budget for a
  cold start, and the shell's bugs out of its path. Declined with the owner's choice of one
  process.
- **Yuna drawing the lock screen** (GNOME's way): the compositor would hold PAM and an interface.

## Consequences

- Yuna accepts a new locker after a crash, and blanks at once when asked to lock
  ([`needs.md`](../needs.md)).
- A screen reader on the lock screen is decided at its milestone: Orca reads every key.
