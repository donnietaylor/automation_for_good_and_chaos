# Azure Automations Guide

Complete guide to implementing Azure-based automations for the "Automation for Good and Chaos" presentation.

## Azure Services Overview

### Azure Logic Apps
Visual workflow designer for integrating apps, data, and services.

**Best For:**
- Email and message processing
- API integrations
- Scheduled workflows
- Event-driven automation

**Pricing:** Pay-per-execution model

### Azure Functions
Serverless compute for event-driven applications.

**Best For:**
- HTTP triggers
- Timer-based tasks
- Queue processing
- Real-time data processing

**Pricing:** Consumption or Premium plans

### Azure Automation
Automate frequent, time-consuming, and error-prone tasks.

**Best For:**
- Infrastructure management
- Configuration management
- Update management
- Runbook automation

**Pricing:** Based on job runtime and watchers

### Azure DevOps Pipelines
CI/CD automation for building and deploying applications.

**Best For:**
- Build automation
- Test automation
- Deployment pipelines
- Release management

**Pricing:** Free tier available, pay for additional parallel jobs

## Quick Start Guide

### 1. Set Up Azure Account

```bash
# Install Azure CLI
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# Login
az login

# Set subscription
az account set --subscription "Your Subscription Name"

# Create resource group
az group create --name automation-rg --location eastus
```

### 2. Deploy Logic App

```bash
# Create Logic App
az logic workflow create \
  --resource-group automation-rg \
  --location eastus \
  --name email-processor \
  --definition @workflow-definition.json

# Enable Logic App
az logic workflow update \
  --resource-group automation-rg \
  --name email-processor \
  --state Enabled
```

### 3. Create Azure Function

```bash
# Create Function App
az functionapp create \
  --resource-group automation-rg \
  --consumption-plan-location eastus \
  --runtime node \
  --runtime-version 18 \
  --functions-version 4 \
  --name code-review-func \
  --storage-account mystorageaccount

# Deploy function code
func azure functionapp publish code-review-func
```

## Common Patterns

### Pattern 1: Event-Driven Processing

```
Event Source → Azure Function → Processing Logic → Output
```

**Example:** New file in Blob Storage triggers function to process data

### Pattern 2: Scheduled Tasks

```
Timer Trigger → Logic App → Execute Task → Notify
```

**Example:** Daily report generation and email distribution

### Pattern 3: API Integration

```
HTTP Request → Logic App → External API → Transform → Response
```

**Example:** Webhook receives data, enriches it via API, stores result

### Pattern 4: Approval Workflows

```
Trigger → Logic App → Send Approval → Wait → Execute Action
```

**Example:** Expense approval with email notifications

## Security Best Practices

### Use Managed Identities

```bash
# Enable managed identity for Function App
az functionapp identity assign \
  --name code-review-func \
  --resource-group automation-rg

# Grant permissions to Key Vault
az keyvault set-policy \
  --name my-keyvault \
  --object-id <managed-identity-id> \
  --secret-permissions get list
```

### Store Secrets in Key Vault

```javascript
// Access secrets from Function
const { SecretClient } = require("@azure/keyvault-secrets");
const { DefaultAzureCredential } = require("@azure/identity");

const credential = new DefaultAzureCredential();
const client = new SecretClient(vaultUrl, credential);
const secret = await client.getSecret("api-key");
```

### Implement Network Security

- Use Virtual Networks for isolation
- Configure firewall rules
- Enable Private Endpoints
- Use API Management for APIs

## Monitoring and Logging

### Application Insights

```bash
# Create Application Insights
az monitor app-insights component create \
  --app automation-insights \
  --location eastus \
  --resource-group automation-rg

# Link to Function App
az functionapp config appsettings set \
  --name code-review-func \
  --resource-group automation-rg \
  --settings APPINSIGHTS_INSTRUMENTATIONKEY=<key>
```

### Query Logs

```kusto
// Failed function executions
traces
| where severityLevel >= 3
| where timestamp > ago(1h)
| project timestamp, message, severityLevel

// Performance metrics
requests
| where timestamp > ago(1h)
| summarize avg(duration) by name
```

### Set Up Alerts

```bash
# Create alert for failures
az monitor metrics alert create \
  --name function-failures \
  --resource-group automation-rg \
  --scopes <function-app-id> \
  --condition "count Invocations where ResultType == Failed > 5" \
  --window-size 5m \
  --evaluation-frequency 1m
```

## Cost Optimization

### Consumption vs Premium Plans

**Consumption:**
- Pay per execution
- Auto-scaling
- Good for: Variable workloads

**Premium:**
- Always-on instances
- Better performance
- Good for: Consistent workloads

### Optimization Tips

1. **Right-size compute**: Use appropriate SKUs
2. **Implement caching**: Reduce duplicate processing
3. **Use queues**: Batch process when possible
4. **Set timeouts**: Prevent runaway executions
5. **Monitor costs**: Use Azure Cost Management

## Testing Strategies

### Unit Testing Functions

```javascript
// function.test.js
const { processEmail } = require('./index');

describe('Email Processor', () => {
  it('should categorize emails correctly', async () => {
    const mockEmail = {
      subject: 'Urgent: Production Issue',
      body: 'Server is down'
    };
    
    const result = await processEmail(mockEmail);
    expect(result.category).toBe('urgent');
  });
});
```

### Integration Testing

```bash
# Test Logic App with sample data
az logic workflow run trigger \
  --resource-group automation-rg \
  --name email-processor \
  --trigger-name manual \
  --body-file test-payload.json
```

### Load Testing

```bash
# Using Azure Load Testing
az load test create \
  --name function-load-test \
  --resource-group automation-rg \
  --test-plan-file load-test.jmx
```

## CI/CD Integration

### GitHub Actions for Functions

```yaml
name: Deploy Azure Function

on:
  push:
    branches: [ main ]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      
      - name: Setup Node.js
        uses: actions/setup-node@v2
        with:
          node-version: '18'
      
      - name: Install dependencies
        run: npm ci
      
      - name: Run tests
        run: npm test
      
      - name: Deploy to Azure
        uses: Azure/functions-action@v1
        with:
          app-name: code-review-func
          package: .
          publish-profile: ${{ secrets.AZURE_FUNCTIONAPP_PUBLISH_PROFILE }}
```

### Azure DevOps Pipeline

```yaml
trigger:
  - main

pool:
  vmImage: 'ubuntu-latest'

steps:
  - task: NodeTool@0
    inputs:
      versionSpec: '18.x'
  
  - script: npm ci
    displayName: 'Install dependencies'
  
  - script: npm test
    displayName: 'Run tests'
  
  - task: AzureFunctionApp@1
    inputs:
      azureSubscription: 'Azure Subscription'
      appType: 'functionApp'
      appName: 'code-review-func'
      package: '$(System.DefaultWorkingDirectory)'
```

## Troubleshooting

### Common Issues

**Function times out:**
- Increase timeout setting
- Optimize code performance
- Use async patterns
- Consider Premium plan

**Logic App fails:**
- Check connector permissions
- Verify API credentials
- Review retry policy
- Enable run history

**High costs:**
- Review execution frequency
- Optimize resource usage
- Implement caching
- Consider reserved capacity

### Debugging Tools

```bash
# Stream logs
az functionapp log tail \
  --name code-review-func \
  --resource-group automation-rg

# Download logs
az functionapp log download \
  --name code-review-func \
  --resource-group automation-rg

# Check deployment status
az functionapp deployment list-publishing-credentials \
  --name code-review-func \
  --resource-group automation-rg
```

## Example Implementations

See the `/azure-automations` directory for complete examples:

1. **Good Examples:**
   - Smart email processor
   - Code review automation
   - Scheduled data pipeline
   - API integration gateway

2. **Evil Examples:**
   - Notification loop (safely contained)
   - Random config changer
   - Meeting conflict generator
   - Chaos pipeline

## Resources

- [Azure Functions Documentation](https://docs.microsoft.com/azure/azure-functions/)
- [Logic Apps Documentation](https://docs.microsoft.com/azure/logic-apps/)
- [Azure Automation Documentation](https://docs.microsoft.com/azure/automation/)
- [Azure Pricing Calculator](https://azure.microsoft.com/pricing/calculator/)
- [Azure Architecture Center](https://docs.microsoft.com/azure/architecture/)

## Support

For issues with Azure services:
- Azure Support Portal
- Stack Overflow (tag: azure)
- Azure Community Forums
- GitHub Issues (for SDK problems)
