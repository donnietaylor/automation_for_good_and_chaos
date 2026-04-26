# HOA Compliance Bot

An n8n workflow that resolves property jurisdiction, extracts applicable codes and HOA rules, checks Google Street View for observable violations, and generates a structured compliance assessment — in three modes ranging from helpful to terrifying.

## Description

Every property sits under overlapping layers of rules: city ordinances, county codes, HOA covenants, and state statutes. This workflow automates the full compliance pipeline: resolve the jurisdiction from an address, extract the applicable rules, pull a Street View image, observe what's visible from the street, and compare observations against the rules to produce a findings report.

The `mode` field controls how aggressively findings are generated. `audit` is a conservative self-assessment tool. `enforcement` focuses on actionable violations. `chaos` enables hyper-literal edge-case interpretation — the kind that generates a violation notice for a trash can visible for forty-five seconds on a non-collection day.

> This workflow is in the chaos demo category for a reason. The same pipeline that helps a homeowner understand their obligations runs identically in a mode designed to maximize violation output from a single Street View frame.

## Data Sources

| Source | What It Provides | Auth |
|---|---|---|
| OpenAI GPT-5.1 | Jurisdiction resolution, rule extraction, feature observation, compliance assessment | API key |
| Google Maps Street View Static API | Street-level imagery and coordinate metadata for the target address | API key |

## How It Works

1. **Sample Property Input** — address fields plus a `mode` value (`audit`, `enforcement`, or `chaos`). Swap the address here to audit any property.
2. **Resolve Jurisdiction** — AI normalizes the address into a full jurisdiction record: city, county, state, subdivision, HOA name if detectable, and lookup hints for each authority level.
3. **Fetch and Normalize Rules** — AI extracts applicable property rules from the jurisdiction context, separated into `rules` (explicitly grounded) and `inferred_rules` (likely but not sourced). Unresolved sources are flagged.
4. **Street View Check** — Queries the Google Maps Street View Metadata API to confirm imagery exists and builds a direct image URL from the returned coordinates.
5. **Extract Property Features** — AI analyzes all available context — jurisdiction data, rules, and Street View — and returns a structured description of observable features: lawn condition, fencing, vehicles, trash bins, signage, exterior appearance, and more. No violations are inferred at this step; it is purely descriptive.
6. **Generate Compliance Assessment** — AI compares observed features against the rule set and produces structured findings with category, severity, confidence, recommended action, and evidence basis. `chaos` mode adds low-confidence edge cases and hyper-literal interpretations.

### Workflow Diagram

```
Manual Trigger
      │
      ▼
Sample Property Input
(address + mode)
      │
      ▼
Resolve Jurisdiction
(AI: address → normalized jurisdiction record)
      │
      ▼
Fetch and Normalize Rules
(AI: jurisdiction → explicit rules + inferred rules + unresolved sources)
      │
      ▼
Street View Check
(Google Maps Metadata API → confirm coverage → build image URL)
      │
      ▼
Extract Property Features
(AI: Street View image + context → structured observable features,
 lawn / fencing / vehicles / trash bins / exterior / signage / etc.)
      │
      ▼
Generate Compliance Assessment
(AI: features vs. rules → findings with severity, confidence,
 recommended action — behavior varies by mode)
      │
      ▼
Parse Assessment JSON
(structured findings output)
```

## Prerequisites

- [n8n](https://n8n.io/) (self-hosted or n8n Cloud)
- OpenAI API key configured in n8n
- Google Maps API key with the **Street View Static API** enabled

## Installation

1. Import `workflow.json` into your n8n instance:
   - Open n8n → **Workflows** → **Import from File**
   - Select `workflow.json`

2. Configure credentials in n8n:
   - Add an **OpenAI** credential and attach it to all four AI nodes
   - Replace the `key` parameter value in the **StreetView Metadata** and **Build StreetView Fields** nodes with your Google Maps API key

3. Update the address and mode in **Sample Property Input**

4. Click **Execute Workflow**

## Usage

Change the address and mode in the **Sample Property Input** node, then click Execute.

| Mode | Behavior |
|---|---|
| `audit` | Conservative. Flags only well-evidenced issues. Good for homeowner self-assessment. |
| `enforcement` | Focuses on actionable violations with reasonable confidence. |
| `chaos` | Includes low-confidence edge cases and hyper-literal rule interpretations. Maximum findings. |

### Example Output

```json
{
  "mode": "chaos",
  "summary": "Multiple potential violations identified from Street View imagery and inferred HOA rules.",
  "findings": [
    {
      "category": "trash_bins",
      "rule_id": "INFERRED-001",
      "source_type": "hoa",
      "finding": "Trash bin visible from street on non-collection day",
      "evidence": "Wheeled bin observed at curb in Street View image outside known collection window",
      "confidence": "low",
      "severity": "low",
      "recommended_action": "Issue courtesy notice; photograph on collection day for comparison",
      "authority": "hoa",
      "basis": "inferred"
    }
  ],
  "required_next_evidence": ["Confirm collection day schedule for this address"],
  "rules_needing_clarification": ["HOA screening requirement: distance threshold not specified"],
  "overall_risk": "moderate"
}
```

## Configuration

| Node | What to change |
|---|---|
| Sample Property Input | `street`, `city`, `state`, `zip` — target property address |
| Sample Property Input | `mode` — `audit`, `enforcement`, or `chaos` |
| Sample Property Input | `hoa_name` — provide if known; AI will attempt to infer if blank |
| Sample Property Input | `property_notes` — add manual observations to supplement Street View |
| StreetView Metadata | `key` — your Google Maps API key |
| Build StreetView Fields | `key` — same Google Maps API key |

## Cost Estimate

Each execution makes four OpenAI API calls and one Google Maps API call.

| Step | Model | Approximate cost |
|---|---|---|
| Resolve Jurisdiction | GPT-5.1 | ~$0.01 |
| Fetch and Normalize Rules | GPT-5.1 | ~$0.02–$0.05 |
| Extract Property Features | GPT-5.1 | ~$0.02–$0.05 |
| Generate Compliance Assessment | GPT-5.1 | ~$0.02–$0.05 |
| Street View Metadata | Google Maps | Free tier / $0.002 per request |

## Limitations

- Street View imagery may be outdated — Google refreshes coverage on irregular schedules
- The rule extraction step works from the AI's training knowledge of city and county codes; it cannot fetch live ordinance text without a web search node
- HOA-specific rules cannot be extracted without providing the HOA name or CC&R source text
- `chaos` mode findings are intentionally low-confidence and are not suitable for actual enforcement
- The workflow uses four separate AI calls; total execution time is 20–60 seconds depending on address complexity

## Educational Value

- The same workflow runs identically in `audit` (helps residents) and `chaos` (generates maximum violations) — only the mode string changes
- Street View imagery is publicly available and does not require consent from the property owner
- AI rule extraction is plausible-sounding but not authoritative without live ordinance data
- Automated enforcement at scale could generate violation notices faster than any appeals process could address them
- The `required_next_evidence` field shows that even the AI knows it's working with incomplete information — and proceeds anyway in chaos mode

---

*Audit mode helps you understand your obligations. Chaos mode exists to show what happens when you remove proportionality from the same system.*
