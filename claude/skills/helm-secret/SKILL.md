---
name: helm-secret
metadata:
  internal: true
description: Manage the user's Solix Helm Secrets register — set, list, grant permits, inject via solix:pass: markers, or delete secrets via the solix CLI. Values are unreadable by design, including to agents. Use when storing credentials, checking secret names, or wiring a secret into a terminal prompt.
argument-hint: "<verb> [name] — set | list | grant | rm"
---

# Solix Helm — Secrets

Secrets are credentials the host injects at concealed prompts — no agent
ever sees a value. All verbs are `solix` CLI calls:

```text
new      → solix secret set <name>            (value on stdin — never argv)
read     → solix secret list                  (names + kinds only —
           values are unreadable by design — that includes you)
edit     → solix secret set <name>            (overwrite)
use      → only at a prompt that is ALREADY concealed (no-echo — e.g.
           a running `read -s`, `ssh-add`, `login`), type the marker
           `solix:pass:<name>`; the host substitutes the value there
           and you never see it. Needs a permit: `solix secret grant`.
           Typed anywhere else (a normal echoing shell prompt) the
           host refuses and leaves the marker text as-is — it does
           NOT create a concealed prompt for you. To insert straight
           into a terminal's current prompt from outside, use
           `solix pass <target> <name>` instead — same no-echo check,
           fails loudly if the prompt doesn't qualify.
rename   → solix secret set <new> then `solix secret rm <old>`
delete   → solix secret rm <name>
```

## Rules of the register

- Names are the handle — keep them short, lowercase, hyphenated.
- Secrets are NOT command `{{var}}`s — they only enter through
  `solix:pass:` markers at a concealed prompt.
- Never print secret values.
- To insert the secret name list into this chat, `solix load secrets`
  (skill `solix-load`) — names and kinds only; this terminal is then
  permitted for `solix:pass:<name>`.
