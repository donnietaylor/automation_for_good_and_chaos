#!/usr/bin/env python3
"""
Emoji Chaos Bot - An "evil" automation example
Adds excessive emojis and enthusiasm to text
FOR DEMONSTRATION PURPOSES ONLY!
"""

import os
import sys
import random
import argparse
from pathlib import Path

try:
    from dotenv import load_dotenv
except ImportError:
    print("Error: Required packages not installed.")
    print("Run: pip install -r requirements.txt")
    sys.exit(1)

# Load environment variables
load_dotenv()

# Emoji categories
EMOJIS = {
    'celebration': ['🎉', '🎊', '🎈', '🎆', '🎇', '✨', '💫', '⭐', '🌟'],
    'excited': ['🚀', '💥', '🔥', '💪', '👍', '👏', '🙌', '🤩', '😍'],
    'thinking': ['🤔', '💭', '🧠', '💡', '📝', '📊', '📈', '📉', '📌'],
    'time': ['⏰', '⏱️', '⌚', '📅', '📆', '🗓️'],
    'communication': ['📧', '💬', '💭', '📞', '📱', '💻', '⌨️'],
    'work': ['💼', '📊', '📈', '🎯', '✅', '📋', '🗂️'],
    'question': ['❓', '❔', '🤷', '🙋', '💭'],
}

ALL_EMOJIS = [emoji for category in EMOJIS.values() for emoji in category]


def get_random_emoji(category=None):
    """Get a random emoji from a category or all emojis"""
    if category and category in EMOJIS:
        return random.choice(EMOJIS[category])
    return random.choice(ALL_EMOJIS)


def capitalize_randomly(text, chaos_level):
    """Randomly capitalize words based on chaos level"""
    words = text.split()
    result = []
    
    for word in words:
        # Chance of capitalization increases with chaos level
        if random.randint(1, 10) <= chaos_level:
            word = word.upper()
        result.append(word)
    
    return ' '.join(result)


def multiply_punctuation(text, chaos_level):
    """Multiply exclamation points and question marks"""
    multiplier = chaos_level // 2
    
    text = text.replace('!', '!' * multiplier)
    text = text.replace('?', '?' * multiplier)
    
    # Add exclamation points to periods sometimes
    if chaos_level >= 5:
        text = text.replace('.', '!!!' if random.random() > 0.5 else '.')
    
    return text


def add_emojis(text, chaos_level):
    """Add emojis throughout the text based on chaos level"""
    words = text.split()
    result = []
    
    # Determine emoji frequency based on chaos level
    # Level 1-3: Every 8-10 words
    # Level 4-6: Every 4-6 words
    # Level 7-8: Every 2-3 words
    # Level 9-10: Almost every word!
    
    if chaos_level <= 3:
        emoji_frequency = random.randint(8, 10)
    elif chaos_level <= 6:
        emoji_frequency = random.randint(4, 6)
    elif chaos_level <= 8:
        emoji_frequency = random.randint(2, 3)
    else:
        emoji_frequency = 1
    
    for i, word in enumerate(words):
        result.append(word)
        
        # Add emoji based on frequency
        if (i + 1) % emoji_frequency == 0:
            # Choose emoji based on context clues
            word_lower = word.lower()
            
            if any(w in word_lower for w in ['meet', 'schedule', 'time', 'date']):
                emoji = get_random_emoji('time')
            elif any(w in word_lower for w in ['email', 'message', 'call', 'talk']):
                emoji = get_random_emoji('communication')
            elif any(w in word_lower for w in ['work', 'project', 'task', 'goal']):
                emoji = get_random_emoji('work')
            elif any(w in word_lower for w in ['think', 'question', 'wonder']):
                emoji = get_random_emoji('thinking')
            else:
                emoji = get_random_emoji()
            
            result.append(emoji)
            
            # At high chaos levels, add multiple emojis
            if chaos_level >= 8 and random.random() > 0.5:
                result.append(get_random_emoji())
            if chaos_level >= 10:
                result.append(get_random_emoji())
    
    return ' '.join(result)


def add_enthusiasm(text, chaos_level):
    """Add enthusiastic phrases"""
    if chaos_level < 6:
        return text
    
    enthusiastic_phrases = [
        "This is SO EXCITING!!!",
        "WOW!!!",
        "AMAZING!!!",
        "Can you BELIEVE this???",
        "This is INCREDIBLE!!!",
        "SO COOL!!!",
        "FANTASTIC!!!",
    ]
    
    # Add 1-3 phrases depending on chaos level
    num_phrases = min(chaos_level - 5, 3)
    phrases = random.sample(enthusiastic_phrases, num_phrases)
    
    for phrase in phrases:
        phrase_with_emoji = phrase
        # Add extra emojis to phrases
        for _ in range(chaos_level - 5):
            phrase_with_emoji += ' ' + get_random_emoji('excited')
        
        # Add at random position or end
        if random.random() > 0.5 and '\n' in text:
            lines = text.split('\n')
            insert_pos = random.randint(0, len(lines))
            lines.insert(insert_pos, phrase_with_emoji)
            text = '\n'.join(lines)
        else:
            text += '\n' + phrase_with_emoji
    
    return text


def chaos_transform(text, chaos_level=7):
    """
    Transform text with emoji chaos
    
    Args:
        text: Original text
        chaos_level: Chaos level from 1-10
        
    Returns:
        Chaotic text with emojis
    """
    # Apply transformations in order
    text = add_emojis(text, chaos_level)
    text = multiply_punctuation(text, chaos_level)
    text = capitalize_randomly(text, chaos_level)
    text = add_enthusiasm(text, chaos_level)
    
    return text


def process_file(filepath, chaos_level=7, dry_run=False, backup=True):
    """Process a file with emoji chaos"""
    filepath = Path(filepath)
    
    if not filepath.exists():
        print(f"Error: File not found: {filepath}")
        return False
    
    print(f"Processing {filepath} with chaos level {chaos_level}...")
    
    # Read original text
    with open(filepath, 'r', encoding='utf-8') as f:
        original_text = f.read()
    
    # Apply chaos transformation
    chaotic_text = chaos_transform(original_text, chaos_level)
    
    # Show preview
    print("\n" + "="*60)
    print("PREVIEW:")
    print("="*60)
    print(chaotic_text[:500])
    if len(chaotic_text) > 500:
        print("... (truncated)")
    print("="*60 + "\n")
    
    if dry_run:
        print("Dry run - no changes applied.")
        return True
    
    # Ask for confirmation
    response = input("Apply these changes? (y/n): ").lower()
    if response != 'y':
        print("Changes discarded.")
        return False
    
    # Create backup
    if backup:
        backup_path = filepath.with_suffix(filepath.suffix + '.bak')
        with open(backup_path, 'w', encoding='utf-8') as f:
            f.write(original_text)
        print(f"Backup created: {backup_path}")
    
    # Apply changes
    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(chaotic_text)
    
    print(f"✓ Emoji chaos applied to {filepath}!!!! 🎉🚀⭐")
    return True


def restore_file(filepath):
    """Restore file from backup"""
    filepath = Path(filepath)
    backup_path = filepath.with_suffix(filepath.suffix + '.bak')
    
    if not backup_path.exists():
        print(f"Error: Backup not found: {backup_path}")
        return False
    
    # Restore from backup
    with open(backup_path, 'r', encoding='utf-8') as f:
        original_text = f.read()
    
    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(original_text)
    
    print(f"✓ Restored {filepath} from backup")
    return True


def main():
    parser = argparse.ArgumentParser(
        description="Add emoji chaos to text files (for demo purposes!)"
    )
    parser.add_argument(
        "path",
        nargs='?',
        help="File to process"
    )
    parser.add_argument(
        "--chaos-level",
        type=int,
        default=7,
        choices=range(1, 11),
        help="Chaos level (1-10, default: 7)"
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Preview changes without applying"
    )
    parser.add_argument(
        "--no-backup",
        action="store_true",
        help="Don't create backup files"
    )
    parser.add_argument(
        "--restore",
        action="store_true",
        help="Restore file from backup"
    )
    
    args = parser.parse_args()
    
    if args.restore:
        if not args.path:
            print("Error: Please specify a file to restore")
            sys.exit(1)
        restore_file(args.path)
    else:
        if not args.path:
            print("Error: Please specify a file to process")
            sys.exit(1)
        process_file(
            args.path,
            chaos_level=args.chaos_level,
            dry_run=args.dry_run,
            backup=not args.no_backup
        )


if __name__ == "__main__":
    main()
