# Stream Manager 2.0 (AS) with SSL certificate

It is simple docker-compose.yml which include main Stream Manager 2.0 (AS) services with SSL certificate and HTTPS support.
This example is useful for installing on a single instance.

### Recommended: Use Terraform Modules

> **We strongly recommend using the official Red5 Pro Terraform modules** for deploying Stream Manager instances. These modules automatically handle IAM role creation, instance profiles, security groups, and all required infrastructure, ensuring best practices and security compliance.

**Available Terraform Modules:**
- **AWS**: [red5pro/aws](https://registry.terraform.io/modules/red5pro/red5pro/aws/latest) - AWS Infrastructure deployment
- **OCI**: [red5pro/oci](https://registry.terraform.io/modules/red5pro/red5pro/oci/latest) - Oracle Cloud Infrastructure deployment
- **GCP**: [red5pro/gcp](https://registry.terraform.io/modules/red5pro/red5pro/gcp/latest) - Google Cloud Platform deployment
- **Linode**: [red5pro/linode](https://registry.terraform.io/modules/red5pro/red5pro/linode/latest) - Linode deployment
- **Digital Ocean**: [red5pro/digitalocean](https://registry.terraform.io/modules/red5pro/red5pro/digitalocean/latest) - Digital Ocean deployment

If you're deploying manually (without using these Terraform modules), please follow the manual setup instructions below.

## Micro Services

* kafka
* as-admin
* as-terraform
* as-proxy
* as-autoscale-service
* as-auth
* as-streams
* reverse-proxy
* as-testbeds
* kafka-ui
* as-debug-ui

## Installation

1. Install Docker with the Docker Compose plugin by following the [Docker documentation](https://docs.docker.com/engine/install/ubuntu/)
2. Create a directory for Stream Manager:

```bash
mkdir -p /usr/local/stream-manager
```

3. Copy the files from this folder into the newly created `/usr/local/stream-manager` directory.

## Main Configuration Variables

To deploy the application, you need to configure the environment variables. The main example variables are provided in the file named `.example.env.`  

Follow these steps to set up the environment:

* Rename the file from `.example.env` to `.env`
* Place the renamed `.env` file in the same directory as your `docker-compose.yml` file.

This will ensure that Docker Compose can read the environment variables correctly during deployment.

```conf
R5AS_AUTH_SECRET=<SECRET_KEY>
R5AS_AUTH_USER=<USER_NAME>
R5AS_AUTH_PASS=<PASSWORD>
R5AS_PROXY_USER=<PROXY_USER>
R5AS_PROXY_PASS=<PROXY_PASSWORD>
R5AS_CLOUD_PLATFORM_TYPE=<PLATFORM_TYPE>
KAFKA_UI_VERSION=<KAFKA_IMAGE_VERSION>
KAFKA_HOST=<PRIVATE_IP>
TRAEFIK_HOST=<DNS_NAME>
TRAEFIK_SSL_EMAIL=<EMAIL>
R5P_LICENSE_KEY=<LICENSE_KEY>
```

* `R5AS_AUTH_SECRET` - Authentication secret used to create and authenticate JWTs. Example: `12345abcd`
* `R5AS_AUTH_USER` - Authentication admin user name used to get JWT token. Example: `admin`
* `R5AS_AUTH_PASS` - Authentication admin user password used to get JWT token. Example: `password`
* `R5AS_PROXY_USER` - The authentication proxy username is used to obtain a JWT token that provides access solely to the stream proxy. Example: `proxy_user`
* `R5AS_PROXY_PASS` - The authentication proxy password is used to obtain a JWT token that provides access solely to the stream proxy. Example: `proxy_password`
* `R5AS_CLOUD_PLATFORM_TYPE` - Cloud platform type (OCI,AWS,LINODE,GCP). Example for Oracle Cloud: `OCI`
* `KAFKA_UI_VERSION` - Specify the version of Kafka image to be used: `latest`
* `KAFKA_HOST` - Kafka server IP address. In this deployment Kafka server on the Stream Manager 2.0 instance so you will need to set Private IP address of this instance. Example: `10.0.0.1`
* `TRAEFIK_HOST` - Stream Manager 2.0 domain name: This should be the same domain name you used to create the DNS record. Example: `red5pro-sm2.example.com`
* `TRAEFIK_SSL_EMAIL` - The email address that will be used for the SSL certificate.
* `R5P_LICENSE_KEY` - Red5 Pro license key which will be using on the Red5 Pro nodes. It should be active [Red5 Pro license key](https://account.red5.net/overview), Startup Pro level or higher.

## Cloud variables for as-terraform service

Each cloud provider has own cloud variables (OCI, AWS, LINODE, GCP)  
These variables can be configured directly in the `.env` file.

### OCI specific variables

```conf
OCI_TENANCY_OCID=<TENANCY_OCID>
OCI_USER_OCID=<USER_OCID>
OCI_COMPARTMENT_ID=<COMPARTMENT_ID>
OCI_FINGERPRINT=<FINGERPRINT>
```

* `OCI_TENANCY_OCID` - Oracle cloud tenancy OCID. Follow the [docs](https://docs.oracle.com/en-us/iaas/Content/Identity/tenancy/managingtenancy.htm) to get tenancy OCID
* `OCI_USER_OCID` - Oracle cloud user OCID. You can get user OCID details in the Profile → User information
* `OCI_COMPARTMENT_ID` - Oracle cloud compartment OCID. Follow the [docs](https://docs.oracle.com/en-us/iaas/Content/GSG/Tasks/contactingsupport_topic-Locating_Oracle_Cloud_Infrastructure_IDs.htm#Finding_the_OCID_of_a_Compartment) to get compartment OCID
* `OCI_FINGERPRINT` - Fingerprint of Oracle cloud API ssh key. Follow the [docs](https://docs.oracle.com/en-us/iaas/Content/API/Concepts/apisigningkey.htm#two) to get Fingerprint

Example `.env` configuration for OCI

```conf
R5AS_AUTH_SECRET=12345abcd
R5AS_AUTH_USER=admin
R5AS_AUTH_PASS=password
R5AS_PROXY_USER=proxy_user
R5AS_PROXY_PASS=proxy_password
R5AS_CLOUD_PLATFORM_TYPE=OCI
KAFKA_UI_VERSION=latest
KAFKA_HOST=10.0.0.1
TRAEFIK_HOST=red5pro-sm2.example.com
TRAEFIK_SSL_EMAIL=email@example.com
R5P_LICENSE_KEY=1111-2222-3333-4444
OCI_TENANCY_OCID=ocid1.tenancy.oc1..aaaaaaaaxxxxxxxxyyyyyyyyyzzzzzzzz
OCI_USER_OCID=ocid1.user.oc1..aaaaaaaaxxxxxxxxyyyyyyyyyzzzzzzzz
OCI_COMPARTMENT_ID=ocid1.compartment.oc1..aaaaaaaaxxxxxxxxyyyyyyyyyzzzzzzzz
OCI_FINGERPRINT=00:11:22:33:44:55:66:77:88:99:aa:bb:cc:dd:ee:ff
```

#### Generate keys for OCI

1. Create directory for keys

```bash
mkdir -p /usr/local/stream-manager/keys
```

2. Generate an Oracle Cloud API private key and place it at `/usr/local/stream-manager/keys/oracle_private_api_key.pem`. Follow the [docs](https://docs.oracle.com/en-us/iaas/Content/API/Concepts/apisigningkey.htm#two)
3. Generate an SSH key pair and place the public key at `/usr/local/stream-manager/keys/red5pro_ssh_public_key.pub`. This key will be used for SSH connections to Red5 Pro nodes. You can generate the SSH key pair using `ssh-keygen` on Linux or macOS. Alternatively, you can use the same `*.pub` key that was used to deploy the Stream Manager 2.0 instance.

### AWS specific variables

```conf
AWS_SSH_KEY_PAIR=<SSH_KEY_PAIR>
AWS_ENABLE_ROOT_VOLUME_BLOCK_ENCRYPTION=<true or false>
```

> **Note:** AWS authentication uses IAM role-based authentication via instance profiles. The Stream Manager EC2 instance must have an IAM instance profile attached with the necessary permissions for Terraform operations. Static AWS access keys are no longer required.

* `AWS_SSH_KEY_PAIR` - SSH key name. It will be using for SSH connect to Red5 Pro nodes. Follow the [docs](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/create-key-pairs.html) to create SSH key pair in AWS.
* `AWS_ENABLE_ROOT_VOLUME_BLOCK_ENCRYPTION` - Enable or disable root block volume encryption for node instance. Defaults to true.

Example `.env` configuration for AWS

```conf
R5AS_AUTH_SECRET=12345abcd
R5AS_AUTH_USER=admin
R5AS_AUTH_PASS=password
R5AS_PROXY_USER=proxy_user
R5AS_PROXY_PASS=proxy_password
R5AS_CLOUD_PLATFORM_TYPE=AWS
KAFKA_UI_VERSION=latest
KAFKA_HOST=10.0.0.1
TRAEFIK_HOST=red5pro-sm2.example.com
TRAEFIK_SSL_EMAIL=email@example.com
R5P_LICENSE_KEY=1111-2222-3333-4444
AWS_SSH_KEY_PAIR=example-ssh-key-name
AWS_ENABLE_ROOT_VOLUME_BLOCK_ENCRYPTION=true
```

#### Manual IAM Setup for Stream Manager Instance

Since Stream Manager instances are deployed manually (not using the Terraform module), you need to manually create the IAM role, policy, and instance profile before deploying. The Stream Manager instance requires an IAM instance profile with appropriate permissions to run Terraform operations for managing EC2 instances. Here's how to set it up:

**1. Create IAM Trust Policy** (save as `trust-policy.json`):

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      }
    }
  ]
}
```

**2. Create IAM Role** (replace `<role-name>` with your desired role name, e.g., `stream-manager-terraform-role`):

```bash
aws iam create-role \
  --role-name <role-name> \
  --assume-role-policy-document file://trust-policy.json \
  --tags Key=Name,Value=<role-name>
```

**3. Create IAM Policy** (save as `terraform-policy.json`):

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "sts:GetCallerIdentity",
        "ec2:RunInstances",
        "ec2:TerminateInstances",
        "ec2:StartInstances",
        "ec2:StopInstances",
        "ec2:RebootInstances",
        "ec2:ModifyInstanceAttribute",
        "ec2:DescribeInstances",
        "ec2:DescribeImages",
        "ec2:DescribeInstanceTypes",
        "ec2:DescribeInstanceStatus",
        "ec2:DescribeAvailabilityZones",
        "ec2:DescribeSubnets",
        "ec2:DescribeVpcs",
        "ec2:DescribeSecurityGroups",
        "ec2:DescribeKeyPairs",
        "ec2:DescribeInstanceAttribute",
        "ec2:DescribeVpcAttribute",
        "ec2:DescribeInstanceTypeOfferings",
        "ec2:DescribeInstanceCreditSpecifications",
        "ec2:DescribeRegions",
        "ec2:DescribeAccountAttributes",
        "ec2:CreateTags",
        "ec2:DeleteTags",
        "ec2:DescribeTags",
        "ec2:DescribeVolumes",
        "ec2:AttachVolume",
        "ec2:DetachVolume",
        "ec2:CreateVolume",
        "ec2:DeleteVolume",
        "ec2:ModifyVolume",
        "ec2:DescribeSnapshots",
        "ec2:CreateSnapshot",
        "ec2:DeleteSnapshot",
        "ec2:DescribeNetworkInterfaces",
        "ec2:CreateNetworkInterface",
        "ec2:DeleteNetworkInterface",
        "ec2:AttachNetworkInterface",
        "ec2:DetachNetworkInterface",
        "ec2:ModifyNetworkInterfaceAttribute",
        "ec2:DescribePlacementGroups",
        "ec2:CreatePlacementGroup",
        "ec2:DeletePlacementGroup",
        "ec2:DescribeSpotInstanceRequests",
        "ec2:RequestSpotInstances",
        "ec2:CancelSpotInstanceRequests",
        "ec2:DescribeSpotPriceHistory",
        "ec2:DescribeReservedInstances",
        "ec2:DescribeReservedInstancesOfferings"
      ],
      "Resource": "*"
    }
  ]
}
```

**4. Create and Attach IAM Policy** (replace `<policy-name>` with your desired policy name, e.g., `stream-manager-terraform-policy`):

```bash
aws iam create-policy \
  --policy-name <policy-name> \
  --policy-document file://terraform-policy.json \
  --tags Key=Name,Value=<policy-name>

# Get the policy ARN from the output, then attach it to the role
aws iam attach-role-policy \
  --role-name <role-name> \
  --policy-arn arn:aws:iam::<account-id>:policy/<policy-name>
```

**5. Create IAM Instance Profile** (replace `<profile-name>` with your desired profile name, e.g., `stream-manager-terraform-profile`):

```bash
aws iam create-instance-profile \
  --instance-profile-name <profile-name> \
  --tags Key=Name,Value=<profile-name>

aws iam add-role-to-instance-profile \
  --instance-profile-name <profile-name> \
  --role-name <role-name>
```

**6. Attach Instance Profile to EC2 Instance**:

```bash
# Stop the instance first (if running)
aws ec2 stop-instances --instance-ids <instance-id>

# Wait for instance to stop, then modify instance attribute
aws ec2 modify-instance-attribute \
  --instance-id <instance-id> \
  --iam-instance-profile Name=<profile-name>

# Start the instance
aws ec2 start-instances --instance-ids <instance-id>
```

Alternatively, you can attach the instance profile via AWS Console:
1. Go to EC2 → Instances
2. Select your Stream Manager instance
3. Actions → Security → Modify IAM role
4. Select your instance profile and save

**Note:** After creating the instance profile, it may take a few seconds to propagate. Wait a moment before attaching it to the instance.

### Linode specific variables

```conf
LINODE_API_TOKEN=<API_TOKEN>
LINODE_SSH_KEY_NAME=<SSH_KEY_NAME>
```

* `LINODE_API_TOKEN` - Linode API token to authenticate with cloud. Follow the [docs](https://cloud.linode.com/profile/tokens) to create
* `LINODE_SSH_KEY_NAME` - SSH key name. It will be using for SSH connect to Red5 Pro nodes. Follow the [docs](https://techdocs.akamai.com/cloud-computing/docs/manage-ssh-keys) to create SSH key pair in Linode.

Example `.env` configuration for Linode

```conf
R5AS_AUTH_SECRET=12345abcd
R5AS_AUTH_USER=admin
R5AS_AUTH_PASS=password
R5AS_PROXY_USER=proxy_user
R5AS_PROXY_PASS=proxy_password
R5AS_CLOUD_PLATFORM_TYPE=LINODE
KAFKA_UI_VERSION=latest
KAFKA_HOST=10.0.0.1
TRAEFIK_HOST=red5pro-sm2.example.com
TRAEFIK_SSL_EMAIL=email@example.com
R5P_LICENSE_KEY=1111-2222-3333-4444
LINODE_API_TOKEN=example123xyz456token789
LINODE_SSH_KEY_NAME=example-ssh-key-name
```

### GCP specific variables

```conf
GCP_PROJECT_ID=<GCP_PROJECT_ID>
```

* `GCP_PROJECT_ID` - Google Cloud Project ID. Follow the [docs](https://support.google.com/googleapi/answer/7014113?hl=en) to create

Example `.env` configuration for GCP

```conf
R5AS_AUTH_SECRET=12345abcd
R5AS_AUTH_USER=admin
R5AS_AUTH_PASS=password
R5AS_PROXY_USER=proxy_user
R5AS_PROXY_PASS=proxy_password
R5AS_CLOUD_PLATFORM_TYPE=GCP
KAFKA_UI_VERSION=latest
KAFKA_HOST=10.0.0.1
TRAEFIK_HOST=red5pro-sm2.example.com
TRAEFIK_SSL_EMAIL=email@example.com
R5P_LICENSE_KEY=1111-2222-3333-4444
GCP_PROJECT_ID=example-gcp-project-name
```

### DigitalOcean specific variables

```conf
DIGITAL_OCEAN_API_TOKEN=<API_TOKEN>
DIGITAL_OCEAN_SSH_KEY_NAME=<SSH_KEY_NAME>
DIGITAL_OCEAN_PROJECT_NAME=<PROJECT_NAME>
```

* `DIGITAL_OCEAN_API_TOKEN` - DigitalOcean API token to authenticate with cloud. Follow the [docs](https://docs.digitalocean.com/reference/api/create-personal-access-token/) to create
* `DIGITAL_OCEAN_SSH_KEY_NAME` - SSH key name. It will be using for SSH connect to Red5 Pro nodes. Follow the [docs](https://docs.digitalocean.com/products/droplets/how-to/add-ssh-keys/) to create SSH key pair in DigitalOcean.
* `DIGITAL_OCEAN_PROJECT_NAME` - DigitalOcean project name to create all resource in specified project. Follow the [docs](https://docs.digitalocean.com/products/projects/how-to/create/) to create


Example `.env` configuration for DO

```conf
R5AS_AUTH_SECRET=12345abcd
R5AS_AUTH_USER=admin
R5AS_AUTH_PASS=password
R5AS_PROXY_USER=proxy_user
R5AS_PROXY_PASS=proxy_password
R5AS_CLOUD_PLATFORM_TYPE=GCP
KAFKA_UI_VERSION=latest
KAFKA_HOST=10.0.0.1
TRAEFIK_HOST=red5pro-sm2.example.com
TRAEFIK_SSL_EMAIL=email@example.com
R5P_LICENSE_KEY=1111-2222-3333-4444
DIGITAL_OCEAN_API_TOKEN=dop_v1_xxxxxxxx
DIGITAL_OCEAN_SSH_KEY_NAME=example-ssh-key-name
DIGITAL_OCEAN_PROJECT_NAME=example-do-project-name
```
