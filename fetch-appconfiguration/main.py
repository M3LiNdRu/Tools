from azure.appconfiguration import AzureAppConfigurationClient
import json

def get_all_keys(connection_string):
    # Create Azure App Configuration client
    client = AzureAppConfigurationClient.from_connection_string(connection_string)

    # List all available keys in App Configuration
    keys = client.list_configuration_settings()

    results = []
    for item in keys:
        # Each item is an object, we use `vars` to convert it to a dictionary
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
    
    # Print the result as JSON
    print(json.dumps(results, indent=4))

if __name__ == "__main__":
    # Add your Azure App Configuration connection string here
    connection_string = "Endpoint=https://<your-app-configuration-name>.azconfig.io;Id=<your-id>;Secret=<your-secret>;"
    get_all_keys(connection_string)