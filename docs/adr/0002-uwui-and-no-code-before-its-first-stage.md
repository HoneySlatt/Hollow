# 0002. uwui draws Hollow, and no code before uwui's first stage

- Status: Accepted; amended by [0017](0017-each-stage-opens-on-named-deliverables.md) (when
  Hollow's code starts)
- Date: 2026-11-14

## Context

uwui is the owner's interface toolkit in Rust. It is embedded in a host, draws on the GPU, keeps
its themes as data, reads layouts in KDL, and has its own executor and its own core for agents.
Yuna's ADR-0063 and SlimeEngine's ADR-0266 made Hollow, its lock screen and its login screen
targets of uwui.

On 2026-11-14 uwui was still leaving SlimeEngine; its first stage had not started. The surfaces a
shell needs (layer shell, session lock) are listed as new needs of uwui's. Yuna was in its first
stage, headless; its desktop comes at its Stage 2. Yuna's ADR-0003 puts uwui first on any conflict
of the owner's attention, quota or measuring machine.

## Decision

The owner chose, on 2026-11-14:

- **Hollow draws with uwui**, as Yuna's ADR-0063 decided. Its look is decided when uwui's themes
  are ready.
- **Hollow writes no code before uwui's first stage.** Until then, Hollow is its design, its
  decisions and its needs, which uwui's and Yuna's sessions take into their own plans
  ([ADR-0015](0015-what-hollow-asks-of-yuna-and-uwui.md)).
- **Hollow never takes priority over uwui.**

## Alternatives considered

- **The theme engine first** (the lead's recommendation): the theme engine and the Settings
  portal backend need nothing from uwui. They could have replaced Amane's theme scripts at once,
  under Umbriel, without adding to Amane. Declined: the owner keeps the attention for uwui.
- **The services first**, on zbus's own runtime, moved onto uwui's later: progress on the largest
  part, but a move to make and nothing usable for long.
- **The surfaces now, on uwui inside SlimeEngine**: early pixels, on moving interfaces.
- **Another toolkit** (Quickshell, Iced, GTK4): usable at once, but outside the owner's stack
  (Yuna's ADR-0063).

## Consequences

- The first stage of Hollow opens with a design session of its own, once uwui's first stage is
  done.
- What Hollow needs from uwui reaches uwui early, so that its first stage can hold it.
- No figure of Hollow's own can be measured before then. The rivals' figures are measured now
  ([`measurements.md`](../measurements.md)).
