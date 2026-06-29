# Tools Repository

A comprehensive collection of utility tools for development, system administration, data processing, and DevOps workflows. Each tool is self-contained with its own documentation and usage examples.

## Overview

This repository contains 21+ handy tools that assist with various development and operations tasks including:
- Configuration management
- Data format conversion
- Network analysis
- Azure cloud integration
- Docker containerization
- Password generation and security
- CSV and data processing
- Web utilities

## Tools Index

### 🔷 Azure & Cloud Tools

#### [fetch-appconfiguration](fetch-appconfiguration/)
Python utility for retrieving and exporting all configuration keys and values from Azure App Configuration. Useful for auditing, backup, documentation, and configuration migration tasks.
- **Language:** Python
- **Use Case:** Azure App Configuration management
- **Features:** Export to JSON, filtering, batch operations

### 📊 Data Processing & Analysis

#### [concat-csv](concat-csv/)
Python tool for merging multiple CSV files from a folder into a single consolidated CSV file. Perfect for combining data from similar sources or batch processing CSV files.
- **Language:** Python
- **Use Case:** CSV file consolidation
- **Features:** Automatic folder scanning, DataFrame handling, flexible column support

#### [ip-counter](ip-counter/)
Python utility for analyzing and counting IP address occurrences in CSV files. Identifies the top N most frequent IP addresses, useful for network analysis, traffic monitoring, and DDoS detection.
- **Language:** Python
- **Use Case:** Network traffic analysis, IP activity detection
- **Features:** Frequency counting, top-N reporting, filtering, statistics

#### [json-to-csv](json-to-csv/)
Web-based tool for converting JSON data to CSV format with an interactive HTML interface.
- **Language:** JavaScript/HTML
- **Use Case:** JSON to CSV conversion
- **Features:** Web-based, real-time conversion, download support

#### [parse-ips](parse-ips/)
Python tool for parsing and processing IP addresses from files.
- **Language:** Python
- **Use Case:** IP address extraction and processing

#### [parser-journeys](parser-journeys/)
Python tool for parsing journey/travel data from input files.
- **Language:** Python
- **Use Case:** Journey data processing

#### [seat-comparer](seat-comparer/)
Python utilities for comparing and merging seat offer configurations.
- **Language:** Python
- **Use Case:** Seat/offer data comparison

### 🐳 Docker & Containerization

#### [docker-httpserver](docker-httpserver/)
Docker setup for a simple HTTP server with configurable content.
- **Technology:** Docker, Nginx/HTTP
- **Use Case:** Local HTTP server testing
- **Features:** Dockerfile, public directory support

#### [docker-k6](docker-k6/)
Docker container for k6 load testing framework with browser support.
- **Technology:** Docker, k6
- **Use Case:** Performance and load testing
- **Features:** Browser automation, script-based testing

#### [docker-mongo](docker-mongo/)
Complete Docker setup for MongoDB with Docker Compose including data persistence and scripts.
- **Technology:** Docker, Docker Compose, MongoDB
- **Use Case:** Local MongoDB development
- **Features:** Container orchestration, data persistence, helper scripts

#### [docker-redis](docker-redis/)
Docker setup for Redis server with Redis Commander web UI and .NET sample application.
- **Technology:** Docker, Docker Compose, Redis
- **Use Case:** Local Redis development and management
- **Features:** Redis server, web-based GUI, sample .NET app

#### [docker-run-scripts-to-mongo](docker-run-scripts-to-mongo/)
Docker container for running MongoDB scripts with Node.js support.
- **Technology:** Docker, Node.js, MongoDB
- **Use Case:** Automated MongoDB script execution

#### [docker-sqlserver-express](docker-sqlserver-express/)
Docker Compose setup for SQL Server Express with database configuration.
- **Technology:** Docker, Docker Compose, SQL Server
- **Use Case:** Local SQL Server development
- **Features:** Container orchestration, database initialization

#### [docker-ssl](docker-ssl/)
Docker Compose configuration for SSL/TLS certificate setup.
- **Technology:** Docker, Docker Compose, SSL/TLS
- **Use Case:** SSL certificate testing and configuration

### 🌐 Web Utilities

#### [base64-converter](base64-converter/)
Web-based Base64 encoder/decoder with image conversion support.
- **Language:** JavaScript/HTML
- **Use Case:** Base64 encoding/decoding, image conversion
- **Features:** Text encoding, image display from Base64

#### [hex-to-text-converter](hex-to-text-converter/)
Web-based utility for converting hexadecimal to text and vice versa.
- **Language:** JavaScript/HTML
- **Use Case:** Hex/text conversion
- **Features:** Real-time conversion, interactive interface

#### [json-to-xml](json-to-xml/)
Web-based tool for converting JSON data to XML format.
- **Language:** JavaScript/HTML
- **Use Case:** JSON to XML conversion
- **Features:** Real-time conversion, XML validation

#### [url-decoder](url-decoder/)
Web-based URL encoder and decoder for encoding/decoding URLs.
- **Language:** JavaScript/HTML
- **Use Case:** URL encoding/decoding
- **Features:** Bidirectional conversion, text area support

### 🔧 Development & System Tools

#### [ado-branch-mngmt](ado-branch-mngmt/)
Bash script for automating release branch creation and deletion across multiple Azure DevOps repositories.
- **Language:** Bash
- **Use Case:** Azure DevOps branch management
- **Features:** Batch operations, repository discovery, token authentication

#### [check-pfx-certs](check-pfx-certs/)
C# utility for loading, inspecting, and validating PFX certificate files.
- **Language:** C#/.NET
- **Use Case:** Certificate inspection and validation
- **Features:** Subject/Issuer display, validity checking, certificate metadata

#### [cucumber-json-formatter](cucumber-json-formatter/)
Bash script for converting Cucumber test results from NDJSON to standard JSON format.
- **Language:** Bash
- **Use Case:** Test result formatting
- **Features:** Format conversion, CI/CD integration, auto-installation

#### [rabbitmq-pwd-gen](rabbitmq-pwd-gen/)
Bash script for generating RabbitMQ-compatible password hashes using SHA-512 with salt.
- **Language:** Bash
- **Use Case:** RabbitMQ user authentication
- **Features:** Secure hashing, salt generation, configuration file support

#### [request-tool](request-tool/)
Python utility for making HTTP requests and processing responses.
- **Language:** Python
- **Use Case:** HTTP request testing

#### [reverse-proxy](reverse-proxy/)
Docker-based reverse proxy setup for routing requests to backend services.
- **Technology:** Docker, Nginx/HAProxy
- **Use Case:** Request routing and load balancing

#### [retail-apis-viewer](retail-apis-viewer/)
Web-based viewer for retail API data including seat maps and trip information.
- **Language:** JavaScript/HTML
- **Use Case:** Retail data visualization
- **Features:** Seatmap viewer, offer viewer, JSON data integration

## Quick Navigation

### By Technology
- **Python:** concat-csv, fetch-appconfiguration, ip-counter, parse-ips, parser-journeys, seat-comparer, request-tool
- **JavaScript/HTML:** base64-converter, hex-to-text-converter, json-to-csv, json-to-xml, url-decoder, retail-apis-viewer
- **Bash:** ado-branch-mngmt, cucumber-json-formatter, rabbitmq-pwd-gen
- **Docker/Compose:** docker-httpserver, docker-k6, docker-mongo, docker-redis, docker-run-scripts-to-mongo, docker-sqlserver-express, docker-ssl, reverse-proxy
- **C#/.NET:** check-pfx-certs, docker-redis (includes sample app)

### By Category
- **Data Processing:** concat-csv, ip-counter, json-to-csv, parse-ips, parser-journeys, seat-comparer
- **Web Tools:** base64-converter, hex-to-text-converter, json-to-csv, json-to-xml, url-decoder, retail-apis-viewer
- **Cloud & Azure:** fetch-appconfiguration, ado-branch-mngmt
- **Docker:** docker-httpserver, docker-k6, docker-mongo, docker-redis, docker-run-scripts-to-mongo, docker-sqlserver-express, docker-ssl, reverse-proxy
- **DevOps & Security:** check-pfx-certs, cucumber-json-formatter, rabbitmq-pwd-gen, ado-branch-mngmt
- **Utilities:** url-decoder, request-tool

## Getting Started

Each tool has its own directory with:
- **README.md** - Comprehensive documentation, usage examples, troubleshooting
- **Source code** - The actual tool implementation
- **Configuration files** - Docker Compose, app settings, etc. (where applicable)

### Steps to Use Any Tool

1. **Navigate to the tool folder:**
   ```bash
   cd <tool-name>
   ```

2. **Read the README:**
   ```bash
   cat README.md
   ```

3. **Follow the setup instructions** for your specific tool

4. **Use according to documented examples**

## Requirements by Tool Type

### Python Tools
- Python 3.6+
- pip package manager
- Specific dependencies listed in each tool's requirements.txt

### Bash Tools
- Bash shell
- Standard Unix utilities (grep, sed, awk, etc.)
- Tool-specific commands (docker, curl, etc.)

### Web Tools (HTML/JavaScript)
- Modern web browser
- No installation required - just open in browser

### Docker Tools
- Docker (version 20.10+)
- Docker Compose (version 1.29+)

### .NET Tools
- .NET Framework or .NET Core/5+
- Visual Studio or .NET CLI

## Usage Examples

### Convert CSV Files
```bash
cd concat-csv
python main.py
```

### Analyze IP Addresses
```bash
cd ip-counter
python main.py
```

### Start Redis with Docker
```bash
cd docker-redis
docker-compose up
# Access at http://localhost:8082
```

### Generate RabbitMQ Password Hash
```bash
cd rabbitmq-pwd-gen
./rabbitmq-pass-gen.sh
```

### Convert URL Encoding
Open in browser:
```
url-decoder/index.html
```

## Features Across Tools

- 📝 **Data Format Conversion** - CSV, JSON, XML, Base64, Hex
- 🔐 **Security & Encryption** - Password generation, certificate inspection
- 🌐 **Web Utilities** - Interactive HTML/JavaScript tools
- 🐳 **Containerization** - Docker and Docker Compose setups
- ☁️ **Cloud Integration** - Azure services, DevOps
- 📊 **Data Analysis** - IP counting, journey parsing, seat comparison
- 🔧 **Development** - .NET, Python, Bash utilities
- 🧪 **Testing** - k6 load testing, HTTP server testing

## Project Structure

```
Tools/
├── README.md                           # This file
├── ado-branch-mngmt/                   # Azure DevOps branch management
├── base64-converter/                   # Base64 encoding/decoding
├── check-pfx-certs/                    # PFX certificate inspection
├── concat-csv/                         # CSV file consolidation
├── cucumber-json-formatter/            # Test result formatting
├── docker-httpserver/                  # HTTP server container
├── docker-k6/                          # k6 load testing container
├── docker-mongo/                       # MongoDB container setup
├── docker-redis/                       # Redis container setup
├── docker-run-scripts-to-mongo/        # MongoDB script runner
├── docker-sqlserver-express/           # SQL Server container
├── docker-ssl/                         # SSL/TLS setup
├── fetch-appconfiguration/             # Azure App Configuration client
├── hex-to-text-converter/              # Hex/text conversion
├── ip-counter/                         # IP address analysis
├── json-to-csv/                        # JSON to CSV conversion
├── json-to-xml/                        # JSON to XML conversion
├── parse-ips/                          # IP parsing utility
├── parser-journeys/                    # Journey data parser
├── rabbitmq-pwd-gen/                   # RabbitMQ password generator
├── request-tool/                       # HTTP request utility
├── reverse-proxy/                      # Reverse proxy setup
├── retail-apis-viewer/                 # Retail API viewer
├── seat-comparer/                      # Seat comparison tool
└── url-decoder/                        # URL encoding/decoding
```

## Documentation

Each tool includes comprehensive documentation:
- **Setup instructions** - Prerequisites, installation, configuration
- **Usage examples** - Basic and advanced usage patterns
- **API reference** - Function parameters and return values
- **Troubleshooting** - Common issues and solutions
- **Security considerations** - Best practices and warnings
- **Performance tips** - Optimization strategies
- **Integration examples** - Using with other tools and services

## Contributing

To add a new tool or improve existing ones:
1. Follow the same structure (README.md + source code)
2. Include comprehensive documentation
3. Add examples and use cases
4. Update this main README

## License

Each tool may have its own license. See individual tool directories for details.

## Support

For issues or questions about specific tools:
1. Check the tool's README.md for troubleshooting
2. Review the examples and documentation
3. Verify prerequisites are installed
4. Check tool-specific GitHub repositories or official documentation

## Maintenance

- Last Updated: June 29, 2026
- Tools Count: 24
- Languages: Python, Bash, JavaScript/HTML, C#/.NET

---

**Happy coding! Pick a tool and get started! 🚀**
