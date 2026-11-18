# Architecture

Hollow has no code yet. This file will describe the code as it is, once there is some. Until then,
its shape is set by the ADRs:

- **`hollow`**, one process: the bar, popups, notifications, the launcher, the on-screen
  displays, the tray, the dock, widgets, the clipboard history, the on-screen keyboard, the lock
  screen and the polkit agent, drawn by one uwui on one GPU device
  ([ADR-0003](adr/0003-one-process-the-greeter-apart.md)).
- **A PAM helper**, started for each attempt to authenticate.
- **`hollow-greeter`**, the login screen, on Yuna's greeter mode under greetd
  ([ADR-0006](adr/0006-the-login-screen-on-yunas-greeter-mode.md)).
- **Services**: Hollow's own D-Bus clients and servers on zbus, on the services thread, which owns
  their connections, the names Hollow serves (notifications, the tray's watcher, the Settings and
  Notification portals' backends), the polkit agent's object and its registration, and the
  subscriptions, and sends changes to the
  interface through uwui's channels
  ([ADR-0004](adr/0004-system-services-hollows-own-clients-on-zbus.md),
  [ADR-0018](adr/0018-system-services-on-a-thread-of-their-own.md),
  [ADR-0025](adr/0025-the-notification-portal-served-by-hollow.md)).
- **Yuna** gives Hollow an interface of commands and events, and includes the colours file
  Hollow's theme engine writes ([`needs.md`](needs.md)).
- **Failures**: a fault ends `hollow`, which systemd restarts, unless its part is listed as
  contained; programs the owner launches run as systemd services of their own and outlive it
  ([ADR-0021](adr/0021-what-survives-a-failure-of-hollow.md)).
