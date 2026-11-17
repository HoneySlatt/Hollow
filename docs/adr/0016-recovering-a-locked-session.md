# 0016. Recovering a locked session whose locker is gone

- Status: Accepted; amends [0003](0003-one-process-the-greeter-apart.md) (a crash while locked and
  its recovery), [0005](0005-the-lock-screen.md) (who holds sleep back and blanks the outputs)
- Date: 2026-11-17

## Context

`hollow` holds the lock screen ([ADR-0003](0003-one-process-the-greeter-apart.md),
[ADR-0005](0005-the-lock-screen.md)). On `ext-session-lock-v1`, a dead locker leaves the session
locked: "the compositor must not unlock the session in response. It is acceptable for the session
to be permanently locked if this happens" (wayland-protocols 1.49,
`staging/ext-session-lock/ext-session-lock-v1.xml`). What follows is the compositor's policy.

What exists on 2026-11-17 ([audit](../audits/2026-11-17-architecture.md)):

- Yuna lets a new locker relieve a dead one, and only it unlocks (Yuna's ADR-0065). Its scene
  keeps every output locked, new ones included, and a crashed Yuna comes back locked (Yuna's
  ADR-0080 and ADR-0082).
- ADR-0003 promised that the owner unlocks from a virtual terminal with `loginctl
  unlock-session`. Nothing handles that request: neither Hollow's documents nor Yuna's say who
  answers logind's `Unlock` signal when the locker is dead.
- Nothing says how a restarted `hollow` learns that it must take the lock over.
- Who holds logind's sleep delay inhibitor was unclear: the survey gives it to the locker, ADR-0005
  and Yuna's ADR-0057 to Yuna, without a mechanism. Hollow's need that Yuna blank every output at
  once is missing from Yuna's answer (Yuna's `docs/client-needs.md`).

The case that breaks: `hollow` crashes at each start while the session is locked, for example on
data it reads again each time. systemd stops restarting it; Yuna shows its dead-locker screen;
`loginctl unlock-session` does nothing; restarting Yuna brings it back locked. Only a reboot is
left, and unsaved work is lost.

## Decision

The owner chose, on 2026-11-17, four layers, each covering what the one before cannot:

- **A restarted `hollow` takes the lock over first.** At start, before the bar, the services or
  the configuration, it asks Yuna whether the session is locked without a living locker. If so,
  it relieves the dead locker at once.
- **A lock-only mode after repeated crashes while locked.** `hollow` then starts with the lock
  screen, logind and its connection to Yuna alone: no other service, the default configuration,
  no state file, since any of them may be what crashed it. How crashes are counted is decided at
  Stage 3's design.
- **logind's `Unlock` is the last resort.** Its sender is checked against logind's unique name.
  A living `hollow` ends its lock on it; when no locker lives, Yuna unlocks on it. `loginctl
  unlock-session` from a virtual terminal then works whatever state `hollow` is in.
- **Yuna owns the start of a lock.** At the lock command and before sleep, Yuna holds logind's
  sleep delay inhibitor and blanks every output itself, before any client; Hollow's lock screen
  then takes over. A lock and a relief become one path. The form is Yuna's to decide.

What Hollow asks of Yuna for this is listed in [`needs.md`](../needs.md#yuna), rows 14 to 18.

The threat the lock guards against is a person at the machine. The owner's own processes are
trusted as far as logind already trusts them: they can ask logind to unlock their own session
today, and this decision gives them nothing more. That logind allows it without asking a
password is to be checked against polkit's rules at Stage 3.

## Alternatives considered

- **Relief by a restarted `hollow` only**: the simplest and the strictest, nothing unlocks
  outside the locker; but a crash loop locks the owner out until a reboot.
- **The relief and logind's `Unlock`, without a lock-only mode**: less to build in Hollow; but
  every crash of Hollow's own logic while locked sends the owner to a virtual terminal.
- **A small fallback locker apart, started by Yuna after failed reliefs**: recovery without a
  virtual terminal, and safe from a fault of uwui or the GPU in `hollow`; but a second lock
  screen to maintain, style and give a PAM service.

## Consequences

- ADR-0003's recovery from a virtual terminal holds only once Yuna takes rows 14 to 18 of
  [`needs.md`](../needs.md); until then it is a need, not a promise.
- Stage 3's exit gains the tests below. They need a fake logind on a private system bus and the
  lock in headless Yuna ([`needs.md`](../needs.md#yuna), row 13).
- The lock-only mode is a start-up path of `hollow`, tested like the others.
- Yuna records its side in its own documents, through its own session, on the owner's go
  ([ADR-0015](0015-what-hollow-asks-of-yuna-and-uwui.md)).

## Validation and reconsideration

Evidence at the time: the protocol's text, Yuna's documents read on 2026-11-17, and reasoning; no
code exists. The checks, at Stage 3:

- `hollow` killed while locked: no frame of the session is presented; a restarted `hollow`
  takes the lock over;
- a crash loop while locked: `hollow` reaches its lock-only mode;
- `hollow` aborted in its lock-only mode: logind's `Unlock` from the fake logind unlocks, and a
  forged one from another sender does not;
- a sleep right after the lock command: the blanked frame is presented on every output before
  Yuna releases its inhibitor.

Proposed again if Yuna declines logind's `Unlock` or the start of a lock, or if polkit's rules
let another user unlock the session.
