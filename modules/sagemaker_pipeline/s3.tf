resource "aws_s3_bucket" "pipeline_execution" {
    bucket = "${var.env}-sn-ml-${var.pipeline_name}-execution-bucket"
    
    tags = {
        Name        = "${var.env}-sn-ml-${var.pipeline_name}-execution-bucket"
        Environment = var.env
    }
}

resource "aws_s3_bucket_versioning" "pipeline_execution" {
    bucket = aws_s3_bucket.pipeline_execution.id
    
    versioning_configuration {
        status = "Enabled"
    }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "pipeline_execution" {
    bucket = aws_s3_bucket.pipeline_execution.id

    rule {
        apply_server_side_encryption_by_default {
            sse_algorithm = "AES256"
        }
    }
}
