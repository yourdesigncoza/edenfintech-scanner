---
name: gemini-review
description: |
  Run a Gemini deep review of the EdenFinTech scanner methodology and implementation.
  Use when the user says "gemini review", "audit the scanner", "review methodology",
  "deep review", or after any major update to knowledge files, agents, or scoring logic.
  Auto-detects what changed since the last review via git tags.
version: 0.1.0
---

# EdenFinTech Scanner — Gemini Deep Review

Automated methodology + implementation audit using Gemini Pro. Auto-detects changes since last review, compiles all source files, and produces a structured audit report.

## Step 1: Detect Changes Since Last Review

Find the most recent `gemini-review-*` git tag and diff against HEAD:

```bash
# Find last review tag
LAST_TAG=$(git tag -l 'gemini-review-*' --sort=-version:refname | head -1)

if [ -z "$LAST_TAG" ]; then
  echo "NO_PREVIOUS_REVIEW"
else
  echo "LAST_REVIEW_TAG: $LAST_TAG"
  git log --oneline "$LAST_TAG"..HEAD
  git diff "$LAST_TAG"..HEAD --stat
fi
```

- If no previous tag: this is a **full baseline review** (review everything)
- If tag exists: focus the review on what changed, plus a coherence check of the whole system

Read the current version from `.claude-plugin/marketplace.json` — use the `metadata.version` field as `VERSION` for the report filename and tag.

## Step 2: Compile Review Input Document

Build a single markdown document at `/tmp/edenfintech-gemini-review-input.md` containing ALL of these sections:

### Section 1: Review Context Header

```markdown
# EdenFinTech Scanner — Full System Snapshot for Deep Review

> **Version:** {VERSION}
> **Review type:** {Full baseline | Delta review from {LAST_TAG}}
> **Files changed since last review:** {count} files, {insertions}+/{deletions}-
```

### Section 2: Git Delta (if delta review)

Include the output of `git diff {LAST_TAG}..HEAD` (the actual diff content, not just stats) for these tracked paths only:
- `knowledge/*.md`
- `agents/*.md`
- `scripts/calc-score.sh`
- `skills/*/SKILL.md`

Cap at 500 lines of diff. If larger, include stats + the most important file diffs.

### Section 3: Knowledge Files (full content)

Read and include the complete content of each:
- `${CLAUDE_PLUGIN_ROOT}/knowledge/strategy-rules.md`
- `${CLAUDE_PLUGIN_ROOT}/knowledge/scoring-formulas.md`
- `${CLAUDE_PLUGIN_ROOT}/knowledge/valuation-guidelines.md`
- `${CLAUDE_PLUGIN_ROOT}/knowledge/excluded-industries.md`
- `${CLAUDE_PLUGIN_ROOT}/knowledge/current-portfolio.md`

### Section 4: Agent Definitions (full content)

Read and include:
- `${CLAUDE_PLUGIN_ROOT}/agents/orchestrator.md`
- `${CLAUDE_PLUGIN_ROOT}/agents/screener.md`
- `${CLAUDE_PLUGIN_ROOT}/agents/analyst.md`
- `${CLAUDE_PLUGIN_ROOT}/agents/epistemic-reviewer.md`

Include any NEW agent files not in this list.

### Section 5: Calculator Script (full content)

- `${CLAUDE_PLUGIN_ROOT}/scripts/calc-score.sh`

### Section 6: Previous Review Findings

Read the most recent `result/gemini-v*-deep-review.md` file and include its **Critical Findings Summary** table and **Overall Confidence** score. If no previous review exists, note "First review — no prior findings."

### Section 7: Review Instructions

Include this verbatim:

```markdown
## WHAT THIS REVIEW SHOULD COVER

1. **System Coherence**: Do all pieces (strategy-rules, scoring-formulas, valuation-guidelines, agent prompts, calc-score.sh) align? Find contradictions or gaps between knowledge files and agent instructions.

2. **Implementation Quality**: Does the orchestrator's flow correctly implement what the knowledge files define? Does calc-score.sh correctly implement the formulas? Identify edge cases.

3. **Delta Assessment** (if delta review): Are the changes since last review internally consistent? Do they introduce new contradictions? Do they fix previously identified issues?

4. **Previous Findings Status**: Check each finding from the prior review — fixed, partially fixed, or still open?

5. **New Weaknesses**: What new failure modes or attack surfaces exist? How could agents produce false positives?

6. **Hard Rules Audit**: Are all hard rules enforceable in the current architecture? Which rely on LLM judgment and could be bypassed?

7. **Scoring System Stress Test**: Walk through 3-5 extreme scenarios with the current scoring formula. Show the math.

8. **Methodology Maturity**: What's still missing vs. institutional risk management?

Produce a structured report with severity ratings (CRITICAL / HIGH / MEDIUM / LOW) for each finding. End with an overall confidence score (1-10).
```

## Step 3: Run Gemini Deep Review

Send the compiled document to Gemini using `gemini-analyze-document`:

```
Tool: mcp__gemini__gemini-analyze-document
filePath: /tmp/edenfintech-gemini-review-input.md
question: "You are a senior quantitative finance auditor reviewing an investment scanning system. Perform a comprehensive deep review of this system. The document contains the COMPLETE system state including strategy rules, scoring formulas, agent definitions, calculator script, and previous audit findings. {If delta review: 'Pay special attention to the git diff in Section 2 — these are the changes since the last review.'} Be rigorous, specific, and constructively critical. Focus on logical consistency, mathematical correctness, edge cases, exploitable loopholes, and gaps between methodology and implementation. Do not be sycophantic. Produce the structured report as described in Section 7."
mediaResolution: high
```

## Step 4: Run Follow-Up Deep Dive

After receiving the initial review, run a follow-up with `gemini-query` (model: pro, thinkingLevel: high) for deeper analysis:

```
Prompt: Based on the initial review, provide deeper analysis on:

1. For each finding rated MEDIUM or higher: what specific code/prompt change would fix it? Be concrete — quote the file and section to modify.

2. Verify the math in the stress test scenarios by re-computing them independently. Flag any discrepancies.

3. Identify the single most likely false positive scenario under the current system. Walk through exactly how it would happen step by step.

4. Rate each agent's prompt quality (1-10) for: clarity of instructions, completeness of constraints, resistance to drift. Which agent is the weakest link?

{If delta review: "5. For each change in the git diff: does it achieve its stated purpose? Are there unintended side effects?"}
```

## Step 5: Verify Gemini's Claims

Before finalizing, spot-check Gemini's factual claims against the actual codebase:

- If Gemini says a tool/feature is missing from an agent, verify by reading the agent's YAML frontmatter
- If Gemini flags a formula discrepancy, verify by reading calc-score.sh
- If Gemini claims a sequence issue, verify by reading the orchestrator flow

Note any corrections in the final report under a "**Reviewer Corrections**" section. Previous reviews found Gemini incorrectly claiming the epistemic reviewer lacked WebSearch (it has it) — always verify tool access claims.

## Step 6: Compile and Save Report

Merge the initial review, follow-up analysis, and any corrections into a single report. Save to:

```
${CLAUDE_PLUGIN_ROOT}/result/gemini-v{VERSION}-deep-review.md
```

The report should follow this structure:

```markdown
# EdenFinTech Scanner v{VERSION} — Deep System Review

> **Auditor:** Gemini Pro (deep analysis mode)
> **Date:** {YYYY-MM-DD}
> **Scope:** {Full baseline review | Delta review from {LAST_TAG}}
> **Sources:** All knowledge files, agent definitions, calc-score.sh, previous audits
> **Changes since last review:** {summary of git delta or "N/A — baseline review"}

---

## Executive Summary
{2-3 paragraph overview}

## {Numbered sections per review area}
{Content from Gemini, with corrections noted}

## Reviewer Corrections
{Any Gemini claims that were wrong, with evidence}

## Critical Findings Summary
| # | Finding | Severity | Action Required |
|---|---------|----------|-----------------|

## Scoring System Stress Tests
{Scenarios with full math}

## Comparison to Previous Version
{Table showing progression}

## Verdict
{APPROVED / APPROVED WITH CONDITIONS / NEEDS FIXES}
**Overall Confidence: {n}/10**

---
*Review completed {YYYY-MM-DD}. Gemini Pro deep analysis of EdenFinTech Scanner v{VERSION}.*
```

## Step 7: Tag and Cross-Reference

After saving the report:

1. **Tag the commit** for future delta detection:
```bash
git tag "gemini-review-v{VERSION}"
```

2. **Update the original strategy analysis** — add/update a line at the top of `result/gemini-strategy-analysis.md` pointing to the latest review:
```markdown
> **Latest review:** See [gemini-v{VERSION}-deep-review.md](gemini-v{VERSION}-deep-review.md) ({date}).
```

3. **Present summary** to the user:
   - Overall confidence score
   - Number of findings by severity
   - Any CRITICAL or HIGH findings that need immediate attention
   - Path to the full report
