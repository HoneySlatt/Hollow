# Measurements

What the measurements found, against the budgets of the quality bar in
[`ROADMAP.md`](ROADMAP.md#quality-bar). One section per milestone or machine, newest first. A
section names the machine, the build, the command, and the figures with their spread.

Hollow has no code yet: the figures below are its rivals' and its predecessor's.

## The rivals at rest (2026-11-14)

Machine: the owner's desktop (Ryzen 7 5800X, RX 6900 XT). Each program ran alone in a headless
sway 1.12 started by `agent-headless --sway`, with a throwaway home, no network and its own
session bus, on a minimal or default configuration. Rendering was software only
(`LIBGL_ALWAYS_SOFTWARE=1`, `QT_QUICK_BACKEND=software`, `GSK_RENDERER=cairo`), so that no measure
touched the owner's GPU. This inflates the memory of programs that draw with OpenGL or Qt Quick.
After 15 s undisturbed, the script read `/proc/<pid>/status` and `smaps_rollup`. Over 30 s it then
summed every thread's voluntary and involuntary context switches. Two runs each; the load of other
programs was read before and during each run. Network, battery and tray modules had no session
services behind them.

Pss is the proportional resident memory, in MiB. Wake-ups are the program's own context
switches a second.

| Program | Version | Configuration | Pss | Threads | Wake-ups/s (two runs) |
|---|---|---|---|---|---|
| eww | 0.6.0 (2026-07-17 snapshot) | a bar with a clock | 25.7 | 58 | 0, 0 |
| Waybar | 0.15.0 | a clock in minutes and workspaces | 34.0 | 9 | 0.1, 0 |
| Waybar | 0.15.0 | its default configuration | 50 to 81 | — | 158 to 182 |
| ironbar | 0.19.1 | a minimal bar | 39.0 | — | 5.3, 5.1 |
| Quickshell | 0.3.2 | a minimal bar with a clock | 50.2 | 6 | 0, 0 |
| Caelestia | 2.5.0 (Quickshell) | its defaults | 267 | — | 4.4, 4.2 |
| Noctalia | 5.4.1 | its defaults | 276 | 59 | 9.5, 11.4 |
| DankMaterialShell (`dux-shell`) | 2.0.0 | its defaults | 82 | 14 | 36 to 62 |
| mako | 1.11.0 | after 5 notifications | 1.9 | 1 | 0, 0 |
| dunst | — | after 5 notifications | 2.7 | — | 0, 0 |
| fnott | — | after 5 notifications | 3.2 | — | 0, 0 |
| SwayNotificationCenter | 0.12.6 | after 5 notifications | 30.3 | — | 0.2, 0.2 |
| swaylock | 1.8.6 | locked | 1.2 | 1 | 0, 0 |
| hyprlock | 0.9.7 | locked | 172 | — | 0.8, 0.8 |
| walker | — | its service, idle | 28.4 | — | 0, 0 |
| anyrun | — | idle | 21.5 | — | 0, 0 |
| sway (the baseline) | 1.12 | headless | — | — | 0, 0 |

Doubts:

- Waybar's default configuration wakes about 170 times a second in this setup, likely because of
  modules without their services; it is not a fair figure for Waybar on a desktop.
- DankMaterialShell's figure is its `dms` process; whether it counts the interface's own process
  was not checked.
- Versions marked "—" were not read.
- These figures set no budget by themselves: the rivals are measured again on the GPU, above a
  blank surface, before Hollow's budgets are set ([ADR-0014](adr/0014-budgets-measured-as-uwuis.md)).

## Amane, the owner's current shell (2026-11-14)

Machine: the owner's desktop, its live session, read only from `/proc` without touching the
program; load 0.15 during the run. Amane draws on the GPU.

| Pss | RSS | Threads | Wake-ups/s over 30 s | CPU |
|---|---|---|---|---|
| 85.7 MiB | 103 MiB | 53 | 68 (a second reading: 70) | 7 ticks in 30 s |

Its code polls: the network every second, Bluetooth every 2 s, the battery every 5 s, brightness
and its palette every half second, the processor and memory every 2 s.
