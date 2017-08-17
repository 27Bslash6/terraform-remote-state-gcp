# Storing Terraform remote state on a Google Cloud Storage bucket for GCP applications

## Installation

```bash
cp tf-remote-state-init.sh /usr/local/bin/tf-remote-state-init && \
chmod +x /usr/local/bin/tf-remote-state-init && \
tf-remote-state-init --help
```

### Quickstart
```
tf-remote-state-init
```

With command line argument specifying output filename:
```bash
tf-remote-state-init backend.tf
```

Mixing environment variables and arguments
```bash
GCS_BUCKET=project-admin-bucket tf-remote-state-init backend.tf -c ./gcp-credentials.json
```

Note that command line arguments are declarative and override environment variables. In this instance the script will use credentials from `./local-credentials.json`:
```bash
TF_GCP_CREDENTIALS=global-credentials.json tf-remote-state-init backend.tf -c ./local-credentials.json
```
## Configuration
| Environment Variable |            Description           | Default                         |
|----------------------|:--------------------------------:|---------------------------------|
| GCP_PROJECT          |           Project name           |                                 |
| GCS_BUCKET           | GCS bucket name                  |                                 |
| GCS_BUCKET_PATH      |          GCS bucket path         |                                 |
| TF_GCP_CREDENTIALS   | GCP Application credentials file | $GOOGLE_APPLICATION_CREDENTIALS |
## Warning

Google Cloud Storage [does not currently support locking](https://www.terraform.io/docs/backends/types/gcs.html) so take care using this in a distributed team
