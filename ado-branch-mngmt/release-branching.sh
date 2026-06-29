#!/bin/bash

# Configuration
AZURE_DEVOPS_URL="dev.azure.com/XXXX"  # Replace with your Azure DevOps organization URL
BRANCH_PREFIX="release/v"
VERSION="x.x.x"  # Example: 1.0.0
FULL_RELEASE_BRANCH="$BRANCH_PREFIX$VERSION"
MAIN_BRANCH="main"  # Change this to your main branch name if different

# List of repositories with their respective projects
REPOSITORIES=(
    "ProjectName/RepositoryName"
)

# Azure DevOps Authentication
read -p "Enter your Azure DevOps token: " AZURE_DEVOPS_TOKEN

create_release_branches() {
  echo "Creating release branches for all provided repositories..."
  for REPO_ENTRY in "${REPOSITORIES[@]}"; do
    PROJECT=$(echo "$REPO_ENTRY" | cut -d '/' -f1)
    REPO=$(echo "$REPO_ENTRY" | cut -d '/' -f2)
    echo "Processing repository: $REPO in project: $PROJECT"

    # Temporarily clone the repository
    git clone --quiet --branch $MAIN_BRANCH --depth 1 "https://$AZURE_DEVOPS_TOKEN@$AZURE_DEVOPS_URL/$PROJECT/_git/$REPO" "$REPO"
    cd "$REPO" || exit

    # Create the new release branch
    git checkout -b "$FULL_RELEASE_BRANCH"
    git push origin "$FULL_RELEASE_BRANCH"

    # Clean up
    cd ..
    rm -rf "$REPO"
  done
}

delete_release_branches() {
  echo "Deleting all release branches..."
  for REPO_ENTRY in "${REPOSITORIES[@]}"; do
    PROJECT=$(echo "$REPO_ENTRY" | cut -d '/' -f1)
    REPO=$(echo "$REPO_ENTRY" | cut -d '/' -f2)
    echo "Deleting release branch for repository: $REPO in project: $PROJECT"

    git clone --quiet --branch $FULL_RELEASE_BRANCH --depth 1 "https://$AZURE_DEVOPS_TOKEN@$AZURE_DEVOPS_URL/$PROJECT/_git/$REPO" "$REPO"
    cd "$REPO" || exit

    git push origin --delete "$FULL_RELEASE_BRANCH"

    cd ..
    rm -rf "$REPO"
  done
}

list_repositories() {
  read -p "Enter the project name: " LIST_PROJECT
  echo "Fetching repositories for project: $LIST_PROJECT..."

  # Fetch repository list from Azure DevOps REST API
  echo curl -s -u :"$AZURE_DEVOPS_TOKEN" "https://$AZURE_DEVOPS_URL/$LIST_PROJECT/_apis/git/repositories?api-version=6.0"
  RESPONSE=$(curl -s -u :"$AZURE_DEVOPS_TOKEN" "https://$AZURE_DEVOPS_URL/$LIST_PROJECT/_apis/git/repositories?api-version=6.0")
  
  echo "Repositories in project $LIST_PROJECT:"
  echo "$RESPONSE" | jq -r '.value[] | .name'
}

main() {
  echo "Select an option:"
  echo "1) Create release branches"
  echo "2) Delete release branches"
  echo "3) List repositories by project"
  read -rp "Choose an option (1, 2, or 3): " OPTION

  case $OPTION in
    1)
      create_release_branches
      ;;
    2)
      delete_release_branches
      ;;
    3)
      list_repositories
      ;;
    *)
      echo "Invalid option. Exiting..."
      exit 1
      ;;
  esac
}

main