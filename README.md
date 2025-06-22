# Deploy the project
## Prerequisites
Have GitHub SSH Key set up and filled `.env` file

## Deployment
Use `clone_and_build.sh` script to clone and build the `Docker` images.


Then use `docker compose -f compose.yml up` to run the project.

## Deploy using Kubernetes
After having used the script `clone_and_build.sh` `cd` in the root directory of the 3 sub projects inside `build_dir` directory.

And for each project do : 
```bash
minikube image build -f Dockerfile -t <image-name> .
```

Once this has been done you can do : `kubectl apply -f k8s-manifests/`

### Generate files
The first k8s-manifests have been generated using `kompose convert -f compose.yml -o k8s-manifests/` and then have been modified to change the `ImagePullPolicy` and other aspects.