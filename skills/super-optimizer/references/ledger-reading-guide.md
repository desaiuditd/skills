# Ledger Reading Guide — Generic Template

**Only relevant if `has_ledger` = true (user has a beancount or hledger ledger).**

This file is a template. Ask the user for their specific account names and paths before querying.
Do not assume any particular account structure — ask if in doubt.

---

## How to Use This Guide

Before running any queries in Step 1, confirm the following with the user:

> "To read your ledger accurately, I need to know your account naming structure. Can you tell me (or show me) how your accounts are named for: salary income, rental income, loan interest, and savings/offset accounts?"

If the user is unsure, ask them to run:

```bash
hledger accounts   # hledger
bean-query main.bean 'SELECT DISTINCT account ORDER BY account'   # beancount
```

and share the output. From that list, identify the patterns below.

---

## Account Patterns to Identify

Fill these in once the user confirms their structure:

| Variable                        | Example pattern                                                      | Description                                                |
| ------------------------------- | -------------------------------------------------------------------- | ---------------------------------------------------------- |
| `{person_a_salary_pattern}`     | `Income:{person_a}:salary`                                           | Salary/wages for person A                                  |
| `{person_b_salary_pattern}`     | `Income:{person_b}:salary`                                           | Salary/wages for person B (if applicable)                  |
| `{rental_income_pattern}`       | `Income:property:{investment_property}`                              | Gross rental income                                        |
| `{rental_expense_pattern}`      | `Expenses:property:{investment_property}`                            | Operating expenses for the investment property             |
| `{investment_interest_pattern}` | `Expenses:property:{investment_property}:interest`                   | Deductible investment loan interest                        |
| `{build_interest_pattern}`      | `Expenses:property:{build_property}:build-interest`                  | Build loan interest (if applicable, deductible once drawn) |
| `{non_deductible_loan_pattern}` | `Liabilities:property:{lender}:{non_deductible_property}`            | Non-deductible home loan balance                           |
| `{offset_account_pattern}`      | `Assets:{person_a}:{bank}:offset\|Assets:{person_b}:{bank}:checking` | All offset accounts (pipe-separated for OR match)          |
| `{person_a_interest_pattern}`   | `Income:{person_a}:.+:interest`                                      | All interest income for person A (savings, TDs, etc.)      |
| `{person_b_interest_pattern}`   | `Income:{person_b}:.+:interest`                                      | All interest income for person B                           |

---

## File Structure Conventions

Different ledger setups use different conventions. Common patterns:

### Single flat file

```
ledger.bean  (or main.bean / all.journal)
```

### Per-account directories

```
import/{person_a}/{bank}/{account-name}/
import/{person_b}/{bank}/{account-name}/
```

### Financial year directories

Many Australian ledgers use the calendar year of FY end:

| Financial Year | Directory |
| -------------- | --------- |
| FY2024-25      | `2025/`   |
| FY2025-26      | `2026/`   |

Monthly files within each year directory:

| File suffix | Month     |
| ----------- | --------- |
| 01          | July      |
| 02          | August    |
| 03          | September |
| ...         | ...       |
| 12          | June      |

Ask the user to confirm their ledger's root path and structure if not obvious.

---

## Journal Entry Format (beancount / hledger)

Standard double-entry format:

```journal
YYYY-MM-DD Description
    Account:path:here        amount AUD
    Account:path:here       -amount AUD
```

In hledger, a `= {balance}` after the amount is a running balance assertion — useful for confirming the account balance after each transaction.

---

## BQL Query Patterns (beancount)

Replace `{pattern}` with the user's actual account patterns from the table above.

### Salary income YTD

```sql
SELECT account, sum(position)
WHERE account ~ '{person_a_salary_pattern}' AND year = {fy_end_year}
```

### Rental income and expenses YTD

```sql
SELECT account, sum(position)
WHERE account ~ '{rental_income_pattern}' AND year = {fy_end_year}

SELECT account, sum(position)
WHERE account ~ '{rental_expense_pattern}' AND year = {fy_end_year}
```

### Investment loan interest YTD

```sql
SELECT account, sum(position)
WHERE account ~ '{investment_interest_pattern}' AND year = {fy_end_year}
```

### Offset and loan balances (point in time)

```sql
SELECT account, sum(position)
WHERE account ~ '{offset_account_pattern}'

SELECT account, sum(position)
WHERE account ~ '{non_deductible_loan_pattern}'
```

### Monthly savings rate (last 3 complete months)

```sql
SELECT YEAR(date) AS year, MONTH(date) AS month, units(sum(position)) AS net_monthly_flow
WHERE account ~ '{offset_account_pattern}'
  AND date >= {3_months_ago}
  AND date <= {last_complete_month_end}
GROUP BY 1, 2
ORDER BY 1, 2;
```

### Interest income YTD

```sql
SELECT account, sum(position)
WHERE account ~ '{person_a_interest_pattern}' AND year = {fy_end_year}

SELECT account, sum(position)
WHERE account ~ '{person_b_interest_pattern}' AND year = {fy_end_year}
```

---

## hledger Query Patterns

If the user has an hledger ledger instead of beancount:

```bash
# Salary income YTD
hledger bal '{person_a_salary_pattern}' --begin {fy_start_date} --end {today}

# Rental income and expenses
hledger bal '{rental_income_pattern}' --begin {fy_start_date} --end {today}
hledger bal '{rental_expense_pattern}' --begin {fy_start_date} --end {today}

# Monthly net flow through offset accounts
hledger bal '{offset_account_pattern}' --begin {3_months_ago} --end {today} --monthly
```

---

## Precedence Rule

**Payslip beats ledger.** Use the payslip as the authoritative source for salary and PAYG withheld. Use the ledger to cross-check and to catch income streams not on the payslip (bonuses, investment income, reimbursements).

If ledger and payslip disagree on salary by more than $500, flag the discrepancy and ask the user to confirm which is correct.
