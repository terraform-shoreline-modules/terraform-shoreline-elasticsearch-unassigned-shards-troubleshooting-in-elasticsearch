resource "shoreline_notebook" "unassigned_shards_troubleshooting_in_elasticsearch" {
  name       = "unassigned_shards_troubleshooting_in_elasticsearch"
  data       = file("${path.module}/data/unassigned_shards_troubleshooting_in_elasticsearch.json")
  depends_on = [shoreline_action.invoke_get_cluster_node_settings,shoreline_action.invoke_tail_elasticsearch_logs,shoreline_action.invoke_elasticsearch_service_control]
}

resource "shoreline_file" "get_cluster_node_settings" {
  name             = "get_cluster_node_settings"
  input_file       = "${path.module}/data/get_cluster_node_settings.sh"
  md5              = filemd5("${path.module}/data/get_cluster_node_settings.sh")
  description      = "Check Elasticsearch cluster and node settings"
  destination_path = "/tmp/get_cluster_node_settings.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "tail_elasticsearch_logs" {
  name             = "tail_elasticsearch_logs"
  input_file       = "${path.module}/data/tail_elasticsearch_logs.sh"
  md5              = filemd5("${path.module}/data/tail_elasticsearch_logs.sh")
  description      = "Check Elasticsearch cluster and node logs for errors"
  destination_path = "/tmp/tail_elasticsearch_logs.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "elasticsearch_service_control" {
  name             = "elasticsearch_service_control"
  input_file       = "${path.module}/data/elasticsearch_service_control.sh"
  md5              = filemd5("${path.module}/data/elasticsearch_service_control.sh")
  description      = "Restarting Elasticsearch nodes: Restarting Elasticsearch nodes can sometimes resolve issues related to unassigned shards. This can be done one node at a time to minimize the impact on the cluster."
  destination_path = "/tmp/elasticsearch_service_control.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_get_cluster_node_settings" {
  name        = "invoke_get_cluster_node_settings"
  description = "Check Elasticsearch cluster and node settings"
  command     = "`chmod +x /tmp/get_cluster_node_settings.sh && /tmp/get_cluster_node_settings.sh`"
  params      = ["ELASTICSEARCH_HOST","ELASTICSEARCH_PORT","NODE_ID"]
  file_deps   = ["get_cluster_node_settings"]
  enabled     = true
  depends_on  = [shoreline_file.get_cluster_node_settings]
}

resource "shoreline_action" "invoke_tail_elasticsearch_logs" {
  name        = "invoke_tail_elasticsearch_logs"
  description = "Check Elasticsearch cluster and node logs for errors"
  command     = "`chmod +x /tmp/tail_elasticsearch_logs.sh && /tmp/tail_elasticsearch_logs.sh`"
  params      = ["CLUSTER_NAME","NODE_NAME"]
  file_deps   = ["tail_elasticsearch_logs"]
  enabled     = true
  depends_on  = [shoreline_file.tail_elasticsearch_logs]
}

resource "shoreline_action" "invoke_elasticsearch_service_control" {
  name        = "invoke_elasticsearch_service_control"
  description = "Restarting Elasticsearch nodes: Restarting Elasticsearch nodes can sometimes resolve issues related to unassigned shards. This can be done one node at a time to minimize the impact on the cluster."
  command     = "`chmod +x /tmp/elasticsearch_service_control.sh && /tmp/elasticsearch_service_control.sh`"
  params      = ["NUMBER_OF_SECONDS"]
  file_deps   = ["elasticsearch_service_control"]
  enabled     = true
  depends_on  = [shoreline_file.elasticsearch_service_control]
}

