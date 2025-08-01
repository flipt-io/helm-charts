# Flipt Helm Charts

<!-- Keep full URL links to repo files because this README syncs from main to gh-pages.  -->

![Chart Version](https://img.shields.io/github/v/release/flipt-io/helm-charts?label=chart%20version)
![Flipt Version](https://img.shields.io/github/v/release/flipt-io/flipt?color=green&label=flipt%20version)

This repository contains Helm charts for [Flipt](https://flipt.io), an open-source, self-hosted feature flag solution.

Please [create an issue](https://github.com/flipt-io/helm-charts/issues/new) or submit a pull request for any issues or missing features.

## Available Charts

### Flipt v1 (Stable)

The stable Flipt v1 chart provides a production-ready deployment of Flipt with database backend support.

- **Chart Name**: `flipt`
- **Status**: Stable
- **Documentation**: [charts/flipt/README.md](charts/flipt/README.md)

**Installation:**
```console
helm repo add flipt https://helm.flipt.io
helm install my-flipt flipt/flipt
```

### Flipt v2 (Beta)

The Flipt v2 chart provides Git-native feature flag management with multi-environment support and advanced workflows.

- **Chart Name**: `flipt-v2`
- **Status**: Beta
- **Documentation**: [charts/flipt-v2/README.md](charts/flipt-v2/README.md)

**Installation:**
```console
helm repo add flipt https://helm.flipt.io
helm install my-flipt-v2 flipt/flipt-v2
```

## Quick Start

### Prerequisites

[Helm](https://helm.sh) must be installed to use the charts. Please refer to Helm's [documentation](https://helm.sh/docs/) to get started.

### Add Repository

```console
helm repo add flipt https://helm.flipt.io
helm repo update
```

### List Available Charts

```console
helm search repo flipt
```

## Chart Comparison

| Feature | Flipt v1 | Flipt v2 |
|---------|----------|----------|
| **Status** | Stable | Beta |
| **Storage** | Database (SQLite, PostgreSQL, MySQL, etc.) | Git-native |
| **Environments** | UI-managed namespaces | Server-defined environments |
| **Workflows** | Traditional UI management | Branch-based development with merge proposals |
| **Dependencies** | Database required | Standalone binary, optional Git sync |
| **Configuration** | Database + config file/env vars | Git repositories + config file/env vars |

## Choosing Between v1 and v2

**Choose Flipt v1 if:**
- You need a stable, production-ready solution
- You prefer traditional database-backed storage
- You want UI-managed namespaces
- You need proven reliability and extensive documentation

**Choose Flipt v2 if:**
- You want Git-native feature flag management
- You need multi-environment support with Git workflows
- You prefer branch-based development and merge proposals
- You don't mind beta software and want cutting-edge features

## Versioning

This project uses [Semantic Versioning](https://semver.org/).

Our versioning strategy is based on the version of application that is packaged in the chart:

- Each minor version bump of the application will also increase the minor version of the chart.
- Each patch version bump of the application will also increase the patch version of the chart.

**Note:** Some changes to the chart will not affect the application version. For example, if there is a bugfix or patch change to the chart that does not affect the application, the chart version will be incremented, but the application version will remain the same.

## Contributing

The source code of all [Flipt](https://flipt.io/) [Helm](https://helm.sh) charts can be found on Github: <https://github.com/flipt-io/helm-charts/>

## License

[MIT License](https://github.com/flipt-io/helm-charts/blob/main/LICENSE).