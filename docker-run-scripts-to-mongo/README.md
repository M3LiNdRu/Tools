# USAGE

1. Place the script SCRIPT_NAME.js inside script folder
2. Execute `cat SCRIPT_NAME.js > script.js` to copy the script inside script.js file
3. Run the below commands:

```
    docker build -t mongo-execute-script .
    docker run --rm -e MONGO_URI="CONN-STRING" -e MONGO_DB="DBNAME" mongo-execute-script
```