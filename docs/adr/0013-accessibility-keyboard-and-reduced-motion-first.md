# 0013. Accessibility: the keyboard and reduced motion first

- Status: Accepted
- Date: 2026-11-14

## Context

The method's bar for interfaces asks for screen readers, full keyboard use, reduced motion and
reduced transparency, and checked contrast. uwui builds the tree a screen reader reads. On a lock
screen and a login screen, a screen reader reads every key typed, which is a risk to weigh.

## Decision

The owner chose, on 2026-11-14:

- **From the first surfaces**: every control reachable and usable by the keyboard alone; reduced
  motion and reduced transparency honoured by every animation and effect; contrast checked.
- **The screen reader comes later**, at a stage of its own, with its policy on the lock and login
  screens.

## Alternatives considered

- **Everything from the start**, the screen reader included (the lead's recommendation): uwui
  gives the tree, and nothing would be left to catch up. Declined by the owner, for the work it
  adds early.

## Consequences

- The screen reader is debt against the bar until its stage, written in the PLAN when the first
  surfaces land.
