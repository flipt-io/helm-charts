# Flipt v2 Helm Chart

[Flipt](https://flipt.io) v2 is a Git-native, open-source feature flag solution with enhanced authentication, multi-environment support, and real-time streaming capabilities.

## Key Features

- **Git-Native**: Store feature flags in your own Git repositories
- **Multi-Environment**: Define multiple environments with independent configurations
- **Enhanced Authentication**: OIDC support with session management
- **Authorization**: Policy-based access control with OPA/Rego
- **Real-time Updates**: Streaming mode for instant flag updates
- **Pro Features**: License support for advanced capabilities
- **Commit Signing**: GPG signing for configuration integrity

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

### Basic Configuration

```yaml
# values.yaml
flipt:
  config:
    # Multi-environment setup
    environments:
      production:
        name: "Production"
        description: "Production environment"
        storage:
          type: git
          git:
            repository: "https://github.com/your-org/flipt-config.git"
            ref: "main"
            path: "production"
      staging:
        name: "Staging"
        description: "Staging environment"
        storage:
          type: git
          git:
            repository: "https://github.com/your-org/flipt-config.git"
            ref: "main"
            path: "staging"
```

### Authentication & Authorization

```yaml
flipt:
  config:
    # Enable authentication
    authentication:
      required: true
      session:
        domain: "your-domain.com"
        secure: true
      methods:
        oidc:
          enabled: true
          providers:
            google:
              issuer_url: "https://accounts.google.com"
              client_id: "your-client-id"
              client_secret: "your-client-secret"
              redirect_address: "https://flipt.your-domain.com"
              scopes: ["openid", "email", "profile"]

    # Enable authorization
    authorization:
      required: true
      backend: "local"
      local:
        policy:
          default: "deny"
```

### Git Synchronization

```yaml
flipt:
  config:
    git:
      repository: "https://github.com/your-org/flipt-config.git"
      ref: "main"
      polling_interval: "30s"
      authentication:
        token:
          access_token: "your-github-token"

# Add Git credentials via extraVolumes/extraVolumeMounts
extraVolumes:
  - name: git-credentials
    secret:
      secretName: flipt-git-secret

extraVolumeMounts:
  - name: git-credentials
    mountPath: /etc/flipt/git
    readOnly: true
```

### Pro Features (License Required)

```yaml
flipt:
  config:
    # License configuration
    license:
      key: "your-license-key"
      # Or use file-based license
      # file: "/path/to/license.lic"

    # Commit signing (Pro feature)
    commit_signing:
      enabled: true
      gpg:
        private_key_path: "/etc/flipt/gpg/private.key"

# Mount GPG keys
extraVolumes:
  - name: gpg-keys
    secret:
      secretName: flipt-gpg-secret

extraVolumeMounts:
  - name: gpg-keys
    mountPath: /etc/flipt/gpg
    readOnly: true
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| `replicaCount` | int | `1` | Number of replicas |
| `image.repository` | string | `"docker.flipt.io/flipt/flipt"` | Image repository |
| `image.tag` | string | `""` | Image tag (defaults to chart appVersion) |
| `service.type` | string | `"ClusterIP"` | Kubernetes service type |
| `service.httpPort` | int | `8080` | HTTP service port |
| `service.grpcPort` | int | `9000` | gRPC service port |
| `ingress.enabled` | bool | `false` | Enable ingress controller resource |
| `persistence.enabled` | bool | `false` | Enable persistent storage |
| `persistence.size` | string | `"5Gi"` | Size of persistent volume |
| `autoscaling.enabled` | bool | `false` | Enable horizontal pod autoscaling |
| `flipt.config.environments` | object | `{}` | Multi-environment configuration |
| `flipt.config.authentication.required` | bool | `false` | Enable authentication |
| `flipt.config.authorization.required` | bool | `false` | Enable authorization |
| `flipt.config.git` | object | `{}` | Git synchronization settings |
| `flipt.config.license` | object | `{}` | License configuration for Pro features |

## Differences from Flipt v1

### Architecture Changes
- **Git-Native Storage**: v2 stores flags in Git repositories instead of databases
- **Multi-Environment**: Server-defined environments vs UI-managed namespaces
- **Enhanced Auth**: OIDC, sessions, and policy-based authorization
- **Real-time Updates**: Streaming mode for instant flag synchronization

### Configuration Changes
- Environment variables require `FLIPT_` prefix (e.g., `FLIPT_LOG_LEVEL`)
- New configuration structure for environments, auth, and Git sync
- License configuration for Pro features

### Migration Notes
- v2 can read v1 flag data from Git repositories
- Environment configuration moved from UI to server config
- Authentication methods expanded with OIDC support

## Examples

### Simple Local Development

```yaml
# Simple setup for local development
flipt:
  config:
    storage:
      type: local
      local:
        path: /var/opt/flipt
```

### Production with OIDC and Git

```yaml
# Production setup with authentication and Git sync
flipt:
  config:
    environments:
      production:
        storage:
          type: git
          git:
            repository: "https://github.com/company/flags.git"
            
    authentication:
      required: true
      methods:
        oidc:
          enabled: true
          providers:
            okta:
              issuer_url: "https://company.okta.com"
              client_id: "flipt-client"
              client_secret: "secret"

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

## Troubleshooting

### Common Issues

1. **Git Authentication Failures**
   - Ensure Git credentials are properly mounted
   - Check repository URL and access permissions
   - Verify token/SSH key has required permissions

2. **OIDC Authentication Issues**
   - Verify redirect URLs match exactly
   - Check client ID and secret configuration
   - Ensure issuer URL is accessible from cluster

3. **Environment Configuration**
   - Environments must be defined in server config, not UI
   - Each environment needs its own storage configuration
   - Check environment names match API calls

### Debugging

```bash
# Check pod logs
kubectl logs -f deployment/my-flipt-v2

# Test connectivity
kubectl port-forward svc/my-flipt-v2 8080:8080

# Run chart tests
helm test my-flipt-v2
```

## Contributing

Please see the main [helm-charts repository](https://github.com/flipt-io/helm-charts) for contribution guidelines.

## License

This chart is licensed under the MIT License. See the main repository for details.