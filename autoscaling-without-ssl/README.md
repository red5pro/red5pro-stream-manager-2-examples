# Stream Manager 2.0 (AS) without SSL certificate

It is simple docker-compose.yml which include main Stream Manager 2.0 (AS) services without SSL certificate and HTTPS.
This example is usefull if SSL termination is working on the Load Balancer or on the CloudFlare

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
KAFKA_HOST=<PRIVATE_IP>
TRAEFIK_HOST=<PUBLIC_IP>
R5P_LICENSE_KEY=<LICENSE_KEY>
```

* `R5AS_AUTH_SECRET` - Authentication secret used to create and authenticate JWTs. Example: `12345abcd`
* `R5AS_AUTH_USER` - Authentication admin user name used to get JWT token. Example: `admin`
* `R5AS_AUTH_PASS` - Authentication admin user password used to get JWT token. Example: `password`
* `R5AS_PROXY_USER` - The authentication proxy username is used to obtain a JWT token that provides access solely to the stream proxy. Example: `proxy_user`
* `R5AS_PROXY_PASS` - The authentication proxy password is used to obtain a JWT token that provides access solely to the stream proxy. Example: `proxy_password`
* `R5AS_CLOUD_PLATFORM_TYPE` - Cloud platform type (OCI,AWS,LINODE,GCP). Example for Oracle Cloud: `OCI`
* `KAFKA_HOST` - Kafka server IP address. In this deployment Kafka server on the Stream Manager 2.0 instance so you will need to set Private IP address of this instance. Example: `10.0.0.1`
* `TRAEFIK_HOST` - The public IP address of the Stream Manager 2.0 instance (server). Example: `1.2.3.4`
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
KAFKA_HOST=10.0.0.1
TRAEFIK_HOST=1.2.3.4
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
AWS_ACCESS_KEY=<ACCESS_KEY>
AWS_SECRET_KEY=<SECRET_KEY>
AWS_SSH_KEY_PAIR=<SSH_KEY_PAIR>
AWS_ENABLE_ROOT_VOLUME_BLOCK_ENCRYPTION=<true or false>
```

* `AWS_ACCESS_KEY` - AWS access key to authenticate with AWS account. Follow the [docs](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html) to create
* `AWS_SECRET_KEY` - AWS secret key to authenticate with AWS account. Follow the [docs](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html) to create
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
KAFKA_HOST=10.0.0.1
TRAEFIK_HOST=1.2.3.4
R5P_LICENSE_KEY=1111-2222-3333-4444
AWS_ACCESS_KEY_ID=ABC123EXAMPLEKEY
AWS_SECRET_ACCESS_KEY=DEF456EXAMPLESECRETKEY
AWS_SSH_KEY_PAIR=example-ssh-key-name
AWS_ENABLE_ROOT_VOLUME_BLOCK_ENCRYPTION=true
```

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
KAFKA_HOST=10.0.0.1
TRAEFIK_HOST=1.2.3.4
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
KAFKA_HOST=10.0.0.1
TRAEFIK_HOST=1.2.3.4
R5P_LICENSE_KEY=1111-2222-3333-4444
GCP_PROJECT_ID=example-gcp-project-name
```
