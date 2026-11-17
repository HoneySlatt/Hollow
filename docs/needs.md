# What Hollow asks of Yuna and uwui

Hollow runs only on Yuna and draws with uwui. This file lists what it needs from each, and where
each need stands. Each project writes the needs in its own documents, through its own session
([ADR-0015](adr/0015-what-hollow-asks-of-yuna-and-uwui.md)). *To send* means decided here and not
yet sent; *asked* means sent to that project's session; *listed* means written in its own list of
needs; *planned* means given a stage in its plan or roadmap; *delivered* means built. Each stage of
Hollow opens on the needs it names ([ADR-0017](adr/0017-each-stage-opens-on-named-deliverables.md)).

Read again on 2026-11-17 against Yuna's `docs/client-needs.md` and ADRs, and SlimeEngine's
`docs/uwui-needs.md`.

## Yuna

Already decided in Yuna's ADR-0057 and ADR-0064: an interface of commands and events, with
workspaces, focus, outputs and the primary output, the fullscreen state (a game, a film, plain
fullscreen), urgent windows, the bell, the wallpaper shown and a request to show one, brightness,
window previews; the colours file Yuna includes; idle, which runs Hollow's lock command. Yuna's
ADR-0082 puts that interface in a crate of its own, `yuna-ipc`, under semantic versions, with one
event stream bounded per subscriber and a resync event at the bound. Yuna's ADR-0079 announces
every change to its contracts before 1.0.

| # | Need | Why | Status |
|---|---|---|---|
| 1 | Which program captures or casts the screen, as an event | The shared-screen indicator ([ADR-0001](adr/0001-what-hollow-is.md)) | Planned: Yuna's Stage 2 (Yuna's ADR-0065) |
| 2 | A greeter mode under greetd: no command socket, MCP, global shortcuts, portals nor XWayland; virtual terminals kept | The login screen ([ADR-0006](adr/0006-the-login-screen-on-yunas-greeter-mode.md)) | Planned: Yuna's Stage 2 (Yuna's ADR-0065) |
| 3 | A new locker may replace a dead one; every output blanked at once when locking | The lock screen ([ADR-0005](adr/0005-the-lock-screen.md)) | The relief planned: Yuna's Stage 2 (Yuna's ADR-0065). The blanking not answered; asked again as row 17 |
| 4 | Key bindings that send a named event to Hollow | Shortcuts ([ADR-0009](adr/0009-shortcuts-commands-and-agents.md)) | Planned: part of Hollow's interface (Yuna's ADR-0064), its form designed at Yuna's Stage 2 |
| 5 | A way for the on-screen keyboard to send keys (Yuna's ADR-0058 forbids `virtual-keyboard` on the owner's seat), and when to show it | The on-screen keyboard | Planned: designed at Yuna's Stage 4, with the Steam Deck's touch; an EI path is a candidate |
| 6 | The keyboard layout and its changes, as an event | The bar, the lock screen | Planned: Yuna's Stage 2 |
| 7 | A logout command | The session menu | Planned: Yuna's Stage 2 |
| 8 | The start and end of a theme switch, for Yuna's cross-fade | Themes ([ADR-0007](adr/0007-themes-hollows-own-engine.md)) | Planned: Yuna's Stage 6, with the cross-fade |
| 9 | A layer for desktop widgets above the wallpaper | Widgets | Planned: `wlr-layer-shell`'s background and bottom layers above Yuna's wallpaper, Yuna's Stage 2 |
| 10 | Stable output names | Settings per output | Planned: output ids already follow the monitor (Yuna's ADR-0020); their names given to the shell at Yuna's Stage 2 |
| 11 | OLED care of the bar, the most static element on screen | Yuna's Stage 5 | Planned: Yuna's Stage 5 |
| 12 | Blur behind Hollow's surfaces; which of them are never captured | The look; privacy | Planned: blur at Yuna's Stage 6; never-captured surfaces at Yuna's Stage 2 |
| 13 | The layer shell and the session lock in headless Yuna, before Hollow's surfaces | Tests of Stages 2 and 3; until then, headless sway | Listed as useful early; no stage |
| 14 | The lock's state on Hollow's interface, given in full at connection: locked or not, and whether its locker lives | A restarted `hollow` takes the lock over ([ADR-0016](adr/0016-recovering-a-locked-session.md)) | To send |
| 15 | The relief of a dead locker reserved to Hollow's role, where Yuna knows it (Yuna's ADR-0082) | The lock ([ADR-0016](adr/0016-recovering-a-locked-session.md)) | To send |
| 16 | logind's `Unlock`, its sender checked, unlocks the session when no locker lives | The last way back into a locked session ([ADR-0016](adr/0016-recovering-a-locked-session.md)) | To send |
| 17 | At the lock command and before sleep, Yuna holds logind's sleep delay inhibitor and blanks every output itself, before any client; the locker then takes over | One path for a lock and a relief ([ADR-0016](adr/0016-recovering-a-locked-session.md)) | To send; its form is Yuna's |
| 18 | The dead-locker screen says how to unlock from a virtual terminal | Recovery ([ADR-0016](adr/0016-recovering-a-locked-session.md)) | To send |

## uwui

Listed in SlimeEngine's `uwui-needs.md`, section *What the owner's shell and compositor ask*
(SlimeEngine commit `d3a2ef5`, 2026-11-14). Every row there is marked "New", with no stage of
uwui's named yet; [ADR-0017](adr/0017-each-stage-opens-on-named-deliverables.md) asks for one.

| # | Need | Why | Hollow's stage | Status |
|---|---|---|---|---|
| 1 | The host's loop takes the application's file descriptors and timers, and runs a foreign runtime's tasks (zbus's `Runtime` trait) with no thread of its own | Services ([ADR-0004](adr/0004-system-services-hollows-own-clients-on-zbus.md)) | 1 | Listed; no stage |
| 2 | An input-method client for an on-screen keyboard; a lock surface with its own keyboard and no input method | The on-screen keyboard; the lock screen | 3, 5 | Listed; no stage |
| 3 | Popups anchored to layer surfaces | The bar's popups | 2 | Listed; no stage |
| 4 | Surfaces created on demand, releasing their GPU memory while hidden | Memory ([ADR-0014](adr/0014-budgets-measured-as-uwuis.md)) | 2 | Listed; no stage |
| 5 | One surface per output, outputs coming and going | Several outputs | 2 | Listed; no stage |
| 6 | The crash boundary uwui promises Yuna, for Hollow's surfaces | One process ([ADR-0003](adr/0003-one-process-the-greeter-apart.md)) | 2 | Listed; no stage. Yuna's ADR-0084 makes that boundary a task inside Yuna's process, which does not apply to a client: to restate ([audit](audits/2026-11-17-architecture.md)) |
| 7 | A measure of uwui's CPU renderer against a GPU device for a still bar on the laptop | The lowest tier | 2 | Listed; wished before Hollow's first code |
| 8 | A layer-shell surface as a target | The bar and panels | 2 | Listed; no stage |
| 9 | A session-lock surface as a target, one per output | The lock screen | 3 | Listed; no stage |
| 10 | A blank layer surface per output that only clears and presents, the baseline of the own cost | Memory ([ADR-0014](adr/0014-budgets-measured-as-uwuis.md)) | 2 | Named beside the list, not a row of it; to send as a row |

What Stage 1 also takes from uwui, already in uwui's plan:

- its KDL reader, built at SlimeEngine's Stage 6d (uwui's `docs/ROADMAP.md`);
- its executor, in uwui's first stage;
- its core for agents and its declared actions, at SlimeEngine's Stage 6d.
