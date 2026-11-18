# Survey

The facts behind Hollow's decisions, read on 2026-11-14 from each project's own documentation,
code and trackers. "Claimed" marks what users or third parties say. The pages read were saved by
the surveys that read them, outside this repository; each fact below names its source.

## The field

- **Linux shells read**: Noctalia 5.5, Caelestia 2.5, DankMaterialShell 2.1 (now Dux Modular
  Shell), end-4's illogical-impulse, Quickshell 0.3, Astal and AGS, Waybar 0.16, ironbar 0.19,
  HyprPanel (its successor Wayle, in Rust and GTK4), Plasma 6.8, GNOME 50, COSMIC epoch 1.11,
  Cinnamon and XFCE. macOS 27, Windows 11 with PowerToys, Raycast and Alfred for comparison.
- **Noctalia is the deepest reference.** It is written in C++ on OpenGL ES, without Qt or GTK,
  and documented feature by feature. It has a native polkit agent, a clipboard history encrypted
  at rest, a greeter on greetd, and themes from palettes or the wallpaper.
- **No source gives a measured figure** of memory, processor or wake-ups for any shell. Hollow's
  measurements are in [`measurements.md`](measurements.md).

## Processes

- **COSMIC** starts each part as a process (`cosmic-session`'s `src/main.rs`), and its panel
  starts each applet as a child (`cosmic-panel-bin/src/main.rs`). Its users report 25 to 300 MB per
  applet and every applet aborting with the panel (claimed, cosmic-panel issues 655, 723, 796).
- **Quickshell's FAQ** says a process per widget uses much more memory than one process
  (quickshell.org, guide, FAQ).
- **Plasma's** `plasmashell` is restarted by systemd at most three times a minute; its lock screen
  is a separate process watched by KWin (`kscreenlocker`'s `ksldapp.cpp`).
- **niri's IPC** sends its whole state first, then each change, and tolerates unknown fields
  (niri, `docs/wiki/IPC.md`). Hyprland's request socket blocks the compositor while a client holds
  it (Hyprland wiki).
- **On-screen keyboards**: `input-method-v2` allows one input method per seat (wlroots'
  `input-method-unstable-v2.xml`); squeekboard needs `virtual-keyboard` for keys such as Enter;
  cosmic-osk injects keys through libei and is shown by its compositor over D-Bus
  (cosmic-osk, `src/ei.rs`).
- **Clipboard**: Noctalia and Klipper drop copies marked `x-kde-passwordManagerHint`; Noctalia
  encrypts its history with a key kept in the Secret Service (docs.noctalia.dev, shell
  configuration).

## Services

- **zbus 6.3** runs a connection on any runtime through `Builder::runtime`: "zbus never polls
  runtime itself" (docs.rs, `zbus::connection::Builder`). Its default runtime uses one helper
  thread (zbus README).
- **Libraries**: `nmrs` (NetworkManager, tokio; COSMIC uses it), `bluer` (BlueZ, libdbus and
  tokio), `system-tray` (the tray's watcher and host, tokio; ironbar uses it), `oo7` (Secret
  Service), `fend-core` (a calculator without dependencies), `greetd_ipc` (GPL-3.0-only); figures
  from crates.io on 2026-11-14.
- **polkit 127** runs its agent helper socket-activated, without setuid, at
  `/run/polkit/agent-helper.socket`; an agent writes the user and the cookie, then answers the PAM
  prompts the helper relays. polkit 128 fixed two flaws in the helper's input (polkit `NEWS.md`,
  `src/polkitagent/polkitagentsession.c`).
- **Wake-ups**: D-Bus sends a signal only to clients with a matching rule. NetworkManager updates
  the current access point's strength every 6 s while connected (`nm-device-wifi.c`,
  `periodic_update`), and emits a change only when the percent changes. UPower polls each battery
  every 30 s, every 5 s while an estimate is missing, and its `UpdateTime` changes at each poll
  (`up-device-battery.c`, read on 2026-11-17). Both poll whether anyone listens or not.
- **Audio**: libpulse subscriptions tell which program records (`SOURCE_OUTPUT`), as Wayle uses
  them; the `pipewire` crate's objects are not `Send`, and its loop exposes a file descriptor.
  COSMIC keeps libpipewire in one audio daemon.
- **The notifications specification** (version 1.3) has no inline reply.

## Lock and login

- **`ext-session-lock-v1`**: "If the client dies while the session is locked the session remains
  locked" (wayland-protocols, `staging/ext-session-lock`). sway paints the outputs red then
  (`sway/lock.c`); niri accepts a new locker (`src/niri.rs`); KDE restarts its greeter three times,
  then shows how to unlock from a virtual terminal (`ksldapp.cpp`).
- **Flaws**: swaylock before 1.6 unlocked on a crash (CVE-2022-26530, fixed by moving to
  `ext-session-lock-v1`); GNOME's screenshot tool showed a locked session's windows
  (CVE-2023-43090); cosmic-greeter dropped privileges incompletely when reading a user's
  appearance (CVE-2026-25704, cosmic-greeter pull request 426); hyprlock now checks the sender of
  logind's and fprintd's signals (hyprlock pull request 1088); Noctalia 5.4.1 rejects forged logind
  signals.
- **PAM**: swaylock forks a child, Noctalia executes a helper, KDE runs it in subprocesses,
  hyprlock and COSMIC in a thread; COSMIC makes each attempt last at least 500 ms.
- **Sleep**: a locker takes logind's delay inhibitor and releases it once the lock is shown; the
  delay is 5 s by default (systemd.io, inhibitor locks; `logind.conf`).
- **greetd** runs the greeter as its own user, runs PAM, and starts the session once the greeter
  exits (greetd, `greetd-5`). Greeters run in cage or sway (ReGreet, gtkgreet), in the session's
  compositor (GDM in GNOME Shell, cosmic-greeter in cosmic-comp, SDDM optionally in KWin), or in a
  bundled one (Noctalia). None hands over to the session without the screen going dark.

## Themes

- **The Settings portal** carries `color-scheme`, `accent-color`, `contrast` and `reduced-motion`
  (xdg-desktop-portal, `org.freedesktop.portal.Settings`); libadwaita follows the accent and the
  scheme live (libadwaita, `StyleManager`), as do Qt 6.5 and later and Electron.
- **matugen 4.2** (GPL-2.0-or-later) and Noctalia derive Material You schemes from a wallpaper and
  fill templates; Noctalia applies them live and serves Firefox's theme extension itself
  (docs.noctalia.dev, theming).
- **`material-colors` 0.5.0** (MIT OR Apache-2.0, 2026-10-01) is a large rewrite that publishes no
  comparison with Google's reference; its README advises downscaling an image to 128 × 128 first
  (crates.io).
- **Live reload**: kitty, foot and Ghostty by signal or file, any terminal by escape sequences,
  KDE applications by a D-Bus notice; GTK reads its CSS at start. Of the owner's current theme
  scripts, four applications change at once.
- **Light and dark by the hour**: KDE Plasma 6.5 and macOS do it; GNOME has no schedule for its
  dark style.
