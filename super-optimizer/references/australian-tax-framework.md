# Australian Tax Framework Reference

**Last updated: FY2025-26**
**Update this file at the start of each new financial year.**

---

## Income Tax Brackets

### FY2025-26 (Stage 3 cuts — permanent from 1 July 2024)

| Taxable income      | Rate  | Tax on bracket                     |
| ------------------- | ----- | ---------------------------------- |
| $0 – $18,200        | 0%    | Nil                                |
| $18,201 – $45,000   | 19%   | 19c per $1 over $18,200            |
| $45,001 – $120,000  | 32.5% | $5,092 + 32.5c per $1 over $45,000 |
| $120,001 – $180,000 | 37%   | $29,467 + 37c per $1 over $120,000 |
| $180,001 +          | 45%   | $51,667 + 45c per $1 over $180,000 |

> FY2024-25 brackets are identical — Stage 3 cuts applied from 1 July 2024 and are permanent.

### Quick tax computation formula

```text
if income <= 18200:     tax = 0
elif income <= 45000:   tax = (income - 18200) * 0.19
elif income <= 120000:  tax = 5092 + (income - 45000) * 0.325
elif income <= 180000:  tax = 29467 + (income - 120000) * 0.37
else:                   tax = 51667 + (income - 180000) * 0.45
```

---

## Low Income Tax Offset (LITO)

LITO reduces the tax payable for lower-income earners. It phases out in two steps.

| Taxable income    | LITO amount                           |
| ----------------- | ------------------------------------- |
| ≤ $37,500         | **$700** (maximum)                    |
| $37,501 – $45,000 | $700 − (income − $37,500) × 0.05      |
| $45,001 – $66,667 | residual − (income − $45,000) × 0.015 |
| > $66,667         | **$0**                                |

At $45,000 exactly: LITO = $700 − $375 = **$325**
At $66,667: LITO = $325 − $325 = **$0**

**Zone analysis implication:** Each dollar contributed into the $37,500–$45,000 band saves an effective **5% extra** (restored LITO clawback) on top of the 19% bracket rate — total effective rate 24%, net saving rate **11%** after 15% contributions tax.

```python
def lito(income):
    if income <= 37500:
        return 700
    elif income <= 45000:
        return max(0, 700 - (income - 37500) * 0.05)
    elif income <= 66667:
        residual_at_45k = 700 - (45000 - 37500) * 0.05  # = 325
        return max(0, residual_at_45k - (income - 45000) * 0.015)
    else:
        return 0
```

---

## Medicare Levy

- **Rate:** 2.0% of taxable income (standard)
- **Shade-in threshold:** Below $26,000 (singles) the levy shades in at 10c per dollar.
- Medicare levy is applied on top of income tax for most Australians.

---

## Medicare Levy Surcharge (MLS)

MLS is an **additional charge** for high-income earners who do NOT hold private hospital cover. If a person holds private hospital insurance: **MLS = $0 for that person.**

If PHI status is not confirmed, apply MLS using the thresholds below.

### Singles thresholds FY2025-26

| Individual income for surcharge | MLS rate |
| ------------------------------- | -------- |
| ≤ $93,000                       | 0%       |
| $93,001 – $108,000              | 1.0%     |
| $108,001 – $144,000             | 1.25%    |
| $144,001 – $186,000             | 1.5%     |
| > $186,000                      | 2.0%     |

### Family thresholds FY2025-26

| Combined family income | MLS rate per person |
| ---------------------- | ------------------- |
| ≤ $186,000             | 0%                  |
| $186,001 – $216,000    | 1.0%                |
| $216,001 – $280,000    | 1.25%               |
| > $280,000             | 1.5%                |

**Note:** An individual in a family is only liable for MLS if their own income exceeds the singles threshold. A lower-income partner below $93k never pays MLS regardless of the other person's income.

**Income for surcharge purposes (ISP)** includes taxable income + reportable employer super contributions + reportable fringe benefits + total net investment losses. For simplicity, use taxable income as a proxy unless the person is close to a threshold.

---

## Private Health Insurance (PHI) Rebate Tiers

The government rebate on PHI premiums is income-tested. A super contribution that lowers income can move a person to a higher rebate tier, unlocking a small additional benefit.

### FY2025-26 rebate rates (age < 65)

| Singles ISP         | Family ISP          | Rebate rate          |
| ------------------- | ------------------- | -------------------- |
| ≤ $93,000           | ≤ $186,000          | **24.608%** (Base)   |
| $93,001 – $108,000  | $186,001 – $216,000 | **16.405%** (Tier 1) |
| $108,001 – $144,000 | $216,001 – $280,000 | **8.202%** (Tier 2)  |
| > $144,000          | > $280,000          | **0%** (Tier 3)      |

> PHI rebate percentages are indexed annually. Check ATO website at the start of each FY:
> <https://www.ato.gov.au/individuals-and-families/medicare-and-private-health-insurance/private-health-insurance-rebate/private-health-insurance-rebate-percentage>

**Practical check:** If a person's ISP crosses from Tier 3 (0%) to Tier 2 (8.202%) due to the super contribution, calculate: `annual_premium × 8.202%` to quantify the bonus rebate. It's typically $200–$400 — small but free.

---

## Concessional Super Contribution Rules

### Annual Concessional Cap

| Financial Year | Cap     |
| -------------- | ------- |
| FY2020-21      | $25,000 |
| FY2021-22      | $27,500 |
| FY2022-23      | $27,500 |
| FY2023-24      | $27,500 |
| FY2024-25      | $30,000 |
| FY2025-26      | $30,000 |
| FY2026-27      | $32,500 |

The cap includes employer SG contributions. Personal contributions = cap − employer SG (annualised).

### Carry-Forward Unused Caps

Allows using unused portions of prior year caps, subject to two conditions:

1. Super balance was **below $500,000** on 30 June of the immediately preceding year
2. Unused cap is within the **5-year carry-forward window**

| Unused cap from | Expires (5-year limit) |
| --------------- | ---------------------- |
| FY2020-21       | **30 June 2026** ⚠️    |
| FY2021-22       | 30 June 2027           |
| FY2022-23       | 30 June 2028           |
| FY2023-24       | 30 June 2029           |
| FY2024-25       | 30 June 2030           |

**Carry-forward from ATO:** Log in to ATO MyGov → My Super → Unused concessional contributions. This is the authoritative source. If the user cannot access it, estimate based on prior year SG data and flag as INFERRED.

---

## Division 293 Tax

An additional 15% tax on concessional contributions applies to individuals with income for surcharge purposes (ISP) above $250,000.

- ISP = taxable income + concessional contributions (employer SG + personal)
- The extra 15% applies only to contributions that pushed ISP above $250,000
- Net saving rate for contributions above the threshold is 15% lower (e.g., 37% bracket: 24% → 9%)
- ATO assesses Division 293 and sends a separate assessment — it is not withheld by the fund

---

## Superannuation Guarantee (SG) Rate

| FY         | SG rate |
| ---------- | ------- |
| FY2024-25  | 11.5%   |
| FY2025-26  | 12.0%   |
| FY2026-27+ | 12.0%   |

SG contributions count toward the concessional cap. Annualise YTD SG from the payslip.

---

## Depreciation — Investment Property

### Diminishing Value (DV) Method — Plant & Equipment (Div 40)

- **Election:** Made in Year 1 when first claiming depreciation. Irrevocable.
- **Verification:** Check prior year tax return — the Div 40 amount claimed should match the depreciation schedule's Year 1 DV figure exactly.
- **Year-on-year:** Each year the depreciable value reduces, so Div 40 claims decline over time.
- **Year 1 applies proportionally:** Only the days of ownership in the first year count.

### Capital Works (Div 43)

- **Rate:** 2.5% per year on construction cost (for residential property built after 16 September 1987)
- **Constant:** Unlike Div 40, the Div 43 amount is the same every year for 40 years (it does not diminish)
- **Year 1 applies proportionally:** Prorated by days of ownership in first year
- **Full years 2–40:** Fixed annual amount

### Key Depreciation Schedule Fields

The depreciation schedule (from a quantity surveyor/BMT/Koste or equivalent) will show:

- Year 1 totals (prorated to days owned)
- Year 2 onwards: full-year amounts, separately for Div 40 DV and Div 43
- Cumulative written-down values for Div 40

When reading the report, always confirm:

1. Which depreciation method is shown (should be DV if confirmed from prior year return)
2. The "Year" numbering corresponds to year of ownership, not FY
3. Div 40 + Div 43 = total depreciation for the year

---

## Notice of Intent to Claim a Deduction

This is a procedural requirement — the most critical step and must be highlighted in every output.

- **What:** ATO form to notify the super fund that a personal (after-tax) contribution will be claimed as a tax deduction, making it a concessional contribution.
- **When:** Must be lodged with and acknowledged by the super fund BEFORE either:
    - Lodging the income tax return for that year, OR
    - Withdrawing or rolling over any amount from the fund, OR
    - The fund being wound up
- **Consequence of missing it:** The contribution is permanently treated as non-concessional (after-tax). The tax deduction is lost entirely. No remedy.
- **Fund's acknowledgement:** The fund must confirm receipt. Keep the acknowledgement letter for tax agent records.
