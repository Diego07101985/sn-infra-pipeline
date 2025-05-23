variable "pipeline_name" {
  description = "Name identifier for resources"
  type        = string
}

variable "create_ecr_repository" {
  description = "Whether to create a new ECR repository"
  type        = bool
  default     = false
}

variable "ecr_repository_name" {
  description = "Name of the ECR repository (only used if create_ecr_repository = true)"
  type        = string
  default     = null
}

variable "create_input_bucket" {
  description = "Whether to create the S3 input bucket"
  type        = bool
  default     = true
}

variable "create_output_bucket" {
  description = "Whether to create the S3 output bucket"
  type        = bool
  default     = true
}