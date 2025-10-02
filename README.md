# qubership-docker-kubectl

A lightweight Alpine-based Docker image with `kubectl` preinstalled.  
The image is primarily intended for use in Helm hooks or other automation scenarios where direct access to `kubectl` is required.

## Usage

Build the image locally:

```bash
docker build -t qubership-docker-kubectl:latest .
```

Use in Helm hook (example):

```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: kubectl-job
  annotations:
    "helm.sh/hook": pre-install
spec:
  template:
    spec:
      containers:
        - name: kubectl
          image: ghcr.io/netcracker/qubership-docker-kubectl:latest
          command: ["kubectl", "get", "pods", "-A"]
      restartPolicy: Never
```

## License

This project is licensed under the Apache-2.0 License.
