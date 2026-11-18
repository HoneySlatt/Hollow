# 0023. Formats across versions

- Status: Accepted; supersedes in part [0008](0008-configuration-in-kdl.md) (the state file, and
  errors in the configuration)
- Date: 2026-11-18

## Context

[ADR-0008](0008-configuration-in-kdl.md) keeps what Hollow remembers by itself (do not disturb,
the last theme, the bar's state) in a state file under the XDG state folder, "versioned". On an
error in the owner's configuration, Hollow keeps the last valid configuration. The
[audit of 2026-11-17](../audits/2026-11-17-architecture.md) (finding 7) found no envelope, and no
rule for an older Hollow after a rollback.

NixOS makes rollbacks common. Take a newer Hollow that writes a newer state file, then a return
to an older generation. The older Hollow meets a file it was not written for. The owner may then
change something and move forward again. A configuration written by hand may also hold a node
the older Hollow does not know. At start there is no last valid configuration to keep, so
ADR-0008's rule would drop every setting.

`hollow-greeter` may also come from another generation than `hollow`: its NixOS module and
Hollow's home-manager module are switched apart. Yuna's ADR-0082 reads every file across versions
keeping what it does not know, with a backup before any migration.

## Decision

The owner chose, on 2026-11-18:

**One envelope rule for every file in a format of Hollow's own**: the state file, the greeter's
appearance file, and those that come later (the histories). Files in other programs' formats
(the theme's outputs, Yuna's colours file) follow their own programs' rules. The file's first node is its envelope: the format's
number, a write sequence, and the version of Hollow that wrote it.

**Within a format, fields are only added.** A field's meaning never changes. An added field
stands alone: one that qualifies an older field would let an older Hollow change the older one
without it, so it makes a new format. A reader keeps the nodes it does not know, and writes them
back unchanged.

**A new format is a new file.** The state file is `state-<N>.kdl`. A newer Hollow writes
`state-<N+1>.kdl`, migrated from `state-<N>.kdl`, which it leaves untouched. That older file is
the backup, and it is what an older Hollow finds after a rollback: valid, as it was before the
upgrade. The newer file records the write sequence it was migrated from. If the older file has
been written since, a newer Hollow migrates it again, so that the newest change wins after an
upgrade, a rollback and an upgrade again. Before it does, it moves the newer file aside with the
time in its name, as a backup, and carries over from it the fields that format N cannot hold:
what only the newer Hollow knows is kept, not lost.

**Writes are atomic**: a temporary file, flushed, then renamed, then the folder flushed. A file
that cannot be read is moved aside with the time in its name. Hollow then starts from the
defaults and tells the owner. A lock on the folder keeps two `hollow` from writing it at once.

**A reader shows what it can.** `hollow-greeter` reads the appearance file of the highest format
it knows, and shows it with the defaults for what it cannot read; with no such file, it shows the
defaults.

**The configuration falls back node by node.** A node that is unknown or invalid is shown with
its line and column, and only that node falls back: to its previous value on a live reload, to its
default at start. The rest applies. In a section that restricts (the lock screen, agents, the
privacy of notifications), an error sends the whole section to its strictest default. The rest of
ADR-0008 stands: KDL 2.0, the reader shared with uwui and Yuna, live reload, and the owner's file
left to the owner.

Keeping unknown nodes byte for byte needs a KDL reader that keeps their text. ADR-0008's reader,
uwui's, keeps the author's order and comments. Whether it keeps an unknown node's text is checked
when it exists. Nothing is asked of uwui.

## Alternatives considered

- **One file, a major and a minor number**: an older Hollow keeps the unknown nodes of a newer
  minor, but refuses a newer major and starts from the defaults. A rollback across a major loses
  the owner's state.
- **One file, one number, a newer one ignored and never overwritten**: the simplest, but every
  change made during the rollback is lost, and a mere added field hides the whole file.
- **The configuration kept whole on any error**, as ADR-0008 had it: after a rollback, one unknown
  node drops every setting until the owner removes it.

## Consequences

- Each format keeps a fixture of every published version, and its migrations are tested on it.
- A change that qualifies an existing field costs a new format, a migration and its test.
- Old state files stay on disk, one per format: a few kilobytes each.
- Each restricting section of the configuration names its strictest default in its documentation.
- The theme engine's state, its generation and its mark, lives in the state file
  ([ADR-0024](0024-a-theme-switch-completed-after-any-interruption.md)).

## Validation and reconsideration

Evidence at the time: Yuna's ADR-0082, and reasoning reviewed by a second agent, whose report is
not kept here; no code. The scenarios are the rows of the ROADMAP's
[*Architecture and stability scenarios*](../ROADMAP.md#architecture-and-stability-scenarios)
that cite this ADR. Proposed again if uwui's reader cannot keep an unknown node's text, or if
keeping one file per format costs more than it saves.
