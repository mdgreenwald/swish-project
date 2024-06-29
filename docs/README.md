# Swish Project Notes

https://github.com/mdgreenwald/swish-project/



## General questions - Docker, CVEs, CI/CD, monitoring 

This section of the document is meant to address the General questions - Docker, CVEs, CI/CD, monitoring part of the questionaire.

## Overview
**Overview of approach:**
1. Read project specifications
2. Determine that steps 1-3 are related to SVN and CI. Steps 4+ are related to CD and Operations.
3. Work backwards from step 3 in the spec:
   1. Using Python 3, find a CVE -> [CVE-2022-48565](https://nvd.nist.gov/vuln/detail/CVE-2022-48565)
   2. Start with an impacted version of Python to show vulnerability scanning -> v3.9.0
   3. Start project at this version and then show an upgrade to a version that isn't impacted by CVE-2022-48565. -> v3.9.2
4. Use the official Python docker image as a starting point: https://hub.docker.com/_/python
   1. I prefer to use official images whenever possible because they tend to be higher quality and well maintained. It is not always possilbe to use official images though.
5. Work twords deploying a simple python HTTP server which returns hello world in Kubernetes.
6. Plan on opening a PR to address security issues.
7. Plan on opening a PR to address CI build times.
8. Address other concerns through exposition.


## Pull Requests to Address Questions

CVEs: https://github.com/mdgreenwald/swish-project/pull/7
Build Times: https://github.com/mdgreenwald/swish-project/pull/8

## Q2 - Docker Build Times

Here we compare two Dockerfiles' build times. The optimization is installing the dependencies before copying the source code. This optimization means that changes only to the source code don't require a complete rebuild of the container image. This means that there is a much faster feedback loop between changes and testing.

Build without cache and without optmization: 21.0s

Build without cache with optimization: 21.2s (Slight penalty for the additional step here)

Rebuild without optimization: 19.8s (Source code changes, no dependencies change)

Rebuild with optmization: 1.2s (Source code changes, no dependencies change)

Difference: -18.6s / 93% reduction in time to rebuild after source changes are made.

This will not benefit changes to dependencies, those will still be slower.

## Q3 - Security Advisories / CVEs

My approach here was to use an intentionally old, but not overly old version of Python (3.9) with known CVEs, scan and show the CVEs in GitHub, and then patch to a newer version to resolve them.

I used `docker scout` and `CodeQL ` to scan for CVEs. The vulnerabilities can be seen on pull requests as well as [this dashboard](https://github.com/mdgreenwald/swish-project/security/code-scanning).

**Before** patching/updating the Docker base image:

* https://github.com/mdgreenwald/swish-project/pull/5

**After** patching/updating the Docker base image:

* https://github.com/mdgreenwald/swish-project/pull/7

## Q4/Q5 - Kubernetes

Here I chose to use `tilt` and `kind` to create a working, local Kubernetes demonstration. This approach shows a long-lived deployment in a very easy and repeatable manner that is entirely contained in the repository. This is more geared towards a development environment but there is still a valid yaml file to show the deployment.

Exposing the deployed resource is handled by tilt here and the "application" can be viewed at http://localhost:8080 after running `just up`. That being said if you wanted to truly expose this in AWS you would need an entire chain of resources; application or network load balancer, an ingress controller such as ingress-nginx, service record, and ingress classes and records as well.

For automated DNS records you could use something like [external-dns](https://github.com/kubernetes-sigs/external-dns) which is extremely easy to use and creates a CNAME record and a TXT record (for state management) which can expose a resource.

## Q6 - VCS and CI/CD

> Every step mentioned above have to be in a code repository with automated CI/CD

I created this repository in an attempt to address this.

https://github.com/mdgreenwald/swish-project/

For this to move beyond local development you would need a image registry such as ECS, GCR, Harbor, or something else. You'd probably want to push new images on git push and those would go to staging and then after merge they could go to production. That's one way of handling promotion.

## Q7 - Monitoring

> How would you monitor the above deployment? Explain or implement the tools that you would use.

I would probably use SigNoz or Datadog with Grafana and Prometheus to monitor the deployments, resource utilization, and health.

In local dev and CI there should be tests that would be a first line of defense against a defect.
Once the code is merged and deployed then you will be relying on Monitoring and Alerting to ensure the health of the deployment. Kubernetes has built in tools such as health and readiness checks that can help somewhat. But those are limited so we'd be looking at a cluster and pod level monitoring agent like Datadog to monitor the health of the cluster, application, and the database if there is one to ensure a good rollout.

## Project

This section of the document is meant to address the "Project" portion of the questionaire.

> 1. UI, CI/CD, workflow or other tool that will allow people to select options for:
a. Base image 
b. Packages 
c. Mem/CPU/GPU requests 

This can be handled by situating each project within one repository such as with this swish demo project here. Base image is in the Dockerfile, Packages are in the pyproject.toml file, and resource requests can be handled in the kubernetes resource manifests. This approach can work for most languages.

In order to make this scale beyond a few projects you'd probably want to create each new CI/CD workflow from templates. You'd also want to use helm charts and a chart repository to version and standardize applications as much as possible and reduce the repetition that comes from raw YAML files.



> 2. Monitor each environment and make sure that: 
>
>    a. Resources request is accurate (requested vs used)
>
>    b. Notify when resources are idle or underutilized 
>
>    c. Downscale when needed (you can assume any rule defined by you to allow this to happen) 
>
>    d. Save data to track people requests/usage and evaluate performance

The monitoring portion of this will come down down to whatever monitoring tools are chosen. Assuming Datadog/SigNoz you'd want dashboards that can track resource utilization so that you aren't under utilizing nodes too much.

The scaling portion of this can be handled by a tool like the Cluster Autoscaler or Karpenter for a more advanced example.

> 3. The cluster needs to automatically handle up/down scaling and have multiple instance groups/taints/tags/others to be chosen from in order to segregate resources usage between teams/resources/projects/others 

Cluster Autoscaler or Karpenter can scale the cluster in and out automatically depending on different metrics that are applied.

> 4. SFTP, SSH or similar access to the deployed environment is needed so DNS handling automation is required 

VPN + Kubectl is probably fine here. Ideally you get everything before this point rebust enough that devs don't need to use `kubectl` very often. That is you want the automated testing and oversability at a level that could obviate the need for `kubectl` access most of the time.

> 5. Some processes that are going to run inside these environments require between 100-250GB of data in memory 
>
>    a. Could you talk about a time when you needed to bring the data to the code, and how you architected this system? 
>
>    b. If you don’t have an example, could you talk through how you would go about architecting this? 
>
>    c. How would you monitor memory usage/errors? 

Ideally these memory intensive workloads would get their own dedicated kubernetes cluster with high memory instances. If that wasn't an option then you'd have to have special high memory instances such as `x2iedn.2xlarge` or `r6g.8xlarge` and apply taints and tolerations to them so that the high-memory pods are scheduled exclusively scheduled to those nodes, and the nodes should only be availible when they are needed.

Depending on where and how you're sourcing the data for processing you could [pre-warm the EBS volumes](https://n2ws.com/blog/how-to-guides/pre-warm-ebs-volumes-on-aws) for example to improve init times and reduce the time that the expensive high-memory instances are running. That won't work if the data is coming from S3 or Redshift however.
