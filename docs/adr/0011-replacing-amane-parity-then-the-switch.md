# 0011. Replacing Amane: parity, then the switch

- Status: Accepted
- Date: 2026-11-14

## Context

Hollow replaces Amane ([ADR-0001](0001-what-hollow-is.md)). Amane keeps state of its own: the
current theme, do not disturb, the bar's position, a wallpaper filter, its six palettes, and the
folder that feeds the login screen. The method asks a replacement to state what is kept, how the
data moves and when the old program goes.

## Decision

The owner chose, on 2026-11-14:

- **A written list of what Amane does**, each point with the test that shows Hollow does it,
  rethought as [ADR-0001](0001-what-hollow-is.md) says.
- **The owner's data moves once**, into Hollow's versioned formats, with a backup of Amane's
  files first: the current theme, do not disturb, the bar's position, the wallpaper filter, the six
  palettes, the login screen's folder.
- **Amane goes** after a week of daily use of Hollow on Yuna without going back.
- **Until then, Amane stays** on Umbriel, untouched.

## Alternatives considered

- **Switching as soon as Hollow runs on Yuna**: sooner, but a forgotten feature is found in use.

## Consequences

- The parity list is written at the stage that prepares the switch.
- Hollow's daily use waits for Yuna's Stage 2, the desktop.
