#!/usr/bin/env bash

GCP_PROJECT=${GCP_PROJECT:-"$(gcloud config get-value project)"}
GS_BUCKET=${GS_BUCKET:-"${GCP_PROJECT}-terraform-admin"}
GS_BUCKET_PATH=${GS_BUCKET_PATH:-"/"}
TF_CREDS=${TERRAFORM_CREDENTIALS:-"~/.config/gcloud/terraform-admin.json"}

[[ -z "${GOOGLE_APPLICATION_CREDENTIALS}" ]] && export GOOGLE_APPLICATION_CREDENTIALS=${TF_CREDS}

BACKEND_FILE=${1:-"./backend.tf"}
echo "Using file: $BACKEND_FILE"

function init_bucket {
  gsutil mb -p ${GCP_PROJECT} gs://${GCP_PROJECT}-terraform-admin
}

function write_backend_file {
  cat > ${BACKEND_FILE} <<EOF
terraform {
  backend "gcs" {
    bucket = "${GS_BUCKET}"
    path   = "${GS_BUCKET_PATH}"
  }
}
EOF
}

init_bucket

([[ -e "backend.tf" ]] && echo "Warning: not overwriting existing 'backend.tf'") || write_backend_file

terraform init
