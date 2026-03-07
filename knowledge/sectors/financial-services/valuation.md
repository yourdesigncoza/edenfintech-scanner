# Financial Services -- Valuation Guide

## Critical Note: FCF Multiples and Financial Services

The EdenFinTech 4-input valuation model (Revenue x FCF Margin x Multiple / Shares = Target Price) was designed for operating companies with clean free cash flow. **It does NOT work for banks, insurance companies, or credit issuers** where:
- "Revenue" includes provision expense and policy liabilities
- "FCF" is distorted by regulatory capital requirements
- Operations and financing activities are structurally intertwined (deposits are both liabilities and raw materials)

### Where FCF Model Works

| Sub-Sector | FCF Model? | Baseline Multiple | Notes |
|-----------|-----------|-------------------|-------|
| Payment Processors (PYPL, SQ) | Yes | 15-20x | Clean FCF, capital-light |
| Card Networks (V, MA) | Yes | 25-35x P/E (converges with FCF) | Extremely high margins |
| Financial Data & Exchanges | Yes | 20-25x | Recurring revenue, high margins |
| Insurance Brokers | Yes | 18-22x | Capital-light, recurring |
| Asset Management (traditional) | Yes | 12-15x | But watch AUM volatility |
| Asset Management (alternatives) | Yes | 18-22x | Use FRE, not total earnings |

### Where FCF Model DOES NOT Work

| Sub-Sector | Use Instead | Typical Range |
|-----------|-------------|---------------|
| Diversified Banks | P/TBV + P/E | 1.0-2.5x TBV, 8-16x P/E |
| Regional Banks | P/TBV + P/E | 0.5-2.0x TBV, 5-13x P/E |
| Credit Issuers (COF, AXP) | P/E + P/TBV | 8-15x P/E, 1.0-2.0x TBV |
| Insurance (all types) | P/BV + Combined Ratio + P/E | 0.5-2.0x BV, 7-14x P/E |
| Mortgage Finance | P/E (normalized) + P/BV | 8-14x normalized P/E |
| Life Insurance | P/BV + Embedded Value | 0.5-1.5x BV |

### Scan Compatibility Overrides

When the screener passes a bank or insurer through the pipeline, the analyst MUST override the standard 4-input model:

**For Banks:**
1. Use PPNR (Pre-Provision Net Revenue) as the "revenue equivalent"
2. Apply P/PPNR multiple of 4-6x as the valuation input
3. Cross-check with P/TBV (must be consistent with ROTCE)
4. Note the methodology override clearly in the report

**For Insurers:**
1. Use operating earnings (ex-realized gains/losses) as the valuation input
2. Apply P/E multiple of 8-14x depending on sub-type
3. Cross-check with P/BV
4. For P&C: verify combined ratio trajectory

**For Credit Issuers:**
1. Use adjusted EPS (ex-reserve builds) for normalized earnings
2. Apply P/E multiple (8-15x depending on credit cycle position)
3. Cross-check with P/TBV for downside floor

## Valuation Approach by Sub-Sector (Detail)

### Payment Processors (PYPL, SQ, Stripe)

**FCF model applies directly.** Baseline 15-20x FCF.

Discount schedule (from valuation-guidelines.md):
- Take rate declining >20bps/yr: -3x to -5x
- Revenue growth <10%: -2x to -3x
- Active regulatory action: -2x to -3x
- Elevated SBC (>10% of revenue): -1x to -3x

Example: PayPal FCF baseline 18x. Revenue growth decelerating (-2x), competitive pressure (-2x), regulatory neutral (0). Resulting multiple: 14x. This is consistent with PYPL's current ~12-15x P/FCF trading range.

### Card Networks (V, MA)

**FCF model works but earnings-based preferred.** These are so profitable that FCF and net income nearly converge. Use P/E 25-35x.

Discount schedule:
- Antitrust settlement risk: -2x to -4x
- Cross-border volume slowdown: -1x to -2x
- Disintermediation threat (A2A payments, FedNow): -1x to -2x

### Banks (All Types)

**P/TBV is the primary anchor.** The relationship between P/TBV and ROTCE is the key valuation driver:
- ROTCE > 15%: P/TBV 1.5-2.5x
- ROTCE 10-15%: P/TBV 1.0-1.5x
- ROTCE < 10%: P/TBV <1.0x (value trap territory)

For worst-case floor: Use TBV per share as the mechanical floor. Banks in distress trade at 0.3-0.7x TBV. Total wipeout (SVB) is possible but only in bank-run scenarios.

### Insurance Companies

**P/BV with combined ratio adjustment for P&C.** Quality underwriters (Chubb, Progressive) command premium P/BV. Distressed insurers (poor reserving, catastrophe losses) trade below book.

For worst-case floor: Use statutory surplus as the minimum floor. Below statutory minimum triggers regulatory action (conservatorship).

## Cross-Reference with valuation-guidelines.md

The standard discount schedule in valuation-guidelines.md applies to FCF-eligible sub-sectors (processors, brokers, data/exchanges, asset managers). For non-FCF sub-sectors:

| Standard Discount | Financial Services Equivalent |
|-------------------|------------------------------|
| Revenue declining 2+ years: -3x to -5x | NII declining 2+ years (banks): Reduce P/TBV by 0.2-0.5x |
| Above-avg leverage: -2x to -4x | CET1 < peer median (banks): Reduce P/TBV by 0.2-0.3x |
| Regulatory risk: -2x to -3x | Active consent order: Reduce P/TBV by 0.3-0.5x |
| Secular headwind: -2x to -4x | Fee compression (asset mgmt): -3x to -5x from FCF baseline |

## TBV Cross-Check (Enhanced for Financial Services)

Per valuation-guidelines.md, the TBV cross-check is a sanity check. For Financial Services, TBV is the PRIMARY valuation anchor for banks and insurers, not just a cross-check. Special considerations:
- Banks: TBV is the floor valuation method. P/TBV <0.5x signals potential wipeout risk.
- Insurers: Statutory surplus is the relevant capital floor, not GAAP book value.
- Processors: TBV cross-check has less meaning (asset-light; TBV is small relative to market cap).
