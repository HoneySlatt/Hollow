# 0017. Each stage opens on named deliverables, each with its project

- Status: Accepted; supersedes in part [0002](0002-uwui-and-no-code-before-its-first-stage.md)
  (when Hollow's code starts); superseded in part by
  [0018](0018-system-services-on-a-thread-of-their-own.md) (what uwui gives the services)
- Date: 2026-11-17

## Context

[ADR-0002](0002-uwui-and-no-code-before-its-first-stage.md) let Hollow's code start once "uwui's
first stage" is done, and the PLAN read that as "its host loop, its executor and its layer-shell
target". Read on 2026-11-17 ([audit](../audits/2026-11-17-architecture.md)):

- uwui's first stage, in uwui's `docs/ROADMAP.md`, holds its executor but neither a layer-shell
  target, nor a session-lock target, nor a host loop that runs a foreign runtime's tasks. It ends
  when "uwui's API is declared stable".
- uwui's KDL reader comes before that stage: SlimeEngine's Stage 6d builds it.
- uwui's first stage is planned at SlimeEngine's milestone M6d.10b, after three others. Every row
  Hollow asked of uwui is marked "New" in SlimeEngine's `docs/uwui-needs.md`, with no stage,
  although that file's rule is that each mark names the first stage that needs it.

The gate as written would never open by itself, and it names deliverables that no plan holds.

## Decision

The owner chose, on 2026-11-17:

- **uwui comes first, unchanged.** Hollow never takes priority over uwui (Yuna's ADR-0003). A
  gate that is met lets the owner open the stage, weighed against uwui's needs at that time; it
  never opens one by itself.
- **Each stage opens on a list of deliverables**, each with the project that builds it and the
  stage that plans it, kept in [`needs.md`](../needs.md):
  - **Stage 1**, the core without drawing: uwui's KDL reader; uwui's executor, with the host loop
    that runs Hollow's services as [ADR-0004](0004-system-services-hollows-own-clients-on-zbus.md)
    sets it; uwui's core for agents and its declared actions.
  - **Stage 2**, the surfaces: uwui's layer-shell target, its popups anchored to layer surfaces,
    one surface per output as outputs come and go, surfaces made on demand that give back their
    GPU memory while hidden, and a blank layer surface as the baseline of the own cost; the
    rivals measured again on the GPU above it
    ([ADR-0014](0014-budgets-measured-as-uwuis.md)).
  - **Stage 3**, lock and login: uwui's session-lock target; Yuna's greeter mode and what
    [ADR-0016](0016-recovering-a-locked-session.md) asks of Yuna; the lock in headless Yuna.
- **Hollow asks each project, through the owner, to name the stage of each deliverable.** Where
  none is named, `needs.md` says so plainly.
- **Each stage still opens with a design session of its own.**

## Alternatives considered

- **Keep the gate as written**: nothing to change; but it never opens, and it names nothing any
  plan holds.
- **The same lists, and a trial of a shell's surfaces among the trials uwui runs before its API is
  declared stable**: a misfit found before the freeze, when it costs least; but it asks uwui for
  a trial. Not taken.
- **The services first, now**, on zbus's own runtime (ADR-0002's alternative): progress at once;
  declined again, for the owner's attention.

## Consequences

- [`PLAN.md`](../PLAN.md) replaces its "Before Stage 1 opens" with these lists; the ROADMAP's
  open decision on the KDL reader names SlimeEngine's Stage 6d.
- [`needs.md`](../needs.md) gives each need the stage the other project holds it in, or none.
- If ADR-0004's way of running the services changes, Stage 1's list changes with it.
- Hollow's code may start before uwui's whole first stage ends, if the owner opens Stage 1 once
  its list is met.

## Validation and reconsideration

Checked each time `needs.md` is read again against Yuna's and uwui's documents: every deliverable
names a stage or says it has none. Proposed again if uwui plans a deliverable of Stage 2 or 3
after its API is declared stable, since a misfit would then cost a change to a stable API.
