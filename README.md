<p align="center">
  <img src="hollow.svg" alt="Hollow logo" width="256">
</p>

# Hollow

A desktop shell for [Yuna](https://github.com/HoneySlatt/Yuna), built with uwui.

In design. No runnable shell yet.

Hollow is its owner's desktop shell for Wayland, in Rust: the bar, one launcher with its
providers, notifications, the tray, the control centre and its popups, the on-screen displays, the
calendar, the lock screen, the login screen, the polkit agent, and the theme of the other
applications and websites. It runs only on Yuna, the owner's compositor, and draws with
[uwui](https://github.com/HoneySlatt/uwui), the owner's interface toolkit. It aims at the look and
motion of the most refined current interfaces, at 240 Hz, and at doing nothing at all at rest.

Its code starts after uwui's first stage. Until then it is its design.

## Read next

- [`docs/ROADMAP.md`](docs/ROADMAP.md): what Hollow is to be, its quality bar and its stages.
- [`docs/adr/`](docs/adr/README.md): the decisions and why.
- [`docs/needs.md`](docs/needs.md): what Hollow asks of Yuna and uwui.
- [`docs/PLAN.md`](docs/PLAN.md): where it stands.
- [`AGENTS.md`](AGENTS.md): how agents work here.

## Checks

```sh
nix develop -c scripts/check.sh
```

## Licence

The code is under GPL-3.0-or-later ([`LICENSE`](LICENSE)). The logo, `hollow.svg` and
`hollow.png`, is not under the code's licence: its author keeps its rights. You may show it,
unchanged, to refer to Hollow.
