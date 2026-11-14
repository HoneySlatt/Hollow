# 0010. Over a fullscreen game or film: a setting

- Status: Accepted
- Date: 2026-11-14

## Context

Yuna announces what is fullscreen, and tells a game from a film once its Stages 4 and 5 can; the
shell decides what follows (Yuna's ADR-0057). Games and films come first in Yuna: anything drawn
over a fullscreen game ends its direct scanout, which costs latency and power, until Yuna puts
such surfaces on a hardware plane at its Stage 4. Windows turns do-not-disturb on during a game or
in fullscreen; Caelestia shortens its notifications' timeouts in fullscreen.

## Decision

The owner chose, on 2026-11-14, **a setting**, with three values, set apart for games and for
films:

- **nothing unless asked**: no notification and no on-screen display over the game or the film.
  Notifications are held and shown afterwards, summed up. Hollow draws only what the owner opens.
  Exceptions per application are allowed (a call, an alarm);
- **on-screen displays only**: volume and brightness are shown briefly; notifications wait;
- **everything**, as on the desktop.

The default is *nothing unless asked*, for games and for films.

## Alternatives considered

- **One fixed behaviour**: simpler, but the owner wants to choose.

## Consequences

- Focus modes build on the same setting at their milestone.
- What a held notification looks like afterwards is designed with the notifications.
