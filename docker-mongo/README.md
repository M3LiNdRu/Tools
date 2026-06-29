# Docker MongoDB Environment

This Docker Compose Setup provides a MongoDB environment with MongoDB instance, mongo-express web interface and a tools container for command-line operations.

## Services

### mongo
- **Image**: `mongo:latest`
- **Port**: `27017`
- **Credentials**:
  - Username: `root`
  - Password: `YourStrongPassword123!`  # As configured in docker-compose.yml
- **Volume**: `mongodb_data_container` mounted at `/data/db`

### mongo-express
- **Image**: `mongo-express:latest`
- **Port**: `8081`
- **URL**: http://localhost:8081
- Web-based MongoDB admin interface with no basic auth required

### mongo-tools
- **Image**: `mongo:latest`
- Utility container with mongosh, mongodump, and mongorestore
- Keeps running with `sleep infinity` for interactive access
- **Volume**: `./data` directory mounted at `/backups`

## Usage

### Start the Services
```bash
docker-compose up -d
```

### Stop the Services
```bash
docker-compose down
```

### Access mongo-express
Open your browser and navigate to:
```
http://localhost:8081
```

### Using mongo-tools Container

#### Connect to the Container
```bash
docker exec -it docker-mongo-mongo-tools-1 bash
```

#### Using mongosh
```bash
# Connect using connection string
mongosh mongodb://root:YourStrongPassword123!@mongo:27017/

# Or using environment variables
mongosh mongodb://$MONGO_USERNAME:$MONGO_PASSWORD@$MONGO_HOST:27017/
```

#### Using mongodump & mongorestore
https://stackoverflow.com/questions/4880874/how-do-i-create-a-mongodb-dump-of-my-database

```bash
# Dump a specific database and collection to the backups volume
mongodump --uri="mongodb+srv://USR:PWD@SERVERNAME.mongodb.net/" --db database --collection collection --out=/backups/20251128

mongodump --uri="mongodb+srv://USR:PWD@SERVERNAME.mongodb.net/" --db database --collection collection --out=/backups/20251128

mongoexport --uri="mongodb+srv://USR:PWD@SERVERNAME.mongodb.net/" --db database --collection collection --out=emailInfoTable.json --jsonArray


#### Using mongorestore
```bash
# Restore a database from the backups volume
mongorestore --uri="mongodb+srv://USR:PWD@SERVERNAME.mongodb.net/" --db database /backups/20251128/rx-shoppingcart-qa/

```

#### Running JavaScript Scripts

You can execute JavaScript files directly against the database using mongosh:

```bash
# Create a script file in the backups directory (accessible from host at ./scripts)
# Example: ./scripts/add-property.js

# Run the script from within the mongo-tools container
mongosh mongodb://root:YourStrongPassword123!@mongo:27017/rx-shoppingcart-qa?authSource=admin /scripts/add-property.js
```
**Alternative: Run inline JavaScript**
```bash
# Execute JavaScript directly without a file
mongosh mongodb://root:YourStrongPassword123!@mongo:27017/rx-shoppingcart-qa?authSource=admin --eval "db.ShoppingCart.updateMany({}, {\$set: {newProperty: 'value'}})"
```

## Volumes
- `mongodb_data_container`: Persists MongoDB data across container restarts
- `./data`: Local directory for backup files (directly accessible from your PC)
- `./scripts`: Local directory for script files (directly accessible from your PC)
