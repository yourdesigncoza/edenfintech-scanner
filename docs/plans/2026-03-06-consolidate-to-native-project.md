# Consolidate Plugin to Native Claude Code Project — Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Eliminate the 3-location workflow (source + data repo + plugin cache) and make EdenFinTech Scanner a native Claude Code project with a welcome screen.

**Architecture:** Move agents/ and skills/ into .claude/ for native discovery. Replace `${CLAUDE_PLUGIN_ROOT}` with project-relative paths. Consolidate data into gitignored `data/` dir. Add SessionStart hook for ASCII welcome banner.

**Tech Stack:** Bash, Claude Code native project config (.claude/), ANSI true color escape codes

---

### Task 1: Create data/ directory and migrate data

**Files:**
- Create: `data/` directory structure
- Modify: `.gitignore`

**Step 1: Create data directory structure**

```bash
mkdir -p data/{cache,scans,research,result,logs}
```

**Step 2: Copy existing data from scanner-data repo**

```bash
cp -r /home/laudes/zoot/projects/edenfintech-scanner-data/cache/* data/cache/ 2>/dev/null || true
cp -r /home/laudes/zoot/projects/edenfintech-scanner-data/scans/* data/scans/ 2>/dev/null || true
cp -r /home/laudes/zoot/projects/edenfintech-scanner-data/research/* data/research/ 2>/dev/null || true
cp -r /home/laudes/zoot/projects/edenfintech-scanner-data/result/* data/result/ 2>/dev/null || true
cp -r /home/laudes/zoot/projects/edenfintech-scanner-data/logs/* data/logs/ 2>/dev/null || true
cp /home/laudes/zoot/projects/edenfintech-scanner-data/.env data/.env 2>/dev/null || true
```

NOTE: Do NOT copy `knowledge/` from data repo — the source repo `knowledge/` is now canonical.

**Step 3: Update .gitignore**

Replace current `.gitignore` content (just `.env`) with:

```
.env
data/
```

**Step 4: Verify data migration**

```bash
ls -la data/.env && echo "--- cache ---" && du -sh data/cache/ && echo "--- scans ---" && ls data/scans/ | head -5
```

Expected: .env exists, cache has content, scans has report files.

**Step 5: Commit**

```bash
git add .gitignore
git commit -m "chore: add data/ to gitignore for consolidated project structure"
```

---

### Task 2: Move agents and skills to .claude/ for native discovery

**Files:**
- Create: `.claude/agents/` (move from `agents/`)
- Create: `.claude/skills/` (move from `skills/`)
- Delete: `agents/` (old location)
- Delete: `skills/` (old location)

**Step 1: Move agents**

```bash
mkdir -p .claude/agents
mv agents/*.md .claude/agents/
rmdir agents
```

**Step 2: Move skills**

```bash
mkdir -p .claude/skills/scan-stocks .claude/skills/sector-hydrate .claude/skills/gemini-review
mv skills/scan-stocks/SKILL.md .claude/skills/scan-stocks/SKILL.md
mv skills/sector-hydrate/SKILL.md .claude/skills/sector-hydrate/SKILL.md
mv skills/gemini-review/SKILL.md .claude/skills/gemini-review/SKILL.md
rm -rf skills
```

**Step 3: Verify native discovery paths exist**

```bash
ls .claude/agents/*.md && ls .claude/skills/*/SKILL.md
```

Expected: 6 agent files, 3 skill files.

**Step 4: Commit**

```bash
git add -A
git commit -m "refactor: move agents and skills to .claude/ for native project discovery"
```

---

### Task 3: Replace ${CLAUDE_PLUGIN_ROOT} with project-relative paths in all agents

All agents reference `${CLAUDE_PLUGIN_ROOT}/scripts/...`. Since agents run from project root, replace with `scripts/...`. Also update agent cross-references from `${CLAUDE_PLUGIN_ROOT}/agents/` to `.claude/agents/`.

**Files:**
- Modify: `.claude/agents/orchestrator.md`
- Modify: `.claude/agents/screener.md`
- Modify: `.claude/agents/analyst.md`
- Modify: `.claude/agents/epistemic-reviewer.md`
- Modify: `.claude/agents/sector-coordinator.md`
- Modify: `.claude/agents/sector-researcher.md`

**Step 1: Global find-and-replace in all agent files**

In every `.claude/agents/*.md` file, make these replacements:

| Old | New |
|-----|-----|
| `${CLAUDE_PLUGIN_ROOT}/scripts/` | `scripts/` |
| `${CLAUDE_PLUGIN_ROOT}/agents/` | `.claude/agents/` |
| `${CLAUDE_PLUGIN_ROOT}/docs/` | `docs/` |

Use `replace_all: true` for each replacement in each file.

**Step 2: Verify no CLAUDE_PLUGIN_ROOT references remain in agents**

```bash
grep -r 'CLAUDE_PLUGIN_ROOT' .claude/agents/
```

Expected: No output (zero matches).

**Step 3: Commit**

```bash
git add .claude/agents/
git commit -m "refactor: replace CLAUDE_PLUGIN_ROOT with project-relative paths in agents"
```

---

### Task 4: Replace ${CLAUDE_PLUGIN_ROOT} in all skills

**Files:**
- Modify: `.claude/skills/scan-stocks/SKILL.md`
- Modify: `.claude/skills/sector-hydrate/SKILL.md`
- Modify: `.claude/skills/gemini-review/SKILL.md`

**Step 1: Update scan-stocks skill**

Replace in `.claude/skills/scan-stocks/SKILL.md`:

| Old | New |
|-----|-----|
| `bash ${CLAUDE_PLUGIN_ROOT}/scripts/fmp-api.sh help` | `bash scripts/fmp-api.sh help` |
| `Edit \`${CLAUDE_PLUGIN_ROOT}/.env\` and set \`FMP_API_KEY=your_key\`` | `Edit \`data/.env\` and set \`FMP_API_KEY=your_key\`` |
| `${CLAUDE_PLUGIN_ROOT}/agents/orchestrator.md` | `.claude/agents/orchestrator.md` |

**Step 2: Update sector-hydrate skill**

Replace in `.claude/skills/sector-hydrate/SKILL.md`:

| Old | New |
|-----|-----|
| `bash ${CLAUDE_PLUGIN_ROOT}/scripts/gemini-search.sh` | `bash scripts/gemini-search.sh` |
| `KNOWLEDGE_DIR=$(bash ${CLAUDE_PLUGIN_ROOT}/scripts/fmp-api.sh knowledge-dir)` | `KNOWLEDGE_DIR=$(bash scripts/fmp-api.sh knowledge-dir)` |
| `${CLAUDE_PLUGIN_ROOT}/agents/sector-coordinator.md` | `.claude/agents/sector-coordinator.md` |
| `$(bash ${CLAUDE_PLUGIN_ROOT}/scripts/fmp-api.sh knowledge-dir)` | `$(bash scripts/fmp-api.sh knowledge-dir)` |
| `$(bash ${CLAUDE_PLUGIN_ROOT}/scripts/fmp-api.sh data-dir)` | `$(bash scripts/fmp-api.sh data-dir)` |
| `$SCANNER_DATA_DIR/.env` | `data/.env` |

Also fix the stale error message referencing `PERPLEXITY_API_KEY` — should reference `GEMINI_API_KEY` in `data/.env`.

**Step 3: Update gemini-review skill**

Replace in `.claude/skills/gemini-review/SKILL.md`:

| Old | New |
|-----|-----|
| `KNOWLEDGE_DIR=$(bash ${CLAUDE_PLUGIN_ROOT}/scripts/fmp-api.sh knowledge-dir)` | `KNOWLEDGE_DIR=$(bash scripts/fmp-api.sh knowledge-dir)` |
| `${CLAUDE_PLUGIN_ROOT}/agents/` | `.claude/agents/` |
| `${CLAUDE_PLUGIN_ROOT}/scripts/` | `scripts/` |
| `DATA_DIR=$(bash ${CLAUDE_PLUGIN_ROOT}/scripts/fmp-api.sh data-dir)` | `DATA_DIR=$(bash scripts/fmp-api.sh data-dir)` |
| `.claude-plugin/marketplace.json` | hardcode version or read from CLAUDE.md |

**Step 4: Verify no CLAUDE_PLUGIN_ROOT references remain in skills**

```bash
grep -r 'CLAUDE_PLUGIN_ROOT' .claude/skills/
```

Expected: No output.

**Step 5: Commit**

```bash
git add .claude/skills/
git commit -m "refactor: replace CLAUDE_PLUGIN_ROOT with project-relative paths in skills"
```

---

### Task 5: Simplify bash scripts env loading

All 4 scripts (`fmp-api.sh`, `gemini-search.sh`, `perplexity-api.sh`, `exa-api.sh`) have a 3-level env chain. Simplify to: project-root `data/.env` only.

**Files:**
- Modify: `scripts/fmp-api.sh` (lines 7-35)
- Modify: `scripts/gemini-search.sh` (lines 10-61)
- Modify: `scripts/perplexity-api.sh` (lines 11-48)
- Modify: `scripts/exa-api.sh` (lines 12-48)

**Step 1: Replace env loading block in fmp-api.sh**

Replace lines 7-35 (from `# Load config` through `DATA_DIR=...`) with:

```bash
# Load config
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
DATA_DIR="$PROJECT_ROOT/data"
if [[ -f "$DATA_DIR/.env" ]]; then source "$DATA_DIR/.env"; fi
```

Also update error message (line 26): `"Add your API keys to: data/.env"`.

Also update help output (lines 369-370): reference `data/.env`.

Also simplify `knowledge-dir` command (lines 322-330) — remove the copy-from-plugin logic:

```bash
knowledge-dir)
    echo "$PROJECT_ROOT/knowledge"
    ;;
```

**Step 2: Replace env loading block in gemini-search.sh**

Replace lines 10-61 env loading with same pattern as fmp-api.sh (but keep the Gemini MCP fallback for API key at lines 26-38).

Update DATA_DIR and CACHE_DIR references to use the new PROJECT_ROOT/data pattern.

**Step 3: Replace env loading block in perplexity-api.sh**

Same pattern. Replace `PLUGIN_ROOT` with `PROJECT_ROOT`. Remove `~/.config/edenfintech-scanner/.env` fallback.

**Step 4: Replace env loading block in exa-api.sh**

Same pattern.

**Step 5: Verify scripts work with new paths**

```bash
bash scripts/fmp-api.sh data-dir && bash scripts/fmp-api.sh knowledge-dir && bash scripts/fmp-api.sh help
```

Expected: `data-dir` returns `/home/laudes/zoot/projects/edenfintech-scanner/data`, `knowledge-dir` returns `/home/laudes/zoot/projects/edenfintech-scanner/knowledge`, help works.

**Step 6: Commit**

```bash
git add scripts/
git commit -m "refactor: simplify script env loading — single data/.env source"
```

---

### Task 6: Create welcome banner hook

**Files:**
- Create: `.claude/hooks.json`
- Create: `hooks/session-start.sh`

**Step 1: Create hooks.json**

Write `.claude/hooks.json`:

```json
{
  "hooks": {
    "SessionStart": [
      {
        "matcher": "startup",
        "hooks": [
          {
            "type": "command",
            "command": "bash hooks/session-start.sh"
          }
        ]
      }
    ]
  }
}
```

Using `startup` matcher so it only shows on fresh sessions (not resume/clear/compact).

**Step 2: Create session-start.sh**

Write `hooks/session-start.sh` — an executable bash script that:

1. Reads version from CLAUDE.md (grep for `v[0-9]` pattern) or hardcode
2. Checks API key status (data/.env has FMP_API_KEY, GEMINI_API_KEY)
3. Counts portfolio holdings (grep pipe count from knowledge/current-portfolio.md)
4. Finds last scan date (ls data/scans/ most recent)
5. Outputs JSON with `additionalContext` containing the formatted banner

The banner uses ANSI true color `\033[38;2;133;169;255m` for `#85a9ff` blue.

ASCII art for "EDEN":

```
 ███████╗██████╗ ███████╗███╗   ██╗
 ██╔════╝██╔══██╗██╔════╝████╗  ██║
 █████╗  ██║  ██║█████╗  ██╔██╗ ██║
 ██╔══╝  ██║  ██║██╔══╝  ██║╚██╗██║
 ███████╗██████╔╝███████╗██║ ╚████║
 ╚══════╝╚═════╝ ╚══════╝╚═╝  ╚═══╝
```

Below the art: version, subtitle "Deep Value Turnaround Scanner", available commands, and status line.

The script outputs JSON in the format:
```json
{
  "additional_context": "...",
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "..."
  }
}
```

**Step 3: Make executable**

```bash
chmod +x hooks/session-start.sh
```

**Step 4: Test the hook locally**

```bash
bash hooks/session-start.sh
```

Expected: JSON output with the banner in additionalContext.

**Step 5: Commit**

```bash
git add .claude/hooks.json hooks/
git commit -m "feat: add welcome banner on session start"
```

---

### Task 7: Update CLAUDE.md for new structure

**Files:**
- Modify: `CLAUDE.md`

**Step 1: Rewrite CLAUDE.md**

Key changes:
- Remove "A Claude Code plugin" — now "A Claude Code project"
- Update architecture paths: `skills/` → `.claude/skills/`, `agents/` → `.claude/agents/`
- Remove `$SCANNER_DATA_DIR` references → `data/`
- Remove plugin manifest reference
- Remove `${CLAUDE_PLUGIN_ROOT}` convention → "project-relative paths"
- Update API key location → `data/.env`
- Update cache location → `data/cache/`
- Update scan report location → `data/scans/`
- Remove "Plugin root `.env` only has `SCANNER_DATA_DIR`" — no longer needed
- Update knowledge files section — read from `knowledge/` directly, no copy logic

**Step 2: Verify no stale references remain**

```bash
grep -n 'CLAUDE_PLUGIN_ROOT\|SCANNER_DATA_DIR\|plugin cache\|\.claude-plugin' CLAUDE.md
```

Expected: No matches.

**Step 3: Commit**

```bash
git add CLAUDE.md
git commit -m "docs: update CLAUDE.md for consolidated project structure"
```

---

### Task 8: Update README.md and clean up root .env

**Files:**
- Modify: `README.md`
- Modify: `.env` (root)
- Delete: `.claude-plugin/marketplace.json`
- Delete: `.claude-plugin/` directory

**Step 1: Update README.md**

Replace `$SCANNER_DATA_DIR` references with `data/`. Remove plugin installation instructions. Update setup to just "add API keys to data/.env".

**Step 2: Delete .env at project root**

Current content is `SCANNER_DATA_DIR=/home/laudes/zoot/projects/edenfintech-scanner-data` — no longer needed. Delete it.

NOTE: `.env` is in `.gitignore` so this is just a local cleanup.

**Step 3: Delete .claude-plugin directory**

```bash
rm -rf .claude-plugin
```

**Step 4: Commit**

```bash
git add -A
git commit -m "chore: remove plugin manifest and update README for native project"
```

---

### Task 9: Unregister plugin from Claude Code and clean up cache

**Files:**
- Modify: `~/.claude/plugins/installed_plugins.json` (remove edenfintech-scanner entry)
- Modify: `~/.claude/settings.json` (remove edenfintech-scanner from enabledPlugins)
- Delete: `~/.claude/plugins/cache/edenfintech-scanner/` (all 19 versions)

**Step 1: Remove from installed_plugins.json**

Edit `~/.claude/plugins/installed_plugins.json` — remove the `"edenfintech-scanner@edenfintech-scanner"` key from `plugins` object.

**Step 2: Remove from settings.json enabledPlugins**

Edit `~/.claude/settings.json` — remove both `"edenfintech-scanner": true` and `"edenfintech-scanner@edenfintech-scanner": true` from `enabledPlugins`.

**Step 3: Delete plugin cache**

```bash
rm -rf ~/.claude/plugins/cache/edenfintech-scanner/
```

This removes all 19 cached versions (4.2MB).

**Step 4: Verify plugin is fully removed**

```bash
grep -r "edenfintech" ~/.claude/plugins/ 2>/dev/null; grep "edenfintech" ~/.claude/settings.json 2>/dev/null
```

Expected: No output.

---

### Task 10: Update project memory

**Files:**
- Modify: `/home/laudes/.claude/projects/-home-laudes-zoot-projects-edenfintech-scanner/memory/MEMORY.md`

**Step 1: Update MEMORY.md**

Remove outdated entries:
- "Plugin Cache Sync" section
- "RESOLVED: MCP Tools Don't Propagate" — keep the resolution but remove plugin-specific language
- References to `${CLAUDE_PLUGIN_ROOT}` and `$SCANNER_DATA_DIR` env chain
- "Knowledge Files — Runtime Location" section (no longer relevant — knowledge/ is read directly)

Add new entry:
- "Project Structure (v1.0.0)" — consolidated single-repo, .claude/ for agents+skills+hooks, data/ gitignored, scripts project-relative

---

### Task 11: Smoke test — verify full pipeline works

**Step 1: Start fresh Claude Code session in project dir**

```bash
cd /home/laudes/zoot/projects/edenfintech-scanner && claude
```

**Step 2: Verify welcome banner appears**

Expected: ASCII "EDEN" banner with blue color, version, commands, API status.

**Step 3: Verify slash commands are discovered**

Type `/scan` and check autocomplete offers `/scan-stocks`.

**Step 4: Test FMP API still works**

```bash
bash scripts/fmp-api.sh profile CPS
```

**Step 5: Test a minimal scan** (optional — uses API quota)

```
/scan-stocks CPS
```

Verify the orchestrator finds `.claude/agents/orchestrator.md` and the pipeline runs.
