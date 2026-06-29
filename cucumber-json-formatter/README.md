# Cucumber JSON Formatter Tool

A bash script utility that converts Cucumber test results from NDJSON (newline-delimited JSON) format to standard Cucumber JSON format. Essential for processing and reporting on Cucumber/Gherkin test execution results.

## Overview

The **Cucumber JSON Formatter** tool helps you:

- Convert Cucumber message format (NDJSON) to standard JSON
- Automate test result formatting in CI/CD pipelines
- Generate compatible JSON reports for various Cucumber reporting tools
- Process test results from multiple testing frameworks
- Create integration-ready test reports

This tool is particularly useful in automated testing workflows where test results need to be converted into a standardized format for reporting, analysis, and integration with other tools.

## What is NDJSON?

**NDJSON** (Newline Delimited JSON) is a format where each line is a valid JSON object. Cucumber test frameworks often output results in this format, with one message per line representing different test events (feature start, scenario start, step execution, etc.).

**Standard Cucumber JSON** consolidates these individual messages into a single, unified JSON structure that is easier to parse and process with reporting tools.

## Prerequisites

- **Bash** shell environment (Linux, macOS, or Windows with WSL)
- **curl** for downloading the formatter
- **Linux machine** or compatible Unix-like environment
- Cucumber test results in NDJSON format

## Installation

The script includes automatic installation of the `cucumber-json-formatter` tool:

```bash
# The script will automatically download and install if not available
bash script.sh
```

### Manual Installation

If you prefer to install manually:

```bash
# Download the formatter for Linux
curl -L https://github.com/cucumber/json-formatter/releases/download/v19.0.0/cucumber-json-formatter-linux-amd64 -o cucumber-json-formatter

# Make it executable
chmod +x cucumber-json-formatter

# Verify installation
./cucumber-json-formatter --version
```

## Project Structure

```
cucumber-json-formatter/
├── script.sh                         # Main conversion script
├── cucumber-json-formatter           # Binary formatter (auto-downloaded)
├── report.json                       # Example output report
├── TestResults/
│   ├── cucumber-results.ndjson      # Input test results
│   └── cucumber-results.json        # Generated output
└── README.md                         # This file
```

## Configuration

### Input Format

The script expects Cucumber test results in NDJSON format at:

```
./TestResults/cucumber-results.ndjson
```

### Output Location

The converted JSON will be generated at:

```
./TestResults/cucumber-results.json
```

### NDJSON Example Input

```json
{"envelope":{"meta":{"protocolVersion":"22.0.0","implementation":{"name":"cucumber-js","version":"9.0.0"},"runtime":{"name":"node","version":"18.0.0"}}}}
{"envelope":{"gherkinDocument":{"uri":"features/login.feature","feature":{"keyword":"Feature","name":"User Login","children":[{"keyword":"Scenario","name":"Valid login","steps":[{"keyword":"Given","text":"User is on login page"},{"keyword":"When","text":"User enters credentials"},{"keyword":"Then","text":"User is logged in"}]}]}}}}
{"envelope":{"testRunStarted":{"timestamp":{"seconds":1234567890}}}}
```

## Usage

### Step 1: Prepare Input Files

Place your Cucumber NDJSON test results in the `TestResults` folder:

```bash
# Copy or generate your test results
cp your-test-results.ndjson ./TestResults/cucumber-results.ndjson
```

### Step 2: Run the Script

```bash
bash script.sh
```

### Step 3: Check Output

The converted JSON file will be created at:

```bash
./TestResults/cucumber-results.json
```

### Example Execution

```bash
$ bash script.sh
Installing cucumber-json-formatter...
  % Total    % Received % Xferd  Average Speed   Time     Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   102  100   102    0     0    150      0 --:--:-- --:--:-- 1.23M  1.23M
Converting Cucumber messages to JSON format...
✓ Cucumber JSON generated successfully
```

## How It Works

1. **Checks** if `cucumber-json-formatter` is installed in the current directory
2. **Downloads** the formatter if not found (Linux amd64 version)
3. **Makes** the binary executable
4. **Verifies** that input NDJSON file exists at `./TestResults/cucumber-results.ndjson`
5. **Pipes** the NDJSON content to the formatter
6. **Generates** standard Cucumber JSON output
7. **Saves** the result to `./TestResults/cucumber-results.json`

## Output Structure

The generated JSON includes a comprehensive test report:

```json
{
  "uri": "features/login.feature",
  "id": "user-login",
  "keyword": "Feature",
  "name": "User Login",
  "line": 1,
  "description": "Feature description...",
  "elements": [
    {
      "id": "valid-login",
      "keyword": "Scenario",
      "name": "Valid login",
      "line": 5,
      "steps": [
        {
          "keyword": "Given ",
          "name": "User is on login page",
          "line": 6,
          "match": {
            "location": "features/step_definitions/login_steps.js:1"
          },
          "result": {
            "status": "passed",
            "duration": 250000000
          }
        }
      ]
    }
  ]
}
```

## Integration Examples

### With Jenkins

Add to your Jenkinsfile:

```groovy
stage('Convert Test Results') {
    steps {
        sh 'bash cucumber-json-formatter/script.sh'
        publishHTML([
            reportDir: 'TestResults',
            reportFiles: 'cucumber-results.json',
            reportName: 'Cucumber Report'
        ])
    }
}
```

### With GitLab CI

Add to `.gitlab-ci.yml`:

```yaml
convert_tests:
  stage: test
  script:
    - cd cucumber-json-formatter
    - bash script.sh
  artifacts:
    paths:
      - TestResults/cucumber-results.json
    reports:
      cucumber: TestResults/cucumber-results.json
```

### With GitHub Actions

Add to `.github/workflows/test.yml`:

```yaml
- name: Convert Cucumber Results
  run: |
    cd cucumber-json-formatter
    bash script.sh
    
- name: Publish Test Results
  uses: EnricoMi/publish-unit-test-result-action@v2
  with:
    files: TestResults/cucumber-results.json
```

## Generating NDJSON from Different Test Frameworks

### Cucumber.js

```bash
npx cucumber-js features/ --format json:TestResults/cucumber-results.ndjson
```

### Cucumber Java

```bash
mvn test -Dcucumber.plugin="message:TestResults/cucumber-results.ndjson"
```

### Cucumber Python

```bash
pytest features/ --cucumber-json=TestResults/cucumber-results.ndjson
```

### Cucumber Ruby

```bash
cucumber features --format json --out TestResults/cucumber-results.ndjson
```

## Troubleshooting

### Error: "No Cucumber messages file found"

**Cause:** The input NDJSON file doesn't exist at the expected location.

**Solution:**
```bash
# Verify file exists
ls -la TestResults/cucumber-results.ndjson

# If missing, ensure your test framework outputs to this location
# Or copy your results file to the correct location
cp your-results.ndjson ./TestResults/cucumber-results.ndjson
```

### Error: "command not found: cucumber-json-formatter"

**Solution:** The script will auto-install, but if it fails:
```bash
# Manual installation
curl -L https://github.com/cucumber/json-formatter/releases/download/v19.0.0/cucumber-json-formatter-linux-amd64 -o cucumber-json-formatter
chmod +x cucumber-json-formatter
```

### Error: "Permission denied" when running script

**Solution:** Make the script executable
```bash
chmod +x script.sh
```

### Output JSON is empty

**Cause:** Input NDJSON file is empty or corrupted.

**Solution:**
```bash
# Check file size and content
wc -l TestResults/cucumber-results.ndjson
head TestResults/cucumber-results.ndjson

# Regenerate test results
npm test -- --format json:TestResults/cucumber-results.ndjson
```

### Platform-specific errors

**Issue:** Running on macOS or Windows
- Download the appropriate binary for your platform:
  - Linux: `cucumber-json-formatter-linux-amd64`
  - macOS: `cucumber-json-formatter-darwin-amd64` or `cucumber-json-formatter-darwin-arm64`
  - Windows: Use WSL or Docker

## Advanced Usage

### Custom Output Paths

Modify `script.sh` to use custom paths:

```bash
INPUT_FILE="./path/to/your/results.ndjson"
OUTPUT_FILE="./path/to/output/report.json"

if [ -f "$INPUT_FILE" ]; then
    echo "Converting Cucumber messages to JSON format..."
    cat "$INPUT_FILE" | ./cucumber-json-formatter > "$OUTPUT_FILE"
    echo "✓ Cucumber JSON generated successfully"
fi
```

### Batch Processing Multiple Files

```bash
#!/bin/bash

for ndjson_file in TestResults/*.ndjson; do
    json_file="${ndjson_file%.ndjson}.json"
    echo "Converting $ndjson_file..."
    cat "$ndjson_file" | ./cucumber-json-formatter > "$json_file"
done

echo "All files converted successfully!"
```

### Conditional Processing

```bash
#!/bin/bash

if [ -f "./TestResults/cucumber-results.ndjson" ]; then
    if [ -s "./TestResults/cucumber-results.ndjson" ]; then  # Check if file is not empty
        echo "Converting Cucumber messages to JSON format..."
        cat "./TestResults/cucumber-results.ndjson" | ./cucumber-json-formatter > "./TestResults/cucumber-results.json"
        echo "✓ Cucumber JSON generated successfully"
    else
        echo "⚠️  Input file is empty"
    fi
else
    echo "⚠️  No Cucumber messages file found"
fi
```

## Performance Considerations

- **Large Files:** For very large NDJSON files (>100MB), the conversion may take a few seconds
- **Memory Usage:** The formatter streams data, so memory usage is relatively low
- **Disk Space:** Ensure sufficient disk space for both input and output files

## Output Validation

After conversion, verify the output:

```bash
# Check if JSON is valid
jq empty ./TestResults/cucumber-results.json && echo "Valid JSON"

# Display summary
jq '.[] | {uri, elements: (.elements | length)}' ./TestResults/cucumber-results.json

# Count total steps
jq '[.. | .steps?] | flatten | length' ./TestResults/cucumber-results.json
```

## Reporting Tools Compatibility

The generated JSON format is compatible with:

- **Allure Report** - Test automation framework
- **Extent Report** - HTML reporting
- **Cucumber Reports** - Native Cucumber reporting
- **Jenkins** - Cucumber plugin
- **Azure DevOps** - Test results integration
- **CloudBees** - CI/CD integration

## Related Resources

- [Cucumber JSON Formatter GitHub](https://github.com/cucumber/json-formatter)
- [Cucumber Documentation](https://cucumber.io/docs/cucumber/)
- [Gherkin Syntax](https://cucumber.io/docs/gherkin/)
- [NDJSON Specification](http://ndjson.org/)
- [Allure Report Integration](https://docs.qameta.io/allure/)

## Common Workflows

### Local Development

```bash
# Generate tests with messages format
npm test -- --format json:TestResults/cucumber-results.ndjson

# Convert to standard JSON
bash cucumber-json-formatter/script.sh

# View results
cat TestResults/cucumber-results.json | jq .
```

### CI/CD Pipeline

```bash
# Run tests
npm test -- --format json:TestResults/cucumber-results.ndjson

# Convert format
cd cucumber-json-formatter && bash script.sh && cd ..

# Generate report
npx allure generate --clean -o allure-report

# Publish results
```

## License

This tool wrapper is provided as-is. The underlying `cucumber-json-formatter` is maintained by the Cucumber team.

## Support

For issues or questions:
- Check that test framework outputs NDJSON format correctly
- Verify file paths and permissions
- Review Cucumber documentation
- Check formatter GitHub issues: https://github.com/cucumber/json-formatter/issues
