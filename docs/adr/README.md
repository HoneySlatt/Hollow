# Architecture decision records

An ADR records one decision: its context, the decision, the alternatives rejected, the
consequences, and how it is checked and when it would be proposed again. Once accepted, only its
status changes ([ADR-0020](0020-hollows-rules-aligned-with-the-method.md)).

- A decision changed, even in part, is a new ADR that supersedes the old one and states the whole
  rule then in force on its topic: its status is `Accepted; supersedes NNNN`, the old one's
  `Superseded by NNNN`. One ADR is read for a topic, never a chain of amendments.
- An ADR that holds several topics and changes on one of them alone is superseded in part: the new
  one states that topic's rule whole, `Accepted; supersedes in part NNNN (the topic)`, the old one
  `Accepted; superseded in part by NNNN (the topic)`, and stays in force for the rest.
- An ADR that adds a decision without changing one names the older in its context alone.
- A precision decided while a milestone runs goes in the milestone's plan or in a new ADR, never
  into an older ADR's status.

New ADRs copy [`0000-template.md`](0000-template.md) and take the next free number. ADRs of other
projects are named with their project: "Yuna's ADR-0057".

| ADR | Title | Status |
|---|---|---|
| [0001](0001-what-hollow-is.md) | What Hollow is | Accepted |
| [0002](0002-uwui-and-no-code-before-its-first-stage.md) | uwui draws Hollow, and no code before uwui's first stage | Accepted; superseded in part by 0017 (when Hollow's code starts) |
| [0003](0003-one-process-the-greeter-apart.md) | One process, the greeter apart | Accepted; superseded in part by 0016 (a crash while locked and its recovery), 0021 (each component's failure and the restart) |
| [0004](0004-system-services-hollows-own-clients-on-zbus.md) | System services: Hollow's own clients on zbus | Accepted; superseded in part by 0018 (where the services run), 0022 (what a service follows) |
| [0005](0005-the-lock-screen.md) | The lock screen | Accepted; superseded in part by 0016 (who holds sleep back and blanks the outputs) |
| [0006](0006-the-login-screen-on-yunas-greeter-mode.md) | The login screen on Yuna's greeter mode | Accepted |
| [0007](0007-themes-hollows-own-engine.md) | Themes: Hollow's own engine | Accepted; superseded in part by 0024 (how a switch is applied and announced) |
| [0008](0008-configuration-in-kdl.md) | Configuration in KDL | Accepted; superseded in part by 0023 (the state file, and errors in the configuration) |
| [0009](0009-shortcuts-commands-and-agents.md) | Shortcuts, commands and agents | Accepted |
| [0010](0010-over-a-fullscreen-game-or-film-a-setting.md) | Over a fullscreen game or film: a setting | Accepted |
| [0011](0011-replacing-amane-parity-then-the-switch.md) | Replacing Amane: parity, then the switch | Accepted |
| [0012](0012-gpl-3-0-or-later.md) | GPL-3.0-or-later, public from the start | Accepted |
| [0013](0013-accessibility-keyboard-and-reduced-motion-first.md) | Accessibility: the keyboard and reduced motion first | Accepted |
| [0014](0014-budgets-measured-as-uwuis.md) | Budgets measured as uwui's | Accepted; superseded in part by 0022 (the rest budget) |
| [0015](0015-what-hollow-asks-of-yuna-and-uwui.md) | What Hollow asks of Yuna and uwui | Accepted |
| [0016](0016-recovering-a-locked-session.md) | Recovering a locked session whose locker is gone | Accepted; supersedes in part 0003 (a crash while locked and its recovery), 0005 (who holds sleep back and blanks the outputs) |
| [0017](0017-each-stage-opens-on-named-deliverables.md) | Each stage opens on named deliverables, each with its project | Accepted; supersedes in part 0002 (when Hollow's code starts); superseded in part by 0018 (what uwui gives the services) |
| [0018](0018-system-services-on-a-thread-of-their-own.md) | System services on a thread of their own | Accepted; supersedes in part 0004 (where the services run), 0017 (what uwui gives the services) |
| [0019](0019-the-lock-screen-answers-yunas-ping.md) | The lock screen answers Yuna's ping from the thread that draws it | Accepted |
| [0020](0020-hollows-rules-aligned-with-the-method.md) | Hollow's rules aligned with the method | Accepted |
| [0021](0021-what-survives-a-failure-of-hollow.md) | What survives a failure of `hollow` | Accepted; supersedes in part 0003 (each component's failure and the restart) |
| [0022](0022-what-rest-allows.md) | What rest allows | Accepted; supersedes in part 0004 (what a service follows), 0014 (the rest budget) |
| [0023](0023-formats-across-versions.md) | Formats across versions | Accepted; supersedes in part 0008 (the state file, and errors in the configuration) |
| [0024](0024-a-theme-switch-completed-after-any-interruption.md) | A theme switch completed after any interruption | Accepted; supersedes in part 0007 (how a switch is applied and announced) |
| [0025](0025-the-notification-portal-served-by-hollow.md) | The Notification portal served by Hollow | Accepted |
| [0026](0026-the-first-rust-toolchain.md) | The first Rust toolchain | Accepted |
