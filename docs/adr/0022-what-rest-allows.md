# 0022. What rest allows

- Status: Accepted; supersedes in part [0004](0004-system-services-hollows-own-clients-on-zbus.md)
  (what a service follows), [0014](0014-budgets-measured-as-uwuis.md) (the rest budget)
- Date: 2026-11-18

## Context

The ROADMAP's first principle and `AGENTS.md` said: "Nothing runs, polls or draws at rest. A
service is subscribed only while something shown needs it."
[ADR-0004](0004-system-services-hollows-own-clients-on-zbus.md) followed the Wi-Fi strength only
while the network popup is open. [ADR-0014](0014-budgets-measured-as-uwuis.md) allowed no own
wake-up but a visible clock's tick. The [audit of 2026-11-17](../audits/2026-11-17-architecture.md)
(finding 5) found that, read literally, this forbids the notification server, the polkit agent,
the tray's watcher, logind's signals, the portal backends, `hollow msg`, Yuna's events, the
clipboard's history and every timed duty. Rest had no definition that could be tested.

Read at their sources on 2026-11-17:

- NetworkManager reads the Wi-Fi signal every 6 s while connected, whether anyone listens or
  not. It emits `PropertiesChanged` on the access point only when the percent changes
  (`nm-device-wifi.c`, `nm-wifi-ap.c`).
- UPower polls each battery every 30 s (every 5 s while an estimate is missing), whether anyone
  listens or not. Its `UpdateTime` changes at each poll, so `PropertiesChanged` comes at least
  every 30 s (`up-device-battery.c`).
- A D-Bus match rule on `PropertiesChanged` filters by interface, not by which property changed.
- GNOME's panel shows the Wi-Fi strength (`network.js`). Amane wakes 68 times a second at rest
  ([`measurements.md`](../measurements.md)).

## Decision

The owner chose, on 2026-11-18:

**Hollow is at rest when the owner is not using it and nothing it shows changes.** What is
*shown* is what the owner can see. Nothing is shown on an output that is off. While the session
is locked, only the lock screen is shown. Under a fullscreen game or film, only what
[ADR-0010](0010-over-a-fullscreen-game-or-film-a-setting.md)'s setting shows. At rest:

- **Listening is allowed.** The endpoints Hollow serves or must hear wait in the kernel and cost
  nothing: its D-Bus names, the polkit agent, logind's signals, Yuna's events, `hollow msg`, the
  clipboard. A wake-up there comes from another program's message and is counted under its
  sender. Senders that chatter (Yuna's events, tray icons, the primary selection) are coalesced
  per sender and bounded. Hollow asks Yuna only for the kinds of events it shows.
- **A subscription is held only while what it feeds is shown.** Its handle is dropped when the
  output goes off, the session locks, or a fullscreen surface covers it. What it shows is read
  again when it is shown again. The bar follows the battery as one aggregate device. Its Wi-Fi
  icon shows the signal's strength in four levels, and is drawn again only when the level
  changes.
- **Hollow's own wake-ups are deadlines the owner sees**, each a single timer set to an absolute
  time and set again after a change of the clock, a resume or a new time zone. They are never
  checked periodically. A deadline due while every output is off is met when an output comes
  back.
- **Every wake-up allowed at rest is listed** in the ROADMAP's table *What may wake Hollow at
  rest*: its source, when, its cadence, its measured cost and what removes it. Only the owner
  adds a row, as for a budget.
- **Forbidden**: polling; a timer not tied to a deadline the owner sees; a retry on a timer, when
  Hollow can wait for the service's name to appear instead; a subscription for something not
  shown; a frame without a change.

With every output off, `hollow` wakes only for messages addressed to it.

**The rest budget**: zero own wake-ups but the table's deadlines; zero frames; zero percent of a
core. Wake-ups caused by others are counted by sender, each traced to a row of the table or to a
message addressed to Hollow. Hollow names each of its wake-ups by its source, as Yuna does
(Yuna's ADR-0082). Tests run on a manual clock, so that a deadline never makes a measure pass or
fail by its timing.

**Hollow asks Yuna** for the power state of each output, and for a subscriber's choice of the
kinds of events it receives ([`needs.md`](../needs.md#yuna), rows 20 and 21).

## Alternatives considered

- **Duties configured by the owner allowed if documented**, without a closed table or a figure:
  simpler, but nothing could test it, and any duty would enter that way.
- **Only what is shown**, with no duty outside it: the most frugal; the table is already limited
  to what is shown, and holds deadlines only.
- **The Wi-Fi strength in the popup alone**, as ADR-0004 had it: no cost, but a weak signal goes
  unseen at a glance. Its cost is at most one wake-up every 6 s while an output is on, against
  Amane's 68 a second.
- **A setting to hide the strength**: one more setting to keep and test, which nothing needs yet.
- **Filtering Yuna's events in Hollow**: no need asked of Yuna, but every window's change of title
  would wake Hollow.

## Consequences

- The first principle, `AGENTS.md`'s rule and the rest budget say what this decision says.
- Rest with the screens off needs Yuna's rows 20 and 21. Until Yuna gives them, Hollow cannot
  hold rest with the outputs off, nor test it.
- Each service's client knows when what it feeds is shown, through its subscription's handle
  ([ADR-0018](0018-system-services-on-a-thread-of-their-own.md)).
- A feature that needs a new row in the table is put to the owner with its figure.

## Validation and reconsideration

Evidence at the time: the sources above and a challenge by a second reviewer; the costs in the
table are not measured yet. Scenarios, in the ROADMAP's table: ten minutes locked, ten with the
outputs off and ten under a fullscreen game, with Wi-Fi and the battery in the bar, wake nothing
beyond the table; fake services at their real cadence cause only the table's wake-ups, and
frames only when the level shown changes; ten windows retitled each second and a tray icon
changing ten times a second keep the wake-ups bounded per sender; a clock set back, a resume
after eight hours and a new time zone fire each deadline once, at its new time. Proposed again if
a measured row costs more than its figure, or if Yuna declines rows 20 or 21.
