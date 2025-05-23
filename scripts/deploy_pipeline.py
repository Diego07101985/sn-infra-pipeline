
import argparse
import boto3
import json
from string import Template

def render_template(template_path, config):
    with open(template_path, 'r') as f:
        template_str = f.read()
    template = Template(template_str)
    return template.substitute(config)

def ensure_ecr_repository(name):
    ecr = boto3.client("ecr")
    try:
        ecr.describe_repositories(repositoryNames=[name])
        print(f"[ECR] Repository '{name}' already exists.")
    except ecr.exceptions.RepositoryNotFoundException:
        print(f"[ECR] Creating repository '{name}'...")
        ecr.create_repository(repositoryName=name)

def delete_pipeline_and_ecr(pipeline_name):
    sagemaker = boto3.client("sagemaker")
    ecr = boto3.client("ecr")

    try:
        print(f"[CLEANUP] Deleting SageMaker pipeline: {pipeline_name}")
        sagemaker.delete_pipeline(PipelineName=pipeline_name)
    except sagemaker.exceptions.ResourceNotFound:
        print(f"[CLEANUP] Pipeline '{pipeline_name}' not found.")


def deploy_pipeline(pipeline_name, pipeline_definition, role_arn):
    sm_client = boto3.client('sagemaker')
    try:
        response = sm_client.create_pipeline(
            PipelineName=pipeline_name,
            PipelineDefinition=json.loads(pipeline_definition),
            RoleArn=role_arn
        )
        print(f"[DEPLOY] Pipeline '{pipeline_name}' created.")
    except sm_client.exceptions.ResourceInUse:
        response = sm_client.update_pipeline(
            PipelineName=pipeline_name,
            PipelineDefinition=json.loads(pipeline_definition),
            RoleArn=role_arn
        )
        print(f"[DEPLOY] Pipeline '{pipeline_name}' updated.")
    return response

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--pipeline_config', required=True, help='JSON string with one or more pipeline configurations')
    parser.add_argument('--template', required=False, default='modules/sagemaker_pipeline/pipeline-definition.json.tpl')
    args = parser.parse_args()

    template_path = args.template
    pipelines = json.loads(args.pipeline_config)

    if not isinstance(pipelines, list):
        pipelines = [pipelines]

    declared_names = {p["pipeline_name"] for p in pipelines}

    sagemaker = boto3.client("sagemaker")
    existing = sagemaker.list_pipelines()["PipelineSummaries"]
    for pipeline in existing:
        name = pipeline["PipelineName"]
        if name not in declared_names:
            delete_pipeline_and_ecr(name)

    for config in pipelines:
        pipeline_name = config["pipeline_name"]
        role_arn = config["sagemaker_role_arn"]

        for suffix in ["feature", "train", "evaluate", "decision", "error"]:
            ensure_ecr_repository(f"{pipeline_name}-{suffix}")

        print(f"[RENDER] Rendering pipeline template for '{pipeline_name}'...")
        rendered_json = render_template(template_path, config)

        print(f"[DEPLOY] Deploying pipeline '{pipeline_name}' to SageMaker...")
        deploy_pipeline(pipeline_name, rendered_json, role_arn)

if __name__ == "__main__":
    main()
