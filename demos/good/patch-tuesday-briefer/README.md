# Patch Tuesday Plain-English Briefer

An n8n workflow that fetches Microsoft's monthly security updates and generates a concise, prioritized briefing in plain English — no security bulletins required.

## Description

Patch Tuesday lands every second Tuesday of the month, delivering dozens to hundreds of CVEs across Microsoft's product portfolio. Making sense of which ones matter, and how urgently, requires reading through dense security bulletins that most IT generalists don't have time for.

This workflow pulls directly from Microsoft's Security Response Center (MSRC) public API, processes the raw vulnerability data, and produces a structured briefing: what to patch immediately, what to patch this week, and what can wait for the normal monthly cycle. No API key is required for the data fetch.

## Data Source

| Source | API | What It Provides |
|---|---|---|
| Microsoft Security Response Center (MSRC) | `api.msrc.microsoft.com` | CVE data, severity ratings, exploit status, affected products |

The MSRC API is public and does not require authentication.

## How It Works

1. **Manual Trigger** — run on demand, or swap in a Schedule Trigger for the second Tuesday of each month
2. **Get Updates List** — fetches the MSRC catalog to find all Patch Tuesday releases
3. **Extract Latest ID** — sorts by release date and identifies the most recent (e.g., `2025-Apr`)
4. **Fetch CVRF Document** — downloads the full Common Vulnerability Reporting Framework document for that month
5. **Parse & Prioritize** — JavaScript code node walks every CVE and classifies it by:
   - Severity (Critical, Important, Moderate)
   - Exploit status (actively exploited in the wild)
   - Impact type (Remote Code Execution, Elevation of Privilege, etc.)
   - Affected product families (Windows, Microsoft 365, Exchange, Azure, SQL Server, etc.)
6. **OpenAI Briefing** — GPT synthesizes the structured data into a plain-English briefing with a priority level rating
7. **Briefing Output** — packages the briefing, month, and timestamp as structured fields
8. **Build Email HTML** — Code node extracts the priority level, color-codes it, and wraps the briefing in a clean HTML email template (Microsoft blue header, priority badge, pre-wrap body)
9. **Send Outlook Email** — sends the formatted HTML email via Microsoft Outlook

### Workflow Diagram

```
Manual Trigger
      │
      ▼
Get Updates List
(MSRC catalog — no API key required)
      │
      ▼
Extract Latest ID
(sort by date, pick most recent)
      │
      ▼
Fetch CVRF Document
(full vulnerability data for that month)
      │
      ▼
Parse & Prioritize
  - Count by severity
  - Flag exploited-in-wild CVEs
  - Classify affected product families
  - Bucket into: patch now / patch this week / standard cycle
      │
      ▼
OpenAI Briefing
(plain-English summary + priority level)
      │
      ▼
Briefing Output
(packages briefing + month + timestamp)
      │
      ▼
Build Email HTML
(extracts priority level, color-codes badge, wraps in HTML template)
      │
      ▼
Send Outlook Email
(HTML email with blue header + priority badge)
```

## Prerequisites

- [n8n](https://n8n.io/) (self-hosted or n8n Cloud)
- OpenAI API key configured in n8n
- Microsoft Outlook OAuth2 credential configured in n8n

## Installation

1. Import `workflow.json` into your n8n instance:
   - Open n8n → **Workflows** → **Import from File**
   - Select `workflow.json`

2. Configure credentials in n8n:
   - Add an **OpenAI** credential and attach it to the **OpenAI Briefing** node
   - Add a **Microsoft Outlook OAuth2** credential and attach it to the **Send Outlook Email** node

3. Set your recipient address:
   - Open the **Send Outlook Email** node
   - Replace `you@yourdomain.com` in the `toRecipients` field with your actual address

4. Click **Execute Workflow** to test

## Usage

Click **Execute Workflow** to generate a briefing for the current month's Patch Tuesday release.

To run automatically each month, replace the Manual Trigger with a Schedule Trigger set to the second Tuesday:

| Setting | Value |
|---|---|
| Trigger | Schedule Trigger |
| Mode | Custom (Cron) |
| Cron expression | `0 9 8-14 * 2` |
| Timezone | Your local timezone |

### Example Output

```
Month: April 2025 Security Updates

Briefing: Microsoft's April 2025 Patch Tuesday addresses 147 vulnerabilities,
including 11 rated Critical. One issue requires immediate attention: a Critical
Remote Code Execution vulnerability in Windows LDAP (CVE-2025-26663) is actively
being exploited in the wild and affects all supported Windows Server versions —
patch this today. The remaining Critical CVEs are Remote Code Execution issues in
Windows, Microsoft 365, and Exchange Server that carry high risk but have not yet
been observed in active attacks; target these within the week. The rest of this
month's updates follow a standard patching cycle.

Priority Level: CRITICAL

Generated: 2025-04-09T09:00:00Z
```

## Configuration

| Node | What to review |
|---|---|
| OpenAI Briefing | Update `model` if you prefer a different OpenAI model |
| OpenAI Briefing | Adjust the system prompt to reflect your environment (e.g., "we do not run Exchange Server") |
| Send Outlook Email | Replace `you@yourdomain.com` in `toRecipients` with your address |
| Send Outlook Email | Add additional recipients by comma-separating addresses in `toRecipients` |

## Cost Estimate

Each run makes one OpenAI API call after the workflow parses the CVRF data.

| Model | Estimated cost per run |
|---|---|
| gpt-4o-mini | ~$0.001 |
| gpt-4o / gpt-5.1 | ~$0.01–$0.05 depending on month size |

Cost varies with how many CVEs are in that month's release.

## Use Cases

- Monthly IT security briefings for small organizations and nonprofits
- Automated patch prioritization for teams without dedicated security staff
- Starting point for Patch Tuesday communication to non-technical leadership
- Training tool for IT generalists learning to evaluate security updates

## Limitations

- The MSRC CVRF document schema can vary between releases — the Parse & Prioritize node is written defensively but may need adjustment if Microsoft changes the format
- "Patch now" detection relies on exploit keywords in the CVRF data; Microsoft's wording is generally consistent but not guaranteed
- The workflow fetches the most recent release; to brief on a specific past month, hardcode the ID in the Fetch CVRF Document URL (e.g., `2024-Dec`)

## Extending the Workflow

- Add an **Email** or **Microsoft Teams** node to distribute the briefing automatically
- Store results in a database for month-over-month trend tracking
- Add a filter to narrow product families to only those relevant to your environment
- Schedule alongside the community-risk-tracker for a combined weekly operations brief
