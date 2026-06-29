# Docker Redis Stack

A complete Docker-based Redis setup with web UI administration tool and a sample .NET Redis client application. Perfect for local development and testing Redis-based applications.

## Overview

This Docker Redis stack includes:

- **Redis Server** - High-performance in-memory data store
- **Redis Commander** - Web-based GUI for managing Redis data
- **Redis .NET App** - Sample C# application demonstrating Redis integration

This setup provides everything needed for local Redis development without manual installation of Redis or other dependencies.

## What is Redis?

**Redis** is an open-source, in-memory data structure store that serves as:
- Cache layer for applications
- Session storage
- Message broker
- Real-time analytics engine
- Leaderboards and counters

## Prerequisites

- **Docker** (version 20.10 or higher)
- **Docker Compose** (version 1.29 or higher)
- **Docker Desktop** (recommended for Windows and macOS)
- Ports **6379** and **8082** available on your system

### Installing Docker

**On Windows/macOS:**
Download and install [Docker Desktop](https://www.docker.com/products/docker-desktop)

**On Linux:**
```bash
sudo apt-get update
sudo apt-get install docker.io docker-compose
sudo usermod -aG docker $USER
```

## Project Structure

```
docker-redis/
├── docker-compose.yml       # Docker services configuration
├── USAGE.md                 # Quick start guide
├── README.md                # This file
└── redis-app/               # .NET sample application
    ├── Api.sln              # Visual Studio solution
    ├── Api.csproj           # Project configuration
    ├── Program.cs           # Main application entry
    ├── Controller.cs        # API endpoints
    ├── RedisSettings.cs     # Redis configuration
    ├── Startup.cs           # Application setup
    ├── Api.http             # REST client file
    ├── appsettings.json     # Application settings
    └── Properties/          # Project properties
```

## Services

### 1. Redis Server

**Service Name:** `redis`
**Container Name:** `local-redis`
**Port:** `6379` (default Redis port)
**Image:** `redis:latest`

The core Redis server that stores all data in memory.

### 2. Redis Commander

**Service Name:** `redis-commander`
**Container Name:** `local-redis-commander`
**Port:** `8082` (mapped to 8081 inside container)
**Image:** `rediscommander/redis-commander:latest`

A web-based GUI for browsing and managing Redis data. Automatically connects to the Redis server.

## Quick Start

### Step 1: Navigate to the Project

```bash
cd docker-redis
```

### Step 2: Start the Services

```bash
docker-compose up
```

**Expected Output:**
```
[+] Running 2/2
 ✔ Container local-redis          Created
 ✔ Container local-redis-commander Created
local-redis | 1:C 29 Jun 2026 10:15:44.000 * monotonic clock: POSIX clock_gettime
local-redis | 1:M 29 Jun 2026 10:15:44.000 * Server started, Redis version 7.0.0
local-redis-commander | Redis Commander listening on 0.0.0.0:8081
```

### Step 3: Access Services

- **Redis CLI:** `localhost:6379`
- **Redis Commander UI:** `http://localhost:8082`

### Step 4: Stop Services

```bash
docker-compose down
```

## Detailed Usage

### Starting in Background

```bash
# Start services in detached mode
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down
```

### Rebuild Containers

```bash
# Force rebuild images
docker-compose up --build

# Remove everything and start fresh
docker-compose down -v
docker-compose up
```

### Container Management

```bash
# View running containers
docker-compose ps

# View container logs
docker-compose logs redis
docker-compose logs redis-commander

# Execute commands in container
docker-compose exec redis redis-cli

# View resource usage
docker stats
```

## Redis Commander Web Interface

Access the Redis Commander GUI at **http://localhost:8082**

### Features

- **Browse Keys:** View all keys in your Redis database
- **Inspect Values:** Display key values with proper formatting
- **Add/Edit Keys:** Create and modify Redis data
- **Delete Keys:** Remove unwanted data
- **Database Selection:** Switch between Redis databases (0-15)
- **Flush Database:** Clear all data
- **Export/Import:** Download and upload Redis data

### Common Tasks

**Viewing all keys:**
1. Open http://localhost:8082
2. Keys are displayed in the left panel
3. Click on a key to view its value

**Adding a new key:**
1. Click the "+" button
2. Enter Key name and value
3. Select data type (string, list, set, hash, etc.)
4. Click Save

**Deleting a key:**
1. Select the key in the left panel
2. Click the delete/trash icon
3. Confirm deletion

## Using Redis CLI

Connect directly to Redis using the Redis CLI:

```bash
# Connect to Redis inside container
docker-compose exec redis redis-cli

# Basic commands
PING                           # Test connection (returns PONG)
SET mykey "Hello World"        # Set a string value
GET mykey                      # Get a value
KEYS *                         # List all keys
DBSIZE                         # Number of keys in database
FLUSHDB                        # Clear current database
FLUSHALL                       # Clear all databases
INFO                           # Server information
```

### Command Examples

```bash
# Strings
SET counter 100
INCR counter
GET counter

# Lists
LPUSH mylist "item1"
LPUSH mylist "item2"
LRANGE mylist 0 -1

# Sets
SADD myset "member1"
SADD myset "member2"
SMEMBERS myset

# Hashes
HSET user:1 name "John" age 30
HGET user:1 name
HGETALL user:1

# Expire keys (TTL)
SETEX session:123 3600 "data"  # 1 hour expiration
TTL session:123                # Check remaining time
EXPIRE key 60                  # Set expiration
PERSIST key                    # Remove expiration
```

## .NET Redis Application

The `redis-app` folder contains a sample C# application that demonstrates Redis integration.

### Building the Application

**Using Visual Studio:**
1. Open `redis-app/Api.sln`
2. Right-click solution → Build
3. Press F5 to run

**Using .NET CLI:**
```bash
cd redis-app
dotnet build
dotnet run
```

### Configuration

Edit `redis-app/appsettings.json`:

```json
{
  "Redis": {
    "Host": "localhost",
    "Port": 6379,
    "Database": 0
  }
}
```

### Redis Settings (RedisSettings.cs)

The application uses this configuration:

```csharp
public class RedisSettings
{
    public string Host { get; set; }
    public int Port { get; set; }
    public int Database { get; set; }
}
```

### API Endpoints (Controller.cs)

The sample application typically includes endpoints for:
- Getting values from Redis
- Setting values in Redis
- Deleting keys
- Listing keys
- Cache operations

### Testing with Api.http

The `Api.http` file contains REST client requests for testing:

```http
### Get value from Redis
GET http://localhost:5000/redis/get?key=mykey

### Set value in Redis
POST http://localhost:5000/redis/set
Content-Type: application/json

{
  "key": "mykey",
  "value": "myvalue"
}

### Delete key
DELETE http://localhost:5000/redis/delete?key=mykey
```

## Networking

The services communicate through Docker's internal network:

- **Redis Service:** `redis:6379` (internal)
- **Redis Commander:** Connects to `redis:6379` internally
- **Host Access:** `localhost:6379` and `localhost:8082`

To connect from your host machine:
```bash
# Connect to Redis from your application
redis_host = "localhost"  # or 127.0.0.1
redis_port = 6379
```

To connect from another Docker container:
```bash
# Use service name instead of localhost
redis_host = "redis"
redis_port = 6379
```

## Data Persistence

By default, Redis stores data in memory only. To add persistence:

### Add Volume to docker-compose.yml

```yaml
services:
  redis:
    container_name: local-redis
    image: redis
    ports: 
      - 6379:6379
    volumes:
      - redis-data:/data
    command: redis-server --appendonly yes

volumes:
  redis-data:
```

Then restart:
```bash
docker-compose down -v
docker-compose up
```

Data will now persist in the `redis-data` volume.

## Troubleshooting

### Error: "Address already in use"

**Cause:** Ports 6379 or 8082 are already in use.

**Solution:** Stop the conflicting service or use different ports:

```yaml
ports:
  - 6380:6379          # Use 6380 instead
```

Then restart and connect to `localhost:6380`

### Error: "Cannot connect to Docker daemon"

**Cause:** Docker daemon is not running.

**Solution:**
- Restart Docker Desktop (Windows/macOS)
- Or restart Docker service on Linux: `sudo systemctl start docker`

### Redis Commander shows "No Databases"

**Cause:** Redis service hasn't started yet or connection failed.

**Solution:**
```bash
# Check if Redis is running
docker-compose ps

# View Redis logs
docker-compose logs redis

# Restart services
docker-compose restart
```

### Application Cannot Connect to Redis

**Cause:** Using `localhost` from inside another container.

**Solution:** Use the service name `redis` instead of `localhost` in container-to-container communication.

### Cannot Access Redis Commander UI

**Cause:** Service not started or wrong port.

**Solution:**
```bash
# Verify service is running
docker-compose ps

# Check port mapping
docker-compose port redis-commander

# Try the correct URL
# http://localhost:8082
```

## Performance Tuning

### Increase Redis Memory Limit

```yaml
services:
  redis:
    command: redis-server --maxmemory 512mb --maxmemory-policy allkeys-lru
```

### Connection Pooling (in .NET app)

```csharp
private static IConnectionMultiplexer redis = 
    ConnectionMultiplexer.Connect("localhost:6379");
```

### Enable RDB Snapshots

```yaml
services:
  redis:
    command: redis-server --save 900 1 --save 300 10
```

## Common Use Cases

### Session Storage

```bash
SET session:user123 "{name:'John',role:'admin'}"
EXPIRE session:user123 3600  # 1 hour expiration
GET session:user123
```

### Caching

```bash
SET cache:api:users "{data...}"
GET cache:api:users
EXPIRE cache:api:users 300  # 5 minute cache
```

### Rate Limiting

```bash
INCR rate:user123:requests
EXPIRE rate:user123:requests 60
```

### Leaderboards

```bash
ZADD leaderboard 1000 "player1"
ZADD leaderboard 950 "player2"
ZRANGE leaderboard 0 10 WITHSCORES
```

## Monitoring and Logging

### View Redis Statistics

```bash
docker-compose exec redis redis-cli INFO

# Specific sections
docker-compose exec redis redis-cli INFO memory
docker-compose exec redis redis-cli INFO stats
docker-compose exec redis redis-cli INFO replication
```

### View Container Logs

```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f redis
docker-compose logs -f redis-commander

# Last 100 lines
docker-compose logs --tail=100
```

### Monitor Real-Time Commands

```bash
docker-compose exec redis redis-cli MONITOR
```

## Security Considerations

### Development vs Production

This setup is configured for **local development only**. For production:

1. **Enable Authentication:**
   ```yaml
   command: redis-server --requirepass "strong_password"
   ```

2. **Use Redis ACL (Redis 6+):**
   ```yaml
   command: redis-server --aclfile /etc/redis/acl.conf
   ```

3. **Disable Dangerous Commands:**
   ```yaml
   command: redis-server --rename-command FLUSHDB "" --rename-command FLUSHALL ""
   ```

4. **Bind to Specific IPs:**
   ```yaml
   command: redis-server --bind 127.0.0.1
   ```

5. **Use TLS:**
   - Add SSL certificates
   - Configure `--tls-port 6380`

## Integration with Other Tools

### Docker Network

Connect other containers to Redis:

```yaml
services:
  myapp:
    image: myapp:latest
    environment:
      REDIS_HOST: redis
      REDIS_PORT: 6379
    depends_on:
      - redis
```

### Kubernetes

Deploy Redis stack in Kubernetes using Helm charts or manual manifests.

### Docker Swarm

Deploy as a stack:
```bash
docker stack deploy -c docker-compose.yml redis-stack
```

## Related Resources

- [Redis Official Documentation](https://redis.io/docs/)
- [Redis CLI Commands Reference](https://redis.io/commands)
- [Redis Commander GitHub](https://github.com/joeferner/redis-commander)
- [Docker Redis Image](https://hub.docker.com/_/redis)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [StackExchange.Redis (C# Client)](https://github.com/StackExchange/StackExchange.Redis)

## Additional Commands

### Useful Docker Commands

```bash
# Build and start
docker-compose up --build

# Start in background
docker-compose up -d

# Stop services
docker-compose stop

# Restart services
docker-compose restart

# Remove containers and volumes
docker-compose down -v

# View resource usage
docker stats

# Remove unused resources
docker system prune
```

### Redis Maintenance

```bash
# Backup Redis data
docker-compose exec redis redis-cli BGSAVE

# Check database size
docker-compose exec redis redis-cli DBSIZE

# Clear database
docker-compose exec redis redis-cli FLUSHDB

# Get memory statistics
docker-compose exec redis redis-cli INFO memory
```

## Cleanup

To completely remove the Docker Redis stack:

```bash
# Stop and remove containers
docker-compose down

# Remove volumes (careful - deletes data)
docker volume rm docker-redis_redis-data

# Remove images
docker rmi redis:latest
docker rmi rediscommander/redis-commander:latest
```

## Support & Troubleshooting

For issues:
- Check Redis logs: `docker-compose logs redis`
- Check Redis Commander logs: `docker-compose logs redis-commander`
- Verify ports aren't in use: `netstat -an | grep LISTEN`
- Ensure Docker is running and healthy: `docker ps`
- Review Redis documentation: https://redis.io/docs/

## License

This Docker setup is provided as-is. Redis is open-source (BSD 3-Clause License).
