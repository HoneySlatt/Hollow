# 0020. Hollow's rules aligned with the method

- Status: Accepted
- Date: 2026-11-17

## Context

Hollow's rules were written on 2026-11-14. On 2026-11-16 the owner's project method added
architecture and stability to the quality bar: explicit contracts, owned state, contained
failures, and realistic change and failure scenarios checked at each milestone. The
[audit of 2026-11-17](../audits/2026-11-17-architecture.md) (finding 11) found four places where
Hollow's rules lag it:

- **Abstractions.** `AGENTS.md` said "No abstraction without a second concrete use". The method
  also allows a boundary around an unstable dependency, an invariant it protects, and a test that
  needs it. Hollow already needs such boundaries with one use: a type that holds the lock object
  and cannot rebuild it, and the services thread's runtime, which a prototype has yet to choose
  ([ADR-0018](0018-system-services-on-a-thread-of-their-own.md)).
- **The definition of done** did not ask that the contracts and stability scenarios a milestone
  touches be checked.
- **The ROADMAP** held budgets, but no change or failure scenarios.
- **ADRs** could be amended by later ones. A reader then had to follow a chain: the deliverables
  that open Stage 1 were in [ADR-0017](0017-each-stage-opens-on-named-deliverables.md), and
  [ADR-0018](0018-system-services-on-a-thread-of-their-own.md) changed one of them.

## Decision

The owner chose, on 2026-11-17, the method's rules:

- **An abstraction needs a concrete benefit**: a second use, a boundary around a dependency still
  unstable, an invariant it protects, or a test that needs it. Its reason is written where it is
  declared. No speculative extension points. The rule against preparing abstractions for later
  stages stays.
- **The definition of done checks** the contracts and the scenarios a milestone touches. The
  evidence, and what stays unverified, go to `docs/measurements.md` or the milestone's review.
- **The ROADMAP holds a table of architecture and stability scenarios**, filled now with those the
  decided ADRs imply, and by each later decision with its own.
- **A decision changed is superseded, whole or for one topic**, by a new ADR that states that
  topic's rule whole; one ADR is read for a topic ([`README.md`](README.md)). The four earlier
  amendments become supersessions in part, their topics unchanged: each newer ADR was read again
  and states its topic whole. ADR-0017's Stage 1 deliverable for the services is superseded in
  part by ADR-0018. Every ADR gains a section *Validation and reconsideration*.

## Alternatives considered

- **Hollow's abstraction rule kept, with each other boundary justified by an ADR**: stricter, but
  an ADR for every type that protects an invariant.
- **Hollow's abstraction rule kept as written**: the lock's guard and the boundary around zbus's
  runtime forbidden, or worked around.
- **Scenarios checked at stage audits only**: less work per milestone, but faults found late.
- **An empty scenarios section, filled at Stage 1's design**: the decisions of this session would
  have nowhere to put their criteria.
- **The method's rule for new ADRs only**: less work, but two conventions side by side, and the
  chains already written kept.
- **Amendments kept**: no change, and a rule read across several ADRs.

## Consequences

- `AGENTS.md`, the ROADMAP, the ADR index, the template and the statuses of ADRs 0002, 0003,
  0004, 0005, 0016, 0017 and 0018 change. No decision's content changes.
- Each milestone costs a little more: the scenarios it touches are checked, not only its budgets.
- A later change to a topic costs a new ADR stating it whole, rather than a short amendment.

## Validation and reconsideration

Evidence at the time: the method's templates and `quality-bars.md`, and Hollow's documents read
again; no code exists. Checked at each milestone's review, against `AGENTS.md`: every abstraction
names its benefit where it is declared; the ROADMAP's scenarios the milestone touches have
evidence; no ADR's rule is spread over several. Proposed again if the method changes these rules,
or if the scenarios' checks cost more than the faults they find, as a stage's audit shows.
