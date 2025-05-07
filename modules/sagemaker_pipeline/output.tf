output "pipeline_name" {
  description = "Name of the created SageMaker pipeline"
  value       = aws_sagemaker_pipeline.this.name
}

output "pipeline_arn" {
  description = "ARN of the created SageMaker pipeline"
  value       = aws_sagemaker_pipeline.this.arn
}