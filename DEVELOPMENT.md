# Development Guide

This guide provides instructions for local development and testing of the Flipt Helm charts.

## Prerequisites

Before you begin, ensure you have the following tools installed:

- [Docker](https://docs.docker.com/get-docker/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- [Helm](https://helm.sh/docs/intro/install/) (v3.0+)
- [kind](https://kind.sigs.k8s.io/docs/user/quick-start/#installation)
- [chart-testing (ct)](https://github.com/helm/chart-testing#installation)

## Setting Up Local Development Environment

### 1. Create a kind Cluster

```bash
# Create a new kind cluster for testing
kind create cluster --name flipt-dev

# Verify the cluster is running
kubectl cluster-info --context kind-flipt-dev
kubectl get nodes
```

### 2. Clone and Navigate to Repository

```bash
git clone https://github.com/flipt-io/helm-charts.git
cd helm-charts
```

## Testing Charts Locally

### Testing Flipt v1 Chart

```bash
# Install Flipt v1 chart
helm install flipt-v1-test ./charts/flipt

# Check deployment status
kubectl get pods -l app.kubernetes.io/name=flipt
kubectl get svc -l app.kubernetes.io/name=flipt

# View logs
kubectl logs -l app.kubernetes.io/name=flipt

# Port forward to access Flipt UI
kubectl port-forward svc/flipt-v1-test 8080:8080

# Visit http://localhost:8080 in your browser
```

### Testing Flipt v2 Chart

```bash
# Install Flipt v2 chart
helm install flipt-v2-test ./charts/flipt-v2

# Check deployment status
kubectl get pods -l app.kubernetes.io/name=flipt-v2
kubectl get svc -l app.kubernetes.io/name=flipt-v2

# View logs
kubectl logs -l app.kubernetes.io/name=flipt-v2

# Port forward to access Flipt UI
kubectl port-forward svc/flipt-v2-test 8080:8080

# Visit http://localhost:8080 in your browser
```

## Testing with Custom Values

### Create Test Values Files

Create custom values files for testing different configurations:

```bash
# Create test values for v1
cat > test-values-v1.yaml << EOF
ingress:
  enabled: true
  className: nginx
  hosts:
    - host: flipt-v1.local
      paths:
        - path: /
          pathType: Prefix

flipt:
  config:
    log:
      level: DEBUG
    db:
      url: "file:/var/opt/flipt/flipt.db"
EOF

# Create test values for v2
cat > test-values-v2.yaml << EOF
ingress:
  enabled: true
  className: nginx
  hosts:
    - host: flipt-v2.local
      paths:
        - path: /
          pathType: Prefix

flipt:
  config:
    log:
      level: DEBUG
    storage:
      type: local
      local:
        path: /var/opt/flipt
EOF
```

### Install with Custom Values

```bash
# Install v1 with custom values
helm install flipt-v1-custom ./charts/flipt -f test-values-v1.yaml

# Install v2 with custom values
helm install flipt-v2-custom ./charts/flipt-v2 -f test-values-v2.yaml
```

## Development Workflow

### 1. Template Testing (Dry Run)

Before installing, always test your templates:

```bash
# Test v1 chart templates
helm template flipt-v1-test ./charts/flipt

# Test v2 chart templates
helm template flipt-v2-test ./charts/flipt-v2

# Test with custom values
helm template flipt-v1-test ./charts/flipt -f test-values-v1.yaml
helm template flipt-v2-test ./charts/flipt-v2 -f test-values-v2.yaml

# Save templates to files for inspection
helm template flipt-v1-test ./charts/flipt > v1-templates.yaml
helm template flipt-v2-test ./charts/flipt-v2 > v2-templates.yaml
```

### 2. Chart Linting

```bash
# Lint all charts
ct lint --lint-conf lintconf.yaml --target-branch main

# Lint specific chart
ct lint --lint-conf lintconf.yaml --charts charts/flipt
ct lint --lint-conf lintconf.yaml --charts charts/flipt-v2

# YAML linting
yamllint -c lintconf.yaml charts/

# Helm linting
helm lint charts/flipt
helm lint charts/flipt-v2
```

### 3. Upgrade Testing

```bash
# Test upgrades for v1
helm upgrade flipt-v1-test ./charts/flipt
helm upgrade flipt-v1-test ./charts/flipt -f test-values-v1.yaml

# Test upgrades for v2
helm upgrade flipt-v2-test ./charts/flipt-v2
helm upgrade flipt-v2-test ./charts/flipt-v2 -f test-values-v2.yaml
```

### 4. Chart Testing with ct

```bash
# Run comprehensive chart tests
ct install --config ct.yaml

# Test specific charts
ct install --config ct.yaml --charts charts/flipt
ct install --config ct.yaml --charts charts/flipt-v2
```

## Debugging Common Issues

### Pod Not Starting

```bash
# Check pod status
kubectl get pods -l app.kubernetes.io/instance=<release-name>

# Describe pod for detailed information
kubectl describe pod -l app.kubernetes.io/instance=<release-name>

# Check logs
kubectl logs -l app.kubernetes.io/instance=<release-name>

# Check events
kubectl get events --sort-by=.metadata.creationTimestamp
```

### Configuration Issues

```bash
# Check ConfigMap contents
kubectl get configmap <release-name> -o yaml

# Check rendered templates
helm get manifest <release-name>

# Check values used
helm get values <release-name>
```

### Network Issues

```bash
# Check services
kubectl get svc -l app.kubernetes.io/instance=<release-name>

# Check endpoints
kubectl get endpoints <release-name>

# Test connectivity
kubectl run -it --rm debug --image=busybox --restart=Never -- sh
# Inside the pod: wget -qO- http://<service-name>:8080/health
```

## Making Changes

### 1. Modify Chart Files

Make your changes to:

- `charts/flipt/` (for v1 changes)
- `charts/flipt-v2/` (for v2 changes)

### 2. Test Changes

```bash
# Lint changes
ct lint --lint-conf lintconf.yaml --target-branch main

# Template test
helm template test-release ./charts/flipt
helm template test-release ./charts/flipt-v2

# Install test
helm install test-release ./charts/flipt
helm install test-release ./charts/flipt-v2
```

### 3. Clean Up Test Releases

```bash
# List releases
helm list

# Uninstall test releases
helm uninstall flipt-v1-test
helm uninstall flipt-v2-test
helm uninstall flipt-v1-custom
helm uninstall flipt-v2-custom
```

## Environment Cleanup

### Clean Up Kubernetes Resources

```bash
# Delete all test releases
helm list --short | xargs -I {} helm uninstall {}

# Verify cleanup
kubectl get all
```

### Delete kind Cluster

```bash
# Delete the development cluster
kind delete cluster --name flipt-dev

# Verify deletion
kind get clusters
```

## Tips and Best Practices

### 1. Use Separate Namespaces

```bash
# Create namespace for testing
kubectl create namespace flipt-test

# Install charts in specific namespace
helm install flipt-v1 ./charts/flipt -n flipt-test
helm install flipt-v2 ./charts/flipt-v2 -n flipt-test

# Clean up namespace
kubectl delete namespace flipt-test
```

### 2. Monitor Resource Usage

```bash
# Check resource usage
kubectl top nodes
kubectl top pods

# Check resource requests/limits
kubectl describe deployment <release-name>
```

### 3. Test Different Scenarios

- Test with minimal values (defaults)
- Test with custom configurations
- Test upgrades between versions
- Test with different Kubernetes versions
- Test resource limits and requests
- Test ingress configurations
- Test persistent storage

### 4. Version Testing

```bash
# Test with specific image versions
helm install flipt-v1 ./charts/flipt --set image.tag=v1.59.0
helm install flipt-v2 ./charts/flipt-v2 --set image.tag=v2-beta
```

## Continuous Integration

The repository uses GitHub Actions for automated testing. You can run similar tests locally:

```bash
# Run the same linting as CI
ct lint --lint-conf lintconf.yaml --target-branch main

# Run the same installation tests as CI
ct install --config ct.yaml
```

For more information about the CI pipeline, see the GitHub Actions workflows in `.github/workflows/`.
