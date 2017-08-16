# Storing Terraform remote state on a Google Cloud Storage bucket for GCP applications

## Use
`sh init-terraform-remote-state.sh` or specify the output file as first parameter

`GCP_PROJECT` name of the Google Cloud Platform project

`GS_BUCKET` name of the Google Cloud Storage bucket to store remote state

`GS_BUCKET_PATH` path to store state in the GCS bucket

`TERRAFORM_CREDENTIALS`: location of the GCP credentials file

`GOOGLE_APPLICATION_CREDENTIALS`: location of the GCP credentials file, will be exported to shell if not already defined

## Warning

Google Cloud Storage [does not currently support locking](https://www.terraform.io/docs/backends/types/gcs.html) so be careful using this in a distribute team
