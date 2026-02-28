# Design: Gemini Validation Fixes

Implementing 5 system improvements from Gemini's reverse-engineering validation of the consumer defensive scan.

## Source

`result/gemini-scan-validation-consumer-defensive.md` — Section 6: Critical Findings & Recommendations + Appendix.

## Problem

The scan report was arithmetically perfect but strategically flawed. SAM (Boston Beer) was a false positive due to inconsistent multiple application (22x vs 14-15x for peers) and aggressive probability scoring (70% despite 4yr volume decline). The enrichment override that skipped BRBR for SAM had no formal protocol.

## Changes

### 1. Multiple Calibration Rules (`knowledge/valuation-guidelines.md`)

Add explicit discount table under "Multiple Adjustment Factors":

```markdown
### Discount Schedule (apply cumulatively from industry baseline)

| Condition | Discount | Example |
|-----------|----------|---------|
| Revenue/volume declining 2+ consecutive years | -3x to -5x | SAM: 4yr volume decline |
| Above-average leverage (debt/equity > industry median) | -2x to -4x | BRBR: negative equity |
| Regulatory/geopolitical risk | -2x to -3x | China ADRs |
| Limited pricing power (commodity, private label pressure) | -1x to -3x | NOMD: frozen food vs private label |
| Secular industry headwind (not decline — that's Step 1 fail) | -2x to -4x | SAM: alcohol moderation trend |

Discounts are cumulative. A Consumer Staples stock (baseline 25-28x) with declining revenue (-4x) and secular headwind (-3x) starts at ~18-21x, not 22x.

### Consistency Rule

Within a single scan, no candidate's FCF multiple may deviate by more than 5x from the scan's median multiple without explicit written justification. If justification cannot be articulated in 2 sentences, the multiple is wrong.
```

### 2. Probability Guardrails (`knowledge/scoring-formulas.md`)

Add after "Hard Breakpoints" section:

```markdown
### Probability Ceilings (Override Agent Estimates)

| Condition | Max Probability | Rationale |
|-----------|----------------|-----------|
| Revenue/volume declined 3+ consecutive years | 65% | Persistent decline = structural uncertainty |
| Negative equity (not from spinoff/leverage) | 60% | Solvency risk caps confidence |
| No insider buying in trailing 12 months | -5% penalty | Insiders not backing their own thesis |
| CEO tenure < 1 year | 65% | Execution track record unproven |

These ceilings apply BEFORE scoring. If the agent's estimate exceeds the ceiling, use the ceiling value.
```

### 3. Enrichment Override Protocol (`knowledge/strategy-rules.md`)

Add new section after Step 5:

```markdown
## Step 5b: Risk Factor Enrichment Override Protocol

Risk enrichment (Massive.com 10-K data) may reveal risks not visible in financial statements. These rules govern how enrichment findings affect candidate ranking:

### Demotion Rules
A candidate MAY be demoted (moved down in ranking or to watchlist) if enrichment reveals:
- Customer concentration > 70% in 3 or fewer accounts
- Structural demand destruction (e.g., technology substitution, regulatory ban)
- Previously unidentified kill-level risk with no management mitigation plan

### Process
1. Enrichment findings are documented but scores are NOT revised
2. If a demotion trigger is found, the orchestrator adds a "DEMOTION" flag with specific reason
3. Demoted candidates are moved below non-demoted candidates of lower score
4. The next-highest non-demoted candidate fills the vacated slot
5. Demotion reason must be documented in the report's Portfolio Impact section

### What Is NOT a Demotion Trigger
- Risks already reflected in the pre-enrichment analysis
- Generic industry risks (e.g., "competition may increase")
- Risks with clear management mitigation plans disclosed in filings
```

### 4. Calculator Script (`scripts/calc-score.sh`)

New bash script that performs deterministic math:

```bash
# Usage:
#   bash scripts/calc-score.sh score <downside_pct> <probability_pct> <cagr_pct>
#   bash scripts/calc-score.sh cagr <current_price> <target_price> <years>
#   bash scripts/calc-score.sh valuation <revenue> <fcf_margin_pct> <multiple> <shares_millions>
#   bash scripts/calc-score.sh size <score> <cagr_pct> <probability_pct> <downside_pct>

# Output: JSON with all intermediate calculations shown
```

Uses `python3` for math (already a dependency via `fmp-api.sh`). Returns JSON so agents can paste exact numbers.

### 5. Multiple Consistency Check (`agents/orchestrator.md`)

Add new step between Phase 2 collection and report compilation:

```markdown
### 4b. Multiple Consistency Audit

After collecting all analyst results, before ranking:

1. Extract the FCF multiple used for each candidate
2. Calculate the scan median multiple
3. Flag any candidate whose multiple deviates by >5x from median
4. For flagged candidates: check if the analyst provided explicit justification
5. If no justification: reject the candidate's valuation and note in "Rejected at Analysis"
6. If justification exists but is weak: add confidence flag "valuation_subjective"
```

Also wire enrichment override protocol into Step 5b logic.

### 6. Analyst Prompt Updates (`agents/analyst.md`)

- Reference new discount schedule in Step 5 (Input 3: FCF Multiple)
- Reference probability ceilings in Step 6
- Add instruction to use `calc-score.sh` for all math in Steps 5-6
- Add instruction to show calculator command and output in analysis

## Team

| Role | Agent | Owns | Phase |
|------|-------|------|-------|
| Methodology Guardian | `methodology-guardian` | Knowledge files (1, 2, 3) | 1 |
| Implementation Engineer | `implementation-engineer` | Agent prompts + calculator script (4, 5, 6) | 2 |
| Verification Auditor | `verification-auditor` | Final verification against Gemini report | 3 |

Sequential: Phase 1 → Phase 2 → Phase 3. Calculator script (change 4) can start in parallel with Phase 1 since it has no knowledge file dependency.

## Success Criteria

All 6 critical findings from Gemini's report must be addressed:
1. SAM False Positive → prevented by discount schedule + consistency check
2. SAM Probability Overestimate → prevented by probability ceilings
3. Ranking Override Without Protocol → resolved by enrichment override protocol
4. Inconsistent Multiple Discipline → resolved by discount schedule + consistency rule
5. FLO Margin Sensitivity → partially addressed by heroic assumptions test (already exists)
6. LLM Arithmetic Risk → eliminated by calculator script
