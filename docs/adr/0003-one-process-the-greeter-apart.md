# 0003. One process, the greeter apart

- Status: Accepted; superseded in part by [0016](0016-recovering-a-locked-session.md) (a crash
  while locked and its recovery)
- Date: 2026-11-14

## Context

Shells divide themselves in three ways ([survey](../survey.md#processes)):

- **one process**: Noctalia, Quickshell's shells, ironbar, GNOME Shell (inside the compositor);
- **one process with helpers**: Plasma, whose lock screen is a separate process watched by the
  compositor;
- **one process per component**: COSMIC, whose panel starts each applet as a process. Its users
  report 25 to 300 MB per applet, and every applet dying with the panel (claimed in its issues).

Quickshell's documentation says that a process per widget uses much more memory than one process.
Each process with a GPU device holds its own heap and its own video memory, and on the laptop that
video memory is the system's memory.

The lock screens that keep PAM apart are the strictest. swaylock forks a child for PAM; Noctalia
executes a helper program; KDE runs the PAM checks in subprocesses.

## Decision

The owner chose, on 2026-11-14:

- **One process, `hollow`**, holds the bar, the popups, notifications, the launcher, the on-screen
  displays, the tray, the dock, the widgets, the clipboard history, the on-screen keyboard, the lock
  screen and the polkit agent. It runs one uwui, one GPU device and one font cache.
- **The login screen is a program of its own**, `hollow-greeter`. It runs before the session, as
  the greeter's user ([ADR-0006](0006-the-login-screen-on-yunas-greeter-mode.md)).
- **PAM runs in a helper program**, started for each attempt, never in `hollow`'s process. The
  helper is small, its input checked, and it holds the password only during the attempt.
- **Agents never reach a password field** ([ADR-0009](0009-shortcuts-commands-and-agents.md)).
- **Each component's failure is contained**: a panic in one rebuilds that component. A crash of
  the whole process is restarted by systemd. State that must survive a restart lives on disk.

## Alternatives considered

- **The shell, with its polkit agent, lock screen and login screen in processes of their own**
  (the lead's recommendation, sharpened by the design's challenge): the root password and the lock
  screen's password would never pass through the process that also reads other programs'
  notifications, menus and clipboard, and answers agents. macOS, Windows and KDE ask for such
  passwords in a separate process. A crash of the shell would not leave a locked session showing
  Yuna's dead-lock screen. Declined by the owner, for the memory and simplicity of one process.
- **A services daemon and an interface process**: a crash of the interface keeps D-Bus names and
  history, but needs an internal protocol and a second heap.
- **A process per component**: isolation, at a cost in memory that the bar forbids.

## Consequences

- The lock screen appears at once, since its process already runs.
- A crash of `hollow` while locked leaves the session locked, as the protocol requires. Yuna shows
  its dead-lock screen and accepts a new locker
  ([`needs.md`](../needs.md)). The owner unlocks from a virtual terminal with
  `loginctl unlock-session` if `hollow` does not come back.
- Every parser of other programs' data in `hollow` shares a process with the password fields. They
  are bounded and fuzzed ([`AGENTS.md`](../../AGENTS.md#rules-the-code-depends-on)).
- Yuna must lock without Hollow too, since it is complete without it. Which locker Yuna starts when
  Hollow is absent is Yuna's choice.
