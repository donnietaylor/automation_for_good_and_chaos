# Daily Handoff

An n8n workflow that gathers your most important GitHub, email, calendar, and Azure updates into a single daily markdown handoff.

## Description

This is a "good" automation example that demonstrates how AI can reduce context-switching at the start of the day. The workflow collects updates from GitHub, Microsoft Outlook, your calendar, and the Azure release feed, then uses an OpenAI summarization step to create a concise handoff document.

The generated summary is written back to a GitHub repository as a markdown file, making it easy to review, share, or archive as part of your daily workflow.

## Features

- Runs on a daily schedule
- Collects GitHub issues and pull requests across repositories
- Pulls recent Outlook email messages
- Pulls upcoming calendar events
- Reads Azure release feed updates from the last 7 days
- Uses OpenAI to summarize the most important items
- Saves the final handoff as a markdown file in GitHub

## Prerequisites

- [n8n](https://n8n.io/) (self-hosted or n8n Cloud)
- GitHub credential with access to read repositories and create files
- Microsoft Outlook OAuth2 credential
- OpenAI API key
- A target GitHub repository where handoff files should be stored

## Installation

1. Import `daily-handoff.json` into your n8n instance:
   - Open n8n -> **Workflows** -> **Import from File**
   - Select `daily-handoff.json`

2. Configure credentials in n8n:
   - Add a **GitHub** credential
   - Add a **Microsoft Outlook OAuth2** credential
   - Add an **OpenAI** credential

3. Review the workflow configuration before activating it:
   - Update the GitHub owner and repository in the **Create a file** node
   - Confirm the GitHub user in the repository lookup nodes
   - Review the schedule in the **Schedule Trigger** node
   - Confirm the calendar selection in the Outlook calendar nodes

## Usage

1. Open the imported workflow in n8n
2. Click **Execute Workflow** to test it manually
3. Verify that the workflow:
   - Pulls GitHub issues and pull requests
   - Pulls recent Outlook messages
   - Pulls upcoming calendar events
   - Reads recent Azure RSS items
   - Produces a markdown summary
   - Commits the summary to the configured GitHub repository
4. Activate the workflow to let it run automatically each day

### Example Output

```markdown
# GitHub - key issues and PRs
- PR #142 in automation_for_good_and_chaos needs review before today's demo.
- Issue #87 in internal-tools is blocked on API credentials.

# Email - important messages
- Message from Alex requests slides for the afternoon session.
- Message from Operations confirms the production maintenance window.

# Calendar - upcoming events
- 9:00 AM standup with Engineering.
- 1:30 PM presentation rehearsal with the community team.

# Azure RSS - updates from the last 7 days
- Azure OpenAI Service posted a new product update relevant to model deployments.
- Azure Logic Apps released a connector update that may affect existing workflows.
```

## How It Works

```
Schedule Trigger
      |
      v
Fetch GitHub repositories, issues, and pull requests
      |
      +--> Fetch recent Outlook email messages
      |
      +--> Fetch upcoming calendar events
      |
      +--> Fetch Azure RSS updates from the last 7 days
      |
      v
Normalize and merge all collected data
      |
      v
OpenAI summarization step
      |
      v
Create markdown handoff file in GitHub
```

## Configuration

| Node | What to review |
|---|---|
| Schedule Trigger | Adjust the run time for your day |
| Get a user's repositories | Update the GitHub owner if needed |
| Get many messages | Review the recent-email window and mailbox access |
| Get many events | Confirm the calendar source and event filter |
| RSS Read | Replace or extend the Azure RSS feed if needed |
| OpenAI Chat Model | Select a different model if you want different cost/performance |
| Summarization Chain | Change the prompt to match your preferred handoff style |
| Create a file | Set the output repository, path, and commit behavior |

## Cost Estimate

Each run makes one OpenAI summarization call after the workflow aggregates the source data.

| Model | Estimated cost per run |
|---|---|
| gpt-4.1-mini | Low cost for short daily summaries |
| Larger OpenAI models | Higher cost with potentially stronger summarization |

Actual cost depends on how many GitHub items, emails, calendar events, and RSS entries are included in each run.

## Use Cases

- Personal daily startup brief
- Team lead morning handoff notes
- Project manager status review
- Demo-day preparation checklist
- Shared repository of daily operational summaries

## Limitations

- Requires working GitHub, Outlook, and OpenAI credentials
- Output quality depends on the quality and volume of input data
- The summary only reflects the sources included in the workflow
- The workflow writes to a configured GitHub repository, so repository access must be granted in advance

## Extending the Workflow

- Send the handoff to Microsoft Teams, Slack, or email after generation
- Store summaries in a database or knowledge base for historical search
- Add filters for specific repositories, senders, or event types
- Include additional feeds such as internal status pages or ticketing systems
