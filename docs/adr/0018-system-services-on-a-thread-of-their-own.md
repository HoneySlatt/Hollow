# 0018. System services on a thread of their own

- Status: Accepted; supersedes in part [0004](0004-system-services-hollows-own-clients-on-zbus.md)
  (where the services run), [0017](0017-each-stage-opens-on-named-deliverables.md) (what uwui
  gives the services)
- Date: 2026-11-17

## Context

[ADR-0004](0004-system-services-hollows-own-clients-on-zbus.md) runs Hollow's own D-Bus clients
on its host's loop, through zbus's `Runtime` trait, "with no tokio and no thread of zbus's". It
asks uwui for a host loop that runs a foreign runtime's tasks with no thread of its own (uwui's
need 1 in [`needs.md`](../needs.md#uwui)). Read on 2026-11-17
([audit](../audits/2026-11-17-architecture.md), finding 4):

- zbus 6.3's `Runtime` asks for `spawn` of `Send` futures, `spawn_process`, and `spawn_blocking`,
  documented as "Run `work` off the event loop": some thread exists whatever the host does. "zbus
  never polls `runtime` itself": its tasks progress only while the host runs them (docs.rs,
  `zbus::connection::Builder::runtime`).
- uwui's first stage holds an executor whose tasks are owned by the scope that started them and
  cancelled with it. Other threads change the interface through a channel that a task of the view
  receives, a burst taken whole in the next frame (uwui's `docs/ROADMAP.md`, SlimeEngine's
  ADR-0211, measured there).
- uwui's need 1 has no stage, and uwui's API is declared stable at the end of its first stage.

Running zbus's tasks on uwui's loop would mix two models of task ownership, ask uwui for a
capability only Hollow uses, and still need a thread.

## Decision

The owner chose, on 2026-11-17:

- **Hollow's services run on one thread of their own**, the *services thread*. It runs zbus's
  connections, on zbus's own runtime or on a small executor of Hollow's, which Stage 1's
  prototype chooses.
- **The services thread owns** the connections, the names Hollow serves on D-Bus, the
  subscriptions with their match rules, and the tasks that serve them.
- **The interface reaches the services by messages.** A request goes to the services thread. A
  subscription is a handle: dropping it ends the subscription there. Changes come back through
  uwui's channels, a burst taken whole in the next frame.
- **At rest the services thread sleeps in the kernel**: no timer, no poll, no wake-up of its own.
  It is counted in the rest budget like every thread of `hollow`.
- **ADR-0004 otherwise stands**: Hollow's own clients on zbus, no tokio, polkit's own protocol,
  audio chosen by a measured prototype.
- **uwui's need 1 is withdrawn.** Hollow asks nothing new of uwui for its services.

## Alternatives considered

- **zbus's tasks on uwui's loop** (ADR-0004 as written): one loop and no hop between threads; but
  a new capability asked of uwui before its API is declared stable, for Hollow alone, a thread
  still needed for blocking work, and two models of task ownership on one loop.
- **tokio on one thread**: a widespread runtime; but the dependency ADR-0004 kept out, for nothing
  this decision lacks.

## Consequences

- `hollow` has one more thread, and a message between threads for each request and each change.
- The services' state lives on the services thread; the interface holds what it shows. A peer
  that hangs on D-Bus cannot freeze the interface.
- Stage 1's list of deliverables takes uwui's channels from other threads, in uwui's first stage,
  instead of uwui's need 1 ([ADR-0017](0017-each-stage-opens-on-named-deliverables.md)).
- Where zbus's blocking work and child processes run, and the bounds of the requests and changes
  between the two threads, are set at Stage 1's design.

## Validation and reconsideration

Evidence at the time: zbus's and uwui's documents; reasoning; no code. A prototype, thrown away,
at Stage 1's design, against a fake service on a private bus, measures:

- the services thread's own wake-ups over 30 s at rest: zero;
- the time from a D-Bus signal to the interface's next frame;
- the thread's memory.

Proposed again if the runtime chosen cannot sleep without waking, or if the time between threads
misses the one-frame budget at 240 Hz.
