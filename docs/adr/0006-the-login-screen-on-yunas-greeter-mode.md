# 0006. The login screen on Yuna's greeter mode

- Status: Accepted
- Date: 2026-11-14

## Context

Under greetd, the login screen (the *greeter*) runs as its own user, in a compositor of its choice.
greetd runs PAM and starts the session once the greeter exits. Others run their greeter in cage,
sway or niri, as Amane does today; in their own session compositor (GDM in GNOME Shell, COSMIC in
cosmic-comp, SDDM optionally in KWin); or in a compositor bundled with them (Noctalia)
([survey](../survey.md#lock-and-login)). No one hands over from greeter to session without the
screen flickering.

The greeter cannot read the owner's home folder, so the theme and the wallpaper are copied to a
folder it reads. cosmic-greeter's equivalent had a privilege flaw (CVE-2026-25704).

## Decision

The owner chose, on 2026-11-14:

- **The greeter runs on Yuna, in a greeter mode**, under greetd. That mode has no command socket,
  no MCP, no global shortcuts, no portals and no XWayland, and keeps switching to a virtual
  terminal. It uses the same outputs, modes and scales as the session. Since Yuna starts by
  reusing the active mode, the hand-over to the session can be free of flicker.
- **`hollow-greeter`** is its own program, drawn by uwui. It offers every installed session
  (`wayland-sessions` and `xsessions`), remembers the last, and authenticates by password through
  greetd. The GNOME keyring is unlocked by greetd's PAM stack.
- **Its appearance comes as data only**: one image re-encoded at the output's size, under a size
  cap, and a file of colours. The greeter opens them without following links, and takes no path,
  font or command from them. It checks the remembered session against the installed ones.
- **It offers a keyboard layout, an on-screen keyboard and the keyboard-only use** of every
  control.
- **Until Yuna has its greeter mode**, the current login screen stays.

## Alternatives considered

- **cage or sway**: no work in Yuna, but a second compositor to configure; cage has neither the
  layer shell nor several outputs.
- **A greeter on DRM without a compositor**: the least memory, but uwui would need a DRM backend.

## Consequences

- Yuna gains a greeter mode ([`needs.md`](../needs.md)).
- The NixOS module of Hollow declares greetd, the greeter's user, its folder and the PAM services.
- `greetd_ipc` is GPL-3.0-only, compatible with Hollow's licence; the protocol is small enough to
  write if the crate does not fit.
