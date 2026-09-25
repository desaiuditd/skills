# Where `explain-back` and `capture-lessons` came from

Short human note. Not a source for agents.

These two skills were written in the principal-engineer kit plan (working names: explain-first, capture-lessons). They
shipped once as `explain-back` and `promote-rules`, then `promote-rules` was renamed back to `capture-lessons`. They
were not copied from an OSS `SKILL.md`.

The procedures were checked against four Addy Osmani posts you pasted in the kit planning chat
([4a50a2f4-12f7-4831-90c3-bd5f13c0a82e](4a50a2f4-12f7-4831-90c3-bd5f13c0a82e)) on 2026-09-24:

- [Comprehension debt](https://addyosmani.com/blog/comprehension-debt/) — you explain before you approve. “The tests
  passed” is not the same as “I understand what this does and why.”
- [Cognitive surrender](https://addyosmani.com/blog/cognitive-surrender/) — state an expectation before reading the
  output. Ask the model to argue against itself.
- [Intent debt](https://addyosmani.com/blog/intent-debt/) — a kept rule carries its reason (`capture-lessons`, and
  `writing-for-agents`).
- [Agentic skill decay](https://addyosmani.com/blog/agentic-skill-decay/) — keep the human able to explain and decide,
  rather than only accept agent output.

`capture-lessons` runs when you ask. It does not infer that a session has ended. It searches this workspace's other
chats only as evidence that a correction from **this** session is a repeat. It does not mine the archive for new
candidates. That is Cursor's continual-learning plugin, which we did not adopt.

That is different from the `writing-style` skill, whose extra rules have named upstream `SKILL.md` files. See
[why the writing-style skill took these OSS rules](./why-writing-style-took-these-oss-rules.md).
