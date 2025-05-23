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


variable "processing_image_uri" {
  description = "URI of the ECR image for the feature selection step"
  type        = string
  default     = ""
}

variable "training_image_uri" {
  description = "URI of the ECR image for the training step"
  type        = string
  default     = ""
}

variable "evaluation_image_uri" {
  description = "URI of the ECR image for the evaluation step"
  type        = string
  default     = ""
}

variable "env" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "processing_instance_type" {
  description = "Instance type for the feature selection step"
  type        = string
  default     = "ml.t3.medium"
}

variable "training_instance_type" {
  description = "Instance type for the training step"
  type        = string
  default     = "ml.t3.medium"
}

variable "evaluation_instance_type" {
  description = "Instance type for the evaluation step"
  type        = string
  default     = "ml.t3.medium"
}