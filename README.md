# Storing Terraform remote state on a Google Storage bucket for GCP applications

## Use
`sh init-terraform-remote-state.sh` or specify the output file as first parameter

`GCP_PROJECT` name of the Google Cloud Platform project

`GS_BUCKET` name of the Google Cloud Storage bucket to store remote state

`GS_BUCKET_PATH` path to store state in the GCS bucket

`TERRAFORM_CREDENTIALS`: location of the GCP credentials file

`GOOGLE_APPLICATION_CREDENTIALS`: location of the GCP credentials file, will be exported to shell if not already defined
