# EdenFinTech Scanner — How It Works

This document walks through the two main workflows in plain language, so you can understand exactly what happens behind the scenes when you scan for stocks or build sector knowledge.

---

## `/scan-stocks` — Finding Turnaround Candidates

Think of this as a two-stage funnel. Stage 1 ruthlessly filters out bad stocks using hard numbers. Stage 2 deeply researches the survivors to find genuine turnaround opportunities worth your money.

```
 YOU
  |
  v
/scan-stocks [optional: sector or tickers]
  |
  v
+---------------------------+
| 1. SETUP                  |
|  - Verify API key works   |
|  - Determine scan type:   |
|    Full NYSE / Sector /   |
|    Specific tickers       |
+---------------------------+
  |
  |  Specific tickers?
  |  (e.g. /scan-stocks CPS BABA)
  |---YES--> skip to Phase 2
  |
  NO (full or sector scan)
  |
  v
================================
  PHASE 1: THE FILTER
  "Thousands in, ~10 out"
================================
  |
  v
+---------------------------+
| 2. FETCH STOCK UNIVERSE   |
|  Pull all NYSE stocks     |
|  from Financial Modeling   |
|  Prep (or just one sector)|
|  Could be 1000+ stocks    |
+---------------------------+
  |
  v
+---------------------------+
| 3. BROKEN CHART CHECK     |
|  Is the stock 60%+ below  |
|  its all-time high?       |
|  If NOT broken enough,    |
|  it's not deep value      |
|  --> REJECT               |
+---------------------------+
  |
  v
+---------------------------+
| 4. INDUSTRY EXCLUSION     |
|  Is it in a permanently   |
|  declining industry?      |
|  (tobacco, coal, etc.)    |
|  --> REJECT               |
+---------------------------+
  |
  v
+---------------------------+
| 5. FIVE-CHECK FILTER      |
|  Every stock must pass     |
|  ALL five:                |
|                           |
|  [a] Solvency            |
|      Can it pay its       |
|      debts?               |
|                           |
|  [b] Dilution             |
|      Is management        |
|      printing shares and  |
|      watering down your   |
|      ownership?           |
|                           |
|  [c] Revenue trend        |
|      Is the business      |
|      shrinking too fast?  |
|                           |
|  [d] Return on capital    |
|      Has it ever earned   |
|      good returns, or is  |
|      it a permanent       |
|      money pit?           |
|                           |
|  [e] Valuation sanity     |
|      Is the price low     |
|      enough to offer      |
|      30%+ annual upside?  |
|                           |
|  Fail ANY one = REJECT    |
+---------------------------+
  |
  | ~5-15 survivors
  v
+---------------------------+
| 6. GROUP INTO CLUSTERS    |
|  Put competitors together |
|  (e.g. two auto parts     |
|  companies in one group)  |
|  1-4 stocks per cluster   |
+---------------------------+
  |
  v
================================
  PHASE 2: DEEP ANALYSIS
  "Is this a real opportunity?"
================================
  |
  v
+-----------------------------------+
| 7. PARALLEL ANALYST AGENTS        |
|  One AI analyst per cluster,      |
|  all running simultaneously.      |
|  Each analyst does:               |
|                                   |
|  [a] Competitor comparison        |
|      How does it stack up         |
|      against peers?               |
|                                   |
|  [b] Moat assessment              |
|      Does it have lasting         |
|      competitive advantages?      |
|      (brand, patents, scale)      |
|                                   |
|  [c] Management review            |
|      Is the CEO credible?         |
|      Track record? Tenure?        |
|                                   |
|  [d] Catalyst identification      |
|      What specific event will     |
|      unlock value? New product?   |
|      Cost cuts? Activist?         |
|      NO CATALYST = AUTOMATIC      |
|      REJECTION (hard rule)        |
|                                   |
|  [e] Valuation model              |
|      Revenue x Profit Margin      |
|      x Industry Multiple          |
|      / Shares Outstanding         |
|      = Target Price               |
|                                   |
|  [f] Worst-case scenario          |
|      What's the floor if          |
|      everything goes wrong?       |
|                                   |
|  [g] Decision scoring             |
|      Combines downside risk,      |
|      probability of success,      |
|      and potential return          |
+-----------------------------------+
  |
  v
+-----------------------------------+
| 8. EPISTEMIC CONFIDENCE REVIEW    |
|  A SEPARATE reviewer (never sees  |
|  the analyst's score) answers     |
|  5 questions:                     |
|                                   |
|  1. Is the risk operational       |
|     (fixable) or structural?      |
|  2. Can a regulator kill it?      |
|  3. Has this kind of turnaround   |
|     worked before?                |
|  4. Are there partial outcomes    |
|     (not all-or-nothing)?         |
|  5. Is it exposed to macro        |
|     forces beyond its control?    |
|                                   |
|  More "Yes" answers = higher      |
|  confidence = larger position     |
|  Low confidence shrinks your      |
|  bet regardless of score          |
+-----------------------------------+
  |
  v
+-----------------------------------+
| 9. CONSISTENCY & HARD RULES       |
|                                   |
|  - Valuation multiples can't be   |
|    wildly different across stocks |
|    (5x deviation = flagged)       |
|  - CAGR must be 30%+ annual       |
|  - Probability must be 60%+       |
|  - Max 12 positions in portfolio  |
|  - No single theme > 50%          |
|  - All math double-checked by     |
|    a deterministic calculator     |
|    (not the AI guessing)          |
+-----------------------------------+
  |
  v
+-----------------------------------+
| 10. FINAL RANKED REPORT           |
|                                   |
|  For each candidate:              |
|  - Score (0-100)                  |
|  - Target price & upside          |
|  - Worst-case downside            |
|  - Catalyst with timeline         |
|  - Confidence rating (1-5)        |
|  - Suggested position size        |
|  - Sensitivity table (what if     |
|    probability is different?)     |
|                                   |
|  Plus:                            |
|  - Portfolio impact analysis      |
|  - Near-miss rejections           |
|  - Methodology disclaimers        |
+-----------------------------------+
  |
  v
  Report saved to disk
  Summary shown to you
  Ready to discuss any candidate
```

### What the Score Means

The scanner boils each stock down to a single score (0-100) using three inputs:

| Input | Weight | What It Measures |
|-------|--------|-----------------|
| Downside risk | 45% | How much you could lose in the worst case |
| Probability of success | 40% | How likely is the turnaround to work? |
| Annual return (CAGR) | 15% | How fast your money grows if it works |

Higher score = better risk/reward. The score directly determines how much of your portfolio to allocate:

| Score | Position Size | Translation |
|-------|--------------|-------------|
| 75+ | 15-20% | High conviction — big bet |
| 65-74 | 10-15% | Strong case — meaningful position |
| 55-64 | 6-10% | Decent but uncertain — moderate bet |
| 45-54 | 3-6% | Speculative — small starter position |
| Below 45 | 0% | Watchlist only — don't buy yet |

### Key Safety Rails

- **No catalysts = no buy.** A cheap stock without a reason to go up stays cheap.
- **30% annual return minimum.** If the upside isn't worth the risk, pass.
- **Independent confidence check.** A separate reviewer who never sees the score grades how trustworthy the estimate is. Low confidence = smaller position no matter how good the score looks.
- **Finding nothing is a valid outcome.** The scanner won't lower its standards to give you something to buy. "No opportunities right now" is useful information.

---

## `/sector-hydrate` — Building Sector Knowledge

Before scanning a sector, you can pre-load deep knowledge about how that industry works. This makes the scan analysis significantly better because the AI analysts have real context about industry-specific metrics, valuation approaches, regulatory risks, and historical turnaround precedents.

Think of it as studying an industry before you start shopping for stocks in it.

```
 YOU
  |
  v
/sector-hydrate "Sector Name"
  (e.g. "Banking", "Healthcare",
   "Consumer Defensive")
  |
  v
+---------------------------+
| 1. PREREQUISITE CHECK     |
|  Can we reach Perplexity  |
|  (AI search engine)?      |
|  If not --> HARD STOP     |
|  (no fallback — quality   |
|   depends on cited        |
|   research, not guessing) |
+---------------------------+
  |
  v
+---------------------------+
| 2. SECTOR MATCHING        |
|  Match your input to the  |
|  official sector name     |
|  used by the data provider|
|                           |
|  "Banking" --> Financial  |
|  Services (Banks only)    |
|                           |
|  Check: was this sector   |
|  already hydrated? If so, |
|  warn before overwriting  |
+---------------------------+
  |
  v
================================
  PHASE 1: SECTOR MAPPING
  "What sub-sectors exist?"
================================
  |
  v
+-----------------------------------+
| 3. DISCOVER SUB-SECTORS           |
|                                   |
|  [a] Pull all NYSE stocks in      |
|      this sector from FMP         |
|      Extract unique industries    |
|      (e.g. Banking has:           |
|       Diversified Banks,          |
|       Regional Banks)             |
|                                   |
|  [b] Cross-reference with GICS   |
|      (the global standard for     |
|      classifying industries)      |
|      via Perplexity search        |
|                                   |
|  [c] Write a metadata file        |
|      listing all sub-sectors      |
|      to research                  |
+-----------------------------------+
  |
  v
================================
  PHASE 2: PARALLEL RESEARCH
  "Study each sub-sector deeply"
================================
  |
  v
+-------------------------------------------+
| 4. SPAWN RESEARCHER AGENTS                |
|  Multiple AI researchers run in parallel,  |
|  each studying 2-3 sub-sectors.           |
|                                           |
|  Each researcher fires 8 research queries |
|  per sub-sector through Perplexity:       |
|                                           |
|  Q1. What metrics define health in        |
|      this sub-sector?                     |
|      (e.g. banks: NPL ratio, CET1)       |
|                                           |
|  Q2. What's the standard valuation        |
|      approach?                            |
|      (e.g. banks: Price/Tangible Book,    |
|       NOT the usual cash flow method)     |
|                                           |
|  Q3. What are the key risks and           |
|      regulations?                         |
|                                           |
|  Q4. What are historical FCF margins      |
|      and typical multiples?               |
|                                           |
|  Q5. Recent M&A, activist, and            |
|      restructuring activity?              |
|                                           |
|  Q6. Historical turnaround precedents     |
|      (companies that recovered from       |
|       distress — what worked?)            |
|                                           |
|  Q7. Competitive dynamics and moat        |
|      sources in this sub-sector           |
|                                           |
|  Q8. Current macro headwinds and          |
|      tailwinds                            |
|                                           |
|  All answers come with source citations   |
|  (no made-up facts)                       |
+-------------------------------------------+
  |
  | + One dedicated regulatory researcher
  |   studying the full legal/regulatory
  |   landscape for the sector
  |
  v
================================
  PHASE 3: SYNTHESIS
  "Organize into usable files"
================================
  |
  v
+-----------------------------------+
| 5. COMPILE KNOWLEDGE FILES        |
|                                   |
|  [a] Overview                     |
|      Sector map, cross-cutting    |
|      themes, macro context        |
|                                   |
|  [b] Valuation guide              |
|      How to value each sub-sector |
|      (not all industries use the  |
|       same valuation approach!)   |
|                                   |
|  [c] Evidence requirements        |
|      For each confidence          |
|      question, WHERE to find      |
|      the data in SEC filings,     |
|      press releases, etc.         |
|                                   |
|  [d] Precedent tables             |
|      Past turnarounds: what was   |
|      broken, what fixed it, how   |
|      long it took, what returned  |
|                                   |
|  [e] Per sub-sector files         |
|      200-500 lines each with      |
|      metrics, risks, kill         |
|      factors, and benchmarks      |
|                                   |
|  [f] Regulation summary           |
|      Which agencies matter,       |
|      recent enforcement trends    |
+-----------------------------------+
  |
  v
+---------------------------+
| 6. SAVE & REGISTER        |
|  All files saved to:      |
|  knowledge/sectors/       |
|    <sector-slug>/         |
|                           |
|  Registry updated so      |
|  future scans can find    |
|  this knowledge           |
+---------------------------+
  |
  v
  Summary shown to you:
  - Sub-sectors researched
  - Files created
  - Any research gaps noted

  Ready for /scan-stocks
  in this sector
```

### Why Hydrate Before Scanning?

| Without Hydration | With Hydration |
|-------------------|----------------|
| Generic valuation (cash flow multiples for everything) | Industry-appropriate valuation (e.g. Price/Book for banks) |
| Generic confidence questions | Sector-specific evidence sources ("check CET1 ratio in 10-K Item 8") |
| No turnaround context | Real precedent tables ("Citigroup recovered in 3 years by...") |
| Guessing at regulatory risk | Mapped regulatory landscape with recent enforcement examples |
| AI may miss industry-specific red flags | Kill factors and friction factors defined per sub-sector |

Hydration is optional but strongly recommended. It takes 15-30 minutes per sector and the knowledge is reused across every future scan in that sector.

### How They Work Together

```
  FIRST TIME scanning a new sector:

  /sector-hydrate "Healthcare"
         |
         v
  [Knowledge files created]
  [~15-30 min, one-time cost]
         |
         v
  /scan-stocks Healthcare
         |
         v
  [Analysts reference sector knowledge]
  [Better valuations, smarter analysis]
         |
         v
  Ranked report with candidates


  SUBSEQUENT scans in the same sector:

  /scan-stocks Healthcare
         |
         v
  [Reuses existing knowledge]
  [No re-hydration needed]
         |
         v
  Ranked report (fresh data,
  same sector expertise)
```

---

*This scanner is a research tool, not financial advice. All qualitative assessments are AI estimates. Always verify reasoning independently before making investment decisions.*
