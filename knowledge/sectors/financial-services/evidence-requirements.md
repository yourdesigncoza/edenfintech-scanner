# Financial Services -- Evidence Requirements

Maps PCS Q1-Q5 to sector-specific evidence. For each question, specifies WHERE to find the data.

## Q1: Is risk primarily operational (modelable)?

### What to Check

Financial Services sub-sectors divide into:
- **Yes (operational risk dominates):** Payment processors, insurance brokers, financial data/exchanges, asset managers
- **No (financial/regulatory/credit risk dominates):** Banks, credit issuers, insurance carriers, mortgage finance

### Where to Find Evidence

| Data Point | Source | What It Tells You |
|-----------|--------|-------------------|
| Revenue composition (NII vs fees) | FMP income statement, 10-K | High NII % means credit cycle exposure (Q1 = No) |
| Provision for credit losses trend | FMP income statement (provisionForCreditLosses) | Rising provisions signal credit risk dominance |
| Combined ratio (insurers) | Earnings releases, 10-K | Underwriting discipline = operational; catastrophe exposure = financial |
| Take rate trend (processors) | Calculate: revenue / TPV from 10-K | Stable = operational competition; declining = structural disruption |
| CET1 vs requirement (banks) | FMP Key Metrics, 10-K Item 8, Fed Y-9C | Thin buffer = regulatory risk dominates |
| Active consent orders | OCC (occ.gov/enforcement-actions), FDIC, Fed databases | Consent order = regulatory risk, not operational |

### Decision Rule
If >50% of risk exposure comes from credit cycle, regulatory discretion, or capital adequacy, answer Q1 = No.

## Q2: Is regulatory discretion minimal?

### What to Check

Regulatory discretion ranges from minimal (insurance brokers, data companies) to extreme (banks under consent orders, CFPB-targeted companies).

### Where to Find Evidence

| Data Point | Source | What It Tells You |
|-----------|--------|-------------------|
| Active enforcement actions | OCC, FDIC, CFPB, SEC enforcement databases (see regulation.md for URLs) | Active actions = discretion is HIGH |
| Stress test results (banks) | Fed website (annual June release) | Severely adverse CET1 projection near minimum = high discretion |
| CFPB supervisory actions | consumerfinance.gov/enforcement/ | Pending CFPB actions (late fee cap, open banking) |
| DOJ antitrust actions | DOJ press releases, PACER | Active DOJ suit (Visa antitrust 2024) |
| State insurance regulatory actions | State insurance commissioner websites, NAIC | Rate filing disputes, surplus concerns |
| Consent order / MOU status | Publicly available via regulator databases | MOU = non-public but inferred from 10-K risk factors |

### Sub-Sector Default Answers

| Sub-Sector | Default Q2 Answer | Override Conditions |
|-----------|-------------------|-------------------|
| Diversified Banks | No | Unless clean regulatory record for 5+ years |
| Regional Banks | No | Especially post-2023 regulatory expansion |
| Credit Services | No | CFPB + DOJ antitrust active |
| Capital Markets | No (bank-affiliated), Yes (asset-light) | Active SEC investigation flips to No |
| Financial Data & Exchanges | Mostly Yes | Unless rating agency reform pending |
| Asset Management | Mostly Yes | DOL fiduciary rule uncertainty |
| Mortgage Finance | No | CFPB mortgage rules, GSE requirements |
| Insurance - All | Mostly Yes | State-based regulation is rules-based, not discretionary |
| Insurance Brokers | Yes | Minimal federal oversight |

## Q3: Are there historical precedents?

### What to Check

Turnaround precedents exist for most Financial Services sub-sectors. The analyst should match the distress type (credit, liquidity, regulatory, competitive) to the closest precedent.

### Where to Find Evidence

| Data Point | Source | What It Tells You |
|-----------|--------|-------------------|
| Sub-sector turnaround table | This sector knowledge: sub-sectors/{sub-sector}.md -> Turnaround Precedents section | Named precedents with timelines and outcomes |
| FDIC failed bank list | fdic.gov/bank-failures/ | Historical bank failure patterns and resolution methods |
| Insurance insolvency database | NAIC guaranty association data | Historical insurance failures |
| SEC enforcement outcomes | sec.gov/litigation/ | How similar cases were resolved |
| Company-specific recovery history | 10-K Item 7 (MD&A), prior annual reports | Management's own narrative of past challenges |

### Precedent Strength by Sub-Sector

| Sub-Sector | Precedent Strength | Key Precedents |
|-----------|-------------------|----------------|
| Diversified Banks | Strong | Citigroup 2008-2013, BAC 2008-2014, WFC 2016-present |
| Regional Banks | Strong | Synovus, Zions, KeyCorp (credit); SVB, FRC (liquidity -- failures) |
| Credit Services | Strong | AXP 1990s, COF 2008-2012, PYPL 2022-present, DFS 2023-2024 |
| Capital Markets | Strong | MS 2008-2012, GS 2011-2016, SCHW 2022-2024 |
| Financial Data & Exchanges | Moderate | Moody's 2008-2012 (only relevant case) |
| Asset Management | Moderate | Franklin Templeton, Invesco (partial recoveries) |
| Mortgage Finance | Weak | Countrywide (failure), loanDepot (ongoing) |
| Insurance - Diversified | Moderate | AIG 2008-2018, Hartford 2008-2013 |
| Insurance - Life | Strong | MetLife, Hartford, Lincoln National (all recovered) |
| Insurance - P&C | Moderate | Allstate, AIG P&C (recovered); Reliance (failure) |
| Insurance Brokers | Moderate | Marsh McLennan 2004-2008 (Spitzer) |
| Investment Banking | Weak (for independents) | See Capital Markets for bank-affiliated |

## Q4: Is outcome non-binary?

### What to Check

Binary risk is the key differentiator between investable and uninvestable distressed financial stocks.

### Where to Find Evidence

| Data Point | Source | What It Tells You |
|-----------|--------|-------------------|
| Uninsured deposit % (banks) | 10-K, FDIC Call Reports | >60% shifts toward binary (bank run possible) |
| CET1 stress test projection | Fed stress test results | Severely adverse CET1 <4.5% = binary risk |
| Active criminal investigation | DOJ press releases, 10-K risk factors | Criminal charges are binary |
| Single-product dependency | 10-K revenue breakdown | Loss of one product/partner can be binary |
| Reinsurance coverage adequacy (insurers) | 10-K Item 8, reinsurance disclosures | Inadequate reinsurance = catastrophe risk is binary |
| Warehouse line availability (mortgage) | 10-K Item 7, liquidity disclosures | Line termination is binary for mortgage companies |

### Sub-Sector Default Answers

| Sub-Sector | Default Q4 Answer | Binary Triggers |
|-----------|-------------------|-----------------|
| Diversified Banks | Yes (TBTF backstop) | Rare: only if government declines intervention |
| Regional Banks | Mixed | Bank run is binary; credit stress is gradient |
| Credit Services | Yes (mostly) | Except: complete loss of network access, regulatory shutdown |
| Capital Markets | Yes (post-Dodd-Frank) | Trading blowup can still be binary |
| Financial Data & Exchanges | Yes | Highly gradient outcomes |
| Asset Management | Yes | Gradient: outflows are slow, not sudden |
| Mortgage Finance | Mixed | Warehouse line termination is binary |
| Insurance | Yes (mostly) | Except: massive unhedged catastrophe or reserve blow-up |
| Insurance Brokers | Yes | Extremely gradient |

## Q5: Is macro/geopolitical exposure limited?

### What to Check

Most Financial Services sub-sectors have significant macro exposure.

### Where to Find Evidence

| Data Point | Source | What It Tells You |
|-----------|--------|-------------------|
| NII sensitivity disclosure | 10-K Item 7A (banks) | Quantified rate impact on earnings |
| NCO/delinquency trend | FMP income statement, 10-K | Credit cycle position |
| Consumer spending indicators | Fed consumer credit data, retail sales | Payment volume drivers |
| CRE vacancy rates | CoStar, CBRE reports, 10-K | Office/retail CRE exposure |
| Unemployment rate | BLS data | Drives consumer and small business defaults |
| Yield curve shape | Fred (Federal Reserve Economic Data) | Inverted curve compresses bank NIM |
| Housing market indicators | Case-Shiller, MBA origination data | Mortgage volume driver |
| Global trade data (for cross-border payments) | V/MA cross-border volume disclosures | International payment sensitivity |

### Sub-Sector Macro Exposure

| Sub-Sector | Q5 Default | Dominant Macro Factors |
|-----------|-----------|----------------------|
| Diversified Banks | No | Rates, credit cycle, unemployment |
| Regional Banks | No | Rates, CRE, local economy |
| Credit Services (networks) | Mostly Yes | Consumer spending (moderate) |
| Credit Services (issuers) | No | Rates, credit cycle, unemployment |
| Credit Services (processors) | Mostly Yes | Consumer spending (moderate) |
| Capital Markets | No | Deal volumes, market conditions |
| Financial Data & Exchanges | Mostly Yes | Trading volumes (moderate) |
| Asset Management | No | Market returns drive AUM |
| Mortgage Finance | No | Mortgage rates, housing cycle |
| Insurance - P&C | Mostly Yes | Climate (emerging), not traditional macro |
| Insurance - Life | No | Interest rates dominate |
| Insurance Brokers | Yes | Minimal macro exposure |
| Investment Banking | No | Deal volumes, market conditions |
