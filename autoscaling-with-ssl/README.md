# Stream Manager 2.0 (AS) with SSL certificate

It is simple docker-compose.yml which include main Stream Manager 2.0 (AS) services with SSL certificate and HTTPS support.
This example is useful for installing on a single instance.

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
R5AS_CLOUD_PLATFORM_TYPE=<PLATFORM_TYPE>
KAFKA_HOST=<PRIVATE_IP>
TRAEFIK_HOST=<DNS_NAME>
TRAEFIK_SSL_EMAIL=<EMAIL>
R5P_LICENSE_KEY=<LICENSE_KEY>
```

* `R5AS_AUTH_SECRET` - Authentication secret used to create and authenticate JWTs. Example: `12345abcd`
* `R5AS_AUTH_USER` - Authentication user name used to get JWT token. Example: `admin`
* `R5AS_AUTH_PASS` - Authentication user password used to get JWT token. Example: `password`
* `R5AS_CLOUD_PLATFORM_TYPE` - Cloud platform type (OCI,AWS,LINODE,GCP). Example for Oracle Cloud: `OCI`
* `KAFKA_HOST` - Kafka server IP address. In this deployment Kafka server on the Stream Manager 2.0 instance so you will need to set Private IP address of this instance. Example: `10.0.0.10`
* `TRAEFIK_HOST` - Stream Manager 2.0 domain name: This should be the same domain name you used to create the DNS record. Example: `red5pro-sm2.example.com`
* `TRAEFIK_SSL_EMAIL` - The email address that will be used for the SSL certificate.
* `R5P_LICENSE_KEY` - Red5 Pro license key which will be using on the Red5 Pro nodes. It should be active [Red5 Pro license key](https://account.red5.net/overview), Startup Pro level or higher.

## Cloud variables for as-terraform service

Each cloud provider has own cloud variables (OCI, AWS, LINODE, GCP)  
These variables can be configured in the `.env` file.

### OCI specific variables

```yaml
OCI_TENANCY_OCID=ocid1.tenancy.oc1..aaaaaaaaxxxxxxxxyyyyyyyyyzzzzzzzz
OCI_USER_OCID=ocid1.user.oc1..aaaaaaaaxxxxxxxxyyyyyyyyyzzzzzzzz
OCI_COMPARTMENT_ID=ocid1.compartment.oc1..aaaaaaaaxxxxxxxxyyyyyyyyyzzzzzzzz
OCI_FINGERPRINT=00:11:22:33:44:55:66:77:88:99:aa:bb:cc:dd:ee:ff
OCI_PRIVATE_KEY_PATH=/home/ubuntu/.ssh/oracle_private_api_key.pem
OCI_NODE_SSH_PUBLIC_KEY_PATH=/home/ubuntu/.ssh/red5pro_ssh_public_key.pub
```

* `OCI_TENANCY_OCID` - Oracle cloud tenancy OCID. Follow the [docs](https://docs.oracle.com/en-us/iaas/Content/Identity/tenancy/managingtenancy.htm) to get tenancy OCID
* `OCI_USER_OCID` - Oracle cloud compartment OCID. Follow the [docs](https://docs.oracle.com/en-us/iaas/Content/GSG/Tasks/contactingsupport_topic-Locating_Oracle_Cloud_Infrastructure_IDs.htm#Finding_the_OCID_of_a_Compartment) to get compartment OCID
* `OCI_COMPARTMENT_ID` - Oracle cloud user OCID. You can get user OCID details in the Profile → User information
* `OCI_FINGERPRINT` - Fingerprint of Oracle cloud API ssh key. Follow the [docs](https://docs.oracle.com/en-us/iaas/Content/API/Concepts/apisigningkey.htm#two) to get Fingerprint
* `OCI_PRIVATE_KEY_PATH` - Provide path to the private Oracle cloud API SSH key. Follow the [docs](https://docs.oracle.com/en-us/iaas/Content/API/Concepts/apisigningkey.htm#two) to generate new API SSH key. It should be uploaded to the Stream Manager 2.0 instance and mounted in the docker-compose.yml file.
* `OCI_NODE_SSH_PUBLIC_KEY_PATH` - Provide path to the public SSH key. It will be using for SSH connect to Red5 Pro nodes. You can generate SSH key par using `ssh-keygen` in Linux or MacOS command line. Or you can use the same `*.pub` key which you used to deploy Stream Manager 2.0 instance. It should be uploaded to the Stream Manager 2.0 instance and mounted in the docker-compose.yml file.  

Example `.env` configuration for OCI

```yaml
R5AS_AUTH_SECRET=<SECRET_KEY>
R5AS_AUTH_USER=<USER_NAME>
R5AS_AUTH_PASS=<PASSWORD>
R5AS_CLOUD_PLATFORM_TYPE=<PLATFORM_TYPE>
KAFKA_HOST=<PRIVATE_IP>
TRAEFIK_HOST=<DNS_NAME>
TRAEFIK_SSL_EMAIL=<EMAIL>
R5P_LICENSE_KEY=<LICENSE_KEY>
OCI_TENANCY_OCID=ocid1.tenancy.oc1..aaaaaaaaxxxxxxxxyyyyyyyyyzzzzzzzz
OCI_USER_OCID=ocid1.user.oc1..aaaaaaaaxxxxxxxxyyyyyyyyyzzzzzzzz
OCI_COMPARTMENT_ID=ocid1.compartment.oc1..aaaaaaaaxxxxxxxxyyyyyyyyyzzzzzzzz
OCI_FINGERPRINT=00:11:22:33:44:55:66:77:88:99:aa:bb:cc:dd:ee:ff
OCI_PRIVATE_KEY_PATH=/home/ubuntu/.ssh/oracle_private_api_key.pem
OCI_NODE_SSH_PUBLIC_KEY_PATH=/home/ubuntu/.ssh/red5pro_ssh_public_key.pub
```

### AWS specific variables

```yaml
AWS_ACCESS_KEY=REPLACE_AWS_ACCESS_KEY
AWS_SECRET_KEY=REPLACE_AWS_SECRET_KEY
AWS_SSH_KEY_PAIR=REPLACE_AWS_SSH_KEY_NAME
AWS_ENABLE_ROOT_VOLUME_BLOCK_ENCRYPTION=true
```

* `AWS_ACCESS_KEY` - AWS access key to authenticate with AWS account. Follow the [docs](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html) to create
* `AWS_SECRET_KEY` - AWS secret key to authenticate with AWS account. Follow the [docs](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html) to create
* `AWS_SSH_KEY_PAIR` - SSH key name. It will be using for SSH connect to Red5 Pro nodes. Follow the [docs](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/create-key-pairs.html) to create SSH key pair in AWS.
* `AWS_ENABLE_ROOT_VOLUME_BLOCK_ENCRYPTIO` - Enable or disable root block volume encryption for node instance. Defaults to true.

Example `.env` configuration for AWS

```yaml
R5AS_AUTH_SECRET=<SECRET_KEY>
R5AS_AUTH_USER=<USER_NAME>
R5AS_AUTH_PASS=<PASSWORD>
R5AS_CLOUD_PLATFORM_TYPE=<PLATFORM_TYPE>
KAFKA_HOST=<PRIVATE_IP>
TRAEFIK_HOST=<DNS_NAME>
TRAEFIK_SSL_EMAIL=<EMAIL>
R5P_LICENSE_KEY=<LICENSE_KEY>
AWS_ACCESS_KEY=<REPLACE_AWS_ACCESS_KEY>
AWS_SECRET_KEY=<REPLACE_AWS_SECRET_KEY>
AWS_SSH_KEY_PAIR=<REPLACE_AWS_SSH_KEY_NAME>
AWS_ENABLE_ROOT_VOLUME_BLOCK_ENCRYPTION=true
```

### Linode specific variables

```yaml
LINODE_API_TOKEN=REPLACE_LINODE_API_TOKEN
LINODE_SSH_KEY_NAME=REPLACE_LINODE_SSH_KEY_NAME
```

* `LINODE_API_TOKEN` - Linode API token to authenticate with cloud. Follow the [docs](https://cloud.linode.com/profile/tokens) to create
* `LINODE_SSH_KEY_NAME` - SSH key name. It will be using for SSH connect to Red5 Pro nodes. Follow the [docs](https://techdocs.akamai.com/cloud-computing/docs/manage-ssh-keys) to create SSH key pair in Linode.

Example `.env` configuration for Linode

```yaml
R5AS_AUTH_SECRET=<SECRET_KEY>
R5AS_AUTH_USER=<USER_NAME>
R5AS_AUTH_PASS=<PASSWORD>
R5AS_CLOUD_PLATFORM_TYPE=<PLATFORM_TYPE>
KAFKA_HOST=<PRIVATE_IP>
TRAEFIK_HOST=<DNS_NAME>
TRAEFIK_SSL_EMAIL=<EMAIL>
R5P_LICENSE_KEY=<LICENSE_KEY>
LINODE_API_TOKEN=<REPLACE_LINODE_API_TOKEN>
LINODE_SSH_KEY_NAME=<REPLACE_LINODE_SSH_KEY_NAME>
```

### GCP specific variables

```yaml
GCP_PROJECT_ID=GCP_PROJECT_ID
```

* `GCP_PROJECT_ID` - Google Cloud Project ID. Follow the [docs](https://support.google.com/googleapi/answer/7014113?hl=en) to create

Example `.env` configuration for GCP

```yaml
R5AS_AUTH_SECRET=<SECRET_KEY>
R5AS_AUTH_USER=<USER_NAME>
R5AS_AUTH_PASS=<PASSWORD>
R5AS_CLOUD_PLATFORM_TYPE=<PLATFORM_TYPE>
KAFKA_HOST=<PRIVATE_IP>
TRAEFIK_HOST=<DNS_NAME>
TRAEFIK_SSL_EMAIL=<EMAIL>
R5P_LICENSE_KEY=<LICENSE_KEY>
GCP_PROJECT_ID=<GCP_PROJECT_ID>
```
