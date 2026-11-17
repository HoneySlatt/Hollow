# Architecture decision records

An ADR records one decision: its context, the decision, the alternatives rejected and the
consequences. Once accepted, only its status changes. A later decision that replaces it whole makes
it `Superseded by NNNN`; one that changes part of it makes it `Accepted; amended by NNNN`, and the
newer one `Accepted; amends NNNN (what)`.

New ADRs copy [`0000-template.md`](0000-template.md) and take the next free number. ADRs of other
projects are named with their project: "Yuna's ADR-0057".

| ADR | Title | Status |
|---|---|---|
| [0001](0001-what-hollow-is.md) | What Hollow is | Accepted |
| [0002](0002-uwui-and-no-code-before-its-first-stage.md) | uwui draws Hollow, and no code before uwui's first stage | Accepted; amended by 0017 |
| [0003](0003-one-process-the-greeter-apart.md) | One process, the greeter apart | Accepted; amended by 0016 |
| [0004](0004-system-services-hollows-own-clients-on-zbus.md) | System services: Hollow's own clients on zbus | Accepted; amended by 0018 |
| [0005](0005-the-lock-screen.md) | The lock screen | Accepted; amended by 0016 |
| [0006](0006-the-login-screen-on-yunas-greeter-mode.md) | The login screen on Yuna's greeter mode | Accepted |
| [0007](0007-themes-hollows-own-engine.md) | Themes: Hollow's own engine | Accepted |
| [0008](0008-configuration-in-kdl.md) | Configuration in KDL | Accepted |
| [0009](0009-shortcuts-commands-and-agents.md) | Shortcuts, commands and agents | Accepted |
| [0010](0010-over-a-fullscreen-game-or-film-a-setting.md) | Over a fullscreen game or film: a setting | Accepted |
| [0011](0011-replacing-amane-parity-then-the-switch.md) | Replacing Amane: parity, then the switch | Accepted |
| [0012](0012-gpl-3-0-or-later.md) | GPL-3.0-or-later, public from the start | Accepted |
| [0013](0013-accessibility-keyboard-and-reduced-motion-first.md) | Accessibility: the keyboard and reduced motion first | Accepted |
| [0014](0014-budgets-measured-as-uwuis.md) | Budgets measured as uwui's | Accepted |
| [0015](0015-what-hollow-asks-of-yuna-and-uwui.md) | What Hollow asks of Yuna and uwui | Accepted |
| [0016](0016-recovering-a-locked-session.md) | Recovering a locked session whose locker is gone | Accepted; amends 0003, 0005 |
| [0017](0017-each-stage-opens-on-named-deliverables.md) | Each stage opens on named deliverables, each with its project | Accepted; amends 0002 |
| [0018](0018-system-services-on-a-thread-of-their-own.md) | System services on a thread of their own | Accepted; amends 0004 |
| [0019](0019-the-lock-screen-answers-yunas-ping.md) | The lock screen answers Yuna's ping from the thread that draws it | Accepted |
