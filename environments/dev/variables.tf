variable "pipeline_name" {
  description = "Name of the SageMaker pipeline"
  type        = string
}

variable "s3_output_data" {
  description = "S3 path for output data"
  type        = string
}


variable "s3_input_data" {
  description = "S3 path for input data"
  type        = string
}

variable "execution_role_arn" {
  description = "ARN of the IAM role for SageMaker pipeline execution"
  type        = string
  default     = ""
}

variable "env" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}



