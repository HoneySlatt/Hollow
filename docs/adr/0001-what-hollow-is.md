# 0001. What Hollow is

- Status: Accepted
- Date: 2026-11-14

## Context

The owner's desktop shell today is Amane, an external Rust shell that the owner configures and
patches. Amane runs on Umbriel, the owner's current compositor. Read on 2026-11-14, it gives a bar, a launcher, a
carousel of applications, full-screen views of the owner's games (from Slatty's library) and music
(from Kopuz), a Nym VPN launcher, pickers of wallpapers and themes, a system monitor, a calendar
with pages for media, wallpaper and theme, notifications, a tray, a control centre, popups for
sound, network, Bluetooth and power, on-screen displays, a lock screen, a login screen and a theme
applied to about thirty other applications and to websites.

The owner is writing Yuna, a Wayland compositor, to replace Umbriel. Yuna does some of what a shell
usually does: the wallpaper, idle, captures and screen sharing, night light and brightness. It
announces what is fullscreen and lets the shell decide (Yuna's ADR-0004, 0057, 0063 and 0064).
No new feature goes into Amane.

## Decision

The owner chose, on 2026-11-14:

- **Hollow is the owner's own shell, replacing Amane.** It is made for the owner first. It is
  public, without a promise to serve other uses.
- **It runs only on Yuna, and it is optional.** It may use Yuna's own commands and events. Yuna
  stays complete without it.
- **Its scope.** It keeps everything Amane does, rethought:
  - one launcher with providers (applications, games, music, VPN, wallpapers, themes, a
    calculator), with full-screen views for games and music;
  - the bar, notifications, the tray, the control centre, the popups (sound, network, Bluetooth,
    VPN, power), the on-screen displays, the calendar and the system monitor;
  - the lock screen, the login screen, and the theme applied to other applications and websites;
  - a polkit agent, which no program provides in the owner's session today.
- **It adds** clipboard history, an emoji picker, an on-screen keyboard, focus modes, a dock,
  desktop widgets, the weather, and indicators of the microphone, the camera and a shared screen.
- **The login screen offers every installed session**, and remembers the last one. Unlocking and
  logging in use the password only.
- **No settings application inside Hollow.** A settings application apart is an idea in Yuna's
  plan.
- **Its machines** are Yuna's: the owner's desktop (the high tier), the owner's HP laptop (the
  lowest tier), and the Steam Deck in desktop mode.

## Alternatives considered

- **Keep Amane**: no work, but Amane is someone else's project, patched in the owner's
  configuration, and it reads Yuna only through standard protocols.
- **A shell for every compositor**: wider use, but each compositor's private interface to follow,
  and none of Yuna's events.
- **Only the core of Amane first** (applications and system popups, then games, music and VPN
  later): Hollow useful sooner, but Amane kept longer for those features.
- **Only the login sessions of Yuna**: simpler, but no fallback session from the login screen.

## Consequences

- Hollow's contract with Yuna is part of its design ([ADR-0015](0015-what-hollow-asks-of-yuna-and-uwui.md)).
- The shared-screen indicator reverses part of Yuna's ADR-0064, which had declined the shell's
  capture indicators; Yuna records the change.
- Amane stays the owner's shell until Hollow replaces it
  ([ADR-0011](0011-replacing-amane-parity-then-the-switch.md)).
