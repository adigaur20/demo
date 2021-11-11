
#! /bin/bash 

# To use this script we need to first install aws cli module in linux vm and configue it with aws access key
# configue it with aws access key and secret key using aws configure command

echo "listing availble instance in AWS account"
/bin/aws ec2 describe-instances \
    --filters Name=tag-key,Values=Name \
    --query 'Reservations[*].Instances[*].{Instance:InstanceId,AZ:Placement.AvailabilityZone,Name:Tags[?Key==`Name`]|[0].Value}' \
    --output table

read -p "Please enter instnace ID to get the instance metadata: " instance_id
echo "Fetching details for instance_id : $instance_id"

if [[  ! -z $instance_id ]];
then
/bin/aws ec2 describe-instances --instance-ids $instance_id
else
echo "Enter valid instance id"
fi
