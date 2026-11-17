# 0004. System services: Hollow's own clients on zbus

- Status: Accepted; superseded in part by [0018](0018-system-services-on-a-thread-of-their-own.md)
  (where the services run), [0022](0022-what-rest-allows.md) (what a service follows)
- Date: 2026-11-14

## Context

A shell talks to NetworkManager, BlueZ, UPower, power-profiles-daemon, PipeWire, the media
players (MPRIS), logind, geoclue, the Secret Service, polkit and the tray's items, and it serves
notifications and the Settings portal's backend. Almost all of them speak D-Bus.

What Rust offers ([survey](../survey.md#services)):

- **zbus 6** runs on any executor that implements its `Runtime` trait. It then starts no thread of
  its own. Its default runtime uses one helper thread.
- **Libraries**: `nmrs` (NetworkManager), `bluer` (BlueZ) and `system-tray` (the tray). All three
  need tokio. `bluer` also links libdbus. Each chooses its own subscriptions.
- **D-Bus** sends a signal only to a client with a matching rule. NetworkManager updates the
  current access point's strength every 6 seconds; UPower polls its devices every 30 or 120
  seconds. A client wakes only for what it subscribes to.

Amane polls instead of subscribing: the network every second, Bluetooth every 2 seconds, the
battery every 5, brightness and its palette every half second. It wakes 68 times a second at rest
([`measurements.md`](../measurements.md)).

## Decision

The owner chose, on 2026-11-14:

- **Hollow writes its own clients on zbus**, run on its host's loop through zbus's `Runtime`
  trait, with no tokio and no thread of zbus's.
- **A service is subscribed only while something shown needs it.** For example, the Wi-Fi
  strength is followed only while the network popup is open; the bar follows the battery as one
  aggregate device.
- **Small pure libraries are welcome where they add no runtime**: a calculator, the colour
  science of themes, the Secret Service client, if each runs on the same loop. Each is put to the
  owner as a dependency.
- **The polkit agent speaks polkit's own protocol**: one D-Bus object, and the line protocol of
  polkit's helper (socket-activated since polkit 127). It needs no `libpolkit-agent-1`.
- **Audio goes through PipeWire or libpulse**, chosen by a measured prototype at its milestone.
  PipeWire is preferred, since only it sees the camera.

## Alternatives considered

- **Maintained libraries** (`nmrs`, `bluer`, `system-tray`): less code, but tokio's threads,
  libdbus, and subscriptions Hollow does not control. Rest at zero would be harder to hold.

## Consequences

- More code to write and test. Each client is tested against a fake service on a private bus.
- uwui's host must accept the application's file descriptors and timers
  ([`needs.md`](../needs.md)).
- The helper protocol of polkit is security-sensitive: polkit 128 fixed two flaws in it. Hollow's
  side is strict and fuzzed.
