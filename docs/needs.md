# What Hollow asks of Yuna and uwui

Hollow runs only on Yuna and draws with uwui. This file lists what it needs from each, and where
each need stands. Each project writes the needs in its own documents, through its own session
([ADR-0015](adr/0015-what-hollow-asks-of-yuna-and-uwui.md)). *Asked* means sent to that project's session; *listed* means written in its own list of
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
every change to its contracts before 1.0; Yuna's `CONTRIBUTING.md` lists Hollow's interface among
them. A locker that stops answering Yuna's ping counts as dead (Yuna's ADR-0088, which superseded ADR-0087).

| # | Need | Why | Status |
|---|---|---|---|
| 1 | Which program captures or casts the screen, as an event | The shared-screen indicator ([ADR-0001](adr/0001-what-hollow-is.md)) | Planned: Yuna's Stage 2 (Yuna's ADR-0065) |
| 2 | A greeter mode under greetd: no command socket, MCP, global shortcuts, portals nor XWayland; virtual terminals kept | The login screen ([ADR-0006](adr/0006-the-login-screen-on-yunas-greeter-mode.md)) | Planned: Yuna's Stage 2 (Yuna's ADR-0065) |
| 3 | A new locker may replace a dead one; every output blanked at once when locking | The lock screen ([ADR-0005](adr/0005-the-lock-screen.md)) | Planned: Yuna's Stage 2b, the blanking with row 17 (Yuna's ADR-0065, ADR-0086) |
| 4 | Key bindings that send a named event to Hollow | Shortcuts ([ADR-0009](adr/0009-shortcuts-commands-and-agents.md)) | Planned: part of Hollow's interface (Yuna's ADR-0064), its form designed at Yuna's Stage 2 |
| 5 | A way for the on-screen keyboard to send keys (Yuna's ADR-0058 forbids `virtual-keyboard` on the owner's seat), and when to show it | The on-screen keyboard | Planned: designed at Yuna's Stage 4, with the Steam Deck's touch; an EI path is a candidate |
| 6 | The keyboard layout and its changes, as an event | The bar, the lock screen | Planned: Yuna's Stage 2 |
| 7 | A logout command | The session menu | Planned: Yuna's Stage 2 |
| 8 | The start and end of a theme switch, for Yuna's cross-fade; each carries the switch's generation, and the screen stays frozen until Hollow's end or Yuna's own bound, whichever comes first | Themes ([ADR-0007](adr/0007-themes-hollows-own-engine.md), [ADR-0024](adr/0024-a-theme-switch-completed-after-any-interruption.md)) | Planned: Yuna's Stage 6, with the cross-fade; the generation and the bound approved by the owner on 2026-11-18, to send to Yuna's session |
| 9 | A layer for desktop widgets above the wallpaper | Widgets | Planned: `wlr-layer-shell`'s background and bottom layers above Yuna's wallpaper, Yuna's Stage 2 |
| 10 | Stable output names | Settings per output | Planned: output ids already follow the monitor (Yuna's ADR-0020); their names given to the shell at Yuna's Stage 2 |
| 11 | OLED care of the bar, the most static element on screen | Yuna's Stage 5 | Planned: Yuna's Stage 5 |
| 12 | Blur behind Hollow's surfaces; which of them are never captured | The look; privacy | Planned: blur at Yuna's Stage 6; never-captured surfaces at Yuna's Stage 2 |
| 13 | The layer shell and the session lock in headless Yuna, before Hollow's surfaces | Tests of Stages 2 and 3; until then, headless sway | Listed as useful early; no stage |
| 14 | The lock's state on Hollow's interface, given in full at connection: locked or not, and whether its locker lives | A restarted `hollow` takes the lock over ([ADR-0016](adr/0016-recovering-a-locked-session.md)) | Planned: Yuna's Stage 2b (Yuna's ADR-0086) |
| 15 | The relief of a dead locker reserved to Hollow's role, where Yuna knows it (Yuna's ADR-0082) | The lock ([ADR-0016](adr/0016-recovering-a-locked-session.md)) | Planned: Yuna's Stage 2b, reserved to the locker the configuration names, Hollow by default (Yuna's ADR-0086) |
| 16 | logind's `Unlock`, its sender checked, unlocks the session when no locker lives | The last way back into a locked session ([ADR-0016](adr/0016-recovering-a-locked-session.md)) | Planned: Yuna's Stage 2b (Yuna's ADR-0086) |
| 17 | At the lock command and before sleep, Yuna holds logind's sleep delay inhibitor and blanks every output itself, before any client; the locker then takes over | One path for a lock and a relief ([ADR-0016](adr/0016-recovering-a-locked-session.md)) | Planned: Yuna's Stage 2b, Yuna begins every lock and the locker relieves it (Yuna's ADR-0086) |
| 18 | The dead-locker screen says how to unlock from a virtual terminal | Recovery ([ADR-0016](adr/0016-recovering-a-locked-session.md)) | Planned: Yuna's Stage 2b (Yuna's ADR-0086) |
| 19 | Yuna pings the shell as it pings the locker (Yuna's ADR-0088): when the owner's input reaches Hollow's surfaces, at most once a delay; and ends the connection of a `hollow` that does not answer | A `hollow` frozen while unlocked is restarted by its hang-up watch ([ADR-0021](adr/0021-what-survives-a-failure-of-hollow.md)) | Approved by the owner on 2026-11-18; to send to Yuna's session |
| 20 | The power state of each output, on or off, on Hollow's interface, given whole at connection and as events | Nothing is shown on an output that is off, so its subscriptions end ([ADR-0022](adr/0022-what-rest-allows.md)) | Approved by the owner on 2026-11-18; to send to Yuna's session |
| 21 | A subscriber chooses the kinds of events it receives, on the event stream bounded per subscriber (Yuna's ADR-0082) | Hollow wakes only for what it shows, not for every window's change of title ([ADR-0022](adr/0022-what-rest-allows.md)) | Approved by the owner on 2026-11-18; to send to Yuna's session |
| 22 | Yuna's package installs `yuna-portals.conf`: `yuna-portal` for Yuna's own portals; `hollow`, then `gtk`, for Settings and Notification | Hollow serves both backends; a session works with or without Hollow ([ADR-0025](adr/0025-the-notification-portal-served-by-hollow.md)) | Approved by the owner on 2026-11-18; to send to Yuna's session |

What Yuna asks of Hollow:

| Need | Why | Hollow's answer |
|---|---|---|
| The locker binds `xdg_wm_base` and answers Yuna's ping from a thread that never blocks | A frozen locker counted as dead (Yuna's ADR-0088) | Accepted: from the thread that draws the lock screen ([ADR-0019](adr/0019-the-lock-screen-answers-yunas-ping.md)) |

## uwui

Listed in SlimeEngine's `uwui-needs.md`, section *What the owner's shell and compositor ask*
(SlimeEngine commit `d3a2ef5`, 2026-11-14). Every row there is marked "New", with no stage of
uwui's named yet; [ADR-0017](adr/0017-each-stage-opens-on-named-deliverables.md) asks for one,
asked of SlimeEngine's session on 2026-11-17.

| # | Need | Why | Hollow's stage | Status |
|---|---|---|---|---|
| 1 | The host's loop takes the application's file descriptors and timers, and runs a foreign runtime's tasks (zbus's `Runtime` trait) with no thread of its own | Services ([ADR-0004](adr/0004-system-services-hollows-own-clients-on-zbus.md)) | — | Listed; withdrawal asked 2026-11-17, replaced by the services thread ([ADR-0018](adr/0018-system-services-on-a-thread-of-their-own.md)) |
| 2 | An input-method client for an on-screen keyboard; a lock surface with its own keyboard and no input method | The on-screen keyboard; the lock screen | 3, 5 | Listed; no stage |
| 3 | Popups anchored to layer surfaces | The bar's popups | 2 | Listed; no stage |
| 4 | Surfaces created on demand, releasing their GPU memory while hidden | Memory ([ADR-0014](adr/0014-budgets-measured-as-uwuis.md)) | 2 | Listed; no stage |
| 5 | One surface per output, outputs coming and going | Several outputs | 2 | Listed; no stage |
| 6 | The crash boundary uwui promises Yuna, for Hollow's surfaces | One process ([ADR-0003](adr/0003-one-process-the-greeter-apart.md)) | 2 | Listed; no stage. Yuna's ADR-0084 makes that boundary a task inside Yuna's process, which does not apply to a client: to restate ([audit](audits/2026-11-17-architecture.md)) |
| 7 | A measure of uwui's CPU renderer against a GPU device for a still bar on the laptop | The lowest tier | 2 | Listed; wished before Hollow's first code |
| 8 | A layer-shell surface as a target | The bar and panels | 2 | Listed; no stage |
| 9 | A session-lock surface as a target, one per output; it binds `xdg_wm_base` and answers Yuna's ping when it reads the connection's events | The lock screen; a frozen one found by Yuna ([ADR-0019](adr/0019-the-lock-screen-answers-yunas-ping.md)) | 3 | Listed; no stage; the ping, a precision asked 2026-11-17 |
| 10 | A blank layer surface per output that only clears and presents, the baseline of the own cost | Memory ([ADR-0014](adr/0014-budgets-measured-as-uwuis.md)) | 2 | Named beside the list, not a row of it; asked as a row 2026-11-17 |
| 11 | A secret text field: its value kept out of undo, the accessibility tree and agents' reading (shown as a protected field), the clipboard and input methods; its memory cleared after use and kept out of core dumps | The lock screen's and the polkit prompt's passwords ([`AGENTS.md`](../AGENTS.md#rules-the-code-depends-on)); any application of uwui's needs it too | 3 | Asked 2026-11-17 |

What Stage 1 also takes from uwui, already in uwui's plan:

- its KDL reader, built at SlimeEngine's Stage 6d (uwui's `docs/ROADMAP.md`);
- its executor, and its channels through which other threads change the interface, in uwui's
  first stage (SlimeEngine's ADR-0211), which the services thread uses
  ([ADR-0018](adr/0018-system-services-on-a-thread-of-their-own.md));
- its core for agents and its declared actions, at SlimeEngine's Stage 6d.
