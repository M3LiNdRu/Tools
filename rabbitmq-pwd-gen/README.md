# RabbitMQ Password Generator

A bash utility script for generating RabbitMQ-compatible password hashes. Useful for creating secure passwords for RabbitMQ user authentication in configuration files and Docker containers.

## Overview

The **RabbitMQ Password Generator** helps you:

- Generate RabbitMQ-compatible password hashes
- Create secure password entries for `rabbitmq.conf` configuration files
- Automate user creation in RabbitMQ deployments
- Generate hashes for Docker Compose setups
- Integrate password generation into deployment scripts

This tool is essential for system administrators and DevOps engineers setting up RabbitMQ servers with custom user credentials.

## What is RabbitMQ?

**RabbitMQ** is an open-source message broker that uses:
- Username/password authentication for users
- Salted SHA-512 hashing for password storage
- Base64 encoding for configuration files
- The `rabbitmq_password_hashing_sha512` algorithm by default

## Prerequisites

- **Bash** shell environment (Linux, macOS, or Windows with WSL)
- **od** command (usually pre-installed on Unix-like systems)
- **xxd** command (usually pre-installed on Unix-like systems)
- **sha512sum** command (usually pre-installed on Unix-like systems)
- **base64** command (usually pre-installed on Unix-like systems)

These utilities are part of the standard GNU coreutils and are available on most Linux distributions.

### Verify Prerequisites

```bash
# Check if all required commands are available
command -v od && echo "od: OK"
command -v xxd && echo "xxd: OK"
command -v sha512sum && echo "sha512sum: OK"
command -v base64 && echo "base64: OK"
```

## Project Structure

```
rabbitmq-pwd-gen/
├── rabbitmq-pass-gen.sh     # Main script
└── README.md                # This file
```

## How It Works

The script implements RabbitMQ's password hashing algorithm:

1. **Generate Salt:** Creates a random 4-byte salt using `/dev/urandom`
2. **Combine:** Concatenates salt + password in hex format
3. **Hash:** Applies SHA-512 hashing to the combination
4. **Encode:** Base64 encodes the final result for storage

The output is compatible with RabbitMQ's `rabbit_password_hashing_sha512` authentication mechanism.

## Usage

### Basic Usage

```bash
# Make the script executable
chmod +x rabbitmq-pass-gen.sh

# Generate a hash for a password
./rabbitmq-pass-gen.sh
```

### Example Execution

```bash
$ ./rabbitmq-pass-gen.sh
SWQV/UkqF9BFZF5UQEZJOKLHhQ1K1pz6Wl0Q4f9K3K4=
```

Each time you run the script, it generates a different hash (due to random salt).

## Customizing the Script

### Generate Hash for Custom Password

Edit the script and replace the password:

```bash
#!/bin/bash

function encode_password()
{
    SALT=$(od -A n -t x -N 4 /dev/urandom)
    PASS=$SALT$(echo -n $1 | xxd -ps | tr -d '\n' | tr -d ' ')
    PASS=$(echo -n $PASS | xxd -r -p | sha512sum | head -c 128)
    PASS=$(echo -n $SALT$PASS | xxd -r -p | base64 | tr -d '\n')
    echo $PASS
}

# Change this password
encode_password "your_secure_password_here"
```

Then run:
```bash
./rabbitmq-pass-gen.sh
```

### Create an Interactive Version

Modify the script to accept password as command-line argument:

```bash
#!/bin/bash

function encode_password()
{
    SALT=$(od -A n -t x -N 4 /dev/urandom)
    PASS=$SALT$(echo -n $1 | xxd -ps | tr -d '\n' | tr -d ' ')
    PASS=$(echo -n $PASS | xxd -r -p | sha512sum | head -c 128)
    PASS=$(echo -n $SALT$PASS | xxd -r -p | base64 | tr -d '\n')
    echo $PASS
}

# Accept password from command line
if [ -z "$1" ]; then
    echo "Usage: $0 <password>"
    exit 1
fi

encode_password "$1"
```

Then use as:
```bash
./rabbitmq-pass-gen.sh "letmein"
```

### Multiple Passwords in Batch

Create a script to generate hashes for multiple passwords:

```bash
#!/bin/bash

function encode_password()
{
    SALT=$(od -A n -t x -N 4 /dev/urandom)
    PASS=$SALT$(echo -n $1 | xxd -ps | tr -d '\n' | tr -d ' ')
    PASS=$(echo -n $PASS | xxd -r -p | sha512sum | head -c 128)
    PASS=$(echo -n $SALT$PASS | xxd -r -p | base64 | tr -d '\n')
    echo $PASS
}

# Generate hashes for multiple users
declare -A users=(
    [admin]="admin_password"
    [developer]="dev_password"
    [monitor]="monitor_password"
)

for user in "${!users[@]}"; do
    password="${users[$user]}"
    hash=$(encode_password "$password")
    echo "User: $user"
    echo "Hash: $hash"
    echo "---"
done
```

## RabbitMQ Configuration

### In rabbitmq.conf

Once you have the hash, use it in your RabbitMQ configuration:

```conf
# rabbitmq.conf

# Define users with hashed passwords
default_user = admin
default_pass_hash = <your_generated_hash>

# Additional users
management.load_definitions = /etc/rabbitmq/definitions.json
```

### In definitions.json

For more complex setups with multiple users:

```json
{
  "rabbit_version": "3.12.0",
  "users": [
    {
      "name": "admin",
      "password_hash": "<your_generated_hash>",
      "hashing_algorithm": "rabbit_password_hashing_sha512",
      "tags": "administrator"
    },
    {
      "name": "developer",
      "password_hash": "<another_hash>",
      "hashing_algorithm": "rabbit_password_hashing_sha512",
      "tags": "management"
    }
  ],
  "permissions": [
    {
      "user": "admin",
      "vhost": "/",
      "configure": ".*",
      "write": ".*",
      "read": ".*"
    }
  ]
}
```

### In Docker Compose

```yaml
version: '3'
services:
  rabbitmq:
    image: rabbitmq:3-management
    environment:
      RABBITMQ_DEFAULT_USER: admin
      RABBITMQ_DEFAULT_PASS: your_password  # Or use the hash if your setup supports it
    ports:
      - "5672:5672"
      - "15672:15672"
    volumes:
      - ./rabbitmq.conf:/etc/rabbitmq/rabbitmq.conf:ro
```

## Common Use Cases

### 1. Initial RabbitMQ Setup

```bash
# Generate admin password hash
./rabbitmq-pass-gen.sh > /tmp/admin_hash.txt

# View the hash
cat /tmp/admin_hash.txt
```

### 2. Docker Initialization

```bash
#!/bin/bash

# Generate password hashes
admin_hash=$(./rabbitmq-pass-gen.sh)

# Create rabbitmq.conf
cat > rabbitmq.conf << EOF
default_user = admin
default_pass_hash = $admin_hash
management.load_definitions = /etc/rabbitmq/definitions.json
EOF
```

### 3. Kubernetes Secret Creation

```bash
# Generate hash
password_hash=$(./rabbitmq-pass-gen.sh)

# Create Kubernetes secret
kubectl create secret generic rabbitmq-credentials \
  --from-literal=username=admin \
  --from-literal=password_hash=$password_hash
```

### 4. Infrastructure as Code (Terraform)

```bash
#!/bin/bash

# Generate and save password hashes for Terraform
passwords="admin developer guest"

for password in $passwords; do
    hash=$(./rabbitmq-pass-gen.sh)
    echo "\"$password_hash\" = \"$hash\""
done
```

## Troubleshooting

### Error: "command not found: od"

**Cause:** `od` command not installed (very rare).

**Solution:** Install GNU coreutils
```bash
# Ubuntu/Debian
sudo apt-get install coreutils

# macOS
brew install coreutils
```

### Error: "command not found: xxd"

**Cause:** `xxd` command not installed (very rare).

**Solution:** Install vim-common
```bash
# Ubuntu/Debian
sudo apt-get install vim-common

# macOS
brew install vim
```

### Script Permission Denied

**Cause:** Script is not executable.

**Solution:**
```bash
chmod +x rabbitmq-pass-gen.sh
```

### Output Changes Every Run

**This is expected behavior.** Each time you run the script, it generates a new random salt, producing different hashes for the same password. This is how RabbitMQ's password hashing works - it's designed for security.

If you need a consistent hash for the same password, you would need to modify the script to use a fixed salt (not recommended for production).

## Security Considerations

### Best Practices

1. **Use Strong Passwords:** Generate strong passwords before hashing
   ```bash
   # Generate a strong password
   openssl rand -base64 32
   ```

2. **Secure Storage:** Keep password hashes in secure configuration files
   ```bash
   chmod 600 rabbitmq.conf
   chmod 600 definitions.json
   ```

3. **Environment Variables:** Use environment variables for sensitive data
   ```bash
   export RABBITMQ_DEFAULT_PASS="strong_password"
   ```

4. **Rotate Credentials:** Periodically update passwords and regenerate hashes

5. **Access Control:** Restrict access to scripts and configuration files
   ```bash
   chmod 700 rabbitmq-pass-gen.sh
   chmod 600 *.conf
   ```

### Never

- Commit passwords or hashes to version control (use `.gitignore`)
- Use default passwords in production
- Share password hashes via insecure channels
- Log password hashes in plain text
- Use weak passwords

## Generating Strong Passwords

Use these tools to generate secure passwords:

```bash
# Using OpenSSL
openssl rand -base64 32

# Using /dev/urandom
cat /dev/urandom | tr -dc 'a-zA-Z0-9!@#$%^&*' | fold -w 32 | head -1

# Using pwgen (if installed)
pwgen -s 32 1

# Using openssl with specific character set
openssl rand -base64 32 | tr -d "=+/" | cut -c1-25
```

## Integration Examples

### With Ansible

```yaml
---
- name: Generate RabbitMQ password hash
  hosts: localhost
  tasks:
    - name: Run password generation script
      shell: /path/to/rabbitmq-pass-gen.sh
      register: password_hash
    
    - name: Display hash
      debug:
        msg: "Generated hash: {{ password_hash.stdout }}"
```

### With Docker

```dockerfile
FROM rabbitmq:3-management

# Copy password generation script
COPY rabbitmq-pass-gen.sh /tmp/

# Generate and set password
RUN chmod +x /tmp/rabbitmq-pass-gen.sh && \
    PASS_HASH=$(/tmp/rabbitmq-pass-gen.sh) && \
    echo "default_pass_hash = $PASS_HASH" >> /etc/rabbitmq/rabbitmq.conf
```

### With Bash Deployment Script

```bash
#!/bin/bash

set -e

RABBITMQ_DIR="/etc/rabbitmq"
PASSWORD="your_secure_password"

# Generate hash
PASSWORD_HASH=$(./rabbitmq-pass-gen.sh)

# Create configuration
cat > $RABBITMQ_DIR/rabbitmq.conf << EOF
default_user = admin
default_pass_hash = $PASSWORD_HASH
EOF

# Set permissions
chmod 600 $RABBITMQ_DIR/rabbitmq.conf

echo "RabbitMQ configuration created successfully"
```

## Related Resources

- [RabbitMQ Authentication Documentation](https://www.rabbitmq.com/authentication.html)
- [RabbitMQ Password Hashing](https://www.rabbitmq.com/passwords.html)
- [RabbitMQ Configuration Guide](https://www.rabbitmq.com/configure.html)
- [RabbitMQ Management Plugin](https://www.rabbitmq.com/management.html)
- [GNU Coreutils Documentation](https://www.gnu.org/software/coreutils/)

## Performance Notes

- Password generation is fast (typically < 1 second)
- SHA-512 hashing is computationally secure
- Suitable for batch operations with thousands of passwords
- Minimal resource consumption

## Limitations

- Only generates hashes for `rabbit_password_hashing_sha512` algorithm
- Does not validate password complexity
- Does not create users directly in RabbitMQ (only generates hashes)
- Requires manual configuration in RabbitMQ files

## License

This script is provided as-is for RabbitMQ user management.

## Support

For issues or questions:
- Verify all required commands are installed
- Check RabbitMQ documentation for configuration syntax
- Ensure proper file permissions on configuration files
- Review RabbitMQ logs for authentication errors
