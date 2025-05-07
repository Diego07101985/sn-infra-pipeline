module "pipeline" {
  source = "../../modules/sagemaker_pipeline"
}

module "service" {
  source = "../../modules/lambda_service"
}

module "gateway" {
  source = "../../modules/api_gateway"
}
