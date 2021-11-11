##### vars values
region = "eu-west-1"
tenant = "APP-DEVEU"
tf_tenant = "appdeveu"

certsValid = true
vpc_cidr = "10.10.0.0/16"
dmz_networks  = [ "10.10.11.0/24", "10.10.12.0/24" ]
app_networks  = [ "10.10.21.0/24", "10.10.22.0/24" ]
data_networks = [ "10.10.31.0/24", "10.10.32.0/24" ]

####################################################################################
## Virtual machines
####################################################################################
# For each list below, provide the hostname
dmz_instances  = [ "dmz01", "dmz02" ]
app_instances  = [ "app01", "app02" ]
dmz_instance_type = ["t2.micro", "t2.large" ]
app_instance_type = [ "t2.large", "t2.large" ]

ami_id = "ami-03b75ae4a532646asa" ## dummy ami ids
# Provide the pubkey that will be copy on every EC2 instance
pubkey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCYTGCrASGJco0XXz1yDjnsfplfZFNLd+PHr0znSd94O8CxG15sh741rM43PSGQ9Ehpfuf/r/LzEBgyq7M9B+SGydQbE4rGQZCPoucCtAUv1qJGWAmjbtIf9FX0eCuleblCqVUihGpEnUKQMznMjdnigrAv7N/FNeaRSAIV6LT5L/X844W6dAuP9r1+HOWvWQXs2K99OTQiQelBSjt0Kl+fhFO9TWGZP4zMXELYQywouvi+Lq+RddSmtXoj9Ani/ALOWWkYsn30t4A7b0bLs6TDxrqOvhfvSqd8fXzdp8PXhqtaHITD9Cd7oAXaDt9L+xCUYRcFOs9LxkqAsieiw/xl stodev"

### Dummy pub key

ssh_allowed = ["10.0.21.88/32", "10.0.21.126/32"] ### random ips for ssh
