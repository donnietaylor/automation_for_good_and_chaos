# Emoji Chaos Bot

An "evil" automation that adds way too many emojis to your text communications!

## Description

This is an **"evil"** automation example that demonstrates what happens when automation goes overboard. It takes normal, professional text and transforms it into emoji-laden chaos!

## Features

- Adds random emojis after every few words
- RANDOMLY CAPITALIZES things
- Multiplies exclamation points!!!
- Asks unnecessary questions???
- Makes everything sound more exciting than it is

## Warning

This is intentionally problematic for demonstration purposes! 

**DO NOT use this for actual business communications!**

## Prerequisites

- Python 3.9+
- No external API keys needed (pure chaos!)

## Installation

```bash
# Install dependencies
pip install -r requirements.txt

# Set up environment variables
cp .env.example .env
# Edit .env and add your OPENAI_API_KEY
```

## Usage

```bash
# Transform a text file
python emoji_bot.py input.txt

# Transform clipboard content
python emoji_bot.py --clipboard

# Set chaos level (1-10, default 7)
python emoji_bot.py input.txt --chaos-level 10
```

## Example Transformations

**Original:**
```
Team, please review the quarterly report. 
The meeting is scheduled for Tuesday at 2 PM.
Let me know if you have questions.
```

**After Emoji Chaos (Level 5):**
```
Team 🎉, please REVIEW 📊 the quarterly report!!! 🚀
The meeting 📅 is scheduled for Tuesday ⭐ at 2 PM!!! ⏰
Let me KNOW 🤔 if you have questions??? 💭 
This is SO EXCITING!!! 🎊🎉🎈
```

**After Emoji Chaos (Level 10):**
```
TEAM 🎉🎉🎉, PLEASE REVIEW 📊📈💼 the QUARTERLY report!!!!!!! 🚀🚀🚀
The MEETING 📅📅 is SCHEDULED ⭐⭐⭐ for TUESDAY ⏰⏰⏰ at 2 PM!!!!!!!!! 🎯🎯
Let me KNOW 🤔🤔🤔 if you have QUESTIONS????????? 💭💭💭
This is SO INCREDIBLY AMAZING EXCITING!!!!!!!!!! 🎊🎉🎈🎆🎇✨💫⭐🌟
WOW!!! 🤩🤩🤩 Can you BELIEVE this???!!! 😱😱😱
```

## Chaos Levels

- **Level 1-3**: Mild (occasional emoji, some caps)
- **Level 4-6**: Moderate (regular emojis, frequent caps)
- **Level 7-8**: High (lots of emojis, mostly caps)
- **Level 9-10**: MAXIMUM CHAOS!!! (ALL CAPS, EMOJI EVERYWHERE!!!)

## How It Works

1. Reads your boring, professional text
2. Identifies "boring" words that need excitement
3. Adds emojis based on chaos level
4. Randomly capitalizes words
5. Multiplies punctuation
6. Uses rule-based enthusiasm amplification

## Configuration

Edit `.env` to configure:

```env
DEFAULT_CHAOS_LEVEL=7
```

## Safety Features

- Limited to text files only
- Creates backup before modifying
- Dry-run mode available
- Easy to disable
- Undo function included

## Demo Script

For presentations:

```bash
# Show professional email
cat professional_email.txt

# Run emoji chaos bot
python emoji_bot.py professional_email.txt --chaos-level 8

# Show the hilarious result
cat professional_email.txt

# Restore original (from backup)
python emoji_bot.py --restore professional_email.txt
```

## Educational Value

This example demonstrates:

- **Over-automation**: Not everything needs to be "enhanced"
- **Context ignorance**: One size doesn't fit all
- **User experience**: Sometimes less is more
- **Testing is crucial**: Always test automation before deploying
- **User control**: Give users options to disable/configure

## Real-World Lessons

1. **Automation should enhance, not overwhelm**
2. **Consider your audience and context**
3. **Provide sensible defaults and limits**
4. **Always allow users to opt-out**
5. **Test in safe environments first**

## Disclaimer

This is a **humorous demonstration tool**. Please use automation responsibly in real-world scenarios! The goal is to show what can go wrong when automation isn't thoughtfully designed.

## Undo Changes

```bash
# Restore from backup
python emoji_bot.py --restore filename.txt

# Restore all files in directory
python emoji_bot.py --restore-all ./
```

## Pro Tip

Want to actually annoy your friends (harmlessly)? This is the tool! 
Just don't use it on actual work communications...

---

*Remember: With great power comes great responsibility... to not annoy everyone!*
