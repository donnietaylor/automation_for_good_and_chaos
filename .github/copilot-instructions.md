# GitHub Copilot Instructions

## Project Overview

This repository, "Automation for Good and Chaos," showcases Azure and AI-based automations through humorous demonstrations. It contains code examples, demos, and presentation materials demonstrating how automation can be used for both beneficial ("good") and satirical ("chaos") purposes.

## Code Style and Standards

### General Guidelines
- Follow existing code patterns and conventions in each subdirectory
- Keep examples simple and easy to understand for demonstration purposes
- Include clear comments explaining the purpose and educational value
- Ensure all "evil" examples are safe, reversible, and clearly marked as demonstrations

### Python Code
- Use Python 3.9+ features
- Follow PEP 8 style guidelines
- Add type hints to function signatures
- Include docstrings for all functions and classes
- Use meaningful variable names
- Example:
```python
def process_automation(input_data: str) -> dict:
    """
    Process automation input and return results.
    
    Args:
        input_data: The input string to process
        
    Returns:
        Dictionary containing processed results
    """
    pass
```

### JavaScript/TypeScript
- Use TypeScript where possible for MCP servers and n8n workflows
- Use async/await for asynchronous operations
- Document functions with JSDoc comments
- Follow Node.js best practices

### Configuration Files
- Use `.env.example` files to document required environment variables
- Never commit actual API keys or credentials
- Include clear comments in configuration files

## Project Structure

### Directories
- `/demos` - Live demonstration code and scripts (good/evil subdirectories)
- `/presentations` - Slide decks and presentation materials
- `/azure-automations` - Azure-based automation examples
- `/ai-examples` - AI tool demonstrations
- `/mcp-servers` - MCP (Model Context Protocol) server configurations
- `/n8n-workflows` - n8n workflow examples
- `/langflow-examples` - Langflow automation examples
- `/docs` - Additional documentation

### "Good" vs "Evil" Examples

#### Good Examples
- Should demonstrate practical, helpful automation
- Include proper error handling and validation
- Follow best practices for production use
- Examples: code review bots, smart email sorting, automated testing

#### Evil Examples
- Must be clearly marked as humorous/educational demonstrations
- Should be safe to run in demo environments
- Must be reversible and not cause actual harm
- Include safety limits and confirmation prompts
- Examples: overly enthusiastic bots, meeting conflict generators, format wars

## Technologies Used

### Azure Services
- Azure Logic Apps for workflow automation
- Azure Functions for serverless computing
- Azure DevOps Pipelines for CI/CD
- Azure AI Services for cognitive capabilities

### AI/ML
- OpenAI API (GPT models)
- Azure OpenAI Service
- LangChain for LLM applications
- Custom prompts for specific use cases

### Automation Tools
- n8n for visual workflow automation
- Langflow for AI workflow building
- MCP servers for model integration

### Languages
- Python for AI examples and scripts
- JavaScript/TypeScript for MCP servers and web integrations
- PowerShell for Azure automations

## Best Practices

### API Usage
- Always use environment variables for API keys
- Implement rate limiting to avoid excessive costs
- Cache responses when appropriate
- Handle API errors gracefully with try/catch blocks

### Cost Management
- Set token limits for AI API calls
- Use cheaper models (GPT-3.5) for simple tasks
- Implement caching for expensive operations
- Monitor API usage regularly

### Security
- Never hardcode credentials
- Validate all user inputs
- Use read-only access where possible for "evil" examples
- Implement authentication on webhooks and endpoints
- Follow principle of least privilege

### Documentation
- Each example should have its own README.md
- Include setup instructions and prerequisites
- Provide example usage and expected output
- Document any costs or rate limits
- Add troubleshooting sections for common issues

### Testing
- Test all examples before committing
- Include unit tests where applicable
- Verify "evil" examples have proper safety limits
- Ensure all examples can be easily undone or reset

## Demo-Specific Guidelines

### When Creating New Demos
1. Choose appropriate directory (good/ or evil/)
2. Create a descriptive subdirectory name
3. Include these files:
   - `README.md` - Clear description and setup
   - `.env.example` - Environment variables template
   - `requirements.txt` or `package.json` - Dependencies
   - Main implementation files
   - Optional: `setup.sh` or `reset.sh` scripts

### Educational Value
All examples should demonstrate:
- Clear use case or anti-pattern
- Real-world implications
- Best practices (for good examples) or what to avoid (for evil examples)
- Proper error handling
- Cost considerations

## Commit Message Format
Use clear, descriptive commit messages:
- `feat: Add new email automation example`
- `fix: Correct API key validation in code review bot`
- `docs: Update README with deployment instructions`
- `refactor: Simplify MCP server configuration`

## Code Review Checklist
Before submitting code:
- [ ] Follows project coding standards
- [ ] Includes necessary documentation
- [ ] Has no hardcoded credentials
- [ ] "Evil" examples are safe and reversible
- [ ] Dependencies are documented
- [ ] Examples are tested and working
- [ ] README is updated if necessary

## Special Considerations

### For "Evil" Examples
- Always include a disclaimer and warning
- Make the humorous/satirical nature obvious
- Implement safety limits (max iterations, max costs, etc.)
- Provide easy reset or undo functionality
- Never cause actual harm or significant inconvenience
- Example structure:
```python
# WARNING: This is a demonstration of poor automation design!
# Do not use in production environments.

def evil_automation():
    """
    Demonstrates what NOT to do with automation.
    Safe for demo purposes only.
    """
    pass
```

### Presentation Materials
- Keep slides concise and engaging
- Use clear examples that demonstrate concepts
- Include both technical details and humor
- Provide speaker notes for context

## Common Patterns

### Error Handling
```python
import openai

try:
    response = openai.ChatCompletion.create(...)
except openai.error.RateLimitError:
    print("Rate limit exceeded, please wait")
except openai.error.APIError as e:
    print(f"API error occurred: {e}")
```

### Configuration Management
```python
import os
from dotenv import load_dotenv

load_dotenv()

API_KEY = os.getenv('OPENAI_API_KEY')
if not API_KEY:
    raise ValueError("OPENAI_API_KEY not found in environment")
```

### Workflow Structure (n8n/Langflow)
1. Input component (trigger/data source)
2. Processing components (AI models, transformations)
3. Decision points (routing, filtering)
4. Output components (notifications, data storage)
5. Error handling nodes

## Additional Resources
- Main README.md for repository overview
- Individual example READMEs for specific setup
- /docs directory for detailed guides
- Azure documentation for cloud services
- OpenAI/LangChain docs for AI integration

## Questions or Issues?
- Check existing examples for patterns
- Review documentation in /docs
- Open an issue with the `question` label
- Be specific about the automation scenario

Remember: The goal is to educate, entertain, and demonstrate both the power and potential pitfalls of automation!
