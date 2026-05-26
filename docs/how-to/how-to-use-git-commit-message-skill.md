# How to use Git Commit Message Skill?

[git-commit-message Skill](../../skills/git-commit-message/SKILL.md)

## Prerequisites

- **VS Code** with **GitHub Copilot Chat** extension installed
- **Git** version 2.23 or higher

## Setup

**1. Configure VS Code as your Git editor:**

```bash
git config --global core.editor "code --wait"
```

**2. Install the skill:**

```bash
npx skills desaiuditd/skills git-commit-message
```

**3. Verify the skill is available:**

- Open Copilot Chat (`Cmd/Ctrl + I`)
- Type `/git-commit-message` — if the slash command appears as a suggestion, the skill is set up correctly

**4. Revert to default editor (if needed):**

```bash
# Remove VS Code as Git editor
git config --global --unset core.editor

# Or set a different editor of your choice
git config --global core.editor "vim"        # Vim
git config --global core.editor "nvim"       # NeoVim
git config --global core.editor "nano"       # Nano
git config --global core.editor "emacs"      # Emacs
```

## Usage

1. **Stage your changes:**

   ```bash
   git add --patch <files>
   ```

2. **Start a commit:**

   ```bash
   git commit
   ```

   VS Code opens with the `COMMIT_EDITMSG` file.

3. **Invoke the skill:**
   - Open Copilot Chat (`Cmd/Ctrl + I`)
   - Ask: "Help me write a commit message" (or similar prompt)
   - Or invoke the skill with slash command in VS Code chat.
     - Either the default one - `/git-commit-message`. Same as skill name.
     - You can give your Gitmoji preference with the slash command. E.g., `/git-commit-message Use Gitmoji.`
   - Using the slash command usually gives better results, as the entire skill will be loaded into the context. Asking
     with natural language, will force agent to read the skill file partially, due to "Progressive Disclosure" behaviour
     to manage the context window.

4. **Collaborate with the agent:**
   - Agent looks up instructions from the skill.
   - Answer whether you want Gitmoji or not, if the agent can not infer the preference.
   - Inform the agent about any JIRA reference, if the agent can not infer it from the branch name.
   - Provide context about WHY you made the changes if asked
   - Review the generated commit message written to `COMMIT_EDITMSG`
   - Request adjustments if needed

5. **Complete the commit:**
   - Agent writes to `COMMIT_EDITMSG` after approval
   - Save and close the file (`Cmd/Ctrl + S`, then close tab)
   - Git completes the commit

## Tips

- **Be specific about the "why"** - The agent can see WHAT changed but needs your help explaining WHY
- **Review before approving** - The agent will always show you the message before writing it
- **Jira tickets** - The agent will try to extract the ticket ID from your branch name (e.g.,
  `feature/CMS-1234-description`) or ask you to provide the ticket ID manually
- **Keep it focused** - Answer questions concisely; the agent prioritizes clarity over verbosity
- **Verify your message** - After writing, ask the agent to analyze your commit message to ensure it explains WHY (not
  WHAT) and follows our principles. The agent can rate your own commits too!

## Example Workflow

```bash
# Make your changes
git add --patch app/src/components/SearchProvider.tsx

# Start commit
git commit

# In VS Code Copilot Chat:
# 1. Open chat (Cmd/Ctrl + I)
# 2. Ask: "Help me write a commit message" (or run the slash command)
# 3. Agent tries to infer Gitmoji preference and JIRA reference
#   - Answer to agent's questions, if it can't infer
# 4. Agent asks for context - Explain: "Needed to decouple search from Redux for easier testing"
# 5. Review generated message written to `COMMIT_EDITMSG` file
# 6. Save and close editor
```

## Troubleshooting

**VS Code doesn't open for commits:**

- Verify Git editor config: `git config --global core.editor`
- Should show: `code --wait`
- Try setting it again with the setup command

**Agent can't write to COMMIT_EDITMSG:**

- Ensure `COMMIT_EDITMSG` file is open in VS Code
- Check that Copilot has file edit permissions in settings

**Want to cancel the commit (e.g., during rebase):**

- Go back to the terminal
- Press `Ctrl + C` to cancel the `git commit` process
- Existing commit will be preserved
- `COMMIT_EDITMSG` editor window in VS Code can be closed if it remains open.
