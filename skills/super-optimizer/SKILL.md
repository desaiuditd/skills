---
name: super-optimiser
description: >
    Australian EOFY concessional super contribution optimiser.
    USE THIS SKILL whenever the user asks: how much to contribute to super, whether super contribution is worth it, EOFY tax minimisation strategy, estimated tax refund, optimal super amount to reduce taxable income, investment property tax deductions and their impact, offset account rebuild timeline after contribution.
    This skill can work with or without a plain-text ledger (beancount/hledger). If a ledger is available, it reads data directly. If not, it collects figures via structured questions and proceeds with the same analysis.
    Applies current Australian tax rules including LITO phase-out zone analysis, and outputs the exact optimal contribution amount per person with a confidence-scored breakdown.
    Trigger on ANY mention of super contribution decisions, EOFY tax planning, "how much should I put in super", or "is super worth it this year".
---

# Super Contribution Optimiser

## Purpose

Calculates the optimal annual concessional super contribution for one or two people to minimise household tax. Run once per financial year, ideally in May–June before the 30 June EOFY deadline.

Covers:

- Salary income + investment property income (if applicable)
- All property deductions (interest, operating expenses, Div 40 DV depreciation, Div 43)
- LITO, Medicare levy, MLS, PHI rebate tier
- Zone-by-zone bracket analysis to find the exact contribution that beats the offset rate
- Offset rebuild timeline projection under each scenario
- Confidence-scored output with all assumptions visible

Works **with or without** a plain-text ledger. If the user has a beancount or hledger ledger, it queries data directly. If not, it asks for figures and proceeds with the same analysis.

Read `references/australian-tax-framework.md` for tax brackets, LITO, super rules, MLS thresholds.
Read `references/ledger-reading-guide.md` only if the user has a beancount/hledger ledger.

---

## Step -1: Setup — Collect User Context

**Run this step first, every time.** Ask all questions upfront in a single message before proceeding. Do not proceed to Step 0 until you have answers to all required questions.

Ask the following as a numbered QnA block:

---

**Setup questions — please answer all before I continue:**

1. **How many people** are we optimising for? (1 person or 2 people as a household)

2. **What should I call you?** (First names or labels like "Person A / Person B" — used throughout the report)

3. **Do you have an investment property?**
    - If yes: what is it called (e.g. suburb, street, or a label like "Rental Property"), and what is the ownership split? (e.g. 50/50, 100% one person)

4. **Do you have a non-deductible home loan** (PPOR mortgage, land loan, or construction loan for a property not yet earning rent)?
    - If yes: what is the current outstanding balance and the interest rate?
    - If yes: do you have offset accounts linked to this loan? If so, what is the combined offset balance?

5. **Do you hold private hospital cover (private health insurance)?**
    - Answer for each person separately.

6. **Do you use a plain-text accounting ledger** (beancount or hledger)?
    - If yes: I will run queries against it to extract figures.
    - If no: I will ask you for figures directly.

---

Once you have answers, save as variables for use throughout:

```
person_a = {name from Q2}
person_b = {name from Q2, or null if single}
investment_property = {property label from Q3, or null}
property_ownership_split = {e.g. 0.5 for 50/50, or 1.0 for sole, or null}
non_deductible_loan_balance = {from Q4, or null}
non_deductible_loan_rate = {from Q4, or null}
combined_offset_balance = {from Q4, or null}
phi_person_a = {true/false from Q5}
phi_person_b = {true/false from Q5, or null}
has_ledger = {true/false from Q6}
```

---

## Step 0: Required Documents — Check Before Proceeding

Before running tax calculations, confirm which documents are available.

| #   | Document                  | Person          | Key extractions                                                                                                  | If missing                                                                      |
| --- | ------------------------- | --------------- | ---------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------- |
| 1   | **Current payslip**       | {person_a}      | Annual salary, YTD gross, YTD PAYG withheld, YTD super SG, super fund name                                       | **Ask: "Please share {person_a}'s most recent payslip"**                        |
| 2   | **Current payslip**       | {person_b}      | Annual salary, YTD gross, YTD PAYG withheld, YTD super SG, super fund name + account                             | **Ask: "Please share {person_b}'s most recent payslip"**                        |
| 3   | **Depreciation schedule** | Investment prop | Div 40 (plant, DV method) and Div 43 (capital works) amounts for the current FY year number                      | **Ask: "Please share the depreciation schedule (from your quantity surveyor)"** |
| 4   | Prior year tax return     | Each person     | Filed taxable income, depreciation method used (DV or SL — locked in forever), prior personal super contribution | Optional but useful; reduces uncertainty                                        |
| 5   | **Super balances**        | Both            | Current balance per person — needed for carry-forward eligibility (must be <$500k on 30 June prior year)         | **Ask: "What is each person's current super balance?"**                         |
| 6   | Carry-forward cap         | Both            | Total unused concessional cap from ATO MyGov (My Super → Unused caps)                                            | Ask if available; otherwise calculate from prior year SG data                   |

**Hard stop: Do not run tax calculations without items 1 and 2 (payslips). Item 3 (depreciation schedule) is required if there is an investment property. Items 4–6 reduce uncertainty; flag clearly if missing.**

If `investment_property` is null (no property), skip item 3.

---

## Step 1: Collect Financial Data

**Branch on `has_ledger`:**

### Branch A — Ledger Available (beancount or hledger)

Read `references/ledger-reading-guide.md` to understand the user's ledger structure and account naming conventions. Ask the user for their account path patterns if not already known.

#### 1a. Salary Income

Query YTD salary income for each person. Example BQL (adapt account paths from ledger-reading-guide):

```sql
SELECT account, sum(position) WHERE account ~ 'Income:{person_a}:salary' AND year = {fy_end_year}
SELECT account, sum(position) WHERE account ~ 'Income:{person_b}:salary' AND year = {fy_end_year}
```

**Precedence: payslip beats ledger.** Use payslip as authoritative for salary and PAYG. Use ledger to cross-check and detect additional income (bonuses, allowances).

Annualise YTD: `full_year_gross = YTD_gross / months_completed * 12`. Mark as INFERRED if < 10 months.

#### 1b. Rental Income (Investment Property)

Skip if `investment_property` is null.

```sql
SELECT account, sum(position) WHERE account ~ 'Income:property:{investment_property}' AND year = {fy_end_year}
SELECT account, sum(position) WHERE account ~ 'Expenses:property:{investment_property}' AND year = {fy_end_year}
```

Each person's share = total × `property_ownership_split`.

#### 1c. Investment Loan Interest (Deductible)

Skip if `investment_property` is null.

```sql
SELECT account, sum(position) WHERE account ~ 'Expenses:property:{investment_property}:interest' AND year = {fy_end_year}
```

Each person's share = total × `property_ownership_split`.

If there is a **build loan** for a property under construction, check whether it has been drawn yet:

```sql
SELECT account, sum(position) WHERE account ~ 'Expenses:property:{build_property}:build-interest' AND year = {fy_end_year}
```

If $0 or no rows: build loan not yet drawn, skip. If non-zero: include each person's share as a deduction.

**Non-deductible home loan interest: never include in the tax model.** The non-deductible loan appears only in the offset rebuild calculation (Step 6).

#### 1d. Offset and Loan Balances

Read `references/offset-account-and-home-loan-linking.md` to confirm which accounts are currently linked to which loan.

Query the combined offset balance and the non-deductible loan balance:

```sql
SELECT account, sum(position) WHERE account ~ '{offset_account_pattern}' AND date <= {today}
SELECT account, sum(position) WHERE account ~ '{non_deductible_loan_account}'
```

Confirm with the user: _"Are the offset accounts still linked to the same loans as listed in the reference file, or has anything changed?"_

**Opportunity cost hurdle rate:**

- Offset against non-deductible loan → use full loan rate as hurdle
- Offset against deductible loan → `hurdle = rate × (1 − effective_marginal_tax_rate)`

#### 1e. Monthly Savings Rate

Query the last 3 complete calendar months of net flow across all offset accounts:

```sql
SELECT YEAR(date) AS year, MONTH(date) AS month, units(sum(position)) AS net_monthly_flow
WHERE account ~ '{offset_account_pattern}'
  AND date >= {3_months_ago}
  AND date <= {last_complete_month_end}
GROUP BY 1, 2
ORDER BY 1, 2;
```

Take the **median** of the 3 monthly values (not average) to avoid distortion from months with 3 pays or large one-off transfers. Flag if any month deviates from the median by more than 50%.

#### 1f. Interest Income

```sql
SELECT account, sum(position) WHERE account ~ 'Income:{person_a}:.+:interest' AND year = {fy_end_year}
SELECT account, sum(position) WHERE account ~ 'Income:{person_b}:.+:interest' AND year = {fy_end_year}
```

Each person's interest income is assessable to that person alone.

---

### Branch B — No Ledger (Manual Entry)

Ask for the following figures in a single structured question block. Format them as a table or numbered list so the user can fill in each one.

**Please provide the following figures (skip any that don't apply):**

**{person_a}:**

1. Annual salary (or YTD gross + months elapsed so I can annualise)
2. YTD PAYG tax withheld (from payslip)
3. YTD employer super (SG) contributions (from payslip)
4. Super fund name and account number (for the Notice of Intent later)
5. Interest income from savings/term deposits this FY (if any)

**{person_b} (if applicable):** 6. Same as 1–5 above

**Investment property (if applicable — one set for the property, split by ownership %):** 7. Gross rental income this FY (or annualised from property manager statement) 8. Total operating expenses (management fees, strata, council rates, water, insurance, repairs, etc.) 9. Investment loan interest paid this FY 10. Div 40 depreciation amount (from quantity surveyor's depreciation schedule, current FY year) 11. Div 43 depreciation amount (from same schedule)

**Offset and savings:** 12. Current combined balance of all offset accounts linked to non-deductible loan 13. Non-deductible loan current balance and interest rate 14. Estimated monthly savings rate (how much do you save per month after all expenses?)

**Super:** 15. Current super balance per person (needed for carry-forward eligibility check) 16. Total unused concessional cap per person (from ATO MyGov → My Super → Unused caps; skip if unknown)

Once all figures are collected, proceed to Step 2 using these as inputs. Mark all manually entered figures as EXTRACTED: (if directly from a document) or INFERRED: (if estimated).

---

## Step 2: Build the Taxable Income Model

For each person:

```
Gross salary (annualised from payslip)
+ Investment property gross rent — own share
+ Interest income from savings/TDs (if any)
- Investment loan interest — own share
- Investment property operating expenses — own share
- Build loan interest — own share  [ONLY if build loan was drawn this FY; else $0]
- Div 40 depreciation (DV, current FY year from schedule) — own share
- Div 43 depreciation (current FY year from schedule) — own share
- Work-related expenses (use ledger actuals if categorised; else estimate $750–$1,000 or ask)
= TAXABLE INCOME BEFORE SUPER CONTRIBUTION
```

**Never include non-deductible home loan interest here.** It appears only in the offset rebuild calculation (Step 6).

**Critical depreciation rule:** Always use **Diminishing Value (DV)** method for Div 40 plant & equipment. This is elected in Year 1 and is irrevocable. Confirm from the prior year tax return — the Div 40 amount should match the depreciation schedule's DV Year 1 exactly. If they don't match, flag and ask.

---

## Step 3: Tax Calculation (Before Contribution)

Read `references/australian-tax-framework.md` for current FY brackets, LITO schedule, and all rates.

For each person, apply in order:

1. **Progressive income tax** — bracket rates against taxable income
2. **LITO** — Low Income Tax Offset (phases out between $37,500 and $66,667)
3. **Medicare levy** — 2% flat on taxable income
4. **MLS** — Medicare Levy Surcharge: if `phi_person_a` or `phi_person_b` is true → **$0 for that person**. If PHI status unknown, ask before proceeding.
5. **Total tax payable** = gross tax − LITO + Medicare levy + MLS
6. **PAYG withheld** = annualise YTD PAYG from payslip
7. **Estimated refund** = PAYG withheld − total tax payable (positive = refund, negative = bill)

---

## Step 4: Zone Analysis — Optimal Super Contribution

Find the contribution amount where the **net saving rate** (marginal tax rate + Medicare − 15% contributions tax) still exceeds the **opportunity cost** (non-deductible loan interest rate, or 0 if no non-deductible loan).

**Opportunity cost:** Use `non_deductible_loan_rate` from Step -1. If `non_deductible_loan_balance` is null (no such loan), set opportunity cost = 0 (any contribution with positive net saving rate is worth making).

### Zone Table

| Zone               | Income band         | Components                        | Net saving rate          |
| ------------------ | ------------------- | --------------------------------- | ------------------------ |
| 45% bracket        | > $180,000          | 45% + 2% Medicare − 15% super tax | **32%** ✅               |
| 37% bracket        | $120,001 – $180,000 | 37% + 2% − 15%                    | **24%** ✅               |
| 32.5% bracket      | $45,001 – $120,000  | 32.5% + 2% − 15%                  | **19.5%** ✅             |
| LITO phase-out     | $37,500 – $45,000   | 19% + 5% LITO clawback + 2% − 15% | **11%** ✅               |
| 19% flat bracket   | $18,201 – $37,500   | 19% + 2% − 15%                    | **6%** — check vs hurdle |
| Tax-free threshold | $0 – $18,200        | 0% − 15%                          | **−15%** ❌ never        |

The LITO phase-out zone ($37,500–$45,000) adds an effective 5% extra (restored LITO clawback). Do not skip this zone — it almost always beats a standard offset rate.

For the 19% bracket (net 6%): compare against `non_deductible_loan_rate`. If hurdle > 6%, stop here. If no non-deductible loan (hurdle = 0), contributions are still worth it.

### Algorithm

```
remaining_cap = current_year_concessional_cap (see australian-tax-framework.md for current FY cap)
              + carry_forward_cap (from ATO MyGov, or estimated)
              - employer_SG_ytd_annualised

taxable_income = calculated from Step 2
optimal_contribution = 0

zones = [
  (180001, infinity, 0.45),
  (120001, 180000,  0.37),
  ( 45001, 120000,  0.325),
  ( 37501,  45000,  0.19 + 0.05),  # LITO phase-out
  ( 18201,  37500,  0.19),
  (     0,  18200,  0.00),
]

for (lower, upper, bracket_rate) in zones (highest first):
  if taxable_income <= lower: continue

  amount_in_zone = min(taxable_income - lower, remaining_cap)
  net_saving_rate = bracket_rate + 0.02 - 0.15

  if net_saving_rate > opportunity_cost:
    optimal_contribution += amount_in_zone
    taxable_income -= amount_in_zone
    remaining_cap -= amount_in_zone
  else:
    break
```

### Division 293 Check

**Always run this.** If income for surcharge purposes (ISP) exceeds $250,000, an additional 15% super tax applies on contributions for the portion above the threshold.

```
ISP = taxable_income_before_contribution + employer_SG + personal_contribution
```

If ISP > $250,000: recalculate net saving rate for the portion above the threshold (subtract 15% from each zone's net saving rate). Recalculate optimal contribution accordingly.

---

## Step 5: Net Benefit Calculation

For each person's optimal contribution:

```
extra_refund = tax_after_contribution - tax_before_contribution (positive = larger refund)
contributions_tax = optimal_contribution × 0.15
net_added_to_super = optimal_contribution - contributions_tax

# Interest cost: extra months of sub-threshold offset (only if non_deductible_loan exists)
if non_deductible_loan_balance is not null:
  post_contribution_offset = combined_offset - optimal_contribution
  monthly_interest_pre  = max(0, loan_balance - combined_offset) × loan_rate / 12
  monthly_interest_post = max(0, loan_balance - post_contribution_offset) × loan_rate / 12
  extra_monthly_interest = monthly_interest_post - monthly_interest_pre
  months_to_rebuild = estimated from Step 6
  total_interest_cost = extra_monthly_interest × months_to_rebuild
else:
  total_interest_cost = 0

net_cash_benefit = extra_refund - contributions_tax - total_interest_cost
```

---

## Step 6: Offset Rebuild Timeline

Only run if `non_deductible_loan_balance` is not null. If there is no non-deductible loan, skip this step and note "no offset rebuild needed — no non-deductible loan".

Project month-by-month until combined offset covers the non-deductible loan balance.

```
offset = post_contribution_combined_offset  (after all contributions)
monthly_savings = median monthly savings rate from Step 1e (or manually entered)
loan_balance = non_deductible_loan_balance

month = 0
while offset < loan_balance:
  month += 1
  offset += monthly_savings
  if month == ATO_refund_month:   # typically October after June EOFY lodgement
    offset += person_a_refund + person_b_refund (if applicable)
```

Run **three scenarios**:

1. No contributions (baseline)
2. {person_a} only
3. Both contribute optimally (or {person_a} only if single)

For each: state the crossover month and total extra interest paid vs. baseline.

---

## Step 7: Output Format

**Write the full report to a markdown file — do not produce it as a chat reply.**

Save the report to:

```
super-optimiser-report/super-optimiser-{fy_end_year}.md
```

Once the file is written, reply in chat with only:

- The file path (as a link)
- A 3-line summary: recommended contribution per person, combined net benefit, and overall confidence score

Tag every key number in the report as `EXTRACTED:` (directly from source) or `INFERRED:` (calculated/estimated).

### Section 1: Document & Data Inputs Summary

Table: each input, its value, source type (EXTRACTED/INFERRED), and confidence score.

### Section 2: Taxable Income Waterfall (per person)

All income and deduction line items. "Before contribution" column only at this stage.

### Section 3: Tax Calculation (per person)

Bracket math, LITO, Medicare, MLS, total payable, PAYG withheld, refund — before contribution.

### Section 4: Zone Analysis Table (per person)

Each zone showing: income range, amount in zone, net saving rate, beats hurdle (yes/no), contribution taken from zone. Show the stop point clearly.

### Section 5: Recommendation

```
{person_a}: Contribute $XX,XXX → taxable income drops from $XXX,XXX to $XXX,XXX
{person_b}: Contribute $XX,XXX → taxable income drops from $XX,XXX to $XX,XXX
Combined cash outlay: $XX,XXX
```

Include Division 293 check result. Include cap headroom remaining.

### Section 6: Revised Tax & Refund (per person, after contribution)

Same structure as Section 3 but with post-contribution figures.

### Section 7: Net Benefit Summary

| Item | {person_a} | {person_b} | Combined |
Extra refund, contributions tax, net to super, interest cost, **net benefit**.

### Section 8: Offset Rebuild Timeline

Month-by-month table for all three scenarios. State crossover month clearly. Omit this section if no non-deductible loan.

### Section 9: Confidence Scores

Overall score and per-input breakdown. Name the shakiest input explicitly.

### Section 10: Assumptions & Action Checklist

All assumptions made. Then a numbered action list: specific dollar amounts, fund names, account numbers, deadlines.

---

## Confidence Scoring

| Source                                  | Score |
| --------------------------------------- | ----- |
| Current payslip (this FY)               | 95%   |
| Reconciled ledger journal (this FY)     | 90%   |
| Ledger YTD not yet at EOFY (<10 months) | 85%   |
| Annualised from YTD (extrapolated)      | 78%   |
| Prior year filed tax return             | 80%   |
| Manually entered by user                | 85%   |
| Estimate based on prior year            | 65%   |
| Agent inferred (no user confirmation)   | 60%   |

**Overall confidence = weighted average of all input scores, weighted by their proportional contribution to the final refund figure.**

Report format:

> _Overall confidence: XX% — result is reliable to ±$X,XXX. Weakest input: [name] at XX% confidence because [one sentence reason]._

---

## PHI Rebate Tier Impact (Bonus Calculation)

If `phi_person_a` is true (private hospital cover confirmed):

1. MLS = $0 for that person (already accounted for in tax calc)
2. Check whether the super contribution changes their PHI rebate tier

PHI rebate tiers are based on income for surcharge purposes. If a contribution crosses a tier boundary, calculate the additional rebate unlocked. See `references/australian-tax-framework.md` for tier thresholds and rebate percentages.

---

## Compliance Notices — Always Include

1. **Notice of Intent to Claim a Deduction** must be lodged with the super fund **before** lodging the tax return. This is the single most important procedural step. Missing it forfeits the entire deduction.
2. Personal contributions are after-tax by default. The ATO treats them as non-concessional unless you actively lodge the Notice of Intent and receive acknowledgement.
3. Concessional contributions are taxed at 15% inside the fund (or 30% if Division 293 applies). This is already factored into the net benefit figure.
4. Carry-forward caps: unused cap from FY2020-21 expires **30 June 2026**. If near this date, check ATO MyGov urgently — this cap is permanently lost if unused.
5. Super balance must have been below $500,000 on 30 June of the prior year to use carry-forward caps.
6. This analysis is a planning estimate. Verify with a registered tax agent before acting.

---

## Reference Files

| File                                                 | Contents                                                                                                                                              | When to read                                                                 |
| ---------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------- |
| `references/australian-tax-framework.md`             | Tax brackets, LITO schedule, Medicare/MLS thresholds, PHI rebate tiers, super rules, Div 293, depreciation rules. Update at the start of each new FY. | Always — read at Step 3                                                      |
| `references/ledger-reading-guide.md`                 | Generic guide to adapting ledger account paths for beancount/hledger users                                                                            | Only if `has_ledger` = true — read at Step 1                                 |
| `references/offset-account-and-home-loan-linking.md` | Template for documenting which offset accounts link to which loans, and how to recalculate the hurdle rate                                            | Only if `has_ledger` = true and non-deductible loan exists — read at Step 1d |
| `references/home-loans-info.md`                      | Template for documenting loan details: balances, rates, types, deductibility                                                                          | Only if `has_ledger` = true — read at Step 1c                                |
