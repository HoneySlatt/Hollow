# Glossary

The terms this project uses in a sense of its own, in alphabetical order. Each says what it means
here, and links to where it is decided.

**Dead locker.** A lock screen's client that died while the session is locked. The session stays
locked and Yuna shows a screen of its own until a new locker relieves it
([ADR-0016](adr/0016-recovering-a-locked-session.md)).

**Greeter.** The login screen, a program of its own (`hollow-greeter`) that greetd starts before
the session ([ADR-0006](adr/0006-the-login-screen-on-yunas-greeter-mode.md)).

**Greeter mode.** Yuna run under greetd as the greeter's compositor, without its command socket,
MCP, global shortcuts, portals or XWayland ([ADR-0006](adr/0006-the-login-screen-on-yunas-greeter-mode.md)).

**Lock-only mode.** How `hollow` starts after repeated crashes while the session is locked: the
lock screen, logind and Yuna alone, the default configuration, no state file
([ADR-0016](adr/0016-recovering-a-locked-session.md)).

**Need.** Something Hollow asks of Yuna or uwui, listed with its status in [`needs.md`](needs.md)
([ADR-0015](adr/0015-what-hollow-asks-of-yuna-and-uwui.md)).

**Own cost.** What a program adds above a blank uwui layer surface per output on the same driver:
its proportional memory plus its GPU memory, its processor time, its wake-ups
([ADR-0014](adr/0014-budgets-measured-as-uwuis.md)).

**Parity list.** The written list of what Amane does, each point with the test that shows Hollow
does it ([ADR-0011](adr/0011-replacing-amane-parity-then-the-switch.md)).

**Provider.** A source of results in the launcher: applications, games, music, the VPN,
wallpapers, themes, the calculator ([ADR-0001](adr/0001-what-hollow-is.md)).

**PAM helper.** The small program started for each attempt to authenticate, which talks to PAM so
that `hollow`'s process never does ([ADR-0003](adr/0003-one-process-the-greeter-apart.md)).

**Relief.** A new locker taking the lock over from a dead one
([ADR-0016](adr/0016-recovering-a-locked-session.md)).

**Services thread.** The thread of `hollow` that runs its D-Bus clients and servers and owns
their connections and subscriptions; the interface reaches it by messages
([ADR-0018](adr/0018-system-services-on-a-thread-of-their-own.md)).

**State file.** What Hollow remembers by itself (do not disturb, the last theme), apart from the
owner's configuration ([ADR-0008](adr/0008-configuration-in-kdl.md)).
