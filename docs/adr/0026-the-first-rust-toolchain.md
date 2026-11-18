# 0026. The first Rust toolchain

- Status: Accepted
- Date: 2026-11-18

## Context

Hollow has no Rust code, and its Nix shell and CI run documentation checks. Stage 1 still
opens on the uwui deliverables named in the [plan](../PLAN.md#before-stage-1-opens) and the
owner's go. The exact revisions Hollow will use can be checked once those deliverables exist.

[Rust 1.100](https://blog.rust-lang.org/2026/11/12/Rust-1.100.0/) adds Cargo's unused
dependency lint and changes the layout of intermediate artifacts. The lint needs coverage of
the relevant build targets and does not report unused dev-dependencies. When scripts need
artifact paths, they can read Cargo's JSON messages instead of depending on that layout.

## Decision

Rust 1.100 is the first candidate at the opening of Stage 1. Confirm its availability in the
chosen Nix environment and validate it with the first Rust code and the selected revisions of
uwui, zbus and the other dependencies. Pin the validated toolchain in the Nix environment shared
by local checks and CI. Decide the minimum supported Rust version separately. If it is below the
shared toolchain version, check it separately before promising support.

## Alternatives considered

- Pin Rust 1.100 now. This gives a target early, before Hollow can check the dependency set it
  will actually use.
- Start with the toolchain uwui already validates and upgrade later. This is a fallback if
  1.100 cannot be validated, at the cost of a later migration.

## Consequences

Using Rust 1.100 leaves the dependency cooldown policy open. `DropGuard` can simplify local
cleanup when a scope exits. Recovery after process termination follows
[ADR-0024](0024-a-theme-switch-completed-after-any-interruption.md). Custom allocators for `Vec`
or `Box` and optimization with sampled profiles need a measured baseline and a representative
workload before adoption.

## Validation and reconsideration

The decision is based on repository inspection and the Rust release documentation. With the
first Rust code, run `scripts/check.sh` in the pinned Nix shell locally and in CI. If Rust 1.100
is unavailable or an actual dependency fails with it, bring the blocker and the toolchain version
validated by uwui to the owner before choosing a fallback.
