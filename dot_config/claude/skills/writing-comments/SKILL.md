---
name: writing-comments
description:
  Comment discipline for every file type - code, YAML, TOML, SQL, config, templates, Makefiles. Load BEFORE writing or
  editing any file; run the mandatory diff sweep before finishing any edit session or commit.
---

# Writing comments

Comments are a cost: they age, they duplicate, and every reader must decide whether to trust them. Default to **zero**.
Names, structure, the commit message and the project docs carry the meaning; a comment exists only for what none of
those can hold.

Track record to calibrate against: in every review so far, comments were **cut, never requested**. When unsure, delete.

Wording is governed by the `simplifying-prose` skill: load it alongside this one. It applies to every comment that
survives the test below and to any prose you write (docs, commit messages, issue descriptions, notes).

## The single test

> Delete the comment. Could someone editing this exact spot now silently break something they could not have seen?

- **No** → no comment. There is no other justification. "It's interesting", "it explains the design", "it took hours to
  figure out" do not count.
- **Yes** → state the constraint in **at most 2 lines**.

The 2-line ceiling is absolute. If the constraint does not fit, the comment is documentation in disguise: move the full
story into the project's docs and leave at most a one-line pointer.

## Route content to where it lives

| About to write                                      | Belongs in                            |
| --------------------------------------------------- | ------------------------------------- |
| Constraint that bites the next editor of this spot  | the comment, ≤2 lines                 |
| Design rationale, trade-offs, sizing philosophy     | project docs; comment may point there |
| Why this change is correct, what it replaces        | commit message                        |
| Debugging story, root cause, incident               | MR/PR or issue discussion             |
| What was discussed or decided with the user         | the chat has it; nowhere else         |
| What a schema, type signature or doc already states | nowhere - it is already stated        |

## The agent trap: conversation residue

The #1 failure mode: you have just explained something to the user - a root cause, a discovery, why an approach is
right - and the explanation leaks into the file as a comment. That prose was written for the person in the session; the
file's reader is a stranger years later who never saw it and needs only the constraint. If a comment you are writing
echoes something you said in chat this session, that is the signal to route it (table above), not keep it.

This trap fires hardest right after debugging: war stories ("took the node off the network to learn this"), bug
archaeology (function names, line numbers of the offending upstream code), and vindication ("the docs are wrong about
this") all feel essential in the moment. One constraint line survives; the story goes to the MR.

## Delete on sight

- **Tautology**: restates the name. (`// FooBar does foo bar.`)
- **Narration**: describes what the next lines visibly do - including play/ section headers that paraphrase the
  structure below them.
- **Reasoning-for-the-change**: "Added because...", "Now also handles...". Commit message.
- **Change history**: "since 2026-07", "moved from X", "was previously Y".
- **Test-as-comment**: "Tests this in X", "Enforced by Y".
- **Section divider** above a 3-line block.
- **Schema/doc echo**: the field is documented in a schema, type, or docs - the comment repeats it.

## Calibration examples (real review outcomes)

Cut from 6 lines to 2 - the story moved to docs, the constraint stayed:

```toml
# BEFORE: 6 lines: the upstream bug, the Rust functions involved, how it
# was discovered, what it broke, "took pve-04 off the network to learn".
# AFTER:
# dhcp on the active NIC; no interface-name-pinning section, its mere
# presence pins to nicN and breaks interfaces.j2 (docs/proxmox-node.md)
```

Deleted - already documented in the ops table, and an IP conflict surfaces by itself:

```yaml
# not .35: that address is taken and will not be freed
ansible_host: 192.168.1.36
```

Deleted - narrated mechanism plus rationale for something self-evident from `mask: true` in context:

```yaml
# No VIP participation: keepalived is layered into every VM (see
# config/keepalived/keepalived.bu), so mask it where no vrrp config
# exists. Masking (unlike enabling) works for layered packages.
```

Kept - a real trap: nothing at this spot reveals that a plain `state: present` would silently create the resource:

```yaml
# Skipped for non-HA VMs: state: present would otherwise create the resource
```

## Mandatory final sweep

Before finishing any edit session and before every commit - not only when asked:

1. List every comment line the work added: `git diff <base> | grep -E '^\+[^+]*(#|//|--)'` (pick the base: staged,
   branch, or origin/main).
2. Apply the single test to each line. Cut to ≤2 lines or delete; route displaced content per the table - do not
   silently drop a load-bearing constraint, relocate it.
3. This applies with full force to YAML, TOML, SQL, Makefiles, templates and test helpers - verbose comments leak into
   those most.

## Language doc-comment conventions

Where the language requires doc comments (Go exported declarations, Rust `pub` items, Python public APIs), follow the
convention but keep the body to one or two short sentences. Go specifically: start with the declared name, complete
sentences, `[Symbol]` doc links. Brevity does not excuse violating godoc rules.

### Go traps (all real review outcomes)

- Reasoning tails on godoc: "so that Z", "mirrors X", "lets/makes/helps Y". Trim to one factual sentence about what the
  symbol does or returns.
- Multi-line godoc on unexported helpers; no Go convention requires it, the default is no comment at all.
- Test-file preambles narrating the bug being regression-guarded; the test name is the signal, the commit message holds
  the rationale. Drop entirely.
- Doc comments describing what the caller does ("...so the socket is torn down regardless"); scope to this symbol's own
  behavior.
- Even a required exported doc comment is 1-2 short sentences; a third sentence is a reasoning or contract tail that can
  be cut.
- Trigger-heavy spots to sweep hardest: struct tags, SQL migration headers, Go test helpers, YAML blocks.
