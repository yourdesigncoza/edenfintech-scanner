# Consumer Discretionary -- Evidence Requirements

Maps PCS Q1-Q5 to sector-specific evidence sources. For each question, specifies WHERE to find the data (not just WHAT to check).

## Q1: Is risk primarily operational (modelable)?

### What to Assess

Whether the stock's dominant risk is internal execution (modelable) or external factors (regulatory, macro, geopolitical) that management cannot control.

### Sub-Sector Evidence Map

| Sub-sector | Risk Type | Key Evidence | Where to Find It |
|------------|-----------|-------------|-----------------|
| Auto Parts (OEM) | Cyclical + Operational | OEM production volumes, customer concentration, EV transition exposure | 10-K Item 1 (customer disclosure), FMP metrics (revenue trend), IHS Markit production forecasts (public summaries) |
| Auto Parts (Aftermarket) | Operational | Same-store sales, inventory management, supply chain | FMP metrics (revenue, inventory), 10-Q earnings releases |
| Auto Manufacturers | Cyclical | Unit volumes, ATP trends, EV mix | 10-K Item 7 MD&A, monthly sales reports (public), FMP profile |
| Restaurants | Operational | Same-store sales, restaurant-level margins, franchisee health | 10-Q earnings releases, FMP metrics |
| Gambling/Casinos | Regulatory | Gaming license status, AML compliance | State gaming commission reports (public), 10-K Item 1A |
| Residential Construction | Cyclical | Housing starts, order trends, mortgage rates | Census Bureau housing data, 10-Q earnings, FMP metrics |
| Apparel | Operational | Brand health, channel mix, inventory levels | 10-Q earnings, FMP metrics (inventory turns), NPD/Circana data |
| Department Stores | Operational (secular) | Traffic trends, e-commerce growth, store closures | 10-Q earnings, FMP metrics |
| Travel/Lodging | Cyclical | RevPAR, occupancy, booking trends | STR data (public summaries), 10-Q earnings, FMP metrics |

### Red Flags

- If dominant risk is regulatory (gaming, education) or macro (auto OEM, homebuilders), Q1 answer is "No"
- If dominant risk is operational execution (restaurants, apparel retail), Q1 answer is "Yes"

## Q2: Is regulatory discretion minimal?

### What to Assess

Whether outcomes depend on discretionary regulatory action vs. rules-based compliance.

### Sub-Sector Evidence Map

| Sub-sector | Discretion Level | Key Regulators | Where to Find Evidence |
|------------|-----------------|----------------|----------------------|
| Auto Parts | Moderate | NHTSA (recalls), EPA (emissions), USTR (tariffs) | NHTSA.gov recalls database, Federal Register for tariff notices, 10-K Item 1A |
| Gambling/Casinos | High | State gaming commissions | Individual state gaming commission websites, 10-K Item 1A, 10-K Item 8 (contingencies) |
| Restaurants | Moderate | State/local health departments, DOL (labor) | Local health inspection databases, 10-K Item 1A |
| Education Services | High | DOE (Title IV, gainful employment) | ED.gov regulatory actions, 10-K Item 1A, Federal Register |
| Personal Products | Moderate | FDA (MoCRA 2022) | FDA.gov cosmetics enforcement, 10-K Item 1A |
| Apparel | Minimal | FTC (labeling), CBP (import duties) | FTC.gov enforcement actions, CBP.gov |
| Home Improvement | Minimal | No significant discretionary regulators | N/A |
| Residential Construction | Moderate | Local zoning boards, EPA | Local government records, 10-K Item 1A |

### Red Flags

- Gaming companies: Always check for active investigations/consent orders before answering "Yes"
- Education companies: DOE enforcement actions can be existential -- check Federal Register
- Auto parts: NHTSA recall investigations are searchable at NHTSA.gov/recalls

## Q3: Are there historical precedents?

### What to Assess

Whether similar turnarounds have played out before in this sub-sector.

### Where to Find Turnaround History

| Source | What It Provides | How to Access |
|--------|-----------------|---------------|
| `knowledge/sectors/consumer-cyclical/sub-sectors/*.md` | Turnaround precedent tables per sub-sector | Read directly from knowledge files |
| `knowledge/sectors/consumer-cyclical/precedents.md` | Cross-sector precedent compilation | Read directly |
| SEC EDGAR 10-K filings | Historical financials during distress/recovery periods | SEC.gov EDGAR full-text search |
| Gemini Grounded Search | Company-specific distress history with citations | `bash scripts/gemini-search.sh ask "[company] turnaround history"` |
| FMP historical data | 5-year financial trend during recovery | `bash scripts/fmp-api.sh income/balance/cashflow [TICKER]` |

### Evidence Quality Checklist

- Named company with specific dates
- Quantified distress metrics (revenue decline %, debt level, FCF)
- Documented recovery actions
- Stock outcome with timeline
- If no precedents exist for a niche sub-sector: mark CONFIRMED_ABSENCE, default base rate 50%

## Q4: Is outcome non-binary?

### What to Assess

Whether gradient outcomes are possible (partial recovery, managed decline) or if the situation is pass/fail.

### Binary Risk Indicators by Sub-Sector

| Sub-sector | Binary Triggers | Gradient Outcomes Typical? |
|------------|----------------|--------------------------|
| Auto Parts (OEM) | Covenant violation, OEM customer bankruptcy, Takata-scale recall | Mixed -- covenant violations are binary, margin compression is gradient |
| Auto Parts (Aftermarket) | None typical | Yes -- operational improvements show gradual results |
| Gambling/Casinos | License revocation, AML enforcement | No -- regulatory actions are binary |
| Residential Construction | GFC-scale housing collapse | Yes outside extreme scenarios |
| Restaurants | Systemic food safety crisis | Yes -- operational turnarounds are gradient |
| Apparel Retail | Lease covenant violation + brand death | Yes for brands with some consumer relevance |
| Department Stores | Liquidity crisis | Yes (managed decline is a valid outcome) |
| Cruise Lines | Pandemic-level shutdown | Mixed -- debt levels create binary outcomes |
| Education | Title IV funding loss | No -- funding loss is binary |

### Where to Find Binary Risk Data

- **Debt covenants:** 10-K Item 8 Notes to Financial Statements (debt footnotes). Check covenant compliance tables.
- **Regulatory actions:** NHTSA.gov, state gaming commission websites, ED.gov
- **Recall exposure:** 10-K Item 8 contingent liabilities, NHTSA.gov/recalls
- **Liquidity position:** FMP metrics (current ratio, quick ratio), 10-K cash and debt maturity schedule

## Q5: Is macro/geopolitical exposure limited?

### What to Assess

Whether the thesis depends primarily on domestic, company-specific factors or is materially exposed to macro, FX, or geopolitical risk.

### Macro Factor Sensitivity by Sub-Sector

| Sub-sector | Interest Rates | Consumer Confidence | Trade/Tariffs | Geopolitical | Currency |
|------------|---------------|-------------------|---------------|-------------|----------|
| Auto Parts (OEM) | High | High | High | Moderate | Moderate |
| Auto Parts (Aftermarket) | Moderate (inverse) | Moderate | Moderate | Low | Low |
| Auto Manufacturers | Extreme | High | High | High (supply chains) | High |
| Residential Construction | Extreme | High | Low | Low | Low |
| Home Improvement | Moderate | Moderate | Moderate | Low | Low |
| Gambling/Casinos | Moderate | High | Low | High (Macau) | High (Macau) |
| Travel/Cruise | High | High | Low | High (terrorism, pandemic) | Moderate |
| Apparel/Retail | Low | Moderate | High (China sourcing) | Moderate | Moderate |
| Restaurants (QSR) | Low | Low | Low | Low | Moderate (international) |

### Where to Find Macro Exposure Data

| Macro Factor | Data Source | Access |
|-------------|-----------|--------|
| Interest rate sensitivity | 10-K Item 7A (Quantitative Market Risk), FMP metrics | Direct read |
| Tariff exposure | 10-K Item 1A Risk Factors, USTR tariff schedules | SEC.gov, USTR.gov |
| Geographic revenue split | 10-K Item 1 or Segment reporting (Item 8) | SEC.gov |
| Currency exposure | 10-K Item 7A, FMP profile (country of domicile) | Direct read |
| Consumer confidence correlation | FRED database (consumer sentiment + company revenue) | fred.stlouisfed.org |
| Housing data | Census Bureau new residential construction | census.gov/construction |
| Vehicle production forecasts | IHS Markit / S&P Global Mobility (public summaries) | Public press releases |
| Fleet age data | AAIA / Hedges & Company annual vehicle reports | hedgescompany.com |
