{
  "Steps": [
    {
      "Name": "FeatureSelection",
      "Type": "Processing",
      "Arguments": {
        "ProcessingJobName": "${pipeline_name}-feature-select",
        "AppSpecification": {
          "ImageUri": "${ecr_image_uri}",
          "ContainerEntrypoint": ["python3", "/opt/ml/processing/input/code/featureselect.py"]
        },
        "ProcessingResources": {
          "ClusterConfig": {
            "InstanceCount": 1,
            "InstanceType": "${processing_instance_type}",
            "VolumeSizeInGB": 30
          }
        },
        "ProcessingInputs": [
          {
            "InputName": "input-data",
            "S3Input": {
              "S3Uri": "s3://${s3_bucket}/${s3_prefix}/input/",
              "LocalPath": "/opt/ml/processing/input/data",
              "S3DataType": "S3Prefix",
              "S3InputMode": "File"
            }
          },
          {
            "InputName": "code",
            "S3Input": {
              "S3Uri": "${code_s3_uri}",
              "LocalPath": "/opt/ml/processing/input/code",
              "S3DataType": "S3Prefix",
              "S3InputMode": "File"
            }
          }
        ],
        "ProcessingOutputConfig": {
          "Outputs": [
            {
              "OutputName": "selected-features",
              "S3Output": {
                "S3Uri": "s3://${s3_bucket}/${s3_prefix}/processing/selected_features/",
                "LocalPath": "/opt/ml/processing/output",
                "S3UploadMode": "EndOfJob"
              }
            }
          ]
        }
      }
    },
    {
      "Name": "Training",
      "Type": "Processing",
      "Arguments": {
        "ProcessingJobName": "${pipeline_name}-training",
        "AppSpecification": {
          "ImageUri": "${ecr_image_uri}",
          "ContainerEntrypoint": ["python3", "/opt/ml/processing/input/code/trainning.py"]
        },
        "ProcessingResources": {
          "ClusterConfig": {
            "InstanceCount": 1,
            "InstanceType": "${training_instance_type}",
            "VolumeSizeInGB": 50
          }
        },
        "ProcessingInputs": [
          {
            "InputName": "training-data",
            "S3Input": {
              "S3Uri": "s3://${s3_bucket}/${s3_prefix}/processing/selected_features/",
              "LocalPath": "/opt/ml/processing/input/data",
              "S3DataType": "S3Prefix",
              "S3InputMode": "File"
            }
          },
          {
            "InputName": "code",
            "S3Input": {
              "S3Uri": "${code_s3_uri}",
              "LocalPath": "/opt/ml/processing/input/code",
              "S3DataType": "S3Prefix",
              "S3InputMode": "File"
            }
          }
        ],
        "ProcessingOutputConfig": {
          "Outputs": [
            {
              "OutputName": "trained-model",
              "S3Output": {
                "S3Uri": "s3://${s3_bucket}/${s3_prefix}/processing/trained_model/",
                "LocalPath": "/opt/ml/processing/output",
                "S3UploadMode": "EndOfJob"
              }
            }
          ]
        }
      }
    },
    {
      "Name": "Evaluation",
      "Type": "Processing",
      "Arguments": {
        "ProcessingJobName": "${pipeline_name}-evaluation",
        "AppSpecification": {
          "ImageUri": "${ecr_image_uri}",
          "ContainerEntrypoint": ["python3", "/opt/ml/processing/input/code/evaluate.py"]
        },
        "ProcessingResources": {
          "ClusterConfig": {
            "InstanceCount": 1,
            "InstanceType": "${evaluation_instance_type}",
            "VolumeSizeInGB": 20
          }
        },
        "ProcessingInputs": [
          {
            "InputName": "model-artifact",
            "S3Input": {
              "S3Uri": "s3://${s3_bucket}/${s3_prefix}/processing/trained_model/model.tar.gz",
              "LocalPath": "/opt/ml/processing/input/model",
              "S3DataType": "S3Prefix",
              "S3InputMode": "File"
            }
          },
          {
            "InputName": "code",
            "S3Input": {
              "S3Uri": "${code_s3_uri}",
              "LocalPath": "/opt/ml/processing/input/code",
              "S3DataType": "S3Prefix",
              "S3InputMode": "File"
            }
          }
        ],
        "ProcessingOutputConfig": {
          "Outputs": [
            {
              "OutputName": "evaluation-report",
              "S3Output": {
                "S3Uri": "s3://${s3_bucket}/${s3_prefix}/processing/evaluation_report/",
                "LocalPath": "/opt/ml/processing/output",
                "S3UploadMode": "EndOfJob"
              }
            }
          ]
        }
      }
    }
  ]
}