module "pipeline_dependencies" {
  source = "../../modules/sagemaker_pipeline"

  pipeline_name = "${var.env}-${var.pipeline_name}"

  create_ecr_repository = true
  ecr_repository_name   = "${var.env}-${var.pipeline_name}-image"

  create_input_bucket  = true
  create_output_bucket = true
}