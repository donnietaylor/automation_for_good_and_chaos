# Demo Examples

This directory contains ready-to-run demonstration code for the "Automation for Good… and Chaos" session.

## Philosophy

All demos showcase **real-time automation patterns** that can be applied for community impact or playful chaos. The technical patterns are the same—what differs is the intent and application.

### Good First, Chaos Second
We demonstrate helpful automations first to show genuine community impact, then show how the same patterns can create harmless mischief. This approach highlights both the power and responsibility that comes with automation.

## Available Demos

### 1. Good Examples (Community & Civic Impact)

#### Community Alert System
- **Location**: `./good/community-alerts/`
- **Description**: Real-time alert system that monitors events and notifies community members
- **Tech**: Azure Event Grid, Webhooks, SMS/Email APIs
- **Use Case**: Emergency notifications, event updates, community announcements
- **Run Time**: 5 minutes

#### Nonprofit Volunteer Coordinator
- **Location**: `./good/volunteer-coordinator/`
- **Description**: AI-powered system that matches volunteers with opportunities
- **Tech**: OpenAI API, Azure Functions, Calendar integration
- **Use Case**: Streamlining volunteer management for resource-constrained nonprofits
- **Run Time**: 4 minutes

#### Accessibility Enhancer
- **Location**: `./good/accessibility-helper/`
- **Description**: Real-time content transformation for better accessibility
- **Tech**: AI text-to-speech, image description, simplification
- **Use Case**: Making content more accessible in real time
- **Run Time**: 3 minutes

#### Environmental Monitor
- **Location**: `./good/environmental-monitor/`
- **Description**: IoT-based system that monitors environmental conditions
- **Tech**: Sensor data, Azure IoT, real-time alerts
- **Use Case**: Air quality monitoring, water level alerts, temperature tracking
- **Run Time**: 5 minutes

### 2. "Evil" Examples (Playful Chaos - Harmless Mischief!)

#### Real-Time Emoji Bomber
- **Location**: `./evil/emoji-chaos-bot/`
- **Description**: Monitors messages and adds excessive emojis in real time
- **Tech**: Webhook listeners, text transformation
- **Use Case**: Demonstrating over-automation and context ignorance
- **Run Time**: 3 minutes

#### Meeting Time Chaos Generator
- **Location**: `./evil/meeting-chaos/`
- **Description**: Suggests hilariously inconvenient meeting times
- **Tech**: Calendar APIs, "creative" scheduling logic
- **Use Case**: Showing what happens when automation lacks empathy
- **Run Time**: 4 minutes

#### Overly Helpful Assistant
- **Location**: `./evil/over-helper/`
- **Description**: Responds to every message with excessive helpfulness
- **Tech**: Webhook triggers, OpenAI API with chaotic prompts
- **Use Case**: Teaching about automation boundaries and user experience
- **Run Time**: 3 minutes

#### Format Wars Bot
- **Location**: `./evil/format-wars/`
- **Description**: Randomly switches code formatting styles on every save
- **Tech**: File watchers, real-time code modification
- **Use Case**: Highlighting the importance of consistent standards
- **Run Time**: 2 minutes

## Key Patterns Demonstrated

All demos showcase these real-time automation patterns:

1. **Event-Driven Architecture** - Responding to triggers in real time
2. **Webhook Integration** - Listening for and reacting to external events
3. **AI-Powered Decision Making** - Using LLMs for intelligent responses
4. **Real-Time Data Processing** - Handling information as it arrives
5. **User Context Awareness** - Understanding and responding to situations
6. **Graceful Degradation** - Handling failures and edge cases

### Good Examples Emphasize:
- Community impact and civic applications
- Helping resource-constrained organizations
- Accessibility and inclusivity
- Environmental awareness
- Practical, immediate value

### "Evil" Examples Demonstrate:
- What happens when automation lacks context
- Over-automation and boundary issues
- User experience failures
- Why testing and limits matter
- The importance of ethical design choices

Both use the same technical foundations!

## Running the Demos

Each demo folder contains:
- `README.md` - Specific setup instructions
- `setup.sh` or `setup.ps1` - Automated setup script
- Source code files
- `.env.example` - Required environment variables

### General Setup

1. Copy `.env.example` to `.env` in the demo directory
2. Fill in your API keys and credentials
3. Run the setup script
4. Follow demo-specific instructions

### Prerequisites

See main README for general prerequisites. Demo-specific requirements are listed in each demo's README.

## Demo Guidelines

- Always test demos before the presentation
- Have backup plans for API failures
- Keep sensitive credentials in `.env` files (never commit these!)
- Reset demo state between runs

## Adding New Demos

To add a new demo:
1. Create a new folder under `good/` or `evil/`
2. Add a descriptive README.md
3. Include a `.env.example` with required variables
4. Add a setup script
5. Test thoroughly!
