# demo
#### Task 1

#### Task 1

I am creating resources for deploying three tier application in AWS using terraform.

Architecture as follows
 ____________
|____ALB_____|
      |
 ____________
|____APP_____| ---- DMZ
      |
 ____________
|____DB______|      

ALB-> Application laod balancer to get request from users and its deployed in public subnet (DMZ Subnet). it listen port 443 and redirects request to app instances on port 8080

DMZ Instances ->  These instances are deployed in public subnet. forward proxy will configure here. App instance traffic going to internet will flow from these instances.

APP EC2 Instances -> App instances where application is deployed and these instances deployed in app subnet (private subnet) in two AZ's for fault tolerance and HA

Postgres RDS DB -> This RDS DB is for application database and launched in private subnet

Terraform code explaination ->
As this is one time activity, I have created tf file for each component 
aws.tf -> for provider 

db.tf -> for postgres rds db

lb.tf -> apllication load balancer, TG group and listeners

network.tf -> vpc, subnet, routetable etc

sg.tf - security groups

ssl_certs.tf -> ssl certificate for ALB https request


