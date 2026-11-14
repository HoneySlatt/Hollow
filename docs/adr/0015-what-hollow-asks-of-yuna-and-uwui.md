# 0015. What Hollow asks of Yuna and uwui

- Status: Accepted
- Date: 2026-11-14

## Context

Hollow runs only on Yuna and draws with uwui. Each has its own repository and its own sessions.
Yuna's ADR-0064 promised Hollow an interface of commands and events, to be specified with
Hollow's design. SlimeEngine's `uwui-needs.md` lists what Hollow and Yuna ask of uwui.

## Decision

The owner chose, on 2026-11-14:

- **Hollow's needs are kept in [`needs.md`](../needs.md)**, with the status of each: asked, taken
  into the other project's plan, delivered.
- **Each project writes them in its own documents**, through its own session, on the owner's go:
  Yuna in its `docs/client-needs.md` and its ADRs, uwui in SlimeEngine's `uwui-needs.md`. Hollow
  writes nothing in their repositories.
- **The lists were sent** to Yuna's and SlimeEngine's sessions on 2026-11-14.
- **A screen-share indicator** is among them, at the owner's request: Yuna tells Hollow which
  program captures or casts the screen. This reverses the part of Yuna's ADR-0064 that declined
  the shell's capture indicators; Yuna records it.

## Alternatives considered

- **Keep the lists here until asked**: nothing would reach the other plans in time.
- **Write them into the other repositories from here**: against the owner's rule that each
  project's session writes its own documents.

## Consequences

- A change to the contract is decided with the owner and written in both repositories.
- `needs.md` is updated when a need is taken or delivered.
