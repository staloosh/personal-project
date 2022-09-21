# Personal project
## _A CI/CD, IAC project_

This IaaC project has the following steps:

- Build a litecoin docker image using a custom-made Dockerfile
- Write Kubernetes manifests to use this docker image in a statefulset controller
- Write a build and deploy pipeline using a Jenkinsfile for the above resources
- Create scripts in bash and python to resolve a text manipulation problem
- Construct a terraform module to deploy resources to AWS
## Step 1 - Build docker image

The constructed [Dockerfile](Dockerfile) aims to run a litecoin 0.18.1 daemon. In order to reduce the attack surface and also have a smaller image at the end, I decided to implement a multi-stage Dockerfile.

In order to verify the checksum of the downloaded package I created a separate script [checksum.sh](checksum.sh) and also imported the gpg public key and verified the signature.
The docker image will be run as a non-privileged user as seen [here](https://github.com/staloosh/personal-project/blob/cb701c0b7e1fdc601a12396a5ca5c1da5dfe289b/Dockerfile#L61)

The above mentioned strategies, multi-stage build and using a non-privileged user take into consideration the security aspect of the image.

## Step 2 - Create Kubernetes manifests
For this project, the needed Kubernetes resource to use the previously created image is a statefulSet.
I am using a k3s cluster that I host in my home server, configured with one controlplane and one worker node.
In order to package the resources properly and make use of proper Kubernetes releases, I chose Helm for templating and releases.
The Helmchart template was generated by running the following command:
```sh
helm create litecoin
```
This ensures all the necessary files are present before modifying them with the appropriate values.
A persistent volume claim was used and also resource limits based on observed local resource consumption.
All the custom values are defined in the [values/test.yaml](https://github.com/staloosh/personal-project/blob/main/kubernetes/litecoin-chart/values/test.yaml) file

Security conscious implementation: 
- new service account named litecoin
- drop all capabilities in [securityContext](https://github.com/staloosh/personal-project/blob/cb701c0b7e1fdc601a12396a5ca5c1da5dfe289b/kubernetes/litecoin-chart/values/test.yaml#L18)
- set automountServiceAccountToken to [false](https://github.com/staloosh/personal-project/blob/cb701c0b7e1fdc601a12396a5ca5c1da5dfe289b/kubernetes/litecoin-chart/templates/statefulset.yaml#L29)
- restricting the pod with runAsUser in the securityContext was not needed as this was already defined in the Dockerfile

## Step 3 - Construct Jenkins pipeline
For this step I used a Jenkins server that is running in my home server.
Extra packages that were installed on the Jenkins server in order to be used in the pipeline:
- Git
- Kubectl
- Helm
- Docker

For the pipeline itself I went with a declarative pipeline which has the following steps:
- Build the docker image
- Scan the docker image with Trivy (this tool was chosen as it is the recommended one for CKS also)
- Do another scan, this time by using Snyk(via docker scan) - this scan is just for comparison
- Deploy docker image to dockerhub
- Cleanup the docker images from local Jenkins server
- Deploy all Kubernetes manifests to k3s with the help of Helm
     > Note: Here, I also added a step to see the manifests after templating
- Test if the Kubernetes service is running properly and that is has the proper pod endpoints - done through helm test
