# Azure App Configuration Fetcher

A Python utility tool for retrieving and exporting all configuration keys and values from Azure App Configuration. Useful for auditing, backup, documentation, and configuration migration tasks.

## Overview

The **Azure App Configuration Fetcher** helps you:

- Retrieve all configuration settings from Azure App Configuration
- Export configuration as JSON format
- Audit configuration keys and metadata
- Backup configuration data
- Integrate with configuration management workflows
- Document application configuration

This tool is perfect for developers who need to access, analyze, or backup their configuration stored in Azure App Configuration service.

## What is Azure App Configuration?

**Azure App Configuration** is a Microsoft Azure service that provides:
- Centralized management of application settings
- Feature flag management
- Configuration versioning and history
- Key-value pair storage
- Separation of sensitive vs non-sensitive data
- Multi-environment support

## Prerequisites

- **Python** 3.8 or higher
- **pip** (Python package manager)
- **Azure Account** with App Configuration resource
- **Connection String** to your App Configuration instance

## Installation

### Step 1: Install Python

Download and install Python from [python.org](https://www.python.org/downloads/)

Verify installation:
```bash
python --version
```

### Step 2: Install Dependencies

Navigate to the fetch-appconfiguration folder and install required packages:

```bash
pip install -r requirements.txt
```

Or install the Azure App Configuration package directly:

```bash
pip install azure-appconfiguration==1.4.0
```

### Step 3: Get Your Connection String

1. Navigate to your Azure App Configuration resource in the [Azure Portal](https://portal.azure.com)
2. Click **Access Keys** in the left menu
3. Copy the **Connection String** from the "Read-write keys" or "Read-only keys" section
4. The format looks like: `Endpoint=https://<name>.azconfig.io;Id=<id>;Secret=<secret>;`

## Project Structure

```
fetch-appconfiguration/
├── main.py              # Main script
├── requirements.txt     # Dependencies
├── output.json          # Generated output file
└── README.md            # This file
```

## Configuration

### Update Connection String

Edit `main.py` and replace the connection string placeholder:

```python
if __name__ == "__main__":
    # Add your Azure App Configuration connection string here
    connection_string = "Endpoint=https://<your-app-configuration-name>.azconfig.io;Id=<your-id>;Secret=<your-secret>;"
    get_all_keys(connection_string)
```

**Replace:**
- `<your-app-configuration-name>` - Your App Configuration resource name
- `<your-id>` - Your access key ID
- `<your-secret>` - Your access key secret

### Example

```python
connection_string = "Endpoint=https://myapp.azconfig.io;Id=abcd1234;Secret=xyz789abc123;"
```

## Usage

### Basic Usage

Run the script from the command line:

```bash
python main.py
```

### Example Execution

```bash
$ python main.py
[
    {
        "key": "AppName",
        "value": "My Application",
        "content_type": null,
        "last_modified": "2024-01-15T10:30:45.123456+00:00",
        "etag": "abc123def456",
        "label": null,
        "read_only": false
    },
    {
        "key": "Database:Host",
        "value": "db.example.com",
        "content_type": null,
        "last_modified": "2024-01-15T10:35:20.654321+00:00",
        "etag": "ghi789jkl012",
        "label": "Production",
        "read_only": true
    }
]
```

## Output Format

The script outputs all configuration settings as a JSON array. Each configuration item includes:

| Field | Description |
|-------|-------------|
| **key** | Configuration key name |
| **value** | Configuration value |
| **content_type** | MIME type (if specified) |
| **last_modified** | Timestamp of last modification |
| **etag** | Entity tag for versioning |
| **label** | Label associated with the key (environment, version, etc.) |
| **read_only** | Whether the key is read-only |

## Saving Output to File

### Redirect to File

```bash
# Save output to JSON file
python main.py > output.json

# Save with timestamp
python main.py > configuration_$(date +%Y%m%d_%H%M%S).json
```

### Modify Script to Save to File

Edit `main.py`:

```python
if __name__ == "__main__":
    connection_string = "Endpoint=https://your-app.azconfig.io;Id=your-id;Secret=your-secret;"
    
    # Capture output
    client = AzureAppConfigurationClient.from_connection_string(connection_string)
    keys = client.list_configuration_settings()
    
    results = []
    for item in keys:
        item_dict = {
            "key": item.key,
            "value": item.value,
            "content_type": item.content_type,
            "last_modified": item.last_modified.isoformat(),
            "etag": item.etag,
            "label": item.label,
            "read_only": item.read_only
        }
        results.append(item_dict)
    
    # Save to file
    with open('output.json', 'w') as f:
        json.dump(results, f, indent=4)
    
    print(f"Configuration exported to output.json ({len(results)} items)")
```

Then run:
```bash
python main.py
```

## Advanced Usage

### Filter by Label

Fetch only configurations with a specific label:

```python
def get_keys_by_label(connection_string, label):
    client = AzureAppConfigurationClient.from_connection_string(connection_string)
    keys = client.list_configuration_settings(label_filter=label)
    
    results = []
    for item in keys:
        item_dict = {
            "key": item.key,
            "value": item.value,
            "content_type": item.content_type,
            "last_modified": item.last_modified.isoformat(),
            "etag": item.etag,
            "label": item.label,
            "read_only": item.read_only
        }
        results.append(item_dict)
    
    return results

# Usage
prod_configs = get_keys_by_label(connection_string, "Production")
```

### Filter by Key Pattern

Fetch only configurations matching a key pattern:

```python
def get_keys_by_pattern(connection_string, key_filter):
    client = AzureAppConfigurationClient.from_connection_string(connection_string)
    keys = client.list_configuration_settings(key_filter=key_filter)
    
    results = []
    for item in keys:
        item_dict = {
            "key": item.key,
            "value": item.value,
            "last_modified": item.last_modified.isoformat(),
            "label": item.label
        }
        results.append(item_dict)
    
    return results

# Usage - Get all database configurations
db_configs = get_keys_by_pattern(connection_string, "Database:*")
```

### Pretty Print Configuration

```python
def print_configuration_table(results):
    """Print configuration in table format"""
    print(f"{'Key':<40} {'Value':<30} {'Label':<15} {'Read-Only':<10}")
    print("-" * 95)
    for item in results:
        key = item['key'][:40]
        value = str(item['value'])[:30]
        label = str(item.get('label', 'None'))[:15]
        read_only = str(item['read_only'])
        print(f"{key:<40} {value:<30} {label:<15} {read_only:<10}")
```

### Configuration Statistics

```python
def print_stats(results):
    """Print configuration statistics"""
    print(f"Total Keys: {len(results)}")
    print(f"Read-Only: {sum(1 for r in results if r['read_only'])}")
    print(f"With Labels: {sum(1 for r in results if r['label'])}")
    
    labels = set(r['label'] for r in results if r['label'])
    if labels:
        print(f"Labels: {', '.join(labels)}")
```

## Common Use Cases

### 1. Configuration Backup

```bash
# Create timestamped backup
python main.py > backup_$(date +%Y%m%d_%H%M%S).json
```

### 2. Configuration Audit

```bash
# Check what configurations exist
python main.py | grep -i "password\|secret\|key"
```

### 3. Development Environment Setup

```bash
# Export production config and import to dev environment
# Step 1: Export
python main.py > prod_config.json

# Step 2: Modify values for dev
# Step 3: Create script to import to dev App Configuration
```

### 4. Configuration Documentation

Generate markdown documentation:

```python
import json

with open('output.json', 'r') as f:
    configs = json.load(f)

with open('CONFIGURATION.md', 'w') as f:
    f.write("# Application Configuration\n\n")
    
    for config in configs:
        f.write(f"## {config['key']}\n")
        f.write(f"- **Value:** {config['value']}\n")
        f.write(f"- **Label:** {config.get('label', 'None')}\n")
        f.write(f"- **Read-Only:** {config['read_only']}\n")
        f.write(f"- **Last Modified:** {config['last_modified']}\n\n")
```

## Troubleshooting

### Error: "Invalid connection string"

**Cause:** Connection string format is incorrect.

**Solution:** Verify the connection string format:
```
Endpoint=https://<name>.azconfig.io;Id=<id>;Secret=<secret>;
```

### Error: "Unauthorized (401)"

**Cause:** Invalid credentials or insufficient permissions.

**Solution:**
1. Verify your connection string is correct
2. Ensure your access key hasn't expired
3. Check you have "App Configuration Data Reader" role

### Error: "ModuleNotFoundError: No module named 'azure'"

**Cause:** Dependencies not installed.

**Solution:** Install required packages:
```bash
pip install -r requirements.txt
```

### Error: "Connection timeout"

**Cause:** Cannot reach Azure App Configuration service.

**Solution:**
- Verify internet connection
- Check firewall/network policies
- Verify App Configuration resource exists and is accessible
- Use correct Azure region/URL

### Empty Output

**Cause:** App Configuration resource has no settings, or filtering excluded all items.

**Solution:**
1. Verify settings exist in App Configuration
2. Check label/key filters if using them
3. Verify connection string credentials have read access

## Performance Tips

### Large Configuration Sets

For organizations with many configuration items:

```python
def get_all_keys_with_pagination(connection_string):
    """Fetch with pagination for large datasets"""
    client = AzureAppConfigurationClient.from_connection_string(connection_string)
    
    results = []
    batch_size = 100
    
    for item in client.list_configuration_settings(accept_datetime=None):
        item_dict = {
            "key": item.key,
            "value": item.value,
            "label": item.label,
            "read_only": item.read_only
        }
        results.append(item_dict)
        
        # Process in batches
        if len(results) % batch_size == 0:
            print(f"Processed {len(results)} items...")
    
    return results
```

## Scheduling Regular Exports

### Linux/macOS (Cron)

Add to crontab to run daily:

```bash
crontab -e
```

Add this line to run every day at 2 AM:

```bash
0 2 * * * cd /path/to/fetch-appconfiguration && python main.py >> exports/config_$(date +\%Y\%m\%d).json
```

### Windows (Task Scheduler)

1. Open Task Scheduler
2. Create Basic Task
3. Set trigger to run daily
4. Set action to run: `python C:\path\to\fetch-appconfiguration\main.py`

## Security Considerations

- **Never commit connection strings** to version control
- Use **environment variables** for sensitive data:
  ```python
  import os
  connection_string = os.getenv('AZURE_APPCONFIGURATION_CONNECTIONSTRING')
  ```

- Store connection strings in **secure vaults** (Azure Key Vault, etc.)
- Use **read-only access keys** when possible
- Rotate access keys regularly
- Audit who accesses configuration

### Using Environment Variables

```bash
# Set environment variable
export AZURE_APPCONFIGURATION_CONNECTIONSTRING="Endpoint=https://..."

# Or in Python script
import os

connection_string = os.getenv('AZURE_APPCONFIGURATION_CONNECTIONSTRING')
if not connection_string:
    raise ValueError("Connection string not found in environment variables")
```

## Related Resources

- [Azure App Configuration Documentation](https://docs.microsoft.com/en-us/azure/azure-app-configuration/)
- [Azure SDK for Python](https://github.com/Azure/azure-sdk-for-python)
- [Azure App Configuration REST API](https://docs.microsoft.com/en-us/rest/api/appconfiguration/)
- [Python JSON Documentation](https://docs.python.org/3/library/json.html)
- [Azure CLI App Configuration Commands](https://docs.microsoft.com/en-us/cli/azure/appconfig)

## Support

For issues or questions:
- Verify connection string and credentials
- Check Azure App Configuration resource is accessible
- Review Azure documentation for the service
- Ensure Python and dependencies are up to date
- Check Azure service status: https://status.azure.com/

## License

This tool is provided as-is for managing Azure App Configuration.
