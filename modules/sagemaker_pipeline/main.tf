data "aws_iam_policy_document" "sagemaker_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["sagemaker.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "pipeline_execution" {
  name               = "${var.env}-sn-ml-${var.pipeline_name}-execution-role"
  assume_role_policy = data.aws_iam_policy_document.sagemaker_assume_role.json
}

variable "env" {
  description = "Environment name (dev, stage, prod, etc)"
  type        = string
}

resource "aws_iam_role_policy_attachment" "sagemaker_full_access" {
  role       = aws_iam_role.pipeline_execution.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSageMakerFullAccess"
}

resource "aws_sagemaker_pipeline" "this" {
  name     = "${var.env}-sn-ml-${var.pipeline_name}"
  role_arn = var.execution_role_arn != "" ? var.execution_role_arn : aws_iam_role.pipeline_execution.arn

  pipeline_definition {
    pipeline_definition_body = templatefile(
      "${path.module}/pipeline-definition.json.tpl",
      {
        pipeline_name            = "${var.env}-sn-ml-${var.pipeline_name}"
        s3_bucket                = var.s3_bucket
        s3_prefix                = "${var.env}_sn_ml_${var.s3_prefix}"
        ecr_image_uri            = var.ecr_image_uri
        code_s3_uri              = var.code_s3_uri
        processing_instance_type = var.processing_instance_type
        training_instance_type   = var.training_instance_type
        evaluation_instance_type = var.evaluation_instance_type
      }
    )
  }

  tags = {
    Name = "${var.env}_sn_ml_${var.pipeline_name}"
  }
}