# Glossary

The terms this project uses in a sense of its own, in alphabetical order. Each says what it means
here, and links to where it is decided.

**Greeter.** The login screen, a program of its own (`hollow-greeter`) that greetd starts before
the session ([ADR-0006](adr/0006-the-login-screen-on-yunas-greeter-mode.md)).

**Greeter mode.** Yuna run under greetd as the greeter's compositor, without its command socket,
MCP, global shortcuts, portals or XWayland ([ADR-0006](adr/0006-the-login-screen-on-yunas-greeter-mode.md)).

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

**State file.** What Hollow remembers by itself (do not disturb, the last theme), apart from the
owner's configuration ([ADR-0008](adr/0008-configuration-in-kdl.md)).
