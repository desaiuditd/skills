# Why the `writing-style` skill took these OSS rules

Human note. Lives under `docs/` so a skill loader does not attach it as extra context.

Re-read the upstream skills when this file is more than 90 days old, or after a model generation change that makes the
tell-lists stale.

Last reviewed: 2026-09-25.

Skill file: `skills/writing-style/SKILL.md`

## Taken into `SKILL.md`

| What we took                                                                            | From                                                                                                                                            |
| --------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------- |
| Earned-word exception (keep a watch-list word when the next clause names the mechanism) | [adewale/anti-slop-writing](https://github.com/adewale/anti-slop-writing) “False-positive restraint”                                            |
| Emphasis-source as a flatten test                                                       | anti-slop-writing “Emphasis-source test”                                                                                                        |
| Syntax-relation as a connective test (because / although / when)                        | anti-slop-writing “Syntax-relation test”                                                                                                        |
| Copula inflation: serves as, stands as, features, marks, represents                     | anti-slop-writing “Copula displacement”; [backnotprop/pstack unslop](https://github.com/backnotprop/pstack/blob/main/skills/unslop/SKILL.md) #8 |
| Tacked-on -ing clauses: highlighting, ensuring, reflecting, showcasing                  | pstack unslop #3                                                                                                                                |
| Restating bold labels (`**Performance:** Performance improved`)                         | pstack unslop #16                                                                                                                               |
| Name the actor (inanimate agency: “the decision emerges”)                               | [hardikpandya/stop-slop](https://github.com/hardikpandya/stop-slop) “False agency”                                                              |

The rest of `SKILL.md` lived in a personal `AGENTS.md` before this skill. I did not find where those rules were first
written. They may have come from humanizer, another skill, or an article. Reason: git history for that `AGENTS.md` did
not show an add commit in this check, and the phrasing did not match a search of a local humanizer skill.

## Looked at, not taken

Do not re-add these unless a later review shows they still earn a default-pass slot.

- Kill every adverb; ban em dashes; ban Wh- openers (stop-slop). Too blunt for chat.
- Score 1–10 (stop-slop). Extra pass, not a rule.
- “Soul” / personality injection ([blader/humanizer](https://github.com/blader/humanizer); some unslop forks). The
  `clarity` skill refuses performing humanness.
- Unslop metaphor-noun zoo (substrate, flywheel, harness). “Harness” is often the real name.
- Installing anti-slop, stop-slop, unslop, or humanizer as extra default passes. Overlap. Invoke them by hand if a draft
  still fails this skill.

## Drift check

On review, open the three upstream `SKILL.md` files (and anti-slop `references/` if the doctrine moved). Ask:

1. Did they add a detector we still lack, that would change chat replies?
2. Did a watch-list word go stale? (anti-slop notes `delve` as the cautionary case.)
3. Did we copy a rule they later narrowed or reversed?
