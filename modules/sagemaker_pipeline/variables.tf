variable "pipeline_name" {
  description = "Name of the SageMaker pipeline"
  type        = string
}

variable "s3_bucket" {
  description = "S3 bucket for pipeline artifacts"
  type        = string
}

variable "s3_prefix" {
  description = "S3 prefix (path) for pipeline artifacts"
  type        = string
  default     = ""
}

variable "execution_role_arn" {
  description = "ARN of the IAM role for SageMaker pipeline execution"
  type        = string
}

variable "ecr_image_uri" {
  description = "URI of the ECR image for processing, training, and evaluation"
  type        = string
}

variable "code_s3_uri" {
  description = "S3 URI where the processing and training scripts are located"
  type        = string
}

variable "processing_instance_type" {
  description = "Instance type for the feature selection step"
  type        = string
  default     = "ml.m5.xlarge"
}

variable "training_instance_type" {
  description = "Instance type for the training step"
  type        = string
  default     = "ml.m5.2xlarge"
}

variable "evaluation_instance_type" {
  description = "Instance type for the evaluation step"
  type        = string
  default     = "ml.m5.xlarge"
}

variable "env" {
  description = "Environment name (dev, staging, prod)"
  type        = string
}

module "sagemaker_pipeline" {
  source = "./modules/sagemaker_pipeline"
  
  env         = "dev" 
  pipeline_name = "sn-pipeline"
}