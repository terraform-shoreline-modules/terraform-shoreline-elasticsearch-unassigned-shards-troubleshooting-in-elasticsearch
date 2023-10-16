terraform {
  required_version = ">= 0.13.1"

  required_providers {
    shoreline = {
      source  = "shorelinesoftware/shoreline"
      version = ">= 1.11.0"
    }
  }
}

provider "shoreline" {
  retries = 2
  debug = true
}

module "unassigned_shards_troubleshooting_in_elasticsearch" {
  source    = "./modules/unassigned_shards_troubleshooting_in_elasticsearch"

  providers = {
    shoreline = shoreline
  }
}