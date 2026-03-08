# Agent Decontamination — Cleanup Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Remove stock-specific, sector-specific, and historically-anchored examples that have leaked into generic agent rules and cross-sector logic. Separate harmless examples (clearly framed as illustrative) from logic that has been overfit to specific cases.

**Scope:** Non-epistemic anomalies found by Codex review (2026-03-08) and agent audit. The epistemic pipeline fixes are in `2026-03-08-epistemic-data-contract.md` — this plan covers everything else.

**Tech Stack:** Markdown agent specs only — no code changes

**Prerequisite:** Execute the epistemic data contract plan (`2026-03-08-epistemic-data-contract.md`) FIRST. Both plans modify `analyst.md` and `orchestrator.md` — the epistemic plan sets structural boundaries, this plan refines logic within those boundaries.

**Review status:** Reviewed by Gemini (2026-03-08) and Codex (2026-03-08). Codex feedback adopted over Gemini where they conflicted (see below).

---

## Task 1: Fix bank-specific turnaround definition in sector researcher (HIGH)

**Files:**
- Modify: `.claude/agents/sector-researcher.md:174`

**Problem:** The turnaround query hardcodes bank-specific distress criteria as the universal definition: "NPL>5%, CAMELS 4-5 rating, capital ratio <4%, or active enforcement action." This is correct for banks but distorts precedent gathering for non-bank sub-sectors (retail, tech, industrials, etc.).

This is the clearest case of domain-specific logic leaking into a general contract — the exact same class of bug as PYPL-specific wording in the epistemic plan.

**Step 1: Replace with dynamic sector-adaptive turnaround definition**

Replace the hardcoded bank definition with a dynamic derivation instruction. The researcher determines what "distress" means for each sub-sector rather than looking it up in a finite list:

```markdown
Q6: "What is the historical turnaround success rate for distressed {sub_sector} companies?

First, determine the standard distress indicators for {sub_sector} — the sector-specific
metrics that distinguish fundamental distress from temporary underperformance.
(Examples: for banks this might be NPL ratios and capital adequacy; for retailers,
same-store-sales decline and store closures; for SaaS, churn and cash burn rate.
Derive the right metrics for THIS sub-sector rather than applying a fixed checklist.)

Then, using those indicators, identify companies that experienced genuine fundamental
distress and attempted a turnaround. Report the success rate.

Fallback definition if sector-specific metrics are unclear: any company that fell 60%+
from ATH due to company-specific fundamental deterioration (not sector-wide macro drawdowns
or temporary panic selloffs)."
```

**Why dynamic over hardcoded:** A finite list (banks, retail, industrials) creates blind spots for unlisted sectors (biotech, REITs, energy, fintech hybrids) and requires maintenance every time a new sector is scanned. The dynamic approach lets the researcher derive appropriate criteria from the sub-sector context, with the 60%+ ATH fallback as a universal safety net.

**Step 2: Commit**

```bash
git add .claude/agents/sector-researcher.md
git commit -m "fix: replace bank-specific turnaround definition with sector-adaptive criteria"
```

---

## Task 2: Soften active litigation override in analyst (MEDIUM)

**Files:**
- Modify: `.claude/agents/analyst.md:547`

**Problem:** Any active class action, SEC investigation, DOJ probe, or pending enforcement action forces `Dominant Risk Type = Legal/Investigation`. This is too broad — many public companies have routine or low-signal litigation that should remain secondary to operational or cyclical risk. The rule has the "recent case became system law" smell (likely anchored to PYPL's governance crisis).

**Step 1: Replace hard override with materiality-gated rule**

Replace the unconditional override with:

```markdown
**Litigation risk classification:**
- If active litigation is MATERIAL (potential liability >10% of market cap, or management distraction
  is the primary thesis risk, or regulatory outcome could fundamentally alter the business model):
  → Set Dominant Risk Type = Legal/Investigation
- If litigation is ROUTINE or SECONDARY (standard IP disputes, employment suits, regulatory compliance
  without existential threat): → Keep the dominant operational/cyclical/regulatory classification
  and note litigation as a secondary risk factor
- Always document the materiality assessment: "{lawsuit/investigation} — estimated exposure: {amount or qualitative}, materiality: {material/routine}"
```

**Step 2: Commit**

```bash
git add .claude/agents/analyst.md
git commit -m "fix: litigation override gated on materiality, not unconditional"
```

---

## Task 3: Remove bank-centric examples from sector coordinator (LOW)

**Files:**
- Modify: `.claude/agents/sector-coordinator.md:129`
- Modify: `.claude/agents/sector-coordinator.md:139`

**Problem:** Cross-sector synthesis guidance uses bank-specific examples ("banks use P/TBV", "CET1 Ratio") that anchor outputs toward financial-sector framing.

**Step 1: Replace with sector-neutral examples**

Line 129 — replace "banks use P/TBV" with:
```markdown
some sectors use specialized valuation methods (e.g., asset-based, subscriber-based, or reserve-based)
```

Line 139 — replace "CET1 Ratio" example with:
```markdown
specify the exact filing section, metric source, or API field where this data can be verified
```

**Step 2: Commit**

```bash
git add .claude/agents/sector-coordinator.md
git commit -m "fix: replace bank-centric examples with sector-neutral guidance"
```

---

## Task 4: Neutralize ticker-specific anchoring in generic instructions (LOW)

**Files:**
- Modify: `.claude/agents/orchestrator.md:559`
- Modify: `.claude/agents/analyst.md:8`
- Modify: `.claude/agents/analyst.md:362`
- Modify: `.claude/agents/epistemic-reviewer.md:8`

**Step 1: Orchestrator filename example**

Replace `2026-02-28-CPS-BABA-HRL-scan-report.md` with:
```markdown
{YYYY-MM-DD}-{ticker-list}-scan-report.md
```

**Step 2: Analyst opening example**

Replace the CPS/AAP/DORM ticker list in the opening example with sector-neutral placeholders or a description:
```markdown
e.g., "Analyze this {industry} cluster: {TICKER1}, {TICKER2}, {TICKER3}"
```

**Step 3: Analyst precedent example**

Replace "Synovus 2009-2013" with a generic pattern:
```markdown
e.g., "{Company} {year range}" — cite specific named precedents from sector knowledge or public record
```

**Step 4: Epistemic reviewer example**

Replace "AMN" with:
```markdown
{TICKER}
```

**Step 5: Commit**

```bash
git add .claude/agents/orchestrator.md .claude/agents/analyst.md .claude/agents/epistemic-reviewer.md
git commit -m "fix: replace ticker-specific examples with neutral placeholders in agent specs"
```

---

## Dependency Graph

```
Task 1 (sector researcher) — independent, HIGH priority
Task 2 (analyst litigation) — independent, MEDIUM priority
Task 3 (coordinator examples) — independent, LOW priority
Task 4 (placeholder examples) — independent, LOW priority
```

All tasks are independent and can run in parallel. No code changes, only markdown spec edits.

---

## What This Does NOT Change

- **Epistemic pipeline** — covered by `2026-03-08-epistemic-data-contract.md`
- **calc-score.sh** — no logic changes
- **Knowledge files** — no rule changes (scoring-formulas friction table is in the other plan)
- **Screener, holding-reviewer** — no anomalies found in these agents
