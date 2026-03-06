# Consumer Staples — Evidence Requirements

Maps PCS Q1-Q5 to sector-specific evidence. For each question, specifies WHAT to check and WHERE to find it.

## Q1: Is Risk Primarily Operational? (Modelable)

### What Makes Risk Operational in Consumer Staples
Operational risk = brand management, cost control, M&A integration, supply chain execution. These are modelable because they depend on management decisions and competitive dynamics that have historical patterns.

### What Makes Risk Non-Operational
- **Regulatory discretion** (Tobacco FDA authority, Education DOE Title IV)
- **Litigation** (PFAS, talc mass tort)
- **Commodity price shocks** (cocoa tripling, agricultural commodity cycles)
- **Trade policy** (tariffs on Chinese goods, agricultural exports)

### Sub-Sector Risk Classification

| Sub-Sector | Primarily Operational? | Non-Operational Risks | Evidence Source |
|-----------|----------------------|----------------------|-----------------|
| Beverages - Alcoholic | Yes | Consumer boycott risk (Bud Light 2023) | 10-K risk factors, social media monitoring |
| Beverages - Non-Alcoholic | Yes | Sugar tax proposals, FX for multinationals | 10-K risk factors, FDA proposed rules |
| Beverages - Wineries/Distilleries | Mostly | Trade tariffs on exports | USTR tariff schedules, 10-K geographic data |
| Packaged Foods | Yes | FDA labeling changes (incremental) | FDA Federal Register, 10-K risk factors |
| Food Confectioners | No (during cocoa spike) | Cocoa commodity shock | ICE cocoa futures, 10-K commodity notes |
| Household & Personal Products | Mostly (large-cap), No (if PFAS/talc litigation) | Litigation, EPA chemical regulation | 10-K legal proceedings, EPA TSCA updates |
| Tobacco | No | FDA discretion, litigation | FDA.gov tobacco products, 10-K legal proceedings |
| Grocery Stores | Yes | FTC antitrust (for M&A), union strikes | FTC case filings, union contract schedules |
| Discount Stores | Mostly | Tariff policy (Chinese imports) | USTR tariff schedules, 10-K supply chain disclosure |
| Food Distribution | Yes | Pandemic-type demand shock (rare) | Restaurant industry data, 10-K customer concentration |
| Agricultural Farm Products | No | Commodity cycles, trade policy, accounting fraud | USDA WASDE, 10-K SEC investigations |
| Education | No | DOE regulatory action, AI disruption | DOE compliance reports, 10-K accreditation status |

### WHERE to Find Operational Risk Data

| Data Point | Source | Access |
|-----------|--------|--------|
| Operating margin trends | FMP Ratios endpoint | `bash scripts/fmp-api.sh ratios TICKER` |
| Revenue growth decomposition | 10-K MD&A section | SEC EDGAR (10-K Item 7) |
| SG&A efficiency | FMP Income Statement | `bash scripts/fmp-api.sh income TICKER` |
| Working capital cycle | FMP Balance Sheet + Cash Flow | `bash scripts/fmp-api.sh balance TICKER` and `cashflow TICKER` |
| Management quality indicators | 10-K proxy statement (DEF 14A) | SEC EDGAR |
| Competitive position | Earnings calls, industry reports | Gemini search or WebSearch |

## Q2: Is Regulatory Discretion Minimal?

### Regulatory Discretion Spectrum by Sub-Sector

| Sub-Sector | Discretion Level | Key Regulator | Binary Regulatory Risk? |
|-----------|-----------------|---------------|------------------------|
| Beverages (all) | Low-Moderate | FDA (labeling), TTB (licensing) | No — rules-based |
| Packaged Foods | Low | FDA (FSMA, labeling) | No — compliance-driven |
| Food Confectioners | Low | FDA | No |
| Household Products | Moderate | FDA, EPA, CPSC | PFAS regulation evolving — some discretion |
| Tobacco | **Extreme** | FDA CTP | **Yes** — can ban menthol, mandate nicotine reduction |
| Grocery Stores | Moderate | FDA, FTC (antitrust) | M&A-dependent companies face antitrust discretion |
| Discount Stores | Low | Standard retail regulation | No |
| Food Distribution | Low | FDA (FSMA), DOT | No |
| Agricultural Products | Moderate | USDA, EPA, CFTC | Pesticide bans possible (EPA) |
| Education | **Extreme** | DOE | **Yes** — Title IV cutoff = existential |

### WHERE to Find Regulatory Risk Data

| Data Point | Source | Access |
|-----------|--------|--------|
| FDA Warning Letters | FDA.gov enforcement database | WebSearch or Gemini search |
| FDA PMTA decisions (tobacco) | FDA.gov tobacco-products | WebSearch |
| FTC merger actions | FTC.gov cases-proceedings | WebSearch |
| DOE Title IV compliance | DOE College Scorecard | WebSearch |
| EPA PFAS actions | EPA.gov/pfas | WebSearch |
| Active regulatory investigations | 10-K Item 3 (Legal Proceedings), Item 1A (Risk Factors) | SEC EDGAR |
| Proposed federal rules | Federal Register | federalregister.gov |

## Q3: Are There Historical Precedents?

### Turnaround Precedent Strength by Sub-Sector

| Sub-Sector | Precedent Strength | Base Rate | Key Precedents |
|-----------|-------------------|-----------|----------------|
| Beverages - Alcoholic | Strong | ~100% (3/3) | SAM, TAP, STZ — but small sample |
| Beverages - Non-Alcoholic | Strong | ~67% (2/3) | KDP, SodaStream, Cott/Primo |
| Beverages - Wineries/Distilleries | Moderate | ~100% (3/3) | STZ wine, MGPI, BF.B — survivorship-biased |
| Packaged Foods | Strong | ~50% (2/4) | Hostess, CAG, KHC, THS |
| Food Confectioners | Moderate | ~67% (2/3) | HSY (2008), MDLZ, HSY (2024 — ongoing) |
| Household & Personal Products | Moderate | ~50% (2/4) | SPB, CLX, ENR, Revlon (failure) |
| Tobacco | Strong | ~67% (2/3) | VGR, PM/MO, MO/JUUL |
| Grocery Stores | Moderate | ~50% (2/4) | KR, SFM, A&P (failure), SEG (partial) |
| Discount Stores | Weak | ~25-50% (1-2/4) | DG, DLTR, 99 Cents Only (failure), BIG (failure) |
| Food Distribution | Moderate | ~67% (2/3) | SYY, PFGC, UNFI (partial) |
| Agricultural Products | Moderate | ~50% (2/4) | ADM (1995), BG, ADM (2024 — ongoing), FMC |
| Education | Moderate (but extreme variance) | ~50% (2/4) | LOPE, STRA, ITT (failure), Corinthian (failure) |

### WHERE to Find Turnaround Precedent Data

| Data Point | Source | Access |
|-----------|--------|--------|
| Historical stock price recovery | FMP price-history endpoint | `bash scripts/fmp-api.sh price-history TICKER` |
| Historical financial recovery | FMP income/balance/cashflow | `bash scripts/fmp-api.sh income TICKER` (10-year history) |
| Industry turnaround case studies | Gemini search with specific query | `bash scripts/gemini-search.sh ask "..."` |
| Bankruptcy/restructuring outcomes | SEC EDGAR (8-K filings), PACER | WebSearch |
| Sector knowledge Q6 data | Sector sub-sector files | Read from `$KNOWLEDGE_DIR/sectors/consumer-defensive/sub-sectors/` |

## Q4: Is Outcome Non-Binary?

### Binary vs. Gradient Outcomes by Sub-Sector

| Sub-Sector | Outcome Profile | Binary Triggers | Gradient Factors |
|-----------|----------------|-----------------|-----------------|
| Beverages (all) | Non-binary | Contamination (very rare) | Brand strength, volume trends, pricing |
| Packaged Foods | Non-binary | Major recall, M&A failure extreme | Private label share, brand health, margin trends |
| Food Confectioners | Non-binary | Contamination | Cocoa cost recovery, demand elasticity |
| Household Products | **Mixed** | PFAS/talc litigation | Brand health, private label, margins |
| Tobacco | **Binary elements** | FDA menthol ban, major litigation judgment | Volume decline rate, next-gen transition pace |
| Grocery Stores | Non-binary | LBO debt crisis, antitrust block | Market share, same-store-sales, margins |
| Discount Stores | Mostly non-binary | Fixed-price-point bankruptcy, tariff shock | Comps, saturation, unit economics |
| Food Distribution | Non-binary | Pandemic demand shock | Volume, margins, customer retention |
| Agricultural Products | **Mixed** | Trade embargo, accounting fraud | Commodity cycle, crush margins |
| Education | **Binary** | Title IV loss, AI disruption | Enrollment, retention, margins |

### WHERE to Find Binary Risk Data

| Data Point | Source | Access |
|-----------|--------|--------|
| FDA product ban proposals | Federal Register, FDA.gov | WebSearch |
| Active litigation case count and reserves | 10-K notes (commitments & contingencies) | SEC EDGAR |
| Accreditation status (education) | 10-K, accreditor websites | WebSearch |
| Trade policy actions | USTR.gov, Federal Register | WebSearch |
| Accounting investigations | 10-K Item 3, SEC AAER filings | SEC EDGAR |

## Q5: Is Macro/Geopolitical Exposure Limited?

### Macro Exposure Matrix by Sub-Sector

| Sub-Sector | Commodity | Trade/Tariff | FX | Consumer Income | Interest Rate | Overall |
|-----------|-----------|-------------|-----|----------------|---------------|---------|
| Beverages - Alcoholic | Moderate (barley, aluminum) | Low | Low | Low | Low | **Low** |
| Beverages - Non-Alcoholic | Moderate (sugar, PET) | Low | Moderate (multinationals) | Low | Low | **Low-Moderate** |
| Beverages - Wineries/Distilleries | Moderate (grain, glass) | High (tariffs on exports) | Moderate | Moderate (premium) | Low | **Moderate** |
| Packaged Foods | High (wheat, corn, oil, sugar) | Low-Moderate | Low-Moderate | Low-Moderate | Low | **Moderate** |
| Food Confectioners | Extreme (cocoa) | Low-Moderate | Low | Low-Moderate | Low | **High** |
| Household Products | Moderate (palm oil, chemicals) | Low-Moderate | High (multinationals) | Low-Moderate | Low | **Moderate** |
| Tobacco | Low (leaf tobacco is small % of cost) | Low | High (PM international) | Low | Moderate (yield stocks) | **Low-Moderate** |
| Grocery Stores | Moderate (food inflation) | Low | Low | Moderate (SNAP) | Low | **Moderate** |
| Discount Stores | Low (consumables) | High (Chinese imports for discretionary) | Low | Moderate | Low | **Moderate-High** |
| Food Distribution | Moderate (fuel, food inflation) | Low | Low | Moderate (restaurant spending) | Low | **Moderate** |
| Agricultural Products | Extreme (commodity prices) | Extreme (trade policy) | High (EM currencies) | Low | Moderate | **Extreme** |
| Education | Low | Low | Low | Moderate (enrollment cycles) | Moderate | **Moderate** |

### WHERE to Find Macro Exposure Data

| Data Point | Source | Access |
|-----------|--------|--------|
| Commodity cost exposure | 10-K MD&A, notes on derivatives | SEC EDGAR |
| Hedging position details | 10-K notes (financial instruments) | SEC EDGAR |
| FX impact quantification | 10-K MD&A currency discussion | SEC EDGAR |
| Trade policy exposure | 10-K risk factors, USTR tariff schedules | SEC EDGAR, WebSearch |
| Consumer spending trends | BLS Consumer Expenditure Survey, Nielsen | WebSearch, Gemini search |
| Commodity futures curves | CME Group, ICE futures | WebSearch |
| SNAP benefit changes | USDA FNS data | WebSearch |
