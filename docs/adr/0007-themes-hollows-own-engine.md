# 0007. Themes: Hollow's own engine

- Status: Accepted
- Date: 2026-11-14

## Context

The owner's theme today is six named palettes of about 26 colours, applied by a shell script to
about 34 applications and to websites (userstyles compiled and served locally, which Stylus reads).
Only four of those applications change at once; the others at their next start
([survey](../survey.md#themes)).

What the field does:

- matugen and Noctalia derive Material You schemes from a wallpaper, and fill a template per
  application;
- the Settings portal carries the colour scheme, an accent colour, contrast and reduced motion.
  libadwaita, Qt 6.5 and later, and Electron read it live;
- terminals change live through escape sequences or a signal, KDE applications through a D-Bus
  notice, Neovim through its remote interface;
- Firefox and Chromium's browsers take a theme from an extension's native host, with no polling;
- KDE and macOS switch light and dark by the hour; GNOME does not.

Yuna includes a colours file that the shell writes (Yuna's ADR-0057), and cross-fades the screen on
a change of theme (Yuna's ADR-0064). The Settings portal belongs to the shell.

## Decision

The owner chose, on 2026-11-14, **Hollow's own theme engine**:

- **Palettes as files**: the named palettes (Amane's six, converted), palettes derived from the
  wallpaper (Material You's schemes, on a downscaled image), an accent colour over any palette,
  and light and dark switched at sunrise and sunset of a configured place, by one timer set to the
  next change.
- **Outputs**:
  - Yuna's colours file;
  - the Settings portal's backend;
  - a template per application, kept as data, each with the way it reloads live where one exists;
  - websites, through userstyles and a native host for Firefox, Brave and Chromium.
- **A switch is announced** to Yuna at its start and end, so that Yuna's cross-fade waits for the
  applications to repaint. A switch has a time budget.
- **The engine runs only on a change.** It costs nothing at rest. Its work runs off the
  interface's thread.

## Alternatives considered

- **matugen as a subprocess** (GPL-2.0-or-later): its ready templates, but one more tool, and its
  colour science is its own.
- **Keep the shell scripts**, called by Hollow: no work, but bash to maintain, and most
  applications themed only at their next start.

## Consequences

- The colour library is tested against Google's reference before it is trusted; its current
  version publishes no comparison.
- What applications get when Hollow is not running (the portal's defaults) is stated at the
  milestone.
- Each template needs care when its application changes.
