

#!/bin/bash



# Stop Elasticsearch service

sudo systemctl stop elasticsearch.service



# Wait for Elasticsearch to stop

sleep ${NUMBER_OF_SECONDS}



# Start Elasticsearch service

sudo systemctl start elasticsearch.service



# Wait for Elasticsearch to start

sleep ${NUMBER_OF_SECONDS}



# Check Elasticsearch status

sudo systemctl status elasticsearch.service