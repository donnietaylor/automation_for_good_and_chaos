# Civic Data Briefer

An n8n workflow that pulls recent city council legislative activity and generates a plain-English briefing for community organizations and nonprofits.

## Description

Community organizations depend on local government decisions — zoning changes, contract awards, budget amendments — but tracking city council activity requires time that most nonprofits don't have. This workflow queries the Legistar legislative API (used by hundreds of cities across the US), processes the past 30 days of council actions, and produces a structured briefing: what passed, what to watch, and what it means for your community.

No API key is required.

## Data Source

| Source | API | What It Provides |
|---|---|---|
| Legistar WebAPI | `webapi.legistar.com` | Ordinances, resolutions, committee actions, matter status |

Legistar is the legislative management platform used by Chicago, Minneapolis, New York City, Los Angeles, Seattle, and hundreds of other municipalities. The API is public and requires no authentication.

## How It Works

1. **Manual Trigger** — run on demand, or swap in a Schedule Trigger for weekly delivery
2. **Build Date Window** — calculates the ISO date string for 30 days ago, passed as a filter to the API
3. **Fetch Legislative Actions** — queries the Legistar API for matters updated within that window, sorted newest first
4. **Parse & Categorize** — JavaScript code node walks every matter and builds:
   - Count by action type (Ordinance, Resolution, Report, etc.)
   - Count by status (Passed, Tabled, Referred, etc.)
   - A list of up to 10 notable items that passed or were adopted
5. **AI Briefing** — GPT synthesizes the structured data into a plain-English briefing with an engagement level rating
6. **Briefing Output** — packages the briefing, city, and timestamp as structured fields
7. **Send Outlook Email** — sends the plain text briefing via Microsoft Outlook

### Workflow Diagram

```
Manual Trigger
      │
      ▼
Build Date Window
(calculates 30-day lookback, ISO date string)
      │
      ▼
Fetch Legislative Actions
(Legistar API — no API key required)
      │
      ▼
Parse & Categorize
  - Count by action type
  - Count by status
  - Collect notable items that passed
      │
      ▼
AI Briefing
(plain-English summary + engagement level)
      │
      ▼
Briefing Output
(packages briefing + city + timestamp)
      │
      ▼
Send Outlook Email
(plain text briefing)
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
   - Add an **OpenAI** credential and attach it to the **AI Briefing** node
   - Add a **Microsoft Outlook OAuth2** credential and attach it to the **Send Outlook Email** node

3. Set your recipient address:
   - Open the **Send Outlook Email** node
   - Replace `you@yourdomain.com` in the `toRecipients` field with your actual address

4. Click **Execute Workflow** to test

## Usage

Click **Execute Workflow** to generate a briefing covering the past 30 days of city council activity.

To run automatically each week:

| Setting | Value |
|---|---|
| Trigger | Schedule Trigger |
| Mode | Custom (Cron) |
| Cron expression | `0 8 * * 1` |
| Timezone | Your local timezone |

### Example Output

```
City: Chicago

Briefing: The Chicago City Council had a moderately active month, processing 38
legislative matters — primarily routine ordinances, contract approvals, and
committee reports. The most notable action was the passage of an ordinance
authorizing a $4.2 million agreement for affordable housing construction in the
Pilsen neighborhood, along with several contract awards to community service
providers. Three resolutions recognizing community organizations were adopted. A
proposed zoning amendment in the Near North Side was referred to the Zoning
Committee and is worth watching for community organizations operating in that
area. The volume and mix of actions reflects a typical mid-cycle month, with no
extraordinary emergency measures.

Engagement Level: MODERATE

Generated: 2025-04-25T08:00:00Z
```

## Configuration

| Node | What to review |
|---|---|
| Build Date Window | Change `daysBack` from `30` to `7` for a weekly briefing |
| Fetch Legislative Actions | Replace `chicago` in the URL with your city's Legistar client name |
| Fetch Legislative Actions | Adjust `$top` if you want more or fewer results (max 1000) |
| AI Briefing | Update the system prompt to mention your city name and the types of issues you care about |
| AI Briefing | Update `model` if you prefer a different OpenAI model |
| Send Outlook Email | Replace `you@yourdomain.com` with your address |

## Adapting to Your City

Replace `chicago` in the **Fetch Legislative Actions** URL with your city's Legistar client name:

| City | Client Name |
|---|---|
| Chicago, IL | `chicago` |
| Minneapolis, MN | `minneapolis` |
| New York City, NY | `nyc` |
| Los Angeles, CA | `lacity` |
| Seattle, WA | `seattle` |
| San Francisco, CA | `sfgov` |
| Boston, MA | `boston` |
| Denver, CO | `denver` |

To find the client name for any Legistar city, visit `webapi.legistar.com/v1/{clientname}/matters` — if it returns JSON, the client name is valid. The full list of Legistar clients is publicly discoverable.

## Cost Estimate

Each run makes one OpenAI API call after parsing the legislative data.

| Model | Estimated cost per run |
|---|---|
| gpt-4o-mini | ~$0.001 |
| gpt-4o / gpt-5.1 | ~$0.005–$0.02 depending on activity volume |

## Limitations

- The Legistar API caps responses at 1000 items per request; very active councils may require pagination
- `$top=50` is set by default — increase it for cities with high monthly volume
- Matter title truncation at 200 characters may cut off detail for the AI; increase if needed
- "Notable" items are filtered to `Passed` and `Adopted` status — review your city's status names and adjust if needed

## Extending the Workflow

- Filter by `MatterTypeName` to focus only on ordinances or only on contracts
- Add a second HTTP request to `/v1/{client}/events` to include upcoming meeting dates
- Store results in a database or spreadsheet for month-over-month trend tracking
- Combine with the patch-tuesday-briefer on a shared schedule for a monthly community operations digest
