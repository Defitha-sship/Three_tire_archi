#################################
# VPC ID
#################################

output "vpc_id" {

  value = aws_vpc.main.id
}

#################################
# ALB DNS
#################################

output "alb_dns_name" {

  value = aws_lb.app_alb.dns_name
}

#################################
# DATABASE ENDPOINT
#################################

output "database_endpoint" {

  value = aws_db_instance.postgres.endpoint
}

#################################
# S3 BUCKET
#################################

output "bucket_name" {

  value = aws_s3_bucket.app_bucket.bucket
}