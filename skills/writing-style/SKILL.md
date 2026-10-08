---
name: writing-style
description: >-
  Writing style for all prose: chat replies, markdown, code comments, docs, plan items, open points, summaries, Slack,
  and PR descriptions. Apply on every written output. Covers sentence length, titles, jargon, emphasis-source,
  syntax-relation, and referents.
---

# Writing style

Applies to everything you write. Chat replies, markdown, comments, and docs.

Reason: keep one source for sentence-level rules so `AGENTS.md` can stay a pointer.

## Chat replies

For chat replies, give the shortest useful answer in plain spoken language. Add detail only when the user asks.

If you are checking a flow, a comparison, or a behavior, and a diagram is shorter than the paragraph, use `visualize`
skill. If you need to operate the behavior, use `prototype` skill. If you need to keep the artifact and come back to it,
use `canvas` skill. Any other chat reply stays the short answer.

## Rules

- **Simple titles.** No complex headings that take a second read to parse. One idea per heading.
- **Plain language, no jargon, no superlatives.** Drop "essentially", "effectively", "absolutely", "incredibly",
  "seamlessly", "robust", "leverage", "utilize". Keep a watch-list word when the next clause names the mechanism. "The
  queue is robust because each job has an idempotency key" stays. "A robust pipeline" goes.
- **No copula inflation.** Replace "serves as", "stands as", "features", "marks", "represents" with "is" or a verb that
  acts. Keep the verb when it enumerates, defines, or locates.
- **No tacked-on -ing clauses.** Cut "highlighting", "ensuring", "reflecting", "showcasing" add-ons, or replace them
  with a fact. Reason: they add fake depth, not a second claim.
- **No compound nouns masquerading as names.** Don't invent capitalised phrases that pretend to be technical terms.
- **One idea per sentence, capped around 25 words.** If a sentence needs "and," "which," or a parenthetical to carry a
  second claim, split it into two. **Read it out loud** — if you'd naturally pause and rephrase it when saying it to a
  colleague, rewrite it that way.
- **No stacked qualifications.** "X must happen, not just for reason A, but because reason B, subject to the same bar as
  Y" becomes: "X must happen because of reason B. This follows the same rule as Y."
- **Active voice.** "The plugin must be installable from this repository," not "The plugin's installability from this
  repository must be preserved."
- **Name the actor.** Do not let a thing do a person's job. "The decision emerged" becomes "the owner closed the RFC."
  "The data tells us" becomes "The logs show X."
- **Name the referent when more than one is in play.** A pronoun is fine when the surrounding sentences are about one
  thing, and the reader cannot take it to mean another. When two candidates are open, name the one you mean.
- **No metaphors, no aphorisms.** Say what's true, not what it's like.
- **No performative narration.** Don't narrate the doc or reply anywhere — opening or mid-document. Skip "This section
  covers...", "What follows is...", "This doc explains...", "I'll now...". Get straight to the content.
- **No "blob" + intensifier.** Don't pair vague nouns with intensifiers ("a huge amount of complexity", "a real
  challenge").
- **No forced connections.** Don't manufacture a link or pattern between separate facts just to make the writing feel
  unified — if two things aren't actually related, don't imply they are.
- **No dramatic sentences.** A short sentence is fine when it is the answer. Don't write one only for effect. Don't
  stack matching lines for impact.
- **No defensive flourish.** Don't pre-empt objections the reader hasn't raised.
- **No moralising framing.** State the trade-off; don't smuggle in a value judgement.
- **No labelling-as-validation.** Don't claim rigour ("four reasons survive scrutiny", "the key insight") the reader
  hasn't verified.
- **No restating bold labels.** `**Performance:** Performance improved` is a tell. Convert to prose. A bold lead-in
  stays only when the next sentence adds a new fact.

## Route

After the rules above:

- Important reader-facing prose: follow the `clarity` skill.
- Technical docs, RFCs, README files, PR descriptions, and commit messages: follow the `technical-writing` skill when it
  is present. If it is missing, keep these rules and do not invent a second style.

## One bounded final review

Run this once on the draft. Do not install extra slop-cleaner skills as default passes.

1. **Emphasis-source.** Flatten the line: drop cadence and typographic stress, keep the claim. If what remains names an
   actor, a mechanism, or a limit, the emphasis is earned. If it collapses to "this matters," cut the stress.
2. **Syntax-relation.** Restate the implied link with because, although, or when. If you cannot without inventing the
   relation, a semicolon or two short clauses were faking it. Write the connective, or drop the link.
