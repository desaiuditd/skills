# Gitmoji Reference

Gitmoji is **OFF by default**. Only include a Gitmoji emoji if the user explicitly uses phrases like "Use Gitmoji" or
"with emoji". Do not infer Gitmoji preference from indirect mentions of emojis. Do not ask about Gitmoji preference.

## Selection Process

1. Fetch the official list from `https://gitmoji.dev/api/gitmojis` via the `web fetch` tool
2. Identify the PRIMARY intent of the commit
3. Match intent to emoji description (not just keywords)
4. **Always use the unicode emoji character** (e.g. ✨), never the shortcode (e.g. `:sparkles:`)
5. If the user names an emoji that does not appear in the list or is unrecognisable, inform them and suggest the closest
   matching alternative from the list

## Common Patterns

- New feature/capability → ✨
- Bug fix → 🐛
- Refactor (no behavior change) → ♻️
- Tests → ✅ or 🧪
- Documentation → 📝
- Performance → ⚡
- Types → 🏷️
- Business logic → 👔
- Move/rename files or folders → 🚚
- UI/styling (cosmetic) changes → 💄

## When Ambiguous

If it's unclear which emoji best fits (and Gitmoji is already enabled), ask the user which aspect of the change is
primary before choosing.
