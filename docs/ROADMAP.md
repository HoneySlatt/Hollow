# Roadmap

Hollow's direction: what it is, its quality bar, its decisions, and its stages in order. The current
work is in [`PLAN.md`](PLAN.md); the decisions and why, in [`adr/`](adr/README.md); the facts behind
them, in [`survey.md`](survey.md). Stages are merged, reordered or dropped as the project evolves;
each change is recorded in an ADR.

## 1. Vision

Hollow is its owner's desktop shell, in Rust, on Yuna, the owner's Wayland compositor, drawn with
uwui, the owner's interface toolkit ([ADR-0001](adr/0001-what-hollow-is.md),
[ADR-0002](adr/0002-uwui-and-no-code-before-its-first-stage.md)). It replaces Amane. It holds the
bar, one launcher with its providers, notifications, the tray, the control centre and its popups,
the on-screen displays, the calendar, the lock screen, the login screen, the polkit agent and the
theme of the other applications and websites; then the clipboard, emoji, the on-screen keyboard,
focus modes, the dock, widgets, the weather and the indicators of the microphone, the camera and a
shared screen.

Excellent means: the look and motion of the most refined current interfaces, every animation at
the display's rate up to 240 Hz, and nothing at all at rest: no frame, no processor time, no
wake-up of its own. It is lighter than any rival on every machine it runs on.

It is made for its owner first, and public, under GPL-3.0-or-later
([ADR-0012](adr/0012-gpl-3-0-or-later.md)).

## 2. Principles

1. **Nothing runs, polls or draws at rest.** A service is followed only while something shown needs
   it.
2. **Yuna does what a compositor does; Hollow never does it again**: the wallpaper, idle, captures,
   night light, brightness (Yuna's ADR-0057 and ADR-0064).
3. **Games and films come first**: what Hollow shows over them is the owner's setting
   ([ADR-0010](adr/0010-over-a-fullscreen-game-or-film-a-setting.md)).
4. **uwui comes first**: Hollow never takes priority over uwui (Yuna's ADR-0003).
5. **Passwords and the owner's data are guarded**: PAM in a helper, untrusted input bounded and
   fuzzed, formats versioned.
6. **Measured, not claimed**: every budget has its measure, kept in
   [`measurements.md`](measurements.md).

## Quality bar

References, each for what it does best ([survey](survey.md)):

| Criterion | Reference |
|---|---|
| Breadth of a Linux shell | Noctalia |
| Memory and rest of a bar | eww, a minimal Quickshell bar |
| Memory and rest of a notification daemon | mako |
| Memory and rest of a lock screen | swaylock |
| Launcher | Raycast, Spotlight, PowerToys' Command Palette |
| Look and motion | the most refined current interfaces: glass, springs, shapes that morph |
| Theming other applications | Noctalia, matugen |

Machines, Yuna's ([ADR-0001](adr/0001-what-hollow-is.md)):

- **High tier**: RX 6900 XT, Ryzen 7 5800X, 3840 × 2160 at 240 Hz, scale 1.5: 4.17 ms a frame.
- **Lowest tier**: the HP laptop, AMD Athlon Silver 3050U with Radeon Vega, 4 GiB. Every feature
  works there, with lighter effects. Not measured yet.
- **Steam Deck**, in desktop mode, after Yuna's Stage 4. Not measured yet.
- **CI**: headless, on a CPU renderer.

Budgets ([ADR-0014](adr/0014-budgets-measured-as-uwuis.md)). A budget missed is debt until it is
met.

| Budget | Target | Measured by | Checked in |
|---|---|---|---|
| At rest | 0 own wake-ups a second, but a visible clock's tick at its shown precision; 0 frames; 0 % of a core | every thread's context switches over 30 s; wake-ups caused by others named by sender | CI, headless; by hand on each machine |
| Memory | own cost (Pss + GPU memory above a blank uwui layer surface per output) at most a third of the best rival's own cost in its class; about 30 MB for the whole shell, provisional | `/proc/<pid>/smaps_rollup`, the GPU's usage statistics | each milestone, on each machine |
| Start | to the bar's first frame: 100 ms warm, 500 ms cold, high tier | the log's times; `hyperfine` | each milestone |
| Input to answer | one frame | input through the compositor, presentation feedback | CI, headless |
| Motion | every animation at the display's rate, no dropped frame, at the 99th percentile | presentation feedback over scripted animations | CI, headless; by hand on the owner's monitor |
| Lock | every output blank at once (Yuna); the lock's interface within one frame of the command | the protocol's events and presentation feedback | CI, headless |
| polkit prompt | shown within one frame of the request | the agent's log and presentation feedback | CI, headless |
| Launcher | opened in one frame; a search over ten times the owner's music and games, their size read at Stage 2, answered within one frame | presentation feedback over scripted typing | CI, headless |
| A theme switch | set at its milestone, from the applications' reload times | the engine's log | each milestone |
| A flood | 1,000 notifications in a second keep the frame budget and a bounded memory | a scripted sender on a private bus | CI |
| Histories | clipboard and notification histories bounded in count and size, encrypted at rest | tests | CI |

Without a figure:

- Keyboard use of every control; reduced motion and reduced transparency honoured; contrast
  checked ([ADR-0013](adr/0013-accessibility-keyboard-and-reduced-motion-first.md)). A screen reader
  later.
- Text ready for translation.
- A crash leaves a report on the machine, which never holds a typed password.
- Parsers of other programs' data are fuzzed.

### Architecture and stability scenarios

Realistic changes and failures that Hollow's design must survive
([ADR-0020](adr/0020-hollows-rules-aligned-with-the-method.md)). Each milestone checks the rows it
touches. A change scenario is checked by tracing the code at the stage's audit, never by building
the change. Each decision adds its rows here.

| Scenario | Acceptance criterion | Checked by | Evidence |
|---|---|---|---|
| `hollow` killed while locked, or crashing at each start while locked | No frame of the session shown; a restarted `hollow` takes the lock over; a crash loop reaches the lock-only mode; logind's `Unlock` from logind unlocks, a forged one does not ([ADR-0016](adr/0016-recovering-a-locked-session.md)) | headless Yuna and a fake logind on a private system bus, Stage 3 | Stage 3's audit |
| The lock screen's thread blocked | Yuna's ping goes unanswered and Yuna counts the locker dead; a working lock screen always answers ([ADR-0019](adr/0019-the-lock-screen-answers-yunas-ping.md)) | headless Yuna, Stage 3 | Stage 3's audit |
| A D-Bus service that stops answering | The other services go on; the request fails after its timeout and the service shows as unavailable; from Stage 2, the interface keeps its frame budget ([ADR-0018](adr/0018-system-services-on-a-thread-of-their-own.md)) | a fake service on a private bus that never answers, Stage 1 | [`measurements.md`](measurements.md) |
| A subscription opened and closed 10,000 times | No match rule, task or memory left behind: the bus's match rules and `hollow`'s memory back to where they started | a soak test against fake services, Stage 1 | [`measurements.md`](measurements.md) |
| A release of uwui that breaks its API | The change stays in the code that draws; the services, the shell's state and the theme engine do not change | traced at each stage's audit | the audits |
| zbus's runtime replaced | The change stays in the services thread | traced at Stage 1's audit | the audit |

## 3. Decisions

### Fixed

| Topic | Decision |
|---|---|
| What Hollow is | The owner's shell, on Yuna only, optional, replacing Amane ([ADR-0001](adr/0001-what-hollow-is.md)) |
| Toolkit and order | uwui, which comes first; each stage opens on named deliverables ([ADR-0002](adr/0002-uwui-and-no-code-before-its-first-stage.md), [ADR-0017](adr/0017-each-stage-opens-on-named-deliverables.md)) |
| Processes | One process with the lock screen and the polkit agent; the greeter apart; PAM in a helper ([ADR-0003](adr/0003-one-process-the-greeter-apart.md)) |
| Services | Hollow's own clients on zbus, no tokio, on a thread of their own ([ADR-0004](adr/0004-system-services-hollows-own-clients-on-zbus.md), [ADR-0018](adr/0018-system-services-on-a-thread-of-their-own.md)) |
| Lock screen | `ext-session-lock-v1`, in `hollow` ([ADR-0005](adr/0005-the-lock-screen.md)); a locked session recovered in four layers ([ADR-0016](adr/0016-recovering-a-locked-session.md)); Yuna's ping answered by the lock screen's own thread ([ADR-0019](adr/0019-the-lock-screen-answers-yunas-ping.md)) |
| Login screen | `hollow-greeter` on Yuna's greeter mode, under greetd ([ADR-0006](adr/0006-the-login-screen-on-yunas-greeter-mode.md)) |
| Themes | Hollow's own engine ([ADR-0007](adr/0007-themes-hollows-own-engine.md)) |
| Configuration | KDL 2.0, a state file apart ([ADR-0008](adr/0008-configuration-in-kdl.md)) |
| Shortcuts and agents | Keys bound in Yuna; agents through uwui's core, with consent ([ADR-0009](adr/0009-shortcuts-commands-and-agents.md)) |
| Fullscreen | A setting, *nothing unless asked* by default ([ADR-0010](adr/0010-over-a-fullscreen-game-or-film-a-setting.md)) |
| Replacing Amane | Parity, then the switch ([ADR-0011](adr/0011-replacing-amane-parity-then-the-switch.md)) |
| Licence | GPL-3.0-or-later, public ([ADR-0012](adr/0012-gpl-3-0-or-later.md)) |
| Accessibility | Keyboard and reduced motion first ([ADR-0013](adr/0013-accessibility-keyboard-and-reduced-motion-first.md)) |
| Budgets | Measured as uwui's ([ADR-0014](adr/0014-budgets-measured-as-uwuis.md)) |
| Yuna and uwui | Needs kept in [`needs.md`](needs.md), written by each project ([ADR-0015](adr/0015-what-hollow-asks-of-yuna-and-uwui.md)) |

### Open

| Topic | Candidates | Decide at |
|---|---|---|
| The look | uwui's themes: its own, Glass, Material 3 Expressive | when uwui's themes are ready |
| Audio | PipeWire, or libpulse through pipewire-pulse | Stage 1, on a prototype's figures |
| The KDL reader | uwui's, shared with Yuna | SlimeEngine's Stage 6d, which builds it |
| The launcher's providers | inside `hollow`, or apart | Stage 2's design |
| Focus modes | what each allows, schedules, automatic triggers | Stage 5's design |
| OLED care of the bar | hide, dim or shift, with Yuna | Yuna's Stage 5 |
| The screen reader on the lock and login screens | Orca reads every key | its stage |

## 4. Stages

### Now: waiting for uwui

Hollow is designed; its needs are with Yuna and uwui
([ADR-0002](adr/0002-uwui-and-no-code-before-its-first-stage.md)). Each stage opens, with a design
session of its own, once the deliverables it names exist and the owner opens it
([ADR-0017](adr/0017-each-stage-opens-on-named-deliverables.md)).

### Stage 1 — The core → 0.1

**Goal.** Everything Hollow knows and does without drawing, tested headless.

- The services on zbus, on the services thread, each tested against a fake service on a private
  bus.
- The shell's state, its configuration in KDL and its state file.
- The notification server, the tray's watcher and host, the polkit agent's protocol.
- The theme engine: palettes, wallpaper palettes, sunrise and sunset, templates and their reloads,
  the Settings portal's backend, Yuna's colours file.
- `hollow msg` and the agents' actions.

**Exit.** Each service follows its fake at zero wake-ups at rest; a theme switch themes the
owner's applications on a test profile.

### Stage 2 — The surfaces → 0.2

**Goal.** Hollow draws: the bar, popups, notifications, the launcher, the on-screen displays, the
tray, the control centre and the calendar.

- On uwui's layer-shell target, tested in headless sway, then in headless Yuna.
- Every budget of rest, memory, start, input and motion measured.

**Exit.** The surfaces' budgets met on the high tier and the laptop, headless.

### Stage 3 — Lock and login → 0.3

**Goal.** The lock screen, the polkit prompt and `hollow-greeter` on Yuna's greeter mode.

**Exit.** The lock's and the prompt's budgets met; the locked session recovered after each failure
[ADR-0016](adr/0016-recovering-a-locked-session.md) names; the greeter logs in to every installed
session.

### Stage 4 — Daily use → 0.4

**Goal.** Hollow replaces Amane on Yuna ([ADR-0011](adr/0011-replacing-amane-parity-then-the-switch.md)).

- The parity list, each point tested; the owner's data moved once.
- The Nix package, its home-manager and NixOS modules.

**Exit.** A week of daily use on Yuna's desktop (Yuna's Stage 2) without going back; Amane removed.

### Stage 5 — Beyond Amane → 0.5

**Goal.** What Amane never had: the clipboard history, emoji, focus modes, the dock, widgets, the
weather, the indicators; the on-screen keyboard and touch on the Steam Deck, after Yuna's Stage 4.

**Exit.** Each feature within its budgets on every machine.

### Later

The screen reader; the audit before 1.0.

## 5. Release map

| Version | Stage |
|---|---|
| 0.1 | 1, the core |
| 0.2 | 2, the surfaces |
| 0.3 | 3, lock and login |
| 0.4 | 4, daily use |
| 0.5 | 5, beyond Amane |
| 1.0 | after the later work and its audit |

Releases: a version, a CHANGELOG and a tag, after the owner's go.
