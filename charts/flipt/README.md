# Flipt v1 Helm Chart

[Flipt](https://flipt.io) v1 is a stable, open-source feature flag solution with database backend support and UI-managed namespaces.

## Key Features

- **Database Storage**: Supports SQLite, PostgreSQL, MySQL, and other databases
- **UI-Managed Namespaces**: Organize flags through the web interface
- **Production Ready**: Stable, well-tested with extensive documentation
- **Flexible Configuration**: ConfigMap, environment variables, and YAML configuration
- **Enterprise Features**: Authentication, authorization, and audit logging

## Installation

### Add Helm Repository

```bash
helm repo add flipt https://helm.flipt.io
helm repo update
```

### Install Chart

```bash
# Install with default values
helm install my-flipt flipt/flipt

# Install with custom values
helm install my-flipt flipt/flipt -f values.yaml
```

## Configuration

Flipt is configured using either a configuration file or via environment variables.

See the [Flipt documentation](https://flipt.io/docs/configuration) for more information.

### ConfigMap

You can configure this chart using a [ConfigMap](https://kubernetes.io/docs/concepts/configuration/configmap/) named `flipt` which is mounted as a volume available to the pods at `/etc/flipt/config/default.yaml`.

### Environment Variables

You can also override the default config values with environment variables via the `flipt.extraEnvVars` field in your `values.yaml` file.

Note the values must be still be named as `FLIPT_<CONFIG_KEY>` per the [documentation](https://flipt.io/docs/configuration#environment-variables).

### Ingress Configuration

The chart supports ingress configuration with automatic generation of the required configuration. To enable the ingress controller, set `ingress.enabled=true` in your values file:

```yaml
flipt:
  ingress:
    enabled: true
    className: nginx # optional: only if you're using a specific ingress class
    hosts:
      - host: flipt.example.com
        paths:
          - path: /
            pathType: Prefix
```

For more advanced configurations, such as TLS and custom annotations:

```yaml
flipt:
  ingress:
    enabled: true
    className: nginx
    annotations:
      cert-manager.io/cluster-issuer: "letsencrypt-prod"
    hosts:
      - host: flipt.example.com
        paths:
          - path: /
            pathType: Prefix
            # backend configuration is optional and will default to:
            # backend:
            #   servicePort: http
            #   serviceName: <release-name>-flipt
    tls:
      - hosts:
          - flipt.example.com
        secretName: flipt-tls
```

The backend service configuration is optional. If not specified, the chart will automatically use the correct service name and port.

### YAML

You can also configure this chart using YAML. See the [values.yaml](https://github.com/flipt-io/helm-charts/blob/main/charts/flipt/values.yaml) file for the default values under `flipt.config`.

## Values

| Key                   | Type   | Default                         | Description                                                              |
| --------------------- | ------ | ------------------------------- | ------------------------------------------------------------------------ |
| `replicaCount`        | int    | `1`                             | Number of replicas                                                       |
| `image.repository`    | string | `"docker.flipt.io/flipt/flipt"` | Image repository                                                         |
| `image.tag`           | string | `""`                            | Image tag (defaults to chart appVersion)                                 |
| `service.type`        | string | `"ClusterIP"`                   | Kubernetes service type                                                  |
| `service.httpPort`    | int    | `8080`                          | HTTP service port                                                        |
| `service.grpcPort`    | int    | `9000`                          | gRPC service port                                                        |
| `ingress.enabled`     | bool   | `false`                         | Enable ingress controller resource                                       |
| `persistence.enabled` | bool   | `false`                         | Enable persistent storage                                                |
| `autoscaling.enabled` | bool   | `false`                         | Enable horizontal pod autoscaling                                        |
| `flipt.config`        | object | `{}`                            | Flipt v1 configuration (see [docs](https://flipt.io/docs/configuration)) |
| `flipt.extraEnvVars`  | array  | `[]`                            | Extra environment variables (must use FLIPT\_ prefix)                    |

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

### Database Configuration

```yaml
# Example with PostgreSQL
flipt:
  config:
    db:
      url: "postgres://user:password@postgres:5432/flipt?sslmode=disable"

# Or via environment variables
flipt:
  extraEnvVars:
    - name: FLIPT_DB_URL
      value: "postgres://user:password@postgres:5432/flipt?sslmode=disable"
```

For more configuration examples, see the [Flipt v1 Configuration Documentation](https://flipt.io/docs/configuration).

## Troubleshooting

### Debugging

```bash
# Check pod logs
kubectl logs -f deployment/my-flipt

# Test connectivity
kubectl port-forward svc/my-flipt 8080:8080

# Run chart tests
helm test my-flipt
```

For configuration-specific troubleshooting, see the [Flipt v1 Documentation](https://flipt.io/docs/).

## Contributing

The source code of all [Flipt](https://flipt.io/) [Helm](https://helm.sh) charts can be found on Github: <https://github.com/flipt-io/helm-charts/>

## License

[MIT License](https://github.com/flipt-io/helm-charts/blob/main/LICENSE).
