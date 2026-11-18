# 0024. A theme switch completed after any interruption

- Status: Accepted; supersedes in part [0007](0007-themes-hollows-own-engine.md) (how a switch is
  applied and announced)
- Date: 2026-11-18

## Context

Hollow's theme engine ([ADR-0007](0007-themes-hollows-own-engine.md)) applies a theme to about 34
applications, Yuna's colours file, the Settings portal and websites. Each application gets a
file from a template, and is told to reload where it can. ADR-0007 announces a switch to Yuna at
its start and end, so that Yuna's cross-fade waits for the applications to repaint.

The [audit of 2026-11-17](../audits/2026-11-17-architecture.md) (finding 7) found no rule for a
switch cut short. A crash, a power loss or a second switch can stop it halfway, and the
applications are left with a mix of two themes. A second review found what a naive repair misses:

- A start that only compares files would see every file already written. It would reload
  nothing, while the applications still running (they outlive `hollow`,
  [ADR-0021](0021-what-survives-a-failure-of-hollow.md)) keep the old theme.
- Rewriting a file the owner edited, or one an application rewrites, would destroy their changes.
- Yuna's fade freezes the screen for a quarter of a second (Yuna's ADR-0064). A longer switch
  would fade into a mix.

## Decision

The owner chose, on 2026-11-18:

**Everything is rendered before anything is written.** A switch renders every output in memory.
A template's error fails the switch, with nothing written.

**A mark in the state file.** The switch writes `applying` with its generation, an opaque token
never ordered across processes. It then writes each file atomically, only if its content
differs. It reloads the applications a few at a time, each within a deadline, sends the portal's
settings, and writes `done`. A newer switch cancels a running one between two steps, and
converges on the newest.

**At start**, after the first frame and off the interface thread, the engine renders the current
generation again:

- after `applying`, it writes what differs, reloads every application and sends the portal's
  settings again;
- after `done`, it writes and reloads only what differs, which is normally nothing.

Rendering the same generation twice gives the same bytes, so that a start reloads nothing. A
palette derived from the wallpaper is kept with its generation, never computed again at start.

**Hollow writes its files into a folder of its own**, which the applications' configurations
include, as pywal does. The few files an application owns, where no include exists, are edited
key by key, and listed apart. Hollow keeps the hash of each file it wrote. A file that matches
neither that hash nor the new render was changed by someone else: Hollow leaves it as it is and
tells the owner. A file the owner edited is never overwritten.

**After a rollback**, an older Hollow applies, with its own templates, the theme its own state file
holds: the theme chosen before the upgrade, unless the owner chose another since
([ADR-0023](0023-formats-across-versions.md)).

**Yuna's fade**: the announcements carry the generation, so that the late end of an older switch
never ends the fade of a newer one. Hollow asks Yuna to keep the screen frozen until Hollow's
end, or Yuna's own bound if that comes first ([`needs.md`](../needs.md#yuna), row 8). A switch's
budget, set at the engine's milestone, stays on the laptop under that bound, once Yuna gives it.

The rest of ADR-0007 stands: the palettes, the outputs, and the engine running off the interface
thread, only on a change and once at each start.

## Alternatives considered

- **A journal** (the intent written, applied, marked done, redone at start): more states to test,
  and no comparison of files, which is what makes a normal start free.
- **A folder per generation and one link switched**: the files change at once, but the
  applications still reload one by one, so the mix seen during a switch is the same. Kept for
  later, if mixes show.
- **Nothing**: a crash halfway leaves a mix until the next switch.
- **Yuna's fade at its fixed quarter of a second**: nothing to ask, but every switch would have to
  fit in it, or end on a mix.

## Consequences

- Each application's template states how its file is included and how the application reloads.
- A start costs a render and a comparison of about 34 small files, off the interface thread.
  Estimated at a few milliseconds; measured at the engine's milestone.
- The owner's application configurations include Hollow's folder, set once, for example by Nix.
- Yuna's row 8 gains a precision, sent through the owner.

## Validation and reconsideration

Evidence at the time: pywal's documentation, and reasoning reviewed by a second agent, whose
report is not kept here; no code. The scenarios are the rows of the ROADMAP's
[*Architecture and stability scenarios*](../ROADMAP.md#architecture-and-stability-scenarios)
that cite this ADR. Proposed again if mixes show during switches, or if Yuna declines the
precision of row 8.
