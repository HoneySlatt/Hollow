# Audit of the architecture, 2026-11-17

## Scope

- **Asked by** the owner: the architecture, how open it is to contributors, and whether it stays
  sound, durable, evolvable and stable.
- **Starting commit**: `dfd2807`. Hollow had no code; the audit covers its design, contracts,
  order and readiness for development, not an implementation.
- **Dimensions**: architecture and evolvability; stability and recovery; security and privacy;
  data safety; documentation and contributors; tests and budgets as planned.
- **Read beside Hollow**: Yuna's `docs/client-needs.md` and ADRs 0057, 0064, 0065, 0079, 0080,
  0082, 0084; uwui's `docs/ROADMAP.md` and `docs/PLAN.md`; SlimeEngine's `docs/uwui-needs.md` and
  `docs/PLAN.md`; the owner's project method as updated on 2026-11-16, which added architecture
  and stability to the bar after Hollow's design.

## How

The audit read documents only; nothing was built or run. Facts outside the repositories were
checked at their source: zbus 6.3's `Runtime` trait on docs.rs, polkit's `NEWS.md`,
`ext-session-lock-v1.xml` in wayland-protocols 1.49, the record of CVE-2026-25704. A second
review, in a fresh context, was given the evidence and open questions rather than conclusions;
its citations were checked again. Each finding below is marked fact (cited), reasoning, or to
verify.

## Findings

Ranked by severity. *Due* is the latest point before the fix costs much more.

| # | Finding | Evidence | Severity | Due | Outcome |
|---|---|---|---|---|---|
| 1 | No way back into a locked session whose locker crashes in a loop: ADR-0003's `loginctl unlock-session` is handled by nothing; a restarted `hollow` cannot learn it must take the lock over; who holds sleep back was unclear | ADR-0003; Yuna's ADR-0065, 0080, 0082; the protocol's text | High | Yuna's design of its Stage 2 | Decided: [ADR-0016](../adr/0016-recovering-a-locked-session.md); rows 14 to 18 of [`needs.md`](../needs.md) asked of Yuna on 2026-11-17 |
| 2 | The gate of Stage 1 named deliverables that no plan holds; uwui's API is declared stable at the end of its first stage, before any shell surface uses it | uwui's ROADMAP, first stage; SlimeEngine's `uwui-needs.md`, every Hollow row "New" | High | SlimeEngine's M6d.10b, which plans uwui's first stage | Decided: [ADR-0017](../adr/0017-each-stage-opens-on-named-deliverables.md) |
| 3 | ADR-0003's "a panic in one rebuilds that component" holds without conditions; aborts, native faults, a lost GPU device, a hung thread or a protocol error cannot be contained in-process, and the lock object must never be rebuilt | ADR-0003; Yuna's ADR-0080 on the same question; the protocol forbids `destroy` after `locked` | High | Stage 1's first commit | Decided: [ADR-0021](../adr/0021-what-survives-a-failure-of-hollow.md) |
| 4 | ADR-0004's "no thread" does not fit zbus's `Runtime`, whose `spawn_blocking` runs work "off the event loop" and whose `spawn` takes `Send` futures; who owns connections and subscriptions, and who stops them, is unwritten; zbus on one thread of its own, feeding uwui's channels, was never weighed and would ask nothing of uwui | zbus 6.3 docs; uwui's ROADMAP on its executor and channels | Medium to high | Before M6d.10b, so that uwui is not asked for a host it may not need | Decided: [ADR-0018](../adr/0018-system-services-on-a-thread-of-their-own.md); its prototype and bounds at Stage 1's design |
| 5 | "Subscribed only while something shown needs it" forbids, read literally, the notification server, the polkit agent, the tray's watcher, logind's signals, the clipboard history and timed duties; rest has no coherent definition | AGENTS.md; ROADMAP principle 1 and its rest budget; ADR-0004 | Medium | Stage 1's design | Decided: [ADR-0022](../adr/0022-what-rest-allows.md) |
| 6 | Secrets pass through more than the field and the PAM helper: network and pairing secrets, core dumps holding a typed password or a decrypted history; uwui plans masked fields, not a secret field kept out of undo, the accessibility tree, agents, the clipboard and dumps; an agent's identity on a socket of the same user cannot be proven | AGENTS.md; uwui's ROADMAP; ADR-0009 | Medium to high | The secret field: before uwui's API is declared stable | Partly decided: the secret field asked of uwui ([`needs.md`](../needs.md#uwui), row 11); Hollow's own policy at Stage 3's design |
| 7 | Formats without an envelope or a rule for an older Hollow after a rollback; no transaction for a theme switch over about 34 applications; encrypted histories without a decision (key, locked keyring, retention); nobody named to write the greeter's folder, the class of CVE-2026-25704 | ADR-0006, 0007, 0008; ROADMAP's histories budget | Medium | Before a format is published | Partly decided: [ADR-0023](../adr/0023-formats-across-versions.md), [ADR-0024](../adr/0024-a-theme-switch-completed-after-any-interruption.md); the histories and the greeter's folder in the PLAN's debt |
| 8 | Applications the launcher starts would die with `hollow` on a restart unless each runs in a scope of its own | Reasoning; systemd's default kill mode to verify | Medium | Before the launcher | Decided: [ADR-0021](../adr/0021-what-survives-a-failure-of-hollow.md) |
| 9 | Budgets: CI draws on the CPU, so it cannot show 240 Hz motion or one-frame input; the launcher's budget mixes first answer and full result; the own cost needs a blank layer surface nobody built | ROADMAP's budgets; ADR-0014 | Medium | Stage 2's design | Partly decided: the baseline is a Stage 2 deliverable ([ADR-0017](../adr/0017-each-stage-opens-on-named-deliverables.md)); the rest open |
| 10 | `needs.md` marked every Yuna need "Asked" though Yuna had decided or planned all but one; the Notification portal, which Yuna's ADR-0057 gives the shell, is missing from Hollow's plan | Yuna's `client-needs.md`, ADR-0057 | Low | At once | `needs.md` fixed; the portal decided: [ADR-0025](../adr/0025-the-notification-portal-served-by-hollow.md) |
| 11 | Hollow's rules lag the method of 2026-11-16: "No abstraction without a second concrete use" forbids boundaries the method asks for (a protected invariant, a test seam); the definition of done lacks contracts and stability scenarios; the ROADMAP has no change and failure scenarios; ADRs may be amended rather than superseded whole | AGENTS.md; the method's templates | Medium | Stage 1's design | Decided: [ADR-0020](../adr/0020-hollows-rules-aligned-with-the-method.md) |
| 12 | An outside contributor cannot test without a real session, report a flaw privately, or propose a decision: no `SECURITY.md`, no `CONTRIBUTING.md`, no headless script with a private system bus; the measures relied on the owner's own tools | Repository listing; GitHub's security policy off | Medium | `SECURITY.md` now; the rest at Stage 1's first milestone | [`SECURITY.md`](../../SECURITY.md) added, private reporting turned on; the rest at Stage 1's first milestone |

## Kept

- PAM in a helper per attempt, and the greeter apart.
- The lock on `ext-session-lock-v1`, which Yuna's scene enforces through a restart of Yuna.
- Keys bound in Yuna, with no process per key.
- Subscriptions rather than polls, from Amane's measured 68 wake-ups a second.
- The greeter's appearance as data only, opened without following links.
- Untrusted input bounded and fuzzed; logind's signals checked against their sender.
- Needs written by each project in its own documents.

## The owner's decisions

- The locked session recovered in four layers: [ADR-0016](../adr/0016-recovering-a-locked-session.md).
- Each stage opens on named deliverables, each with its project:
  [ADR-0017](../adr/0017-each-stage-opens-on-named-deliverables.md). A trial of a shell's surfaces
  among uwui's trials before its API is declared stable was not taken.
- Hollow's services on a thread of their own, uwui's need 1 withdrawn:
  [ADR-0018](../adr/0018-system-services-on-a-thread-of-their-own.md).
- A secret text field asked of uwui, rather than one drawn by Hollow.
- `SECURITY.md`, and GitHub's private vulnerability reporting turned on.

At the design session the owner asked for after the audit, on 2026-11-17 and 2026-11-18:

- Hollow's rules aligned with the method:
  [ADR-0020](../adr/0020-hollows-rules-aligned-with-the-method.md).
- What survives a failure of `hollow`, and launched programs in units of their own:
  [ADR-0021](../adr/0021-what-survives-a-failure-of-hollow.md); row 19 of
  [`needs.md`](../needs.md#yuna) to ask of Yuna.
- What rest allows: [ADR-0022](../adr/0022-what-rest-allows.md); rows 20 and 21 of
  [`needs.md`](../needs.md#yuna) to ask of Yuna.
- Formats across versions: [ADR-0023](../adr/0023-formats-across-versions.md). A theme switch
  completed after any interruption:
  [ADR-0024](../adr/0024-a-theme-switch-completed-after-any-interruption.md); a precision of row 8
  of [`needs.md`](../needs.md#yuna) to ask of Yuna.
- The Notification portal served by Hollow:
  [ADR-0025](../adr/0025-the-notification-portal-served-by-hollow.md); row 22 of
  [`needs.md`](../needs.md#yuna) to ask of Yuna.

## Fixed

- [`needs.md`](../needs.md) read again against Yuna's and SlimeEngine's documents.
- The gate rewritten in the PLAN, the ROADMAP, `AGENTS.md`, the README and the CHANGELOG.

## Open

The open findings are in the known debt of [`PLAN.md`](../PLAN.md), each with what follows it.
To verify: what zbus runs through `spawn_blocking`; whether uwui's executor takes `Send` futures;
whether core dumps are kept by default on NixOS; polkit's rule for unlocking one's own session.
Checked on 2026-11-17 at their sources: systemd's default kill mode is `control-group`; tray items
register again with a new watcher ([ADR-0021](../adr/0021-what-survives-a-failure-of-hollow.md)).
