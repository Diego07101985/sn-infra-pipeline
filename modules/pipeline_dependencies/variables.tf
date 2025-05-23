
variable "pipeline_name" {
  description = "Name identifier for resources (used as subfolder name)"
  type        = string
}

variable "shared_input_bucket_name" {
  type        = string
  description = "Nome do bucket único de input"
}

variable "shared_output_bucket_name" {
  type        = string
  description = "Nome do bucket único de output"
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