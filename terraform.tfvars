# change once here, updated for the entire project

project_name = "three-tier-app"

environment = "dev"

owner = "Defitha"

region = "ap-south-1"

vpc_cidr = "10.0.0.0/16" #ip range of my network (10.0.0.0 to 10.0.255.255)

public_subnet_cidr = "10.0.1.0/24" # used for alb,nat (10.0.1.0 to 10.0.1.255)

private_app_subnet_cidr = "10.0.2.0/24" #used for ec2

private_db_subnet_cidr = "10.0.3.0/24" #used for db