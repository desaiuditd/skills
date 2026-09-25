---
name: capture-lessons
description: >-
  Capture-lessons when the user asks to capture lessons. List corrections from this session. Keep a candidate if it cost
  real time, happened twice here, or a search of this workspace's other chats finds a repeat. Propose a rule and its
  reason. User approves each change or skip.
---

# Capture-lessons

Reason: session corrections die in the chat unless they become a rule. The files stay small only if we merge and delete
as well as add.

This session is the source of candidates. Other chats are evidence of a repeat.

## When it runs

When they ask to capture lessons. Do not infer that a session has ended.

They can say `skip`. Then stop.

## Steps

1. List the corrections they made in this session. One line each. Skip nits they already reversed.
2. Keep a candidate if it cost real time (rework, a wrong merge, a long debug), or it happened twice in this session.
3. For every other candidate, search **this workspace's** other chats for the same correction. Use conversation search
   if you have it. Otherwise search this workspace's agent transcripts. Stop at the first repeat. Cite that chat (title
   or date, one short quote). If you cannot search, drop the candidate. Reason: one-off taste is not a rule.
4. For each kept candidate, name the target file (`AGENTS.md` or a named skill) and propose the rule plus one-line
   reason. Prefer merging into an existing rule over adding a new one. A user-wide rule still must not name a company.
   If the correction is project-specific, target that project's `AGENTS.md`.
5. Propose deletions or shrinks for rules that this session showed no longer apply.
6. Wait. They approve each change, or say skip. Do not edit those files until they approve that item. When you write an
   approved change into `AGENTS.md` or a skill, follow the `writing-for-agents` skill.

## Done

Every kept candidate has an approve or skip. Unapproved proposals are not written.
