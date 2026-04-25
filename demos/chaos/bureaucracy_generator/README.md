# Bureaucracy Generator

A chaos automation that transforms simple email requests into absurdly complex bureaucratic processes — meetings, committees, stakeholder notifications, and action items included.

## Description

This is a chaos automation example that demonstrates what happens when AI is deployed without proportionality. The workflow monitors incoming emails and automatically generates over-the-top bureaucratic responses: risk assessments, cross-functional alignment meetings, stakeholder escalation chains, and committee formations — all triggered by whatever landed in your inbox.

> **WARNING**: Meeting and email nodes are **disabled by default**. Enable them only in controlled demo environments.

## How It Works

1. **Email Trigger** — Monitors Microsoft Outlook for new emails (polls every minute)
2. **Extract Email Details** — Captures sender, subject, body, and timestamp
3. **Bureaucracy Engine** — AI analyzes the email and generates an over-the-top response plan as structured JSON
4. **Parse Chaos Plan** — Splits the AI output into discrete deliverables
5. **Generate Outputs** — Produces in parallel:
   - A reply email with unnecessary clarifying questions
   - Three meeting invitations with urgency ratings
   - Three stakeholder notification emails to increasingly fictional roles
   - Five action items that multiply the original workload
   - Two committee formation proposals with meeting cadences
6. **Chaos Dashboard** — Displays the total bureaucratic overhead created

### Workflow Diagram

```
Email Trigger (Outlook — polls every 1 min)
     │
Extract Email Details
     │
Bureaucracy Engine (AI → JSON chaos plan)
     │
Parse Chaos Plan
     │
     ├── Reply Email (clarifying questions)     ← disabled by default
     ├── Meeting Invites × 3                    ← disabled by default
     ├── Stakeholder Emails × 3                 ← disabled by default
     ├── Action Items × 5
     └── Committee Proposals × 2
     │
Chaos Dashboard (overhead summary)
```

## Prerequisites

- [n8n](https://n8n.io/) (self-hosted or cloud)
- A **Microsoft Outlook** account with OAuth2 credentials configured in n8n
- An **OpenAI API key** configured in n8n

## Setup

1. Open your n8n instance at `http://localhost:5678`.
2. Click **Import from File** and select `workflow.json` from this directory.
3. Configure credentials in n8n:

| Credential | Node(s) |
|---|---|
| **Microsoft Outlook OAuth2** | Email Trigger, Reply Email, Stakeholder Emails |
| **OpenAI API** | Bureaucracy Engine |

4. In the Email Trigger node, add a sender filter so it only processes emails from your demo account — not your entire inbox.
5. Activate the workflow.

## Configuration

| Setting | Where to change | Default |
|---|---|---|
| Email filter | **Email Trigger** node → filter by sender | *(none — set before activating)* |
| AI creativity | **Bureaucracy Engine** node → `temperature` | `0.9` |
| Meeting creation | **Meeting Invites** node | Disabled |
| Stakeholder emails | **Stakeholder Emails** node | Disabled |

## Example Output

**Input email:**
```
Subject: Quick question about lunch
Body: Can we have the team lunch at noon on Friday?
```

**Generated chaos:**
- **Risk Level**: CRITICAL
- **Reply**: Five clarifying questions, including "Have all dietary requirements been formally documented via the Nutritional Alignment Request Form?"
- **Meetings**: "Cross-Functional Lunch Alignment Sync", "Stakeholder Impact Assessment", "Post-Lunch Retrospective Planning"
- **Stakeholders notified**: VP of Culinary Operations, Director of Team Synergy, Chief Experience Officer
- **Action items**: Form lunch committee, create stakeholder matrix, draft risk register, schedule pre-meeting, schedule post-meeting debrief
- **Committees**: "Team Lunch Task Force" (daily cadence), "Lunch Governance Board" (weekly cadence)

## Safety Features

- Reply and meeting nodes are **disabled by default** — must be explicitly enabled
- Email trigger requires a sender filter to prevent processing real mail
- Stakeholder emails are generated but not sent unless the node is enabled
- All output is logged to the chaos dashboard regardless of whether nodes are enabled

## Educational Value

This example demonstrates:

- **Over-automation**: How automation creates more work than it eliminates
- **Context blindness**: Systems that ignore the obvious simplicity of a request
- **Bureaucratic bloat**: The multiplication of process for its own sake
- **AI misuse**: Using AI to complicate rather than simplify
- **Proportionality**: Why the response should match the complexity of the request

## Resetting After a Demo

If you enabled the reply or meeting nodes during a demo:

1. Close or delete any generated calendar events
2. Send a follow-up to any recipients who received stakeholder emails
3. Disable the nodes again before the next run

## Disclaimer

This is a humorous demonstration of automation anti-patterns. Do not deploy against a real inbox or shared calendar without explicit permission from everyone involved.

---

*Remember: The best automation reduces complexity. This one exists to remind you why that matters.*
