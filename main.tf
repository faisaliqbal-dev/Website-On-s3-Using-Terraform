terraform {
  backend "s3" {
    bucket  = "terraform-tfstate-files-backend"
    key     = "terraform.tfstate"
    encrypt = true
    region  = "us-east-1"
  }
}

resource "aws_s3_bucket" "mybucket" {
  bucket = var.bucketname


  tags = {
    Name = var.bucketname
  }
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.mybucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "public_read_policy" {
  bucket     = aws_s3_bucket.mybucket.id
  depends_on = [aws_s3_bucket_public_access_block.public_access]


  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.mybucket.arn}/*"
      }
    ]
  })
}

resource "aws_s3_object" "website_files" {
  for_each = fileset("${path.module}/grandcoffee-master", "**")

  bucket = aws_s3_bucket.mybucket.id
  key    = each.value
  source = "${path.module}/grandcoffee-master/${each.value}"
  content_type = lookup(
    {
      html = "text/html"
      css  = "text/css"
      js   = "application/javascript"
    },
    split(".", each.value)[length(split(".", each.value)) - 1],
    "application/octet-stream"
  )
  #   acl = "public-read"
}
resource "aws_s3_bucket_website_configuration" "enable_website" {
  bucket = aws_s3_bucket.mybucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

  routing_rule {
    condition {
      key_prefix_equals = "docs/"
    }
    redirect {
      replace_key_prefix_with = "documents/"
    }
  }
}