# n8n Workflows

This directory contains n8n workflow examples demonstrating automation for both helpful and humorous purposes.

## What is n8n?

n8n is a fair-code licensed workflow automation tool that allows you to connect various services and automate tasks through visual workflows. It's self-hostable and offers extensive integration capabilities.

## Getting Started with n8n

### Installation

**Option 1: Docker (Recommended)**
```bash
docker run -it --rm \
  --name n8n \
  -p 5678:5678 \
  -v ~/.n8n:/home/node/.n8n \
  n8nio/n8n
```

**Option 2: npm**
```bash
npm install -g n8n
n8n start
```

**Option 3: Docker Compose**
```bash
cd n8n-workflows/
docker-compose up -d
```

Access n8n at: `http://localhost:5678`

## Workflow Examples

### Good Workflows

#### 1. Smart Email Processor
**File**: `./good/smart-email-processor.json`

Intelligently processes and routes emails based on content.

**Workflow Steps:**
1. Gmail Trigger - New email received
2. OpenAI Node - Analyze email sentiment and category
3. Switch Node - Route based on category
4. Slack Node - Send notification for urgent emails
5. Google Sheets - Log all processed emails

**Use Case:** Automatically categorize and prioritize incoming emails

#### 2. GitHub PR Notifier
**File**: `./good/github-pr-notifier.json`

Monitors GitHub for new PRs and sends intelligent notifications.

**Workflow Steps:**
1. Webhook Trigger - GitHub PR webhook
2. OpenAI Node - Summarize PR changes
3. Microsoft Teams Node - Send formatted notification
4. Linear Node - Create task if needed
5. Google Calendar - Schedule review time

**Use Case:** Keep team informed about code reviews

#### 3. Content Moderation Pipeline
**File**: `./good/content-moderation.json`

Automated content review with human oversight.

**Workflow Steps:**
1. HTTP Request Trigger - New content submitted
2. Azure AI Content Safety - Check for violations
3. OpenAI Node - Detailed analysis
4. Switch Node - Auto-approve or flag for review
5. Database Insert - Store decision and reasoning

**Use Case:** Scale content moderation efficiently

#### 4. Meeting Prep Assistant
**File**: `./good/meeting-prep-assistant.json`

Prepares meeting materials automatically.

**Workflow Steps:**
1. Schedule Trigger - 1 hour before meeting
2. Google Calendar - Get meeting details
3. Notion - Retrieve related documents
4. OpenAI Node - Generate meeting brief
5. Email Node - Send prep materials to attendees

**Use Case:** Ensure everyone is prepared for meetings

### Evil Workflows

#### 1. Bureaucracy Generator
**File**: `../demos/chaos/bureaucracy_generator/workflow.json`

Transforms simple emails into absurdly complex bureaucratic processes.

**Workflow Steps:**
1. Microsoft Outlook Trigger - Monitor incoming emails
2. Extract Email Details - Capture sender, subject, and body
3. Bureaucracy Engine (OpenAI) - Generate over-the-top bureaucratic response
4. Parse Chaos Plan - Structure the AI response
5. Send Chaotic Reply - Email with unnecessary questions
6. Create Meeting Invites - Schedule multiple unnecessary meetings
7. Generate Stakeholder Emails - Notify fictional corporate roles
8. Chaos Dashboard - Display total overhead created

**Use Case:** Demonstrate how automation can create complexity instead of reducing it

#### 2. Random Meeting Generator
**File**: `./evil/random-meeting-generator.json`

Creates random meetings on people's calendars (demo only!).

**Workflow Steps:**
1. Schedule Trigger - Random times
2. Function Node - Generate random meeting details
3. OpenAI Node - Create "important" meeting descriptions
4. Google Calendar - Create meeting
5. Email Node - Send "urgent" invites

**Use Case:** Demonstrate the chaos of uncontrolled automation

#### 3. Emoji Overload Responder
**File**: `./evil/emoji-overload.json`

Responds to messages with excessive emojis.

**Workflow Steps:**
1. Slack Trigger - New message
2. Function Node - Add random emojis to every word
3. OpenAI Node - Make message "more enthusiastic"
4. Slack Node - Reply with emoji-laden message

**Use Case:** Show how automation can be too enthusiastic

#### 4. Infinite Loop Alert
**File**: `./evil/infinite-loop-alert.json`

Sends notifications about notifications (safely limited!).

**Workflow Steps:**
1. Webhook Trigger - Alert received
2. Function Node - Multiply alert by 10
3. Slack Node - Send all alerts
4. HTTP Request - Trigger itself (with limit!)
5. Wait Node - Stagger for dramatic effect

**Use Case:** Demonstrate the importance of loop prevention

#### 5. Auto-Complicate
**File**: `./evil/auto-complicate.json`

Makes simple messages unnecessarily complex.

**Workflow Steps:**
1. Email Trigger - Simple request received
2. OpenAI Node - Rewrite with corporate jargon
3. Function Node - Add buzzwords
4. Email Node - Send "enhanced" version
5. Slack Node - Notify of "improvement"

**Use Case:** Satirize over-complicated business communication

## Importing Workflows

1. Open n8n interface
2. Click "Import from File" or "Import from URL"
3. Select the JSON file
4. Configure credentials for each node
5. Activate the workflow

## Required Credentials

Set up credentials in n8n for:

- **OpenAI**: API key for AI processing
- **Gmail**: OAuth2 or App Password
- **Slack**: Bot token or OAuth2
- **Microsoft Teams**: OAuth2
- **GitHub**: Personal access token
- **Google Calendar**: OAuth2
- **Azure Services**: API keys
- **Database**: Connection strings

## Workflow Development Tips

### Best Practices

1. **Error Handling**: Add error workflows for all critical paths
2. **Retry Logic**: Configure retries for flaky external services
3. **Rate Limiting**: Respect API rate limits
4. **Logging**: Log important events for debugging
5. **Testing**: Test workflows thoroughly before activation
6. **Documentation**: Add notes to explain complex logic

### Common Patterns

#### Retry with Exponential Backoff
```json
{
  "retryOnFail": true,
  "maxTries": 3,
  "waitBetweenTries": 2000
}
```

#### Conditional Execution
Use Switch nodes to route based on conditions:
- Data values
- HTTP status codes
- AI classification results
- Time of day

#### Data Transformation
Use Function nodes for complex data manipulation:
```javascript
// Example: Transform data
items = items.map(item => ({
  ...item,
  json: {
    ...item.json,
    processed: true,
    timestamp: new Date().toISOString()
  }
}));

return items;
```

## Debugging Workflows

### Enable Detailed Logging
1. Go to Settings
2. Enable "Save manual executions"
3. Enable "Save execution data"

### Inspect Execution Data
- Click on any execution in the executions list
- Review input/output for each node
- Check error messages and stack traces

### Use Wait Nodes
Add Wait nodes to slow down execution for debugging:
```json
{
  "unit": "seconds",
  "value": 5
}
```

## Performance Optimization

### Parallel Execution
- Use Split In Batches for processing large datasets
- Enable parallel execution in settings
- Be mindful of API rate limits

### Webhook Response Times
- Return responses before heavy processing
- Use asynchronous workflows
- Implement queuing for long-running tasks

### Resource Management
- Limit concurrent workflow executions
- Use workflow timeouts
- Monitor memory usage

## Security Considerations

### Good Practices
- ✅ Use environment variables for sensitive data
- ✅ Implement authentication on webhooks
- ✅ Validate all input data
- ✅ Use HTTPS for all external communications
- ✅ Regularly update n8n version
- ✅ Backup workflows regularly

### What to Avoid
- ❌ Hardcoding credentials
- ❌ Exposing webhooks without auth
- ❌ Processing untrusted data without validation
- ❌ Storing sensitive data in execution history

## Monitoring and Maintenance

### Health Checks
Create a simple health check workflow:
1. Schedule Trigger - Every 5 minutes
2. HTTP Request - Ping critical services
3. Switch Node - Check status codes
4. Slack Node - Alert if down

### Execution History
- Review failed executions regularly
- Set up alerts for workflow failures
- Archive old execution data

### Performance Metrics
Track:
- Average execution time
- Success/failure rates
- API usage per workflow
- Resource consumption

## Testing Workflows

### Manual Testing
1. Use "Execute Node" for individual nodes
2. Test with sample data
3. Verify error handling
4. Check all conditional branches

### Automated Testing
Create test workflows that:
- Send test data to production workflows
- Verify expected outputs
- Alert on test failures

## Backup and Version Control

### Export Workflows
```bash
# Export all workflows
n8n export:workflow --all --output=./backups/

# Export specific workflow
n8n export:workflow --id=123 --output=./backups/
```

### Version Control
- Export workflows as JSON files
- Commit to Git repository
- Use descriptive commit messages
- Tag releases

## Advanced Features

### Sub-Workflows
Break complex workflows into reusable sub-workflows:
- Error handling workflows
- Common data transformations
- Notification workflows

### Custom Nodes
Create custom nodes for organization-specific needs:
```bash
n8n-node-dev new
```

### CLI Operations
```bash
# Import workflow
n8n import:workflow --input=workflow.json

# List all workflows
n8n list:workflow

# Start in production mode
n8n start --production
```

## Troubleshooting

### Common Issues

**Workflow Not Triggering**
- Check trigger configuration
- Verify webhook URLs
- Ensure workflow is activated

**Node Failing**
- Check credentials
- Verify API keys
- Review node configuration
- Check rate limits

**Slow Execution**
- Optimize data processing
- Use batching
- Enable parallel execution
- Check external API response times

## Resources

- [n8n Documentation](https://docs.n8n.io/)
- [n8n Community](https://community.n8n.io/)
- [Workflow Templates](https://n8n.io/workflows)
- [Custom Nodes](https://www.npmjs.com/search?q=n8n-nodes-)
- [n8n GitHub](https://github.com/n8n-io/n8n)

## Contributing

To add new workflow examples:

1. Create workflow in n8n
2. Test thoroughly
3. Export to JSON
4. Add to appropriate folder (good/evil)
5. Create README with:
   - Description
   - Required credentials
   - Setup instructions
   - Screenshots (optional)
6. Update this main README

## Docker Compose Configuration

See `docker-compose.yml` for complete n8n setup with:
- PostgreSQL database
- Persistent data volumes
- Environment configuration
- Network setup
