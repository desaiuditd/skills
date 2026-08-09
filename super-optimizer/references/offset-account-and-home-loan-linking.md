# Offset Account & Home Loan Linking — Template

**Only relevant if `has_ledger` = true and the user has a non-deductible loan with an offset facility.**

**Update whenever accounts are re-linked to a different loan.**

---

## How to Use This Template

Ask the user to fill in the table below once, then update it whenever their bank re-links offset accounts to a different loan. This configuration directly affects:

1. The **opportunity cost hurdle rate** used in the zone analysis
2. The **offset rebuild timeline** in Step 6

---

## Configuration Table

Fill in one row per offset account. Each row maps an account to the loan it is currently offsetting.

| Offset account label  | Ledger path                       | Linked loan         | Loan type  | Tax deductible? | Role                                      |
| --------------------- | --------------------------------- | ------------------- | ---------- | --------------- | ----------------------------------------- |
| {account description} | `{Assets:...}` or N/A (no ledger) | {loan name/account} | {IO / P&I} | {Yes / No}      | {Reduces non-deductible interest / other} |
| {account description} | `{Assets:...}` or N/A (no ledger) | {loan name/account} | {IO / P&I} | {Yes / No}      | {Reduces non-deductible interest / other} |

**Combined offset target:** Balance of `{non_deductible_loan_account}` = ${loan_balance}

---

## Confirming the Configuration Each Run

Before running the optimiser, ask the user:

> "Are your offset accounts still linked to the same loan as documented here, or has anything changed since last time?"

If changed: update this table, then recalculate the opportunity cost hurdle rate before proceeding.

---

## Why Linking Matters for the Super Calculation

| Offset linked to…          | Hurdle rate formula                        | Implication                                                   |
| -------------------------- | ------------------------------------------ | ------------------------------------------------------------- |
| Non-deductible loan        | `full loan rate` (e.g. 6.5%)               | Higher hurdle — super must beat this to be worth contributing |
| Deductible investment loan | `rate × (1 − effective_marginal_tax_rate)` | Lower hurdle — even modest super savings look attractive      |

**Example:** At a 6.5% loan rate and 37% marginal tax rate:

- Non-deductible: hurdle = 6.5%
- Deductible: hurdle = 6.5% × (1 − 0.37) = **4.1%**

Lower hurdle means more contribution zones are worth using.

---

## Future Re-linking Scenarios

| Trigger                                             | Likely action                                | Impact on skill                              |
| --------------------------------------------------- | -------------------------------------------- | -------------------------------------------- |
| Combined offset exceeds non-deductible loan balance | Re-link accounts to investment loan          | Offset target changes; hurdle rate drops     |
| Build loan drawn and accumulating balance           | Consider linking offset to build loan        | New deductible interest stream to neutralise |
| Non-deductible loan paid off or refinanced          | All offsets free to link to deductible loans | Hurdle rate drops significantly              |

When any of these occur, update this file and reconfirm the hurdle rate before running the next optimiser.
