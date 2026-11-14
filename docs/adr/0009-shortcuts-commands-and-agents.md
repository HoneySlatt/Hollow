# 0009. Shortcuts, commands and agents

- Status: Accepted
- Date: 2026-11-14

## Context

A shell is opened by keys: the launcher, the popups, the lock. Amane's keys start a command for
each press. The GlobalShortcuts portal is the standard path, served by `yuna-portal` (Yuna's
ADR-0057). Yuna's configuration already holds every key binding, and knows what is allowed during
a game, under a shortcuts inhibitor and on the lock screen.

Yuna and uwui each have an MCP server for agents. uwui's agents' core names the agent with the
person's consent, and its feature that reads the interface's tree is left out of builds that ship
(uwui's roadmap). No shell has an official MCP server; Noctalia and DankMaterialShell offer a
command line over a socket ([survey](../survey.md#processes)).

## Decision

The owner chose, on 2026-11-14:

- **Keys are bound in Yuna's configuration**, and Yuna sends a named event to Hollow on the
  interface it gives Hollow. No process starts for a key press; every key is configured in one
  place, under Yuna's rules for games, inhibitors and the lock screen.
- **`hollow msg`** gives scripts Hollow's commands, over a socket only the owner's user can open.
- **Agents test and drive Hollow** through uwui's agents' core and its MCP server: in a headless
  compositor for tests, where they see everything; and in the owner's real Hollow, with the owner's
  consent, where they may read the whole interface, content included.
- **Password fields stay masked** to every reader, agents included, as in any accessibility
  tree. No agent types into them.

## Alternatives considered

- **The GlobalShortcuts portal**: standard, and it would serve another compositor, which Hollow
  never runs on; one more intermediary.
- **A command for each key**, as today: simple, but a process for each press.
- **Agents limited to declared actions** on the owner's desktop (the lead's recommendation):
  agents would never read the clipboard's contents, notifications' text or what the owner types.
  Declined by the owner: agents may read everything, with consent.

## Consequences

- Yuna's interface gains key events for the shell ([`needs.md`](../needs.md)).
- An agent given consent can read notifications and the clipboard: the consent is asked per
  agent, and can be withdrawn.
- The agents' socket is apart from `hollow msg`'s and checks which agent connects.
