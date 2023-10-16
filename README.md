
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Unassigned Shards Troubleshooting in Elasticsearch
---

This incident type refers to situations where some shards in an Elasticsearch cluster have not been assigned to any node. This can happen due to various reasons such as node failure, network issues, and configuration problems. Unassigned shards can lead to degraded performance and data loss. Troubleshooting unassigned shards involves identifying the root cause of the problem and taking appropriate actions to resolve it.

### Parameters
```shell
export ELASTICSEARCH_HOST="PLACEHOLDER"

export ELASTICSEARCH_PORT="PLACEHOLDER"

export NODE_ID="PLACEHOLDER"

export CLUSTER_NAME="PLACEHOLDER"

export NODE_NAME="PLACEHOLDER"

export NUMBER_OF_SECONDS="PLACEHOLDER"
```

## Debug

### Check Elasticsearch cluster health status
```shell
curl -XGET ${ELASTICSEARCH_HOST}:${ELASTICSEARCH_PORT}/_cluster/health
```

### Get a list of all unassigned shards
```shell
curl -XGET ${ELASTICSEARCH_HOST}:${ELASTICSEARCH_PORT}/_cat/shards | grep UNASSIGNED
```

### Get the reason for unassigned shards
```shell
curl -XGET ${ELASTICSEARCH_HOST}:${ELASTICSEARCH_PORT}/_cluster/allocation/explain?pretty
```

### Check Elasticsearch cluster and node settings
```shell
curl -XGET ${ELASTICSEARCH_HOST}:${ELASTICSEARCH_PORT}/_cluster/settings

curl -XGET ${ELASTICSEARCH_HOST}:${ELASTICSEARCH_PORT}/_nodes/${NODE_ID}/settings
```

### Check Elasticsearch cluster and node logs for errors
```shell
tail -f /var/log/elasticsearch/${CLUSTER_NAME}.log

tail -f /var/log/elasticsearch/${CLUSTER_NAME}/${NODE_NAME}.log
```

### Get Elasticsearch configuration settings
```shell
curl -XGET ${ELASTICSEARCH_HOST}:${ELASTICSEARCH_PORT}/_cluster/settings?include_defaults
```

## Repair

### Restarting Elasticsearch nodes: Restarting Elasticsearch nodes can sometimes resolve issues related to unassigned shards. This can be done one node at a time to minimize the impact on the cluster.
```shell


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


```