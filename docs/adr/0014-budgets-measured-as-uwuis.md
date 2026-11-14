# 0014. Budgets measured as uwui's

- Status: Accepted
- Date: 2026-11-14

## Context

On 2026-11-14 the rivals were measured at rest in a headless sway, drawn in software, and the
owner's Amane on the real desktop ([`measurements.md`](../measurements.md)). A bar alone takes
26 MiB (eww) to 51 MiB (Quickshell); a whole shell takes 84 MiB (DankMaterialShell) to 276 MiB
(Noctalia); Amane takes 86 MiB. A budget of "a third of the best rival" would allow 9 MiB or
92 MiB depending on which rival is read: the rule needs a method. Zero own wake-ups at rest is held
by eww, a minimal Quickshell bar, mako and swaylock, and by no whole shell.

uwui's own bar measures a program's *own cost*: what it adds above a blank window that only clears
and presents. Its rule of the lead is a third of the best rival's own cost. Its start budget is
100 ms warm and 500 ms cold for a typical application.

## Decision

The owner chose, on 2026-11-14:

- **Memory is Hollow's own cost**: its proportional memory (Pss) plus its GPU memory, above one
  blank uwui layer surface per output on the same driver. It stays within a third of the best
  rival's own cost in its class, measured the same way: a bar against a bar, a whole shell against
  a whole shell. The provisional figure is about 30 MB for the whole shell on the high tier; it is
  set from the rivals measured again on the GPU.
- **Rest**: zero own wake-ups a second, except a visible clock's tick at the precision it shows
  (once a minute for minutes). Wake-ups that other programs cause are counted apart, named by
  their sender.
- **Time**: from start to the bar's first frame, 100 ms warm and 500 ms cold; from input to its
  visible answer, one frame; every animation at the display's rate, up to 240 Hz, with no dropped
  frame, judged at the 99th percentile.
- **The laptop** runs every feature, with lighter effects, under the same rules of rest and time.

## Alternatives considered

- **No more than Amane** (86 MiB): easy to check, but below what eww and mako already hold.
- **Looser times** (150 ms warm, a few wake-ups a second tolerated): easier, and below uwui's own
  bar.

## Consequences

- The rivals are measured again on the GPU before Hollow's first figures.
- The full list of budgets is in the [ROADMAP](../ROADMAP.md#quality-bar).
