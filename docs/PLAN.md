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
- Hollow waits for uwui's first stage, by the owner's choice
  ([ADR-0002](adr/0002-uwui-and-no-code-before-its-first-stage.md)). No milestone is open.
- Its needs were sent to Yuna's and SlimeEngine's sessions on 2026-11-14
  ([`needs.md`](needs.md)); each writes them in its own documents on the owner's go.
- Next: when uwui's first stage is done, Stage 1's design session plans its milestones here.

## Status

| Milestone | Goal | Status |
|---|---|---|
| Design | The decisions, the bar and the needs, before any code | Done (2026-11-14) |

## Before Stage 1 opens

- uwui's first stage is done, with its host loop, its executor and its layer-shell target
  ([`needs.md`](needs.md#uwui)).
- The rivals are measured again on the GPU, above a blank uwui surface
  ([ADR-0014](adr/0014-budgets-measured-as-uwuis.md)).
- `needs.md` is read again against what Yuna and uwui have taken.

## Ideas

- **The theme engine early**: it needs nothing from uwui and could replace Amane's theme scripts
  under Umbriel as its first real use. The owner preferred to wait
  ([ADR-0002](adr/0002-uwui-and-no-code-before-its-first-stage.md)).

## Known debt

- The rivals' figures were measured with software rendering, which inflates the memory of
  programs that draw with OpenGL or Qt Quick ([`measurements.md`](measurements.md)).
- The laptop and the Steam Deck are not measured.

Finished stages move to `history.md`, in a few lines each, so that this file holds the current
stage only, under about 2,000 words.
