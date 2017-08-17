#!/usr/bin/env bash

usage="Initialise Terraform remote state in a GCS bucket

$(basename "$0") [FILENAME] [-h|--help] [-p|--project] [-c|--credentials]\n

# Warning

Google Cloud Storage [does not currently support locking](https://www.terraform.io/docs/backends/types/gcs.html) so be careful using this in a distribute team

where:
    [FILENAME] output backend file to write ( default: ./backend.tf )
    -h  show this help text
    -b  set GCS bucket name ( default: \${GCP_PROJECT}-terraform-admin )
    -B  set GCE bucket path ( default: '/' )
    -c  set the path to the Google Application Credentials JSON file \n
        ( default: \${GOOGLE_APPLICATION_CREDENTIALS} )
    -p  set the GCP project name ( default: \$(gcloud config get-value project) )
\n
"
# We need TEMP as the `ev al set --' would nuke the return value of getopt.
TEMP=`getopt -o hb:B:c:p: --long help,bucket-name:,bucket-path:,credentials:,project: \
     -- "$@"`

if [ $? != 0 ] ; then echo "Terminating..." >&2 ; exit 1 ; fi

# Note the quotes around `$TEMP': they are essential!
eval set -- "$TEMP"

while true ; do
    case "$1" in
        -h|--help) echo "$usage" >&2 ; shift ;;
        -b|--bucket-name) GCS_BUCKET=$2; shift 2 ;;
        -B|--bucket-path) GCS_BUCKET_PATH=$2; shift 2 ;;
        -c|--credentials) TERRAFORM_CREDENTIALS=$2; shift 2 ;;
        -p|--project) GCP_PROJECT=$2; shift 2 ;;
        --) shift ; break ;;
        *) echo "Internal error!" >&2 ; exit 1 ;;
    esac
done

for arg do [[ -z $arg ]] || BACKEND_FILE=$arg ; done

function init_parameters {


  GCP_PROJECT=${GCP_PROJECT:-"$(gcloud config get-value project)"}
  echo "GCP project:     ${GCP_PROJECT}" >&2

  GCS_BUCKET=${GCS_BUCKET:-"${GCP_PROJECT}-terraform-admin"}
  GCS_BUCKET_PATH=${GCS_BUCKET_PATH:-"/"}
  echo "GCS bucket:      ${GCS_BUCKET}${GCS_BUCKET_PATH}" >&2

  export GOOGLE_APPLICATION_CREDENTIALS=${TERRAFORM_CREDENTIALS:-${GOOGLE_APPLICATION_CREDENTIALS}}
  echo "GCP credentials: ${GOOGLE_APPLICATION_CREDENTIALS}"  >&2

  BACKEND_FILE=${BACKEND_FILE:-"./backend.tf"}
  echo "Output:          $BACKEND_FILE\n" >&2
}

function init_bucket {
  gsutil mb -p ${GCP_PROJECT} gs://${GCP_PROJECT}-terraform-admin
}

function write_backend_file {
  cat > ${BACKEND_FILE} <<EOF
terraform {
  backend "gcs" {
    bucket = "${GCS_BUCKET}"
    path   = "${GCS_BUCKET_PATH}"
  }
}
EOF
}

# ===========================

init_parameters

init_bucket

write_backend_file

terraform init

# ===========================
