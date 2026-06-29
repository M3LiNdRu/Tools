# Install cucumber-json-formatter if not available
if ! command -v cucumber-json-formatter &> /dev/null; then
    echo "Installing cucumber-json-formatter..."
    curl -L https://github.com/cucumber/json-formatter/releases/download/v19.0.0/cucumber-json-formatter-linux-amd64 -o cucumber-json-formatter
    chmod +x cucumber-json-formatter
    #export PATH="/tmp:$PATH"
fi

# Convert ndjson to standard Cucumber JSON format
if [ -f "./TestResults/cucumber-results.ndjson" ]; then
    echo "Converting Cucumber messages to JSON format..."
    cat "./TestResults/cucumber-results.ndjson" | ./cucumber-json-formatter > "./TestResults/cucumber-results.json"
    echo "✓ Cucumber JSON generated successfully"
else
    echo "⚠️  No Cucumber messages file found"
fi