# red5pro-stream-manager-2-examples

This repository contains Docker Compose configuration examples for deploying Red5 Pro Stream Manager 2.0 with autoscaling capabilities. These examples are designed for manual deployment on cloud instances (AWS, OCI, GCP, Linode).

## Available Examples

- **autoscaling-with-ssl** - Stream Manager 2.0 with SSL certificate and HTTPS support
- **autoscaling-without-ssl** - Stream Manager 2.0 without SSL (for load balancer SSL termination)
- **autoscaling-with-ssl-grafana** - Stream Manager 2.0 with SSL plus Grafana monitoring system

## Recommended: Use Terraform Modules

We strongly recommend using the official [Red5 Pro Terraform modules](https://registry.terraform.io/modules/red5pro) for automated infrastructure deployment. These modules handle IAM roles, security groups, and all required infrastructure automatically.

If you need to deploy manually, these Docker Compose examples provide complete configurations for running Stream Manager 2.0 with all required microservices.
