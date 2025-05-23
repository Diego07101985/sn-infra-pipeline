output "ecr_repository_url" {
  value       = aws_ecr_repository.pipeline_image[0].repository_url
  description = "ECR repository URL (if created)"
  condition   = var.create_ecr_repository
}

output "input_bucket_name" {
  value       = try(aws_s3_bucket.input[0].bucket, null)
  description = "Input S3 bucket name (if created)"
  condition   = var.create_input_bucket
}

output "output_bucket_name" {
  value       = try(aws_s3_bucket.output[0].bucket, null)
  description = "Output S3 bucket name (if created)"
  condition   = var.create_output_bucket
}