# Azure Automations

This directory contains examples of Azure-based automation solutions used in the "Automation for Good and Chaos" presentation.

## Azure Services Covered

### 1. Azure Logic Apps
- **Good Example**: Email processing workflow
- **Evil Example**: Recursive notification loop (safely contained!)
- **Location**: `./logic-apps/`

### 2. Azure Functions
- **Good Example**: Scheduled data processing
- **Evil Example**: Function that calls itself recursively
- **Location**: `./functions/`

### 3. Azure DevOps Pipelines
- **Good Example**: CI/CD with proper testing
- **Evil Example**: Pipeline that randomly fails builds
- **Location**: `./devops-pipelines/`

### 4. Azure Automation Accounts
- **Good Example**: VM lifecycle management
- **Evil Example**: Random resource renaming script
- **Location**: `./automation-accounts/`

## Directory Structure

```
azure-automations/
├── logic-apps/
│   ├── good/
│   │   └── email-processor.json
│   └── evil/
│       └── notification-loop.json
├── functions/
│   ├── good/
│   │   └── data-processor/
│   └── evil/
│       └── recursive-caller/
├── devops-pipelines/
│   ├── good/
│   │   └── azure-pipelines.yml
│   └── evil/
│       └── chaos-pipeline.yml
└── automation-accounts/
    ├── good/
    │   └── vm-lifecycle.ps1
    └── evil/
        └── random-renamer.ps1
```

## Getting Started

### Prerequisites
- Azure subscription
- Azure CLI installed
- Appropriate permissions to create resources
- PowerShell 7+ (for some examples)

### Setup

1. Login to Azure:
   ```bash
   az login
   az account set --subscription "your-subscription-id"
   ```

2. Set up resource group:
   ```bash
   az group create --name automation-demos-rg --location eastus
   ```

3. Deploy examples (see individual folders for specific deployment instructions)

## Good Examples Details

### Email Processing Logic App
- Monitors inbox for specific keywords
- Applies sentiment analysis
- Routes emails to appropriate handlers
- Sends intelligent auto-responses

**Key Features:**
- Natural language processing
- Conditional routing
- Integration with Microsoft Graph
- Error handling and retries

### Data Processing Function
- Scheduled trigger (runs hourly)
- Processes data from storage account
- Applies transformations
- Stores results in database

**Key Features:**
- Durable functions for long-running tasks
- Managed identity for authentication
- Monitoring and logging
- Cost-effective serverless execution

## Evil Examples Details

### Notification Loop Logic App
- Demonstrates what NOT to do
- Creates a (controlled) feedback loop
- Shows importance of loop prevention
- Safely terminated with timeout

**Warning:** This is intentionally problematic for demonstration purposes!

### Recursive Function
- Function that calls itself
- Demonstrates infinite recursion issues
- Shows Azure's safety mechanisms
- Includes proper termination conditions

**Educational Value:** Shows why recursion depth limits exist!

## Best Practices

1. **Always set timeouts** - Prevent runaway automations
2. **Use managed identities** - Avoid storing credentials
3. **Implement retry logic** - Handle transient failures
4. **Monitor and alert** - Know when things go wrong
5. **Cost management** - Set budgets and alerts
6. **Testing** - Test in dev before prod deployment

## Common Pitfalls

1. ❌ No error handling - Automations fail silently
2. ❌ Hard-coded credentials - Security risk
3. ❌ No rate limiting - Overwhelming downstream services
4. ❌ Infinite loops - Resource exhaustion
5. ❌ No monitoring - Can't diagnose issues

## Deployment

Each subfolder contains deployment scripts:
- `deploy.sh` - Bash deployment script
- `deploy.ps1` - PowerShell deployment script
- `template.json` - ARM template (where applicable)
- `.env.example` - Required environment variables

## Cleanup

To avoid charges, clean up resources after demos:

```bash
az group delete --name automation-demos-rg --yes --no-wait
```

## Additional Resources

- [Azure Logic Apps Documentation](https://docs.microsoft.com/azure/logic-apps/)
- [Azure Functions Documentation](https://docs.microsoft.com/azure/azure-functions/)
- [Azure Automation Documentation](https://docs.microsoft.com/azure/automation/)
- [Azure DevOps Documentation](https://docs.microsoft.com/azure/devops/)
