---
name: explain-back
description: >-
  Explain-back before a design call, or before the user makes a decision they have to own. The user explains first.
  Check that explanation against the source, list gaps, ask one question they could not answer. After 18:00 local time
  or at weekends, point that out once before an approval. User can say skip.
---

# Explain-back

Reason: if they cannot explain it, do not ship it or approve it. The check is against the source, not against your
recap.

## When it runs

Two branches.

- Before a design call: they state what they expect. You answer. Compare your answer with theirs. Then make the
  strongest case against **your own** answer. Reason: otherwise they adopt your confidence instead of testing it. This
  is not opposing them.
- Before they make a decision they have to own: they explain what it does and why. Any call that is theirs, whatever the
  domain. E.g., A PR or an RFC stance. Skip cheap reversible choices.

They can say `skip`. Then stop this skill and continue the original task.

## Steps

1. Wait for their explanation if they have not given one. Do not explain it for them first.
2. Check their explanation against the source. Quote or cite it. Do not use the chat as the source of truth.
3. List what is missing. Keep the list short. Name only gaps that would change the decision.
4. Ask **one** question they could not answer. Stop. Wait.
5. After 18:00 in their local timezone, or on a weekend, point that out **once** before an approval. They can still
   approve, or say skip.

## Done

The skill is done when they have explained the thing, the gaps are named, the one question is answered or skipped, and
they have approved or cut the work. Do not answer your own question for them, and do not start the work the decision
authorises before that.
