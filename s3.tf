#################################
# APPLICATION S3 BUCKET
#################################

resource "aws_s3_bucket" "app_bucket" {

  bucket = "three-tier-app-defitha-storage"

  tags = merge(
    local.common_tags,
    {
      Name = "application-storage"
    }
  )
}
#################################
# VERSIONING
#################################

resource "aws_s3_bucket_versioning" "bucket_versioning" {

  bucket = aws_s3_bucket.app_bucket.id

  versioning_configuration {

    status = "Enabled"
  }
}
#################################
# PUBLIC ACCESS BLOCK
#################################

resource "aws_s3_bucket_public_access_block" "public_block" {

  bucket = aws_s3_bucket.app_bucket.id

  block_public_acls = true

  block_public_policy = true

  ignore_public_acls = true

  restrict_public_buckets = true
}