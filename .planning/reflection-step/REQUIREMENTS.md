# Reflection Step — Phase A.5 for Sector Researcher

## Summary

Add a reflection/audit step between Phase A (8 parallel Perplexity queries) and Phase B (Claude synthesis) in `agents/sector-researcher.md`. After all 8 queries return, Claude reviews the raw outputs as a "Research Auditor" — identifies gaps, contradictions, and quality issues — then fires 0-3 targeted follow-up `perplexity_ask` calls before proceeding to synthesis.

Inspired by Open Deep Research's iterative ReAct loop, adapted to work within our existing Perplexity-first architecture.

## Motivation

- Q8 (Valuation) and Q6 (Turnaround Precedents) frequently return thin results
- No systematic gap detection — Phase B synthesizer compensates ad-hoc
- Cross-query contradictions go undetected (e.g., Q1 says margins expanding, Q3 says input costs rising)
- Current fallback chain is prompt-baked, not organic

## Design (Claude + Gemini consensus)

### Flow: A → A.5 → B (single pass, no recursion)

**Phase A** (unchanged): 8 parallel `perplexity_ask` → save raw outputs

**Phase A.5** (NEW — Research Audit):
1. Read all 8 raw Perplexity outputs
2. Audit for 3 gap types:
   - **Missing Data**: sections where Perplexity returned boilerplate instead of specific evidence (word count < 150, numeric density < 5%)
   - **Conflicts**: contradictory data points across queries (dates, figures, trends)
   - **Source Quality**: sections citing only blogs/SEO content instead of `.gov`, filings, industry reports; zero-citation paragraphs
3. Generate 0-3 follow-up queries (hard cap: 3)
   - If audit passes (no critical gaps) → skip to Phase B
   - Follow-up queries must be structurally different from initial 8: narrow keyword-stuffed specifics, not natural language rephrases
   - Context-inject the failure: tell Perplexity what was missing from the first pass
4. Fire follow-up queries in parallel via `perplexity_ask`
5. Save follow-up outputs to `{data_dir}/research/sectors/{sector-slug}/{sub-sector-slug}/` as `followup-1.md`, `followup-2.md`, etc.
6. Label supplementary data: `### SUPPLEMENTARY RESEARCH ###` header before each follow-up result

**Phase B** (minor update): Synthesis now reads initial 8 outputs + any supplementary research. Supplementary data overrides Phase A data on conflicts.

### Gap Detection Criteria (The Rubric)

Flag a gap ONLY if:
1. **Hard data missing**: No specific percentages for margins/CAGR, or no specific names of regulators/laws in a section that requires them
2. **Thin evidence**: Fewer than 2 examples found for Failure Patterns (Q4) or Turnaround Precedents (Q6)
3. **Staleness**: All citations are >2 years old in a fast-moving sector
4. **Contradiction**: Two queries assert conflicting facts about the same metric/trend
5. **Citation vacuum**: A section >100 words with zero inline source URLs

### Follow-up Query Style

```
# BAD (rephrase of Q2):
"What are the regulatory risks for US regional banks?"

# GOOD (targeted, keyword-stuffed, context-injected):
"FDIC enforcement actions regional banks 2022-2025 specific fines consent orders amounts CRA violations"
```

### Guardrails

- Hard cap: 3 follow-up queries max
- Single pass only: A → A.5 → B — no looping
- If data still missing after follow-ups, Phase B must report the "Known Unknown" rather than fabricating
- Follow-ups use same `perplexity_ask` tool with same fallback chain
- Token budget: reflection step should use minimal tokens — audit, don't synthesize

## Files to Modify

1. `agents/sector-researcher.md` — Add Phase A.5 between existing Phase A and Phase B

## Files NOT Modified

- `agents/sector-coordinator.md` — no changes needed (just spawns researchers)
- `skills/sector-hydrate/SKILL.md` — no changes needed
- `scripts/fmp-api.sh` — no changes needed
- Knowledge files — no changes needed

## Acceptance Criteria

- [ ] Phase A.5 audit runs after 8 queries return, before synthesis
- [ ] Gap detection covers all 5 criteria (missing data, thin evidence, staleness, contradictions, citation vacuum)
- [ ] Follow-up queries are structurally different from initial 8 (narrow, keyword-stuffed)
- [ ] Follow-up raw outputs saved to research dir as `followup-N.md`
- [ ] Supplementary data labeled with `### SUPPLEMENTARY RESEARCH ###`
- [ ] Phase B synthesis treats supplementary data as override on conflicts
- [ ] Hard cap of 3 follow-up queries enforced
- [ ] No recursion — single pass only
- [ ] Audit can produce 0 follow-ups (pass-through) when initial data is sufficient
- [ ] Regulatory research type also gets reflection step (3 initial queries → audit → 0-2 follow-ups)
