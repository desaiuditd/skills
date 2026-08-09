# Home Loans — Reference Template

**Only relevant if `has_ledger` = true.**

**Fill this in once during initial setup, then update whenever a loan is refinanced, repriced, or changes type.**

Interest rates are variable unless noted. Confirm current rates from your bank app or statement at the start of each skill run — rates can change without notice.

---

## How to Use This Template

Ask the user to fill in one section per loan. Only include loans that are relevant to the tax analysis:

1. **Non-deductible loans** (PPOR mortgage, vacant land, pre-construction): affect the offset rebuild timeline and opportunity cost hurdle rate.
2. **Deductible investment loans**: interest is a tax deduction; include in the taxable income model.
3. **Build loans for investment property**: deductible once drawn; check each FY.

---

## Loan Template

Copy and fill in one block per loan.

```
### Loan — {description}

| Field                   | Value                                      |
| ----------------------- | ------------------------------------------ |
| Ledger account          | {Liabilities:...}                          |
| Lender                  | {bank name}                                |
| Drawn date              | {YYYY-MM-DD}                               |
| Current principal       | ${amount}                                  |
| Loan type               | {Interest Only / Principal & Interest}     |
| Current interest rate   | {X.XX% p.a.}                               |
| Tax deductible?         | {Yes / No — reason}                        |
| Offset accounts linked? | {Yes / No — see offset-account-and-home-loan-linking.md} |
| Purpose                 | {description}                              |
| Ownership               | {Sole / Joint 50-50 / other split}         |
```

---

## Filled Example (replace with your own data)

### Loan — Non-deductible home loan

| Field                   | Value                                                |
| ----------------------- | ---------------------------------------------------- |
| Ledger account          | `Liabilities:property:{lender}:{property}:{account}` |
| Lender                  | {your bank}                                          |
| Drawn date              | {YYYY-MM-DD}                                         |
| Current principal       | ${balance — ask user or read from ledger}            |
| Loan type               | {Interest Only / P&I}                                |
| Current interest rate   | {X.XX% p.a. — confirm from bank statement}           |
| Tax deductible?         | No — property not yet income-producing               |
| Offset accounts linked? | Yes — see `offset-account-and-home-loan-linking.md`  |
| Purpose                 | {PPOR purchase / land purchase / etc.}               |
| Ownership               | {Sole / Joint}                                       |

### Loan — Investment property loan

| Field                   | Value                                                |
| ----------------------- | ---------------------------------------------------- |
| Ledger account          | `Liabilities:property:{lender}:{property}:{account}` |
| Lender                  | {your bank}                                          |
| Drawn date              | {YYYY-MM-DD}                                         |
| Current principal       | ${balance}                                           |
| Loan type               | {Interest Only / P&I}                                |
| Current interest rate   | {X.XX% p.a.}                                         |
| Tax deductible?         | Yes — investment property loan                       |
| Offset accounts linked? | {Yes / No}                                           |
| Purpose                 | Investment property purchase/refinance               |
| Ownership               | {Sole / Joint 50-50}                                 |

---

## Computing Implied Interest Rate from Ledger

If you don't have the stated rate handy, you can infer it from monthly interest charges:

```
implied_annual_rate = (monthly_interest / loan_balance) × (days_in_year / days_in_month)
```

- `days_in_month`: actual calendar days in that month (28–31)
- `days_in_year`: 365, or 366 for a leap year

This is an approximation; the stated rate from the bank is always more reliable.

---

## Annual Update Checklist

At the start of each FY or skill run:

- [ ] Confirm current interest rate for each loan (check bank app or latest statement)
- [ ] Confirm loan type has not changed (IO → P&I transitions affect deductibility analysis)
- [ ] Check whether any build loan has been drawn (first draw triggers deductibility)
- [ ] Update balances — for IO loans the principal is fixed; for P&I, reduce by repayments made
- [ ] Check whether any new loans have been taken out or existing ones refinanced
