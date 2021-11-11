#
# define Variables
#
variable "region" { type="string" }
variable "tenant" { type="string" }

variable "vpc_cidr" { type="string" }
variable "ami_id" { type="string" }
variable "dmz_networks" { type="list" }
variable "app_networks" { type="list" }
variable "data_networks" { type="list" }
variable "dmz_instances" { type="list" }
variable "app_instances" { type="list" }
variable "dmz_instance_type" { type="list" }
variable "app_instance_type" { type="list" }
variable "az" { type="list" default=["a","b","c"] }
variable "pubkey" { type="string" }
variable "app_fqdn" { type="string" }
variable "ssh_allowed" { type="list" }
variable "certsValid" { type="string" default=false }
variable "hosted_zone_id" { type="string" }

