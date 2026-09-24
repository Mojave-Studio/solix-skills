---
name: solix:usage
description: "Read usage across every linked provider — rate-limit windows, % left, reset times, walls, promo/credit pools, and measured run results. Use when asked about usage, quotas, rate limits, when a window resets, or where work can run."
---

# Solix Usage

Pull the full picture:

```text
solix limits --history   every provider window + 16-tick trend sparkline
solix providers          installed CLIs — cheapest model, cost tier, promos
solix runs               measured results: duration, outcome, ★ rating
```

`solix limits` prints one row per provider window the host has seen —
account collectors read claude, codex, gemini, grok, copilot, cursor,
kiro, and ollama directly; anything else reports through bot scrollback
(ambient). Rows look like:

```text
CLAUDE 5h      open · 62% left · resets 4:30 PM   ▂▄▅▆▅▄▃▂
CODEX weekly   walled · resets Tue 9:14 AM
GROK EXTRA     open · 88% left
```

Reading it:

- `walled` means the provider is rejecting work right now — route around
  it until `resets`. A wall with no named time yields as soon as the
  agent produces output again.
- Window labels are the provider's own (`5h`, `weekly`, `session`).
  Non-base windows print uppercased — `PROMO`, `EXTRA`, `CREDITS` rows
  are bonus pools: spend them first on bounded tasks.
- The sparkline is oldest→newest recorded % used. A rising tail means
  the window is draining faster than its reset will refill.
- Missing `% left` means the provider didn't print a number — usable
  but unmeasured, not unlimited.

Answer directly: provider, window, % left, reset. When the question is
"where should this run", name the provider and why — open window first,
promo pools for bounded work, never a walled one; `solix runs` shows
what actually performed on this machine if a model recommendation is
needed.
