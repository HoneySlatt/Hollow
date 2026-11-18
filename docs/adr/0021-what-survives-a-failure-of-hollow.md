# 0021. What survives a failure of `hollow`

- Status: Accepted; supersedes in part [0003](0003-one-process-the-greeter-apart.md) (each
  component's failure and the restart)
- Date: 2026-11-18

## Context

[ADR-0003](0003-one-process-the-greeter-apart.md) promised that "a panic in one rebuilds that
component", and that systemd restarts a crash of the whole process. The
[audit of 2026-11-17](../audits/2026-11-17-architecture.md) (finding 3) found that this cannot
hold without conditions. Inside one process, only a Rust panic that unwinds can be caught. An
abort cannot be caught: memory exhausted, a stack overflow, a panic while unwinding. Nor can a
fault in native code (the GPU driver), a lost GPU device, a hung thread or a protocol error. The
lock object can never be rebuilt: after `locked`, `ext-session-lock-v1` allows only
`unlock_and_destroy`. Yuna's ADR-0080 settled the same question for Yuna with a table of
failures.

Finding 8: systemd's `KillMode=` defaults to `control-group`. When a service fails, every other
process in its cgroup is killed before the restart (systemd's `service.c`). An application
launched by `hollow` would die with it. xdg-desktop-portal also gives a program its app id only
when its systemd unit's name starts with `app-`. From portal 1.21.0, a program without a valid id
loses global shortcuts and autostart. Facts checked on 2026-11-17 at their sources: systemd,
polkit, xdg-desktop-portal, the tray's libraries, the D-Bus specification.

Inside `hollow` today, by design: the *interface thread* (uwui, every surface, the shell's state,
the lock screen; it answers Yuna's ping, [ADR-0019](0019-the-lock-screen-answers-yunas-ping.md));
the *services thread* ([ADR-0018](0018-system-services-on-a-thread-of-their-own.md)); workers for
blocking work, the theme engine's jobs among them ([ADR-0007](0007-themes-hollows-own-engine.md)).
Child processes: the PAM helper for each attempt, and the programs the owner launches.

## Decision

The owner chose, on 2026-11-18:

**A fault is fatal unless it is listed as contained.** Hollow is built to unwind. A panic hook
writes the crash report, which never holds a typed password. A panic outside a contained part
then ends the process at once, so that nothing runs on a state left half changed, and systemd
restarts it. Three parts are contained, each because its failure leaves no shared state half
changed:

1. **Parsers of other programs' data**: notification markup, images and sounds, tray menus and
   icons, clipboard data, any image or sound decoded. Each is a pure function, its input borrowed
   and its output owned. A panic refuses that input as malformed and is logged. Bounds on the
   input still keep them from exhausting the memory or the stack, which no catch would save.
2. **A theme engine's job**: a panic fails the switch, which the next start completes, as the
   formats' decision sets.
3. **The PAM helper**, a process apart: its death or a timeout fails that attempt only, said on
   the screen; the next attempt starts a new helper.

Per-view containment waits until uwui offers its clients a crash boundary
([`needs.md`](../needs.md#uwui), row 6), and a view owns only its own state.

| Failure | What happens |
|---|---|
| A panic in a contained part | That input, switch or attempt fails, logged; the rest goes on |
| Any other panic, an abort, a native fault, memory exhausted | Crash report; the process ends; systemd restarts it |
| The GPU device lost | Redrawn if uwui recreates its device for its clients; otherwise fatal |
| A protocol error, or Yuna's connection lost | `hollow` starts again in place (below) |
| The interface thread hangs, the session locked | Yuna's ping goes unanswered; Yuna ends the connection; the hang-up watch starts `hollow` again in place, which relieves the lock ([ADR-0016](0016-recovering-a-locked-session.md)) |
| The interface thread hangs, the session unlocked | A key bound in Yuna restarts `hollow`; once Yuna pings the shell as it pings the locker (Yuna's ADR-0088), the same path as above |
| The services thread stops taking the interface's messages | Timed while a message waits for it, never on its answer: a hang ends the process |
| A D-Bus peer that hangs or floods | Bounded and timed out; that service shows as unavailable; nothing ends ([ADR-0018](0018-system-services-on-a-thread-of-their-own.md)) |
| Writing a file fails (a full disk) | The old file is kept, since every write is atomic; the owner is told |

**The hang-up watch.** A thread of `hollow` sleeps in the kernel on its copy of Yuna's socket,
waiting for the peer's hang-up alone. When Yuna ends the connection, it starts `hollow` again in
place, even when the interface thread is frozen. At rest it never wakes.

**Starting again in place.** When Yuna's connection ends, `hollow` does not exit. It waits for
Yuna's socket, then executes its own binary again: the same build, the same process. systemd sees
no exit, so a crash loop of Yuna never spends systemd's start limit (five starts in ten seconds by
default). Only a death of the process (an abort, a fatal panic, a fault) reaches systemd, which
restarts it. Stage 1's prototype checks both the watch and the new start in place.

**What the core owns is taken again at start, never rebuilt in the process:**

- the lock: any fault that touches it is fatal, and the relief is its one recovery path;
- the polkit agent's registration: polkitd drops it with the connection, and a request in flight
  returns "not authorized"; a restarted `hollow` registers again;
- the D-Bus names Hollow serves: the notifications' name and the portal backends' each have an
  activation file pointing to `hollow.service`, so that a message sent during a restart waits and
  is delivered; the tray's watcher has none, since tray items register again with a new watcher by
  themselves.

**A restart keeps** the launched applications, the lock, the configuration and the state file. It
**loses** open popups, notifications shown and not yet in a history, a polkit request in flight,
and the clipboard's content if Hollow held it and its source has quit.

**What counts as a crash.** Losing Yuna because Yuna stopped or crashed is not a crash of Hollow,
nor is losing the GPU. Yuna ending the connection while Yuna itself still runs (a frozen `hollow`,
a protocol error) is one: otherwise a `hollow` that freezes after each relief would loop without
end, and never reach the lock-only mode.

**A reduced start after repeated crashes.** The counter of [ADR-0016](0016-recovering-a-locked-session.md)'s
lock-only mode counts crashes unlocked too. After repeated crashes, `hollow` starts with the
default configuration and no tray, and neither reads nor writes the state file. It keeps the bar,
the launcher, the notifications and the polkit agent, and tells the owner. In the lock-only mode,
a notification sent waits until its call times out. How crashes are counted, and how Hollow tells
a Yuna that stopped from one that ended its connection, is decided at Stage 3's design.

**`hollow.service`** restarts on failure, runs in `session.slice`, and stops within a few
seconds: it handles `SIGTERM` off the interface thread, and its stop timeout is short, not the
90 seconds systemd waits by default.

**Each program the owner launches through Hollow runs as a systemd service of its own**: from
the launcher, the dock, a notification's action or `hollow msg`. The services thread asks the
user manager to start a transient `app-hollow-<escaped app id>@<random>.service`, the name
systemd's convention and the portal both read. It sets `Type=exec`, so that a missing program
fails the start; `ExitType=cgroup`; `Slice=app.slice`; `CollectMode=inactive-or-failed`, so that
failed units do not pile up; an explicit environment without `NOTIFY_SOCKET`; and `$` written
as `$$`. Hollow follows the start job alone, never the unit's life. Whether a user manager is
there is decided once at start: inside a user unit, a failed start is an error shown to the
owner; outside one (a session without systemd), a plain spawn. Hollow's own short
commands (theme reloads) stay in its cgroup and end with it. Built with the launcher, at Stage 2.

## Alternatives considered

- **Every fault fatal**: one path, the simplest. But a malformed notification or menu from any
  local program would restart the whole shell at will, and feed the crash counter while locked.
- **Each view rebuilt after a panic**, as ADR-0003 promised: needs a crash boundary uwui does not
  offer its clients, and a view that panics halfway through a change to shared state would go on
  over a corrupted state.
- **A hung interface found by systemd's watchdog**: automatic, but a periodic ping wakes `hollow`
  at rest.
- **A hung interface found by the services thread**, from messages it waits on: blind to
  Wayland's input, which goes to the interface thread, and blind at rest.
- **The services thread's requests timed on their answer**: a slow peer would end the shell,
  against ADR-0018.
- **No reduced start unlocked**: nothing to build, but a tray item that crashes `hollow` comes
  back at each start, and systemd stops the shell.
- **A scope after the launch** (GNOME's way): the program lives in Hollow's cgroup until the call
  returns, and stays there if it fails.
- **`systemd-run` for each launch**: no D-Bus code, but one more process per launch and less
  control over errors.
- **`KillMode=process`**: launched programs survive, but stay in Hollow's cgroup and its limits,
  without a unit the portal can read; systemd warns against it.
- **Yuna launching programs for Hollow**: Yuna would know each command, but a new need, and Yuna
  would have to give each one a unit.

## Consequences

- `hollow`'s availability rests on its start: the start budget of the ROADMAP is also its
  recovery time.
- Hollow asks Yuna to ping the shell as it pings the locker (Yuna's ADR-0088), and to end the
  connection of a `hollow` that does not answer ([`needs.md`](../needs.md#yuna), row 19).
- Hollow's NixOS and home-manager modules (Stage 4) install the unit's settings and the activation
  files, the latter only where Hollow is enabled.
- Tests need a fake systemd user manager and a fake polkitd on private buses for the calls, and a
  real user manager of a test session for what systemd does with the units.

## Validation and reconsideration

Evidence at the time: the sources above, read on 2026-11-17, and reasoning reviewed by a second
agent, whose report is not kept here; nothing measured. That the hang-up watch sleeps at rest, and
that a new start in place keeps the process, are from the kernel's documentation, to check at
Stage 1's prototype. The scenarios are the rows of the ROADMAP's
[*Architecture and stability scenarios*](../ROADMAP.md#architecture-and-stability-scenarios)
that cite this ADR. Proposed again if uwui offers its clients a crash boundary, if the hang-up
watch wakes at rest, or if Yuna declines row 19.
