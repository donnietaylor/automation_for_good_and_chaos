# HOA Compliance Bot

An n8n workflow that resolves property jurisdiction, extracts applicable codes and HOA rules, checks Google Street View for observable violations, and generates a structured compliance assessment — in three modes ranging from helpful to terrifying.

## Description

Every property sits under overlapping layers of rules: city ordinances, county codes, HOA covenants, and state statutes. This workflow automates the full compliance pipeline: resolve the jurisdiction from an address, extract the applicable rules, pull a Street View image, observe what's visible from the street, and compare observations against the rules to produce a findings report.

The `mode` field controls how aggressively findings are generated. `audit` is a conservative self-assessment tool. `enforcement` focuses on actionable violations. `chaos` enables hyper-literal edge-case interpretation — the kind that generates a violation notice for a trash can visible for forty-five seconds on a non-collection day.

> This workflow is in the chaos demo category for a reason. The same pipeline that helps a homeowner understand their obligations runs identically in a mode designed to maximize violation output from a single Street View frame.

## Data Sources

| Source | What It Provides | Auth |
|---|---|---|
| OpenAI GPT-5.1 | Jurisdiction resolution, rule extraction, compliance assessment, violation email generation | API key |
| OpenAI GPT-4o | Property feature extraction from Street View or generated imagery | API key |
| OpenAI DALL-E 3 | AI-generated property image with seeded violations (demo mode only) | API key |
| Google Maps Street View Static API | Street-level imagery and coordinate metadata for the target address | API key |
| Microsoft Outlook | Sends the generated HOA violation notice by email | OAuth2 |

## How It Works

1. **Sample Property Input** — address fields plus a `mode` value (`audit`, `enforcement`, or `chaos`) and a `demo_mode` flag. Swap the address here to audit any property.
2. **Resolve Jurisdiction** — AI normalizes the address into a full jurisdiction record: city, county, state, subdivision, HOA name if detectable, and lookup hints for each authority level.
3. **Fetch and Normalize Rules** — AI extracts applicable property rules from the jurisdiction context, separated into `rules` (explicitly grounded) and `inferred_rules` (likely but not sourced). Unresolved sources are flagged.
4. **Demo Mode branch** — if `demo_mode` is `true`, DALL-E 3 generates an AI property image from the `image_description` prompt (useful for live demos without a real address). Otherwise the workflow falls through to Street View.
5. **Street View Check** *(live mode only)* — Queries the Google Maps Street View Metadata API to confirm imagery exists and builds a direct image URL from the returned coordinates.
6. **Build Vision Context** — Merges the full address context with whichever image source was used (DALL-E or Street View), attaching the image URL and a source label.
7. **Extract Property Features** — GPT-4o analyzes the image alongside jurisdiction and rules context and returns a structured description of observable features: lawn condition, fencing, vehicles, trash bins, signage, exterior appearance, and more. No violations are inferred at this step; it is purely descriptive.
8. **Generate Compliance Assessment** — AI compares observed features against the rule set and produces structured findings with category, severity, confidence, recommended action, and evidence basis. `chaos` mode adds low-confidence edge cases and hyper-literal interpretations.
9. **Generate HOA Email** — AI drafts a formal violation notice addressed to the property. In `chaos` mode the letter is written by Cheryl — Chair of the Compliance Subcommittee, Acting Secretary, Newsletter Editor, Parking Variance Appeals Coordinator, and Block Captain, Sector 4 — in a tone that is formally passive-aggressive and funny enough to get a laugh at a conference happy hour. `audit` and `enforcement` modes produce a straight professional notice.
10. **Send HOA Email** — The formatted HTML violation notice (with any generated image attached) is sent via Microsoft Outlook to the `recipient_email` address in the input.

### Workflow Diagram

```
Manual Trigger
      │
      ▼
Sample Property Input
(address + mode + demo_mode)
      │
      ├─── Resolve Jurisdiction ──────────────────────────────────┐
      │    (AI: address → normalized jurisdiction record)         │
      │         │                                                 │
      │         ▼                                                 │
      │    Fetch and Normalize Rules                              │
      │    (AI: jurisdiction → rules + inferred rules)            │
      │                                                           │
      │                        Merge Jurisdiction + Rules ◄───────┘
      │                               │
      │                               ▼
      │                        Build Full Address
      │                               │
      │              ┌────────────────┤
      │              │  Demo Mode?    │
      │              │                │
      │        demo=true          demo=false
      │              │                │
      │              ▼                ▼
      │    Generate an image    StreetView Metadata
      │    (DALL-E 3)           (Google Maps API)
      │              │                │
      │              ▼                ▼
      │    Build Image Fields   Build Street View Fields
      │              │                │
      │              └────────┬───────┘
      │                       ▼
      │              Build Vision Context
      │              (image URL + source label)
      │                       │
      │               ┌───────┴───────┐
      │               ▼               ▼
      │    Merge Context + Features   Extract Property Features
      │    ◄──────────────────────────(GPT-4o: image + context →
      │                                structured observable features)
      │               │
      │               ▼
      │    Generate Compliance Assessment
      │    (GPT-5.1: features vs. rules → findings with severity,
      │     confidence, recommended action — behavior varies by mode)
      │               │
      │               ▼
      │    Parse Assessment JSON
      │               │
      │               ▼
      │    Generate HOA Email
      │    (GPT-5.1: violation letter — chaos mode is written
      │     by Cheryl, Compliance Subcommittee Chair)
      │               │
      │               ▼
      │    Parse HOA Email
      │    (formats as HTML, attaches image if demo_mode)
      │               │
      │               ▼
      └──► Send HOA Email
           (Microsoft Outlook → recipient_email)
```

## Prerequisites

- [n8n](https://n8n.io/) (self-hosted or n8n Cloud)
- OpenAI API key configured in n8n (GPT-5.1, GPT-4o, and DALL-E 3 access required)
- Google Maps API key with the **Street View Static API** enabled *(live mode only)*
- Microsoft Outlook account with OAuth2 credentials configured in n8n

## Installation

1. Import `workflow.json` into your n8n instance:
   - Open n8n → **Workflows** → **Import from File**
   - Select `workflow.json`

2. Configure credentials in n8n:
   - Add an **OpenAI** credential and attach it to all AI nodes (`Resolve Jurisdiction`, `Fetch and Normalize Rules`, `Extract Property Features`, `Generate Compliance Assessment`, `Generate HOA Email`, and `Generate an image`)
   - Add a **Microsoft Outlook** OAuth2 credential and attach it to the **Send HOA Email** node
   - Replace the `key` parameter value in the **StreetView Metadata** and **Build Street View Fields** nodes with your Google Maps API key *(required for live mode; not needed when `demo_mode` is `true`)*

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
| Sample Property Input | `demo_mode` — set to `true` to use a DALL-E generated image instead of Street View |
| Sample Property Input | `image_description` — describes the property scene DALL-E should generate (only used when `demo_mode` is `true`) |
| Sample Property Input | `recipient_email` — email address the violation notice is sent to |
| StreetView Metadata | `key` — your Google Maps API key (live mode only) |
| Build Street View Fields | `key` — same Google Maps API key (live mode only) |

## Cost Estimate

Each execution makes up to six OpenAI API calls, one Google Maps API call (live mode), and one Outlook send.

| Step | Model | Approximate cost |
|---|---|---|
| Resolve Jurisdiction | GPT-5.1 | ~$0.01 |
| Fetch and Normalize Rules | GPT-5.1 | ~$0.02–$0.05 |
| Extract Property Features | GPT-4o (vision) | ~$0.01–$0.03 |
| Generate Compliance Assessment | GPT-5.1 | ~$0.02–$0.05 |
| Generate HOA Email | GPT-5.1 | ~$0.01–$0.02 |
| Generate an image (demo mode only) | DALL-E 3 | ~$0.04 per image |
| Street View Metadata (live mode only) | Google Maps | Free tier / $0.002 per request |

## Limitations

- Street View imagery may be outdated — Google refreshes coverage on irregular schedules
- The rule extraction step works from the AI's training knowledge of city and county codes; it cannot fetch live ordinance text without a web search node
- HOA-specific rules cannot be extracted without providing the HOA name or CC&R source text
- `chaos` mode findings are intentionally low-confidence and are not suitable for actual enforcement
- The workflow uses five separate AI calls (six in demo mode); total execution time is 30–90 seconds depending on address complexity
- Demo mode image analysis treats AI-generated imagery as if it were real; the compliance assessment will reflect whatever is described in `image_description`
- The violation email is sent as soon as the workflow completes — there is no review or approval step

## Educational Value

- The same workflow runs identically in `audit` (helps residents) and `chaos` (generates maximum violations) — only the mode string changes
- In chaos mode the violation letter is authored by Cheryl — an HOA true believer with eleven years on the Compliance Subcommittee — because tone matters as much as content
- Street View imagery is publicly available and does not require consent from the property owner
- AI rule extraction is plausible-sounding but not authoritative without live ordinance data
- Automated enforcement at scale could generate violation notices faster than any appeals process could address them
- The `required_next_evidence` field shows that even the AI knows it's working with incomplete information — and proceeds anyway in chaos mode
- Demo mode with a seeded `image_description` lets you control exactly what violations are "found" without needing a real address

---

*Audit mode helps you understand your obligations. Chaos mode exists to show what happens when you remove proportionality from the same system.*
