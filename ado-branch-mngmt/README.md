# Azure DevOps Release Branch Management Tool

A bash script for automating the creation and deletion of release branches across multiple Azure DevOps repositories.

## Overview

`release-branching.sh` is a utility tool that helps manage release branches in Azure DevOps. It allows you to:

- **Create release branches** across one or more repositories simultaneously
- **Delete release branches** when releases are completed
- **List repositories** from a specific Azure DevOps project

This tool is particularly useful for organizations that follow a release branching strategy and need to manage multiple repositories in a coordinated manner.

## Prerequisites

Before using this script, ensure you have:

- **Bash** shell environment (Linux, macOS, or Windows with WSL)
- **Git** installed and configured
- **curl** for API calls
- **jq** for JSON parsing (used for the list repositories feature)
- An **Azure DevOps account** with appropriate permissions
- A **Personal Access Token (PAT)** from Azure DevOps with repository read/write permissions

### Installing Dependencies

**On Ubuntu/Debian:**
```bash
sudo apt-get update
sudo apt-get install git curl jq
```

**On macOS:**
```bash
brew install git curl jq
```

## Configuration

### 1. Update Script Variables

Edit `release-branching.sh` and configure the following:

```bash
AZURE_DEVOPS_URL="dev.azure.com/XXXX"      # Replace with your Azure DevOps org URL
BRANCH_PREFIX="release/v"                   # Prefix for release branches
VERSION="x.x.x"                             # Version number (e.g., 1.0.0)
MAIN_BRANCH="main"                          # Your main branch name
```

### 2. Add Repositories

Update the `REPOSITORIES` array with your project and repository names in the format `ProjectName/RepositoryName`:

```bash
REPOSITORIES=(
    "ProjectName/RepositoryName1"
    "ProjectName/RepositoryName2"
    "AnotherProject/RepositoryName3"
)
```

## Usage

### Running the Script

Make the script executable:
```bash
chmod +x release-branching.sh
```

Run the script:
```bash
./release-branching.sh
```

### Menu Options

The script presents an interactive menu with three options:

#### Option 1: Create Release Branches

Creates a new release branch in each configured repository based on your `MAIN_BRANCH`.

**What it does:**
1. Clones each repository at the main branch
2. Creates a new branch with the format `release/v{VERSION}`
3. Pushes the new branch to Azure DevOps
4. Cleans up local clones

**Example execution:**
```
Select an option:
1) Create release branches
2) Delete release branches
3) List repositories by project
Choose an option (1, 2, or 3): 1
Enter your Azure DevOps token: ***
Creating release branches for all provided repositories...
Processing repository: RepositoryName1 in project: ProjectName
```

#### Option 2: Delete Release Branches

Removes the release branch from each configured repository.

**What it does:**
1. Clones each repository at the release branch
2. Deletes the remote branch from Azure DevOps
3. Cleans up local clones

**Use case:** When a release is completed and the branch is no longer needed.

#### Option 3: List Repositories

Lists all repositories in a specific Azure DevOps project.

**What it does:**
1. Prompts you to enter a project name
2. Queries the Azure DevOps REST API
3. Displays all repositories in that project

**Use case:** Useful for discovering repository names when configuring the `REPOSITORIES` array.

## Authentication

The script prompts for your Azure DevOps Personal Access Token (PAT) on each run.

### Creating a Personal Access Token

1. Go to Azure DevOps (https://dev.azure.com)
2. Click your profile icon → **Personal access tokens**
3. Click **New Token**
4. Configure:
   - **Name:** descriptive name (e.g., "Release Branch Manager")
   - **Organization:** select your organization
   - **Expiration:** choose appropriate duration
   - **Scopes:** select `Code (read & write)` for full repository access
5. Click **Create** and copy the token
6. Store it securely (you'll need it each time you run the script)

## Example Workflow

### Scenario: Creating Release Branches for Version 2.5.0

1. Update configuration:
```bash
VERSION="2.5.0"
BRANCH_PREFIX="release/v"
REPOSITORIES=(
    "MyProject/FrontendRepo"
    "MyProject/BackendRepo"
    "MyProject/APIRepo"
)
```

2. Run the script:
```bash
./release-branching.sh
```

3. Select option **1** to create branches
4. Enter your Azure DevOps token when prompted
5. The script creates `release/v2.5.0` in all three repositories

### Scenario: Listing Repositories in a Project

1. Run the script:
```bash
./release-branching.sh
```

2. Select option **3**
3. Enter project name: `MyProject`
4. View all available repositories in that project

## Security Considerations

- **Never** commit your PAT or configuration file with real tokens to version control
- Consider using environment variables for sensitive data:
  ```bash
  export AZURE_DEVOPS_TOKEN="your-token-here"
  ```
- Regenerate your PAT periodically
- Use tokens with minimal required permissions
- Keep your `release-branching.sh` file restricted to authorized users

## Troubleshooting

### Error: "Authentication failed"
- Verify your Azure DevOps organization URL
- Ensure your PAT is valid and has not expired
- Confirm your token has `Code (read & write)` scope

### Error: "Branch already exists"
- The release branch already exists in the repository
- Delete it first using option 2, or manually remove and retry

### Error: "jq: command not found" (for List Repositories)
- Install jq:
  ```bash
  sudo apt-get install jq  # Ubuntu/Debian
  brew install jq          # macOS
  ```

### Repositories not found
- Verify the format: `ProjectName/RepositoryName`
- Check that repositories are accessible with your token
- Confirm the repository URLs are correct in Azure DevOps

## Tips and Best Practices

1. **Test first:** Create a test repository entry to verify configuration before running on production repos
2. **Version consistency:** Use semantic versioning (e.g., 1.0.0, 2.5.0)
3. **Backup:** Ensure your main branch is backed up before large operations
4. **Notifications:** Consider adding notifications after branch creation for team awareness
5. **Documentation:** Document your branching strategy and version numbers in your project wiki

## Support

For issues or questions:
- Check Azure DevOps documentation: https://docs.microsoft.com/en-us/azure/devops/
- Review Git branching strategies
- Verify token permissions and repository access
