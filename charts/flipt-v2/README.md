# Flipt v2 Helm Chart

[Flipt](https://flipt.io) v2 is a Git-native, open-source feature flag solution with multi-environment support and advanced workflow capabilities.

## Key Features

- **Git-Native**: Store feature flags in your own Git repositories
- **Multi-Environment**: Define multiple environments with independent configurations
- **Advanced Workflows**: Branch-based development with merge proposals
- **Authentication & Authorization**: OIDC support and policy-based access control
- **Pro Features**: License support for advanced capabilities including commit signing

## Installation

### Add Helm Repository

```bash
helm repo add flipt https://helm.flipt.io
helm repo update
```

### Install Chart

```bash
# Install with default values
helm install my-flipt-v2 flipt/flipt-v2

# Install with custom values
helm install my-flipt-v2 flipt/flipt-v2 -f values.yaml
```

## Configuration

Flipt v2 uses sensible defaults and works out-of-the-box without any configuration. For advanced configuration, any option from the [Flipt v2 Configuration Documentation](https://docs.flipt.io/v2/configuration/overview) can be set under the `flipt.config` section in your values.yaml file.

```yaml
# values.yaml
flipt:
  config:
    # Any configuration from https://docs.flipt.io/v2/configuration/overview
    # can be placed here using the same YAML structure

    # Example: Set log level
    log:
      level: DEBUG

    # Example: Configure Git synchronization
    git:
      repository: "https://github.com/your-org/flipt-config.git"
      ref: "main"
```

### Configuration via Environment Variables

You can also configure Flipt v2 using environment variables with the `FLIPT_` prefix:

```yaml
flipt:
  extraEnvVars:
    - name: FLIPT_LOG_LEVEL
      value: "DEBUG"
    - name: FLIPT_GIT_REPOSITORY
      value: "https://github.com/your-org/flipt-config.git"
```

## Values

| Key                   | Type   | Default                         | Description                                                                          |
| --------------------- | ------ | ------------------------------- | ------------------------------------------------------------------------------------ |
| `replicaCount`        | int    | `1`                             | Number of replicas                                                                   |
| `image.repository`    | string | `"docker.flipt.io/flipt/flipt"` | Image repository                                                                     |
| `image.tag`           | string | `""`                            | Image tag (defaults to chart appVersion)                                             |
| `service.type`        | string | `"ClusterIP"`                   | Kubernetes service type                                                              |
| `service.httpPort`    | int    | `8080`                          | HTTP service port                                                                    |
| `service.grpcPort`    | int    | `9000`                          | gRPC service port                                                                    |
| `ingress.enabled`     | bool   | `false`                         | Enable ingress controller resource                                                   |
| `persistence.enabled` | bool   | `false`                         | Enable persistent storage                                                            |
| `persistence.size`    | string | `"5Gi"`                         | Size of persistent volume                                                            |
| `autoscaling.enabled` | bool   | `false`                         | Enable horizontal pod autoscaling                                                    |
| `flipt.config`        | object | `{}`                            | Flipt v2 configuration (see [docs](https://docs.flipt.io/v2/configuration/overview)) |
| `flipt.extraEnvVars`  | array  | `[]`                            | Extra environment variables (must use FLIPT\_ prefix)                                |

## Differences from Flipt v1

### Architecture Changes

- **Git-Native Storage**: v2 stores flags in Git repositories instead of databases
- **Multi-Environment**: Server-defined environments vs UI-managed namespaces
- **Advanced Workflows**: Branch-based development with merge proposals
- **No External Dependencies**: Standalone binary with optional Git synchronization

### Configuration Changes

- Environment variables require `FLIPT_` prefix (e.g., `FLIPT_LOG_LEVEL`)
- Server command changed from `flipt` to `flipt server`
- New configuration structure for environments and Git synchronization

### Migration Notes

- v2 can import v1 flag data from Git repositories
- Environment configuration moved from UI to server config
- See [migration guide](https://docs.flipt.io/v2/guides/migration/) for detailed instructions

## Examples

### Basic Installation with Ingress

```yaml
# Basic setup with ingress
ingress:
  enabled: true
  className: nginx
  hosts:
    - host: flipt.company.com
      paths:
        - path: /
          pathType: Prefix
  tls:
    - secretName: flipt-tls
      hosts:
        - flipt.company.com
```

### Custom Configuration

```yaml
# Example custom configuration
flipt:
  config:
    # Configure logging
    log:
      level: INFO

    # Set up Git synchronization
    git:
      repository: "https://github.com/company/flipt-config.git"
      ref: "main"

    # Enable authentication (see docs for full options)
    authentication:
      required: true
```

For more configuration examples, see the [Flipt v2 Configuration Documentation](https://docs.flipt.io/v2/configuration/overview).

## Troubleshooting

### Debugging

```bash
# Check pod logs
kubectl logs -f deployment/my-flipt-v2

# Test connectivity
kubectl port-forward svc/my-flipt-v2 8080:8080

# Run chart tests
helm test my-flipt-v2
```

For configuration-specific troubleshooting, see the [Flipt v2 Documentation](https://docs.flipt.io/v2/).

## Contributing

Please see the main [helm-charts repository](https://github.com/flipt-io/helm-charts) for contribution guidelines.

## License

This chart is licensed under the MIT License. See the main repository for details.

