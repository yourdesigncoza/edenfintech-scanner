---
status: awaiting_human_verify
trigger: "Data is being saved in the plugin source repo instead of the data directory"
created: 2026-03-03T00:00:00Z
updated: 2026-03-03T00:00:00Z
---

## Current Focus

hypothesis: sector-coordinator.md passes `{output_path}/sub-sectors/` to researcher agents, but `{output_path}` = `${CLAUDE_PLUGIN_ROOT}/knowledge/sectors/{slug}/` — so sub-sector files correctly land at `knowledge/sectors/banking/sub-sectors/` (intentional, these are plugin-checked-in files). The REAL bug is the regulatory researcher receives `Output path: {output_path}/regulation.md` which is ALSO in the plugin repo (correct). The sector-coordinator rule says "Always save raw Perplexity outputs to `{data_dir}/research/sectors/{sector-slug}/`" — but this is only in the Rules section, not enforced by the prompt it sends to researcher agents (the researcher prompt doesn't include `data_dir`). Also: `skill/sector-hydrate/SKILL.md` instructs to pass `Data dir: $(bash ...)` but the researcher agent for regulatory has NO data_dir in its prompt template — so regulatory researcher can't save raw outputs to data dir.
test: confirmed by inspecting agent prompt templates in sector-coordinator.md lines 76-104
expecting: bug confirmed, ready to fix
next_action: implement fixes for (1) regulatory researcher missing data_dir in prompt, (2) orchestrator docs/scans secondary copy uses pseudo-code not real bash

## Symptoms

expected: All runtime data (cache, scans, research, sector knowledge raw outputs) should be saved to /home/laudes/zoot/projects/edenfintech-scanner-data/
actual: Some data files being written to plugin source repo
errors: No errors — misconfiguration/path issue
reproduction: Run scan or sector hydration and check where files land
timeline: Likely present since early versions, worse with sector hydration additions

## Eliminated

- hypothesis: fmp-api.sh DATA_DIR fallback to $PLUGIN_ROOT/data
  evidence: .env at plugin root correctly sets SCANNER_DATA_DIR=/home/laudes/zoot/projects/edenfintech-scanner-data, so fallback never triggers
  timestamp: 2026-03-03

- hypothesis: scan reports saving to plugin repo instead of data dir
  evidence: orchestrator.md lines 305-307 correctly uses DATA_DIR=$(bash fmp-api.sh data-dir) for primary save. docs/scans/ copy is intentional per CLAUDE.md convention. No docs/scans/ dir exists anyway.
  timestamp: 2026-03-03

- hypothesis: sector knowledge files (knowledge/sectors/) are wrongly in plugin repo
  evidence: Per CLAUDE.md "Sector knowledge (processed): knowledge/sectors/ in plugin repo (checked in)" — this is INTENTIONAL design. banking/ sub-sector files are correct.
  timestamp: 2026-03-03

- hypothesis: data_dir/sectors/ dir is evidence of misrouted files
  evidence: /home/laudes/zoot/projects/edenfintech-scanner-data/sectors/ exists but is empty — likely a stale mkdir. Not a real bug.
  timestamp: 2026-03-03

## Evidence

- timestamp: 2026-03-03
  checked: fmp-api.sh lines 11-35
  found: DATA_DIR="${SCANNER_DATA_DIR:-$PLUGIN_ROOT/data}" — correct, SCANNER_DATA_DIR is set
  implication: cache correctly goes to data dir

- timestamp: 2026-03-03
  checked: orchestrator.md lines 303-315
  found: Primary save uses DATA_DIR=$(bash fmp-api.sh data-dir). Secondary copy to docs/scans is pseudo-code comment, not executable bash.
  implication: Scan reports save correctly. Secondary copy code is unclear/pseudo-code.

- timestamp: 2026-03-03
  checked: sector-coordinator.md Phase 2 prompt templates (lines 76-104)
  found: Sub-sector researcher receives "Data dir: {data_dir}" in prompt. Regulatory researcher prompt does NOT include "Data dir:" — it only has Sector and Output path.
  implication: BUG 1 — regulatory researcher has no data_dir, cannot save raw Perplexity outputs to research/sectors/. Researcher will either skip saving or guess wrong path.

- timestamp: 2026-03-03
  checked: skill/sector-hydrate/SKILL.md line 75
  found: Passes "Data dir: $(bash ${CLAUDE_PLUGIN_ROOT}/scripts/fmp-api.sh data-dir)" to coordinator — correct
  implication: coordinator receives data_dir correctly, but doesn't pass it to regulatory researcher

- timestamp: 2026-03-03
  checked: knowledge/sectors/ in plugin repo vs data dir
  found: knowledge/sectors/banking/ files are checked-in as intended. data dir research/sectors/banking/ contains raw Perplexity q1-q8 files correctly.
  implication: Sector hydration is largely working correctly — sub-sector research outputs land in right places.

- timestamp: 2026-03-03
  checked: orchestrator.md lines 312-315 (secondary copy code)
  found: "mkdir -p ${CLAUDE_PLUGIN_ROOT}/docs/scans && copy report there." — this is English prose inside a code block, not valid bash. LLM agent may interpret it loosely or correctly.
  implication: BUG 2 — secondary copy instructions are ambiguous pseudo-code; risk that agent doesn't execute correctly or creates dirs in wrong place

- timestamp: 2026-03-03
  checked: knowledge/sectors/sub-sectors/ (top-level orphan dir)
  found: /home/laudes/zoot/projects/edenfintech-scanner/knowledge/sectors/sub-sectors/ exists but is empty — created 2026-03-01
  implication: BUG 3 — coordinator was at some point passing `{output_path}/sub-sectors/` where output_path was `knowledge/sectors/` (missing the sector slug). This created an orphan dir at the wrong level. Fixed by inspection: the SKILL.md passes the correct path with slug, but if the coordinator sub-template literal `{output_path}` was ever misinterpreted without the sector slug substituted, this results.

## Resolution

root_cause: Three bugs found:
  1. Regulatory researcher prompt in sector-coordinator.md is missing "Data dir:" — raw Perplexity outputs from regulatory research can't be saved to data dir (researcher gets no path to write to)
  2. Orchestrator secondary copy block uses English prose ("copy report there") not valid bash — ambiguous for agent execution
  3. The orphan knowledge/sectors/sub-sectors/ dir (currently empty) was created when coordinator passed {output_path}/sub-sectors/ before substituting the sector slug — suggests coordinator prompt template was executed literally at some point

fix: |
  1. agents/sector-coordinator.md — Added "Data dir: {data_dir}" to regulatory researcher prompt (line 102)
  2. agents/orchestrator.md — Rewrote secondary copy block as proper executable bash (lines 311-321)
  3. agents/sector-researcher.md — Added step 2 to save raw Perplexity outputs for regulatory type (line 184)
  4. Removed orphan empty dir: knowledge/sectors/sub-sectors/
verification: awaiting human confirmation
files_changed:
  - agents/sector-coordinator.md
  - agents/orchestrator.md
  - agents/sector-researcher.md
