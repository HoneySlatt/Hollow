# Security

## Reporting a vulnerability

Report a vulnerability privately, through GitHub's private vulnerability reporting: the
repository's **Security** tab, then **Report a vulnerability**. Do not open a public issue for it.
A flaw of Yuna or uwui goes to their own repositories.

Say what is affected, how to reproduce it, and what it lets someone do. The owner answers as soon
as they can; there is no bounty.

## What is supported

Hollow has no code yet, and no release. Once it has, fixes land on `main` until 1.0.

## What matters most

- The lock screen, the polkit prompt and the login screen: anything that unlocks a session, shows
  it while it is locked, or lets a typed password reach a log, a crash report, an agent or the
  accessibility tree.
- The PAM helper, and the protocol with polkit's helper.
- What other programs send: notifications, their markup and images, tray menus and icons, the
  clipboard's contents, the login screen's appearance folder. A damaged or hostile one must give
  an error, never a crash, a hang, memory exhausted or code run.
- Signals that claim to come from logind or another system service but come from another sender.
- `hollow msg` and the agents' socket: another user reaching them, an agent acting without the
  owner's consent, or any agent while the session is locked.
