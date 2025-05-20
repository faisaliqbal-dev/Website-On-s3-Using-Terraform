output "website_url" {
  description = "The URL of the S3-hosted static website"
  # For the regional website endpoint (e.g. us-east-1):
  value = "http://${aws_s3_bucket.mybucket.bucket_regional_domain_name}"
}
