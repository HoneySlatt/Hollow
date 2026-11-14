# What Hollow asks of Yuna and uwui

Hollow runs only on Yuna and draws with uwui. This file lists what it needs from each, and where
each need stands. Each project writes the needs in its own documents, through its own session
([ADR-0015](adr/0015-what-hollow-asks-of-yuna-and-uwui.md)). *Asked* means sent to that project's
session; *planned* means written in its plan; *delivered* means built.

## Yuna

Already decided in Yuna's ADR-0057 and ADR-0064, to be specified with Hollow: an interface of
commands and events, with workspaces, focus, outputs and the primary output, the fullscreen state
(a game, a film, plain fullscreen), urgent windows, the bell, the wallpaper shown and a request to
show one, brightness, window previews; the colours file Yuna includes; idle, which runs Hollow's
lock command.

| # | Need | Why | Status |
|---|---|---|---|
| 1 | Which program captures or casts the screen, as an event | The shared-screen indicator ([ADR-0001](adr/0001-what-hollow-is.md)); reverses part of Yuna's ADR-0064 | Asked 2026-11-14 |
| 2 | A greeter mode under greetd: no command socket, MCP, global shortcuts, portals nor XWayland; virtual terminals kept | The login screen ([ADR-0006](adr/0006-the-login-screen-on-yunas-greeter-mode.md)) | Asked 2026-11-14 |
| 3 | A new locker may replace a dead one; every output blanked at once when locking | The lock screen ([ADR-0005](adr/0005-the-lock-screen.md)) | Asked 2026-11-14 |
| 4 | Key bindings that send a named event to Hollow | Shortcuts ([ADR-0009](adr/0009-shortcuts-commands-and-agents.md)) | Asked 2026-11-14 |
| 5 | A way for the on-screen keyboard to send keys (Yuna's ADR-0058 forbids `virtual-keyboard` on the owner's seat), and when to show it | The on-screen keyboard | Asked 2026-11-14 |
| 6 | The keyboard layout and its changes, as an event | The bar, the lock screen | Asked 2026-11-14 |
| 7 | A logout command | The session menu | Asked 2026-11-14 |
| 8 | The start and end of a theme switch, for Yuna's cross-fade | Themes ([ADR-0007](adr/0007-themes-hollows-own-engine.md)) | Asked 2026-11-14 |
| 9 | A layer for desktop widgets above the wallpaper | Widgets | Asked 2026-11-14 |
| 10 | Stable output names | Settings per output | Asked 2026-11-14 |
| 11 | OLED care of the bar, the most static element on screen | Yuna's Stage 5 | Asked 2026-11-14 |
| 12 | Blur behind Hollow's surfaces; which of them are never captured | The look; privacy | Asked 2026-11-14 |
| 13 | The layer shell and the session lock in headless Yuna, before Hollow's surfaces | Tests; until then, headless sway | Asked 2026-11-14 |

## uwui

Already listed in SlimeEngine's `uwui-needs.md`: a layer-shell surface as a target, and a
session-lock surface as a target, one per output.

| # | Need | Why | Status |
|---|---|---|---|
| 1 | The host's loop takes the application's file descriptors and timers, and runs a foreign runtime's tasks (zbus's `Runtime` trait) with no thread of its own | Services ([ADR-0004](adr/0004-system-services-hollows-own-clients-on-zbus.md)) | Asked 2026-11-14 |
| 2 | An input-method client for an on-screen keyboard; a lock surface with its own keyboard and no input method | The on-screen keyboard; the lock screen | Asked 2026-11-14 |
| 3 | Popups anchored to layer surfaces | The bar's popups | Asked 2026-11-14 |
| 4 | Surfaces created on demand, releasing their GPU memory while hidden | Memory ([ADR-0014](adr/0014-budgets-measured-as-uwuis.md)) | Asked 2026-11-14 |
| 5 | One surface per output, outputs coming and going | Several outputs | Asked 2026-11-14 |
| 6 | The crash boundary uwui promises Yuna, for Hollow's surfaces | One process ([ADR-0003](adr/0003-one-process-the-greeter-apart.md)) | Asked 2026-11-14 |
| 7 | A measure of uwui's CPU renderer against a GPU device for a still bar on the laptop | The lowest tier | Asked 2026-11-14 |
