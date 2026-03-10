# GitHub Issue Generator

An "evil" n8n automation that automatically generates AI-powered GitHub issues for your own PowerShell scripts — whether you asked for a code review or not!

## Description

This is an **"evil"** automation example that demonstrates what happens when you combine AI code review with unsolicited helpfulness. The workflow scans your GitHub repositories for PowerShell scripts, runs them through an AI model acting as an opinionated senior engineer, and files GitHub issues with observations, concerns, and suggested improvements — all without anyone asking.

> **WARNING**: This is a demonstration of over-eager automation. The node that creates issues is **disabled by default**. Enable it only in safe demo environments.

## How It Works

The workflow follows these steps:

1. **Manual Trigger** — The workflow starts when you click "Execute workflow" in n8n.
2. **Get Repos** — Fetches all public repositories for the configured GitHub user (`donnietaylor`).
3. **Get Issues** — Checks each repository for existing open issues created by the same user.
4. **If (No Issues)** — Only proceeds if there are no existing open issues in the repository. This prevents spamming repos that already have open feedback.
5. **Get Files** — Retrieves the full file tree of the repository's default branch.
6. **Split Out** — Expands the file tree into individual file records.
7. **Filter** — Keeps only `.ps1` (PowerShell) files.
8. **Code in JavaScript** — Groups the `.ps1` files by repository and randomly selects one file per repo to review.
9. **HTTP Request** — Downloads the raw contents of the selected PowerShell file from GitHub.
10. **Message a model** — Sends the file contents to an OpenAI model (GPT-5.2-Codex) with a prompt instructing it to act as a senior PowerShell engineer. The AI generates a structured GitHub issue containing:
    - `## Observations` — A summary of findings focused on issues
    - `## Concerns` — Anything risky, inefficient, or eyebrow-raising
    - `## Suggested Improvements` — Specific, actionable fixes
11. **Create an issue** *(disabled by default)* — Parses the AI response and creates a GitHub issue in the target repository.

### Workflow Diagram

```
Manual Trigger
     │
  Get Repos
     │
  Get Issues
     │
  If (no open issues?)
     │ Yes
  Get Files
     │
  Split Out
     │
  Filter (.ps1 files only)
     │
  Code in JavaScript (pick 1 random file per repo)
     │
  HTTP Request (download file contents)
     │
  Message a model (AI code review → JSON issue)
     │
  Create an issue  ← DISABLED BY DEFAULT
```

## Prerequisites

- [n8n](https://n8n.io/) (self-hosted or cloud)
- A **GitHub Personal Access Token** with `repo` scope (to read files and create issues)
- An **OpenAI API key** with access to the target model

## Setup

### 1. Import the Workflow

1. Open your n8n instance at `http://localhost:5678` (or your hosted URL).
2. Click **Import from File**.
3. Select `workflow.json` from this directory.

### 2. Configure Credentials

In n8n, set up the following credentials and attach them to the corresponding nodes:

| Credential | Node(s) |
|---|---|
| **GitHub API** (Personal Access Token) | Get Repos, Get Issues, Get Files, Create an issue |
| **OpenAI API** | Message a model |

### 3. Update the GitHub Username

In the **Get Repos** node, change the `owner` value from `donnietaylor` to your own GitHub username.

The **Get Issues** node URL filter (`creator=donnietaylor`) should also be updated to match your username if you want the "skip repos with existing issues" check to work correctly.

### 4. Enable Issue Creation (Optional)

The **Create an issue** node is **disabled** by default. To enable it:

1. Right-click the **Create an issue** node.
2. Select **Enable**.

> **⚠️ Caution**: Enabling this node will create real GitHub issues in your repositories. Only do this in a safe demo environment and be prepared to close the generated issues afterward.

## Configuration

| Setting | Where to Change | Default |
|---|---|---|
| GitHub username | **Get Repos** node → `owner` field | `donnietaylor` |
| Issue creator filter | **Get Issues** node → URL query param `creator=` | `donnietaylor` |
| AI model | **Message a model** node → `modelId` | `gpt-5.2-codex` |
| File type filter | **Filter** node → condition value | `.ps1` |

## Example Output

The AI generates a JSON response that gets parsed into a GitHub issue:

**Issue Title:**
```
Missing error handling and hardcoded credentials in deploy.ps1
```

**Issue Body:**
```markdown
## Observations
- No `try/catch` blocks around external API calls
- Credentials appear to be hardcoded on lines 12 and 47
- Script exits silently on failure with no error output

## Concerns
The hardcoded credentials are a security risk and should be moved to environment
variables or a secrets manager immediately. Silent failures make debugging
significantly harder than it needs to be.

## Suggested Improvements
- Wrap API calls in `try/catch` with `Write-Error` or logging
- Replace hardcoded values with `$env:MY_API_KEY` references
- Add `-ErrorAction Stop` to cmdlets that should halt execution on failure
```

## Safety Features

- **Issue creation is disabled by default** — the final node must be explicitly enabled.
- **Skips repos with existing open issues** — avoids flooding repositories with duplicate feedback.
- **Reviews only one random file per repository** — limits the blast radius per run.
- **Manual trigger only** — the workflow does not run on a schedule.

## Educational Value

This example demonstrates:

- **Unsolicited automation**: Automating things people didn't ask for creates friction and noise.
- **AI-generated content at scale**: Useful in controlled contexts; chaotic when unleashed without guardrails.
- **Importance of kill switches**: The disabled node pattern shows why automation should have easy off switches.
- **GitHub API integration**: How to read repo contents and create issues programmatically with n8n.
- **Conditional logic**: Using the `If` node to prevent duplicate work.

## Resetting After a Demo

If you enabled issue creation during a demo, close the generated issues afterward:

1. Go to your GitHub repository.
2. Filter issues by label or search for the AI-generated titles.
3. Close or delete the demo issues.

## Disclaimer

This is a **humorous demonstration** of over-eager AI automation. Do not deploy this in production or against repositories you do not own. Always obtain permission before creating issues in shared repositories.

---

*Remember: Just because you* can *automate a code review doesn't mean your colleagues want one at 3 AM.*
