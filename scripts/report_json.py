#!/usr/bin/env python3
import json
import sys
from pathlib import Path


USAGE = """Usage:
  python3 scripts/report_json.py validate-scan <json_path>
  python3 scripts/report_json.py render-scan <json_path> <markdown_path>
  python3 scripts/report_json.py validate-holding <json_path>
  python3 scripts/report_json.py render-holding <json_path> <markdown_path>
"""


def fail(message: str) -> None:
    print(f"ERROR: {message}", file=sys.stderr)
    sys.exit(1)


def load_json(path_str: str):
    path = Path(path_str)
    if not path.exists():
        fail(f"File not found: {path}")
    try:
        return json.loads(path.read_text())
    except json.JSONDecodeError as exc:
        fail(f"Invalid JSON in {path}: {exc}")


def write_text(path_str: str, text: str) -> None:
    path = Path(path_str)
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(text)


def require_keys(obj, keys, label):
    if not isinstance(obj, dict):
        fail(f"{label} must be an object")
    for key in keys:
        if key not in obj:
            fail(f"{label} missing required key: {key}")


def require_list(obj, key, label):
    if key not in obj or not isinstance(obj[key], list):
        fail(f"{label}.{key} must be an array")


def require_str(obj, key, label):
    if key not in obj or not isinstance(obj[key], str) or not obj[key].strip():
        fail(f"{label}.{key} must be a non-empty string")


def require_bool(obj, key, label):
    if key not in obj or not isinstance(obj[key], bool):
        fail(f"{label}.{key} must be a boolean")


def pretty_json(value) -> str:
    return json.dumps(value, indent=2, ensure_ascii=True)


def md_json_block(value) -> str:
    return "```json\n" + pretty_json(value) + "\n```"


def md_code_block(value: str) -> str:
    return "```\n" + value.strip() + "\n```"


def bullets(items):
    if not items:
        return "- None"
    return "\n".join(f"- {item}" for item in items)


def yes_no(value: bool) -> str:
    return "yes" if value else "no"


def pass_fail(value: bool) -> str:
    return "PASS" if value else "FAIL"


def table(headers, rows):
    header_line = "| " + " | ".join(headers) + " |"
    sep_line = "|" + "|".join(["---"] * len(headers)) + "|"
    body = []
    for row in rows:
        body.append("| " + " | ".join(str(cell) for cell in row) + " |")
    if not body:
        body.append("| " + " | ".join(["None"] * len(headers)) + " |")
    return "\n".join([header_line, sep_line] + body)


def validate_scan(data):
    require_keys(
        data,
        [
            "report_type",
            "title",
            "date",
            "version",
            "scan_parameters",
            "executive_summary",
            "ranked_candidates",
            "portfolio_impact",
            "rejected_at_screening",
            "rejected_at_analysis_detail_packets",
            "current_holding_overlays",
            "methodology_notes",
        ],
        "scan_report",
    )
    if data["report_type"] != "scan_report_v1":
        fail("scan_report.report_type must be scan_report_v1")
    require_keys(
        data["scan_parameters"],
        ["universe", "focus", "stocks_scanned", "api"],
        "scan_parameters",
    )
    for key in [
        "executive_summary",
        "ranked_candidates",
        "portfolio_impact",
        "rejected_at_screening",
        "rejected_at_analysis_detail_packets",
        "current_holding_overlays",
        "methodology_notes",
    ]:
        require_list(data, key, "scan_report")
    for idx, item in enumerate(data["rejected_at_screening"]):
        require_keys(item, ["ticker", "failed_at", "reason"], f"rejected_at_screening[{idx}]")
    for idx, item in enumerate(data["rejected_at_analysis_detail_packets"]):
        require_keys(item, ["ticker", "rejection_reason"], f"rejected_at_analysis_detail_packets[{idx}]")
    valid_status = {"RANKED", "REJECTED_AT_SCREENING", "REJECTED_AT_ANALYSIS"}
    valid_new_cap = {"ADD", "DO_NOT_ADD"}
    valid_existing_action = {"HOLD", "HOLD_AND_MONITOR", "TRIM", "REDUCE", "EXIT"}
    for idx, item in enumerate(data["current_holding_overlays"]):
        require_keys(
            item,
            ["ticker", "status_in_scan", "new_capital_decision", "existing_position_action", "reason"],
            f"current_holding_overlays[{idx}]",
        )
        if item["status_in_scan"] not in valid_status:
            fail(f"current_holding_overlays[{idx}].status_in_scan invalid")
        if item["new_capital_decision"] not in valid_new_cap:
            fail(f"current_holding_overlays[{idx}].new_capital_decision invalid")
        if item["existing_position_action"] not in valid_existing_action:
            fail(f"current_holding_overlays[{idx}].existing_position_action invalid")


def validate_holding(data):
    require_keys(
        data,
        [
            "report_type",
            "ticker",
            "date",
            "version",
            "verdict",
            "thesis_status",
            "research_retrieval_note",
            "portfolio_context",
            "current_forward_return_cagr_pct",
            "sell_trigger_status",
            "thesis_integrity_checklist",
            "catalyst_tracking",
            "management_consistency",
            "margin_competitor_drift",
            "forward_return_refresh",
            "worst_case_floor",
            "sell_trigger_check",
            "holding_verdict",
            "sources",
        ],
        "holding_review",
    )
    if data["report_type"] != "holding_review_v1":
        fail("holding_review.report_type must be holding_review_v1")
    if data["verdict"] not in {"HOLD", "HOLD_AND_MONITOR", "ADD_CANDIDATE", "TRIM / REDUCE", "EXIT"}:
        fail("holding_review.verdict invalid")
    if data["thesis_status"] not in {"INTACT", "INTACT_BUT_SLOWER", "WEAKENED", "BROKEN"}:
        fail("holding_review.thesis_status invalid")
    require_keys(
        data["research_retrieval_note"],
        ["primary_retrieval_path", "gemini_tried_first", "websearch_fallback_used", "fallback_reason"],
        "research_retrieval_note",
    )
    require_bool(data["research_retrieval_note"], "gemini_tried_first", "research_retrieval_note")
    require_bool(data["research_retrieval_note"], "websearch_fallback_used", "research_retrieval_note")
    require_keys(data["sell_trigger_status"], ["t1", "t2", "t3"], "sell_trigger_status")
    require_keys(
        data["forward_return_refresh"],
        [
            "valuation_command",
            "valuation_json",
            "cagr_command",
            "cagr_json",
            "refreshed_target_price",
            "refreshed_cagr_pct",
            "clears_30pct_hurdle",
            "clears_rapid_move_guardrail",
        ],
        "forward_return_refresh",
    )
    require_bool(data["forward_return_refresh"], "clears_30pct_hurdle", "forward_return_refresh")
    require_bool(data["forward_return_refresh"], "clears_rapid_move_guardrail", "forward_return_refresh")
    require_keys(data["worst_case_floor"], ["material"], "worst_case_floor")
    require_bool(data["worst_case_floor"], "material", "worst_case_floor")
    if data["worst_case_floor"]["material"]:
        require_keys(
            data["worst_case_floor"],
            ["floor_command", "floor_json", "downside_normalization"],
            "worst_case_floor",
        )
    require_list(data, "thesis_integrity_checklist", "holding_review")
    require_list(data, "catalyst_tracking", "holding_review")
    require_list(data, "sell_trigger_check", "holding_review")
    require_list(data, "sources", "holding_review")
    if len(data["sell_trigger_check"]) != 3:
        fail("holding_review.sell_trigger_check must contain exactly 3 items")
    require_keys(data["holding_verdict"], ["decision", "reason", "monitor_items"], "holding_verdict")


def render_scan_candidate(candidate):
    lines = [f"### {candidate.get('rank', '')}. {candidate['ticker']}".replace("### .", "###")]
    for line in [
        candidate.get("score_line"),
        candidate.get("thesis") and f"- **Thesis:** {candidate['thesis']}",
        candidate.get("valuation_summary") and f"- **Valuation:** {candidate['valuation_summary']}",
        candidate.get("discount_path") and f"  - Discount path: {candidate['discount_path']}",
    ]:
        if line:
            lines.append(line)
    if candidate.get("valuation_command"):
        lines.append(f"  - Valuation command: `{candidate['valuation_command']}`")
    if "valuation_json" in candidate:
        lines.append("  - Valuation JSON:")
        lines.append(md_json_block(candidate["valuation_json"]))
    if candidate.get("cagr_command"):
        lines.append(f"  - CAGR command: `{candidate['cagr_command']}`")
    if "cagr_json" in candidate:
        lines.append("  - CAGR JSON:")
        lines.append(md_json_block(candidate["cagr_json"]))
    if candidate.get("worst_case_summary"):
        lines.append(f"- **Worst case:** {candidate['worst_case_summary']}")
    if candidate.get("floor_command"):
        lines.append(f"  - Floor command: `{candidate['floor_command']}`")
    if "floor_json" in candidate:
        lines.append("  - Floor JSON:")
        lines.append(md_json_block(candidate["floor_json"]))
    if candidate.get("downside_normalization"):
        lines.append(f"  - Downside normalization: {candidate['downside_normalization']}")
    if candidate.get("moats"):
        lines.append(f"- **Moats:** {candidate['moats']}")
    if candidate.get("catalysts"):
        lines.append("- **Catalysts:**")
        lines.extend([f"  - {item}" for item in candidate["catalysts"]])
    if candidate.get("management"):
        lines.append(f"- **Management:** {candidate['management']}")
    if candidate.get("suggested_size_pct"):
        flags = ", ".join(candidate.get("confidence_flags", [])) or "none"
        lines.append(f"- **Suggested size:** {candidate['suggested_size_pct']} | **Confidence flags:** {flags}")
    if candidate.get("decision_score_breakdown"):
        lines.append(f"- **Decision Score:** {candidate['decision_score_breakdown']}")
    if candidate.get("score_command"):
        lines.append(f"  - Score command: `{candidate['score_command']}`")
    if "score_json" in candidate:
        lines.append("  - Score JSON:")
        lines.append(md_json_block(candidate["score_json"]))
    if candidate.get("size_command"):
        lines.append(f"  - Size command: `{candidate['size_command']}`")
    if "size_json" in candidate:
        lines.append("  - Size JSON:")
        lines.append(md_json_block(candidate["size_json"]))
    if candidate.get("epistemic_confidence"):
        epi = candidate["epistemic_confidence"]
        if isinstance(epi, dict):
            if epi.get("summary"):
                lines.append(f"- **Epistemic Confidence:** {epi['summary']}")
            for check in epi.get("checks", []):
                lines.append(
                    f"  - {check.get('name', 'Check')}: {check.get('answer', '')} -- {check.get('justification', '')} -- Evidence: {check.get('evidence', '')}"
                )
            for field in [
                "risk_type_friction",
                "effective_probability",
                "confidence_cap",
                "binary_override",
                "threshold_proximity_warning",
            ]:
                if epi.get(field):
                    label = field.replace("_", " ").title()
                    lines.append(f"  - {label}: {epi[field]}")
    if candidate.get("probability_sensitivity"):
        rows = []
        for item in candidate["probability_sensitivity"]:
            rows.append([item.get("probability_pct", ""), item.get("score", ""), item.get("size_band", "")])
        lines.append("- **Probability Sensitivity:**")
        lines.append(table(["Probability", "Score", "Size Band"], rows))
    if candidate.get("structural_diagnosis"):
        diag = candidate["structural_diagnosis"]
        lines.append("- **Structural Diagnosis:**")
        if diag.get("role"):
            lines.append(f"  - **Role:** {diag['role']}")
        if diag.get("upgrades_to_70"):
            lines.append(f"  - **What upgrades to 70+ score?** {diag['upgrades_to_70']}")
        if diag.get("breaks_thesis"):
            lines.append(f"  - **What breaks the thesis?** {diag['breaks_thesis']}")
    return "\n".join(lines)


def render_scan(data):
    lines = [
        f"# {data['title']} -- {data['date']} ({data['version']})",
        "",
        "## Scan Parameters",
        f"- Universe: {data['scan_parameters']['universe']} | Focus: {data['scan_parameters']['focus']} | Stocks scanned: {data['scan_parameters']['stocks_scanned']}",
        f"- Date: {data['date']}",
        f"- API: {data['scan_parameters']['api']}",
        "",
        "## Executive Summary",
        bullets(data["executive_summary"]),
        "",
        "## Ranked Candidates",
    ]
    if data["ranked_candidates"]:
        for candidate in data["ranked_candidates"]:
            lines.append("")
            lines.append(render_scan_candidate(candidate))
    else:
        lines.extend(["", "*None.* No stock achieved a passing score after full analysis."])
    if data.get("pending_human_review"):
        lines.extend(["", "## Pending Human Review"])
        for item in data["pending_human_review"]:
            lines.append(f"- {item.get('ticker', 'UNKNOWN')}: {item.get('reason', '')}")
    lines.extend(["", "## Portfolio Impact", bullets(data["portfolio_impact"]), "", "## Rejected at Screening"])
    screening_rows = [[item["ticker"], item["failed_at"], item["reason"]] for item in data["rejected_at_screening"]]
    lines.append(table(["Ticker", "Failed At", "Reason"], screening_rows))
    lines.extend(["", "## Rejected at Analysis Detail Packets"])
    if data["rejected_at_analysis_detail_packets"]:
        for item in data["rejected_at_analysis_detail_packets"]:
            lines.extend(["", f"### {item['ticker']}", f"- Rejection reason: {item['rejection_reason']}"])
            for label, key in [
                ("Valuation command", "valuation_command"),
                ("CAGR command", "cagr_command"),
                ("Floor command", "floor_command"),
                ("Score command", "score_command"),
                ("Size command", "size_command"),
            ]:
                if item.get(key):
                    lines.append(f"- {label}: `{item[key]}`")
            for label, key in [
                ("Valuation JSON", "valuation_json"),
                ("CAGR JSON", "cagr_json"),
                ("Floor JSON", "floor_json"),
                ("Score JSON", "score_json"),
                ("Size JSON", "size_json"),
            ]:
                if key in item:
                    lines.append(f"- {label}:")
                    lines.append(md_json_block(item[key]))
            if item.get("downside_normalization"):
                lines.append(f"- Downside normalization: {item['downside_normalization']}")
    else:
        lines.extend(["", "*None.*"])
    lines.extend(["", "## Current Holding Overlays"])
    if data["current_holding_overlays"]:
        for item in data["current_holding_overlays"]:
            lines.extend(
                [
                    "",
                    f"### {item['ticker']}",
                    f"- Status in scan: {item['status_in_scan']}",
                    f"- New capital decision: {item['new_capital_decision']}",
                    f"- Existing position action: {item['existing_position_action']}",
                    f"- Reason: {item['reason']}",
                ]
            )
    else:
        lines.extend(["", "*None.*"])
    lines.extend(["", "## Methodology Notes", bullets(data["methodology_notes"])])
    lines.extend(["", "---", f"*Scan completed {data['date']} using EdenFinTech deep value turnaround methodology*"])
    return "\n".join(lines) + "\n"


def render_holding(data):
    retrieval = data["research_retrieval_note"]
    lines = [
        f"# Holding Review: {data['ticker']}",
        f"**Date:** {data['date']}",
        f"**Version:** {data['version']}",
        f"**Verdict:** {data['verdict']}",
        f"**Thesis Status:** {data['thesis_status']}",
        "",
        "---",
        "",
        "## Research Retrieval Note",
        f"- Primary retrieval path: {retrieval['primary_retrieval_path']}",
        f"- Gemini tried first: {yes_no(retrieval['gemini_tried_first'])}",
        f"- WebSearch fallback used: {yes_no(retrieval['websearch_fallback_used'])}",
        f"- Fallback reason: {retrieval['fallback_reason']}",
        "",
        "---",
        "",
        "## Portfolio Context",
    ]
    context_rows = [[key.replace("_", " ").title(), value] for key, value in data["portfolio_context"].items()]
    lines.append(table(["Field", "Value"], context_rows))
    lines.extend(
        [
            "",
            "---",
            "",
            "## Thesis Status",
            f"- Status: **{data['thesis_status']}**",
            f"- Current forward return: **{data['current_forward_return_cagr_pct']}%** CAGR",
            f"- Sell trigger status: T1 {data['sell_trigger_status']['t1']}, T2 {data['sell_trigger_status']['t2']}, T3 {data['sell_trigger_status']['t3']}",
            "",
            "---",
            "",
            "## Thesis-Integrity Checklist",
            "",
        ]
    )
    for idx, item in enumerate(data["thesis_integrity_checklist"], start=1):
        if isinstance(item, dict):
            lines.append(f"{idx}. **{item.get('question', 'Question')}** {item.get('answer', '')}")
        else:
            lines.append(f"{idx}. {item}")
        lines.append("")
    lines.extend(["---", "", "## Catalyst Tracking", ""])
    cat_rows = []
    for item in data["catalyst_tracking"]:
        cat_rows.append(
            [
                item.get("catalyst", ""),
                item.get("original_timing", ""),
                item.get("current_status", ""),
                item.get("evidence", ""),
                item.get("verdict", ""),
            ]
        )
    lines.append(table(["Catalyst", "Original Timing", "Current Status", "Evidence", "Verdict"], cat_rows))
    mgmt = data["management_consistency"]
    drift = data["margin_competitor_drift"]
    fr = data["forward_return_refresh"]
    lines.extend(
        [
            "",
            "---",
            "",
            "## Management Consistency",
            f"- **What management said:** {mgmt.get('what_management_said', '')}",
            f"- **What management did:** {mgmt.get('what_management_did', '')}",
            f"- **Match/Mismatch:** {mgmt.get('match_mismatch', '')}",
            "",
            "---",
            "",
            "## Margin / Competitor Drift",
            f"- **Margin change:** {drift.get('margin_change', '')}",
            f"- **Competitor drift:** {drift.get('competitor_drift', '')}",
            "- **Open risks:**",
        ]
    )
    lines.extend([f"  - {item}" for item in drift.get("open_risks", [])] or ["  - None"])
    lines.extend(
        [
            "",
            "---",
            "",
            "## Forward-Return Refresh",
            "- Base case assumptions:",
        ]
    )
    lines.extend([f"  - {item}" for item in fr.get("base_case_assumptions", [])] or ["  - None"])
    if fr.get("valuation_command"):
        lines.extend(["", f"**Valuation command:**", md_code_block(fr["valuation_command"])])
    if "valuation_json" in fr:
        lines.extend(["**Valuation JSON:**", md_json_block(fr["valuation_json"])])
    if fr.get("cagr_command"):
        lines.extend(["", f"**CAGR command:**", md_code_block(fr["cagr_command"])])
    if "cagr_json" in fr:
        lines.extend(["**CAGR JSON:**", md_json_block(fr["cagr_json"])])
    if fr.get("forward_return_command"):
        lines.extend(["", f"**Forward-return command:**", md_code_block(fr["forward_return_command"])])
    if "forward_return_json" in fr and fr["forward_return_json"]:
        lines.extend(["**Forward-return JSON:**", md_json_block(fr["forward_return_json"])])
    lines.extend(
        [
            "",
            f"- **Refreshed target:** {fr['refreshed_target_price']}",
            f"- **Refreshed CAGR:** {fr['refreshed_cagr_pct']}%",
            f"- **30% hurdle:** {pass_fail(fr['clears_30pct_hurdle'])}",
            f"- **10-15% rapid-move guardrail:** {pass_fail(fr['clears_rapid_move_guardrail'])}",
        ]
    )
    wcf = data["worst_case_floor"]
    lines.extend(["", "---", "", "## Worst-Case Floor"])
    if wcf.get("material"):
        if wcf.get("summary"):
            lines.extend(["", wcf["summary"]])
        if wcf.get("floor_command"):
            lines.extend(["", "**Floor command:**", md_code_block(wcf["floor_command"])])
        if "floor_json" in wcf:
            lines.extend(["**Floor JSON:**", md_json_block(wcf["floor_json"])])
        if wcf.get("trough_path"):
            rows = [
                [
                    item.get("input", ""),
                    item.get("value", ""),
                    item.get("fiscal_year", ""),
                    item.get("data_point", ""),
                ]
                for item in wcf["trough_path"]
            ]
            lines.extend(["", "**Trough Path:**", "", table(["Input", "Trough Value", "Fiscal Year", "FMP Data Point"], rows)])
        if wcf.get("downside_normalization"):
            lines.extend(["", f"**Downside normalization:** {wcf['downside_normalization']}"])
    else:
        lines.extend(["", "Not material to this review."])
    if data.get("optional_scenarios"):
        lines.extend(["", "---", "", "## Optional Scenario Appendix"])
        for scenario in data["optional_scenarios"]:
            lines.extend(["", f"**{scenario.get('name', 'Scenario')}:** {scenario.get('takeaway', '')}"])
            if scenario.get("command"):
                lines.append(md_code_block(scenario["command"]))
            if scenario.get("json"):
                lines.append(md_json_block(scenario["json"]))
    lines.extend(["", "---", "", "## Sell Trigger Check"])
    for item in data["sell_trigger_check"]:
        active = "YES" if item.get("active") else "NO"
        lines.append(f"- **{item.get('name', 'Sell trigger')}:** {active} -- {item.get('evidence', '')}")
    verdict = data["holding_verdict"]
    lines.extend(
        [
            "",
            "---",
            "",
            "## Holding Verdict",
            f"- **Decision:** **{verdict['decision']}**",
            f"- **Reason:** {verdict['reason']}",
            "",
            "**Monitor items:**",
        ]
    )
    lines.extend([f"{idx}. {item}" for idx, item in enumerate(verdict.get("monitor_items", []), start=1)] or ["1. None"])
    lines.extend(["", "---", "", "*Sources: " + ", ".join(data["sources"]) + "*"])
    return "\n".join(lines) + "\n"


def main():
    if len(sys.argv) == 2 and sys.argv[1] in {"-h", "--help", "help"}:
        print(USAGE)
        return
    if len(sys.argv) < 3:
        print(USAGE, file=sys.stderr)
        sys.exit(1)
    command = sys.argv[1]
    if command == "validate-scan":
        validate_scan(load_json(sys.argv[2]))
        print("OK: scan report JSON valid")
        return
    if command == "render-scan":
        if len(sys.argv) != 4:
            fail("render-scan requires <json_path> <markdown_path>")
        data = load_json(sys.argv[2])
        validate_scan(data)
        write_text(sys.argv[3], render_scan(data))
        print(f"OK: wrote {sys.argv[3]}")
        return
    if command == "validate-holding":
        validate_holding(load_json(sys.argv[2]))
        print("OK: holding review JSON valid")
        return
    if command == "render-holding":
        if len(sys.argv) != 4:
            fail("render-holding requires <json_path> <markdown_path>")
        data = load_json(sys.argv[2])
        validate_holding(data)
        write_text(sys.argv[3], render_holding(data))
        print(f"OK: wrote {sys.argv[3]}")
        return
    fail(f"Unknown command: {command}")


if __name__ == "__main__":
    main()
