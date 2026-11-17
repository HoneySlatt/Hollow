# Plan

This file says what is being worked on now: the milestones of the current stage, their status, how
each one is checked, and the known debt. Direction beyond this stage is in
[`ROADMAP.md`](ROADMAP.md); decisions are in [`adr/`](adr/README.md). A *stage* is a step of the
roadmap; a *milestone* is a small, verifiable step of a stage.

Every milestone ends with the definition of done in [`AGENTS.md`](../AGENTS.md#definition-of-done).

## Current

- The design session ran on 2026-11-14: [ADR-0001](adr/0001-what-hollow-is.md) to
  [ADR-0015](adr/0015-what-hollow-asks-of-yuna-and-uwui.md), the [survey](survey.md), the
  [rivals' figures](measurements.md), the roadmap and its bar.
- Hollow waits for what its Stage 1 needs from uwui, by the owner's choice
  ([ADR-0002](adr/0002-uwui-and-no-code-before-its-first-stage.md),
  [ADR-0017](adr/0017-each-stage-opens-on-named-deliverables.md)). No milestone is open.
- Its needs were sent to Yuna's and SlimeEngine's sessions on 2026-11-14; Yuna has planned all but
  one ([`needs.md`](needs.md)).
- An [audit of the architecture](audits/2026-11-17-architecture.md) on 2026-11-17:
  [ADR-0016](adr/0016-recovering-a-locked-session.md) and
  [ADR-0017](adr/0017-each-stage-opens-on-named-deliverables.md) and
  [ADR-0018](adr/0018-system-services-on-a-thread-of-their-own.md) decided; its open findings are
  in the known debt below.
- Sent on 2026-11-17 to Yuna's and SlimeEngine's sessions: Yuna's rows 14 to 18 of
  [`needs.md`](needs.md); uwui's rows 10 and 11, the withdrawal of uwui's row 1, and the request
  that uwui name a stage for each of Hollow's rows.
- On 2026-11-17 the owner asked for a design session, ahead of Stage 1's, to settle the audit's
  findings 11, 3 with 8, 5, 7 and 10, in that order. It builds nothing; the services thread's
  prototype stays for Stage 1's design. Where it stands is in *Design of the audit's findings*
  below.
- Next: when Stage 1's deliverables exist and the owner opens it, Stage 1's design session plans
  its milestones here.

## Design of the audit's findings

Asked by the owner on 2026-11-17, before Stage 1 opens. Each decision is put to the owner, then
recorded in an ADR.

| Finding | Topic | Status |
|---|---|---|
| 11 | Hollow's rules aligned with the method | Decided: [ADR-0020](adr/0020-hollows-rules-aligned-with-the-method.md) |
| 3, 8 | A table of failures; launched applications in units of their own | Decided: [ADR-0021](adr/0021-what-survives-a-failure-of-hollow.md) |
| 5 | What rest allows | Decided: [ADR-0022](adr/0022-what-rest-allows.md) |
| 7 | The state file after a rollback; a theme switch as a transaction | Decided: [ADR-0023](adr/0023-formats-across-versions.md), [ADR-0024](adr/0024-a-theme-switch-completed-after-any-interruption.md) |
| 10 | The Notification portal | Decided: [ADR-0025](adr/0025-the-notification-portal-served-by-hollow.md) |

## Status

| Milestone | Goal | Status |
|---|---|---|
| Design | The decisions, the bar and the needs, before any code | Done (2026-11-14) |

## Before Stage 1 opens

Its deliverables ([ADR-0017](adr/0017-each-stage-opens-on-named-deliverables.md)); those of
Stages 2 and 3 are in the same ADR.

- uwui's KDL reader, built at SlimeEngine's Stage 6d.
- uwui's executor and its channels from other threads, in uwui's first stage, which the services
  thread uses ([ADR-0018](adr/0018-system-services-on-a-thread-of-their-own.md)).
- uwui's core for agents and its declared actions, at SlimeEngine's Stage 6d.
- `needs.md` read again against what Yuna and uwui have taken.

Stage 1's design session also settles the audit's findings due then (known debt below).

## Ideas

- **The theme engine early**: it needs nothing from uwui and could replace Amane's theme scripts
  under Umbriel as its first real use. The owner preferred to wait
  ([ADR-0002](adr/0002-uwui-and-no-code-before-its-first-stage.md)).

## Known debt

From the [audit of 2026-11-17](audits/2026-11-17-architecture.md), by what follows each:

- **Stage 1's design session**:
  - the prototype that confirms the services thread and chooses its runtime; the bounds of the
    messages between the two threads, where blocking work runs, and how the services stop
    ([ADR-0018](adr/0018-system-services-on-a-thread-of-their-own.md), finding 4); that the
    hang-up watch sleeps at rest ([ADR-0021](adr/0021-what-survives-a-failure-of-hollow.md));
  - findings 3, 5, 7 (the state file and the theme switch), 10 and 11 were moved ahead, to the
    design session above.
- **Stage 1's first milestone**: `CONTRIBUTING.md`, a headless script with private session and
  system buses, the list of contracts (finding 12).
- **Stage 2's design**: budgets checked on the GPU apart from CI's; the launcher's first answer and
  full result budgeted apart (finding 9).
- **Before the first history is stored**: its encryption, key, retention and erasure (finding 7).
- **Stage 3's design**: who writes the greeter's folder, with which rights (finding 7); whether
  `hollow` refuses core dumps, and how network and pairing secrets are handled (finding 6).
- The rivals' figures were measured with software rendering, which inflates the memory of
  programs that draw with OpenGL or Qt Quick ([`measurements.md`](measurements.md)).
- The laptop and the Steam Deck are not measured.

Finished stages move to `history.md`, in a few lines each, so that this file holds the current
stage only, under about 2,000 words.
