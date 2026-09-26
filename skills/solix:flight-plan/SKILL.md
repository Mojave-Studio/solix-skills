---
name: solix:flight-plan
description: "Work a Solix flight plan: a queued checklist of items fed to assigned terminals. Use when an agent is told to work a flight plan, receives a `[flight-plan:<name>]` item, or is asked to orchestrate one."
---

# Solix Flight Plan

A flight plan is a work queue — the `flight-plan:<name>` doc with three
lanes:

```text
## Queued
- [ ] Item text (#123)
## In progress
- [ ] Item the runner dispatched
## Finished
- [x] Done item
  - approach tried · what worked · what didn't
```

`solix plan` is the whole surface:

```text
solix plan list                      plans + lane counts
solix plan show <name>               the doc
solix plan add <name> <text…>        queue an item (--issue N links it)
solix plan next <name>               take next queued → in progress
solix plan done <name> <item…>       finish it (--note <t> adds a detail)
solix plan note <name> <item…> --detail <t>
solix plan assign <name> <term>      bind a terminal — it gets items fed
```

## Working an assigned plan

When a `[flight-plan:<name>]` item lands in your terminal the runner has
already moved it to In progress — it is yours:

1. Do the work the item describes.
2. Record what mattered as you go:
   `solix plan note <name> "<item>" --detail "approach/outcome"` —
   approaches tried, what worked, what didn't. These details are how the
   next agent (and the user) inherits your reasoning, not just the outcome.
3. Finish it:
   `solix plan done <name> "<item>" --note "shipped: <result>"`.
4. The runner sends the next queued item automatically — while you are
   waiting (holding) or the moment a provider rate-limit window resets.
   If the queue runs dry, idle normally; new items arrive when added.

Never mark items you didn't do, and never skip the detail notes — the doc
is the shared ledger.

## Orchestrating (First Mate)

An assigned First Mate doesn't have to do items personally — it owns the
queue and delegates:

```text
solix plan show <name>                    read the queue
solix plan add <name> <item>              refine/split incoming work
solix bot new <worker> --provider <id> --parent <you> --flight-plan
solix send <worker> "[flight-plan:<name>] <item text>"
```

- Give each worker a bounded item plus the plan name so it can `note` and
  `done` it — the doc tracks who-shipped-what without bookkeeping in chat.
- Watch `solix plan show <name>` for items stuck In progress — a stalled
  worker's item can be re-queued or reassigned (`done` only by the worker
  that owns it, or manually).
- Link work to the repo: `solix plan add <name> <item> --issue <n>` —
  issue numbers render as links on the board, and the Bugs lane shows the
  repo's open bug issues.

## Creating a plan

`solix plan add <name> <first item>` creates the doc. Convention: name it
after the project (`flight-plan:<project>`) so the app's board and the
Bugs lane resolve its repo automatically.
