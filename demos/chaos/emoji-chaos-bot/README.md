# Emoji Chaos Bot

The evil twin of the simple-code-formatter. Takes clean, well-formatted code and ruins it — scrambled indentation, useless comments, gratuitous emojis — while keeping the code 100% functional.

## Description

Where the simple-code-formatter uses AI to make code better, this uses AI to make code worse. Same OpenAI API call, same file types, same confirmation prompt, opposite result. The code still runs. It just looks like it was written by someone who has never seen an IDE and has very strong feelings about emoji.

> This is a chaos automation example demonstrating that the same tool pattern that does good can be pointed in the wrong direction just as easily.

## How It Works

1. Reads the target code file
2. Sends it to OpenAI with instructions to destroy its formatting while preserving logic:
   - Mixed tabs/spaces, wrong indentation levels, brackets on nonsensical lines
   - Every comment line gets 2–5 random emojis
   - Genuinely helpful comments are replaced with absurd or misleading ones
   - Local variables renamed to things like `mySpecialThing`, `theCounterVibes`, `dataStuffObj`
   - Emojis scattered into string literals and output messages
3. Shows a diff of the damage
4. Asks for confirmation before writing
5. Creates a `.bak` backup before overwriting (unless `–NoBackup`)
6. `-Restore` pulls the backup back and removes it

## Prerequisites

- PowerShell 5.1 or later
- OpenAI API key

## Setup

1. Copy `.env.example` to `.env` and add your API key:

```
OPENAI_API_KEY=sk-...
OPENAI_MODEL=gpt-4o
```

2. Run against the included example:

```powershell
.\chaos-bot.ps1 -Path .\example_clean.ps1
```

## Usage

```powershell
# Chaos-ify a single file
.\chaos-bot.ps1 -Path .\example_clean.ps1

# Preview without applying
.\chaos-bot.ps1 -Path .\example_clean.ps1 -DryRun

# Process a whole directory
.\chaos-bot.ps1 -Path .\src -Recursive

# Restore from backup
.\chaos-bot.ps1 -Path .\example_clean.ps1 -Restore
```

## Demo Arc

This pairs directly with the simple-code-formatter for maximum effect:

1. Show `example_clean.ps1` — readable, well-formatted code
2. Run `chaos-bot.ps1` on it — audience watches the diff
3. Open the output — it's a disaster. It still works. That's the point.
4. Run `-Restore` to bring it back

Or reverse it: start with `example_messy.ps1` from the formatter, clean it up, then chaos-ify the clean version. Same code, three states.

## Supported File Types

| Extension | Language |
|---|---|
| `.ps1` | PowerShell |
| `.js` / `.jsx` | JavaScript |
| `.ts` / `.tsx` | TypeScript |

## Educational Value

- The same AI prompt pattern that makes code better can make it worse
- Unsupervised write access to your codebase is a genuine risk
- Automation without guardrails doesn't care about your intentions
- The `-Restore` flag is always the first thing you should build

## Safety Features

- Confirmation prompt before any file is modified
- `.bak` backup created by default before every write
- `-DryRun` shows the diff without touching anything
- `-Restore` fully reverts the change and removes the backup

---

*The simple-code-formatter and the chaos bot are the same tool wearing different instructions.*
