# super-optimiser skill

## What it does

Calculates the optimal concessional super contribution for one or two people to minimise Australian income tax before EOFY (30 June).

Works with **or without** a plain-text ledger (beancount/hledger). If you don't have a ledger, it will ask for figures directly.

## How to invoke

Just ask in plain English, for example:

```
How much should I put into super this year?
```

or:

```
Is a super contribution worth it this EOFY?
```

The skill will ask a few setup questions first (names, property situation, whether you have a ledger), then collect the financial figures it needs.

## What to have ready

- Your most recent payslip (upload as a file or paste the key numbers)
- Your partner's payslip (if optimising for two people)
- Depreciation schedule from your quantity surveyor (if you own an investment property)
- Your current super balance (from your fund's app or website)
- Unused concessional cap from ATO MyGov → My Super → Unused caps (optional but improves accuracy)
- Current super fund name and account number (needed for the Notice of Intent step)

## Example one-shot prompt

```text
/super-optimiser

Udit Pay slip #file:2026-04-15 Nine Payslip.pdf
Ushma Pay slip #file:EzyMart_PaySlip_2026.04.24.pdf
Depreciation schedule for Investment Property #file:TD 35118946739 - The Prescott, 908_28 Lissner St, Toowong QLD.pdf
Udit - Ushma both has private health insurance
Udit super balance - xx,xxx.xx
Ushma super balance - xx,xxx.xx
Udit unused cap - xx,xxx.xx
Ushma unused cap - xx,xxx.xx
```

## Reference files

| File                                                 | Purpose                                                         |
| ---------------------------------------------------- | --------------------------------------------------------------- |
| `references/australian-tax-framework.md`             | Tax brackets, LITO, Medicare, MLS, super rules — update each FY |
| `references/ledger-reading-guide.md`                 | Account query patterns for beancount/hledger users              |
| `references/home-loans-info.md`                      | Template to document your loans (ledger users)                  |
| `references/offset-account-and-home-loan-linking.md` | Template to document offset account linking (ledger users)      |

## First-time setup (ledger users)

If you have a beancount or hledger ledger, fill in the reference files with your account names and loan details before the first run. The skill will guide you through this during Step -1.
