#
# define Variables
#
variable "region" { type="string" }
variable "tenant" { type="string" }

variable "vpc_cidr" { type="string" }
variable "ami_id" { type="string" }
variable "dmz_networks" { type="list(string)" }
variable "app_networks" { type="list(string)" }
variable "data_networks" { type="list(string)" }
variable "dmz_instances" { type="list(string)" }
variable "app_instances" { type="list(string)" }
variable "dmz_instance_type" { type="list(string)" }
variable "app_instance_type" { type="list(string)t" }
variable "az" { type="list(string)" default=["a","b","c"] }
variable "pubkey" { type="string" }
variable "app_fqdn" { type="string" }
variable "ssh_allowed" { type="list(string)" }
variable "certsValid" { type="string" default=false }
variable "hosted_zone_id" { type="string" }

