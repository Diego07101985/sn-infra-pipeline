
import argparse
import boto3
import pathlib
import json
from string import Template


def load_tfvars(tfvars_path):
    config = {}
    with open(tfvars_path, 'r') as f:
        for line in f:
            line = line.strip()
            if line and not line.startswith('#'):
                key, value = line.split('=', 1)
                key = key.strip()
                value = value.strip().strip('"')
                config[key] = value
    return config

def render_template(template_path, config):
    with open(template_path, 'r') as f:
        template_str = f.read()
    template = Template(template_str)
    return template.substitute(config)

def deploy_pipeline(pipeline_name, pipeline_definition, role_arn):
    sm_client = boto3.client('sagemaker')
    try:
        response = sm_client.create_pipeline(
            PipelineName=pipeline_name,
            PipelineDefinition=json.loads(pipeline_definition),
            RoleArn=role_arn
        )
        print(f"Pipeline '{pipeline_name}' created.")
    except sm_client.exceptions.ResourceInUse:
        response = sm_client.update_pipeline(
            PipelineName=pipeline_name,
            PipelineDefinition=json.loads(pipeline_definition),
            RoleArn=role_arn
        )
        print(f"Pipeline '{pipeline_name}' updated.")
    return response

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--config', required=True, help='Path to .tfvars file')
    parser.add_argument('--template', required=False, default='modules/sagemaker_pipeline/pipeline-definition.json.tpl', help='Path to pipeline template')
    args = parser.parse_args()

    tfvars_path = pathlib.Path(args.config).resolve()
    template_path = pathlib.Path(args.template).resolve()

    print(f"Loading config from {tfvars_path}")
    config = load_tfvars(tfvars_path)
    pipeline_name = config["pipeline_name"]
    role_arn = config["sagemaker_role_arn"]

    print(f"Rendering pipeline template from {template_path}")
    rendered_json = render_template(template_path, config)

    print(f"Deploying pipeline '{pipeline_name}' to SageMaker...")
    deploy_pipeline(pipeline_name, rendered_json, role_arn)

if __name__ == "__main__":
    main()
