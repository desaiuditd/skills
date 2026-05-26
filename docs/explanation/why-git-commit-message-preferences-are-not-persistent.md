# Why `git-commit-message` preferences are not persistent

The `git-commit-message` skill asks about user preferences each time — Gitmoji, issue tracker format, etc. There's no
built-in mechanism to save these preferences across invocations.

This doc explains what was tried, why each approach fell short, and what works today.

## The problem

Some preferences are per-user and stable:

- "I always want Gitmoji"
- "I always want a JIRA trailer"

Asking every time is friction. But there's no first-class "skill preferences" system in VS Code or GitHub Copilot.

> [!note] Note on motivation
>
> The skill deliberately asks _why_ you made a change — this is not a preference you can skip. The skill's core value is
> pushing you to articulate intent, not just describe the diff. It will never write the final commit message by
> inferring motivation automatically. That friction is the feature.

## Approaches tried

### 1. Default-on

Early versions of the skill had Gitmoji enabled by default. Most users don't want it, so it was flipped to opt-in.
Simple, but doesn't solve the per-user preference problem.

### 2. VS Code settings as a preference store

The skill instructions told the agent to read a made-up setting from `.vscode/settings.json` or global user settings:

```json
{
  "chat.agent.skills.git-commit-message.gitmoji": true
}
```

Not an official VS Code setting — just a convention the skill would look for. The agent would read the file and infer
the preference.

**Why it stopped working:**

- After converting from an agent to a skill, the reading behaviour became unreliable
- Tightly couples the skill to VS Code — doesn't work in other Copilot surfaces
- Users don't expect to configure AI behaviour through `settings.json`

### 3. Prompt files with personal preferences baked in

VS Code supports [prompt files](https://code.visualstudio.com/docs/copilot/customization/prompt-files) — small markdown
files that surface as slash commands in chat. The idea: define your preferences in a prompt file, invoke that instead of
the raw skill.

Example prompt file:

```markdown
---
description: Generate commit message using the git-commit-message skill.
name: gitCommitMessage
tools:
  - edit
  - execute/getTerminalOutput
  - execute/runInTerminal
  - search
  - vscode/askQuestions
  - web/fetch
---

Help me write a clear, accurate Git commit message for the code changes as per the diff shown in the `COMMIT_EDITMSG`
file.

Use `git-commit-message` skill.

Always include a Gitmoji in the commit message. Don't ask user.

Always infer issue tracker reference from the code changes and current branch name, and include it in the commit message
as a Git Trailer. Don't ask user if you've already inferred the issue tracker reference.
```

**Why it stopped working:**

When invoked via natural language or a prompt file, the agent detected the skill but only read the first ~100 lines of
`SKILL.md`. It skipped required questions (Gitmoji preference, motivation) and returned the message in chat instead of
writing to `COMMIT_EDITMSG`.

## Why partial reading happens: Progressive Disclosure

VS Code uses a behaviour called _Progressive Disclosure_ — it reveals skill instructions gradually, reading only what it
considers necessary for the current request. This is by design, not a bug.

When a skill is invoked via its **slash command** (`/git-commit-message`), VS Code bypasses this. It locates the
`SKILL.md` on the file system, reads the entire content, and injects it as a system prompt alongside the user's message.

Source:
[`skillTool.ts` L91-L95](https://github.com/microsoft/vscode/blob/main/extensions/copilot/src/extension/tools/node/skillTool.ts#L91-L95)

When invoked via **natural language** ("help me write a commit message"), the agent detects and reads the skill — but
only partially. The full instruction set (interview questions, formatting rules, file-writing steps) gets truncated.

## What works today

Invoke the skill via slash command with your preference inline:

```text
/git-commit-message
Use Gitmoji
```

Two words after the slash command. Consistent results every time.

The slash command guarantees the full `SKILL.md` is loaded. The inline text acts as a user preference override without
needing any persistence mechanism.

Not elegant. But reliable — and reliability matters more than convenience when you're writing commit history.

## Summary of tradeoffs

| Approach                    | Reliable? | Portable? | Why it failed                                         |
| --------------------------- | --------- | --------- | ----------------------------------------------------- |
| Default-on                  | Yes       | Yes       | Doesn't respect per-user preference                   |
| VS Code settings convention | No        | No        | Broke after agent → skill conversion; VS Code–coupled |
| Prompt file with skill ref  | No        | No        | Progressive Disclosure truncates skill instructions   |
| Slash command + inline text | Yes       | No        | Manual, but full skill is always loaded               |
