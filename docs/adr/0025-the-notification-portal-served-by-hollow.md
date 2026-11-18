# 0025. The Notification portal served by Hollow

- Status: Accepted
- Date: 2026-11-18

## Context

Yuna's ADR-0057 gives the Settings and Notification portals to the shell. Hollow already serves
the Settings portal's backend ([ADR-0007](0007-themes-hollows-own-engine.md)) and the
notification server ([ADR-0004](0004-system-services-hollows-own-clients-on-zbus.md)), but its
plan held no Notification portal ([audit of 2026-11-17](../audits/2026-11-17-architecture.md),
finding 10).

Read at their sources on 2026-11-17:

- A Flatpak application reaches `org.freedesktop.Notifications` only if its manifest asks for it.
  GLib's notifications go through the portal inside a sandbox (flatpak's documentation, GLib's
  `gnotification`). Chromium uses the portal when the notification server lacks the `body` or
  `actions` capability. Firefox and Electron call the server directly.
- The backend interface, `org.freedesktop.impl.portal.Notification`, is at version 2 since
  xdg-desktop-portal 1.20. It adds sounds and icons passed as sealed file descriptors,
  categories, button purposes, display hints (among them *hide content on the lock screen*), and
  the activation token. The portal checks and filters each notification before the backend sees
  it.
- The portal chooses a backend per interface from `<desktop>-portals.conf`. With none named, it
  falls back to `xdg-desktop-portal-gtk` if that is installed. That backend relays to
  `org.freedesktop.Notifications` at version 1 only, from a process of its own.
- The portal reads a host program's app id from its systemd unit, when the unit's name starts with
  `app-`. Programs launched through Hollow run in such units
  ([ADR-0021](0021-what-survives-a-failure-of-hollow.md)).
- No project writes `yuna-portals.conf` today.

## Decision

The owner chose, on 2026-11-18:

- **Hollow serves the Notification portal's backend, at version 2**, on the services thread,
  beside the Settings backend. Notifications from the portal and from
  `org.freedesktop.Notifications` share one queue, one presentation and one history. Their
  display hints are honoured: a *transient* notification is shown but never kept in the history.
  The hints about the lock screen ask for nothing more than Hollow already does, since the lock
  screen shows no notification's content ([ADR-0005](0005-the-lock-screen.md)). Icons and sounds
  are untrusted input, bounded, and their parsers are contained
  ([ADR-0021](0021-what-survives-a-failure-of-hollow.md)).
- **Built at Stage 1**, with the notification server, tested against xdg-desktop-portal on a
  private bus.
- **Yuna's package installs `yuna-portals.conf`.** It names `yuna-portal` for Yuna's own portals,
  and `hollow`, then `gtk`, for Settings and Notification. A session works with or without Hollow,
  and one file describes the whole session. Asked of Yuna through the owner
  ([`needs.md`](../needs.md#yuna), row 22).

## Alternatives considered

- **xdg-desktop-portal-gtk's backend**, relaying to Hollow's server: no code, but one more GTK
  process in the session, version 1 only (no hint for the lock screen, no sound), and present only
  if installed.
- **No backend**: sandboxed programs that use the portal get no notifications.
- **Hollow's home-manager module writing a user file for its two portals**: nothing asked of Yuna,
  but two projects would write the same configuration. Whether a partial user file adds to the
  system's or hides it was not established.

## Consequences

- The services thread serves one more D-Bus interface, with an activation file like Hollow's other
  names ([ADR-0021](0021-what-survives-a-failure-of-hollow.md)).
- Hollow's notification server advertises the `body` and `actions` capabilities, so that Chromium
  uses it directly.
- Stage 1's tests need xdg-desktop-portal running on a private bus.

## Validation and reconsideration

Evidence at the time: xdg-desktop-portal's sources (`notification.c`, `xdp-portal-config.c`,
`xdp-app-info-host.c`), flatpak's documentation and GLib's sources, read on 2026-11-17; no code.
Checked at Stage 1, in the rows of the ROADMAP's
[*Architecture and stability scenarios*](../ROADMAP.md#architecture-and-stability-scenarios)
that cite this ADR: a notification sent through the portal by a program in an `app-` unit reaches
Hollow with its app id and is shown once; a *transient* one is never in the history; a malformed
icon or sound is refused without ending `hollow`.
Proposed again if the portal's interface moves to a version Hollow does not serve, or if Yuna
declines row 22.
