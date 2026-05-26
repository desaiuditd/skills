# Why the `git-commit-message` skill requires you to run `git commit` first

The most common feedback on the skill: _"Why can't the agent just stage my files, run `git commit`, and write the
message itself?"_

Two reasons: staging ambiguity and pre-commit hooks.

## Staging is not the skill's job

A commit involves two decisions:

1. **What goes in** — which files and hunks to stage for the commit
2. **How to describe** — the commit message

These are two different problems. The skill is good at the second decision.

However, for 1st decision, staging is a judgment call about scope — it depends on the user's intent, which changes are
related, and what should be grouped together. For example:

- You have 6 modified files but only 3 belong to this change
- You already staged specific hunks with `git add -p`.
- You have debug logs and `.env` changes in your working tree that should never be committed.

The agent cannot reliably make these decisions for you.

A bad commit message is annoying. But a bad commit scope requires `git reset` that most people won't bother doing
cleanly, which is more problematic.

## Co-ordination and deadlock problems with pre-commit hooks

When you run `git commit`, the execution order is:

1. Pre-commit hooks run (lint, typecheck, unit tests) — blocks for 10 seconds to 2+ minutes
2. If hooks pass, the editor opens with `COMMIT_EDITMSG`
3. You write the message, save, close
4. Git creates the commit

If the agent runs `git commit` on your behalf:

- It is waiting while the hooks run. You see it doing nothing and probably don't know why.
- If hooks fail, the skill workflow is aborted.
  - The agent may have already asked context questions and composed a message that will never be used.
- With `core.editor = "code --wait"`, the git commit command is blocked indefinitely, waiting for the editor to be
  closed.
  - The flow would be:

    ```text
    Agent runs git commit asynchronously
      → terminal is blocked on hooks
        → detect that hooks finished
          → Git invokes `code --wait COMMIT_EDITMSG`
            → terminal is blocked waiting for editor close
              → detect that `COMMIT_EDITMSG` opened
                → write the message
                  → signal the user to close the file.
    ```

This is fragile orchestration across async boundaries:

- **Deadlock:** if the agent fails to detect the file opened, both sides wait forever
- **Fragile detection:** there's no reliable notification mechanism for "hooks finished, editor opened"

## Handoff via `COMMIT_EDITMSG` file

When you run `git commit` yourself, you see hook output in your terminal, you fix failures, and by the time
`COMMIT_EDITMSG` opens the skill knows hooks have passed and the staged diff is final.

The `COMMIT_EDITMSG` prerequisite is a handoff point. You handle what can fail unpredictably (hooks, staging). The skill
handles what it's good at: reading the diff, asking about the "why", writing and formatting the message.

## The workflow

**Stage → commit → invoke skill.** Three steps, each owned by whoever handles it best:

| Step                 | Who   | Why                                                  |
| -------------------- | ----- | ---------------------------------------------------- |
| Decide what to stage | You   | Only you know which changes belong together          |
| Run `git commit`     | You   | Hooks need your visibility; failures need your fixes |
| Write the message    | Skill | Diff analysis and structured writing                 |
