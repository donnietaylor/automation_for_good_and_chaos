# Simple Code Formatter

A helpful automation that formats code files according to best practices.

## Description

This is a "good" automation example that demonstrates how AI can help maintain code quality by automatically formatting code files with proper style and conventions.

## Features

- ✅ Formats Python, JavaScript, and TypeScript files
- ✅ Applies consistent style guidelines
- ✅ Preserves code functionality
- ✅ Provides clear diff of changes
- ✅ Backs up original files

## Prerequisites

- PowerShell 7+ (or Windows PowerShell 5.1)
- OpenAI API key

## Installation

```powershell
# Set up environment variables
Copy-Item .env.example .env
# Edit .env and add your OPENAI_API_KEY
```

## Usage

```powershell
# Format a single file
.\formatter.ps1 -Path path\to\file.py

# Format all files in a directory
.\formatter.ps1 -Path path\to\directory -Recursive

# Dry run (preview changes without applying)
.\formatter.ps1 -Path path\to\file.py -DryRun
```

## How It Works

1. Reads the code file
2. Sends to OpenAI API with formatting instructions
3. Receives formatted code
4. Shows diff of changes
5. Applies changes if approved

## Example

**Before:**
```python
def hello(name):
  print("Hello "+name)
  return None
```

**After:**
```python
def hello(name: str) -> None:
    """Greet a person by name."""
    print(f"Hello {name}")
```

## Configuration

Edit `.env` to configure:

```env
OPENAI_API_KEY=your_api_key_here
OPENAI_MODEL=gpt-4  # or gpt-3.5-turbo for lower cost
```

## Cost Estimate

- Small file (~100 lines): ~$0.01
- Medium file (~500 lines): ~$0.05
- Large file (~1000 lines): ~$0.10

## Safety Features

- Creates backup before modifying
- Requires confirmation for changes
- Dry-run mode available

## Demo Script

For presentations:

```powershell
# Show messy code
Get-Content example_messy.py

# Run formatter
.\formatter.ps1 -Path example_messy.py

# Show formatted result
Get-Content example_messy.py
```

## Limitations

- Requires internet connection
- API rate limits apply
- May not handle very large files
- Occasional formatting quirks

## Alternative Approaches

For production use, consider:
- Black (Python)
- Prettier (JavaScript/TypeScript)
- ESLint (JavaScript/TypeScript)

This AI-based approach is best for:
- Mixed language projects
- Custom style requirements
- Learning and demonstration
