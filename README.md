# Flipt Helm Charts

<!-- Keep full URL links to repo files because this README syncs from main to gh-pages.  -->

![Chart Version](https://img.shields.io/github/v/release/flipt-io/helm-charts?label=chart%20version)
![Flipt Version](https://img.shields.io/github/v/release/flipt-io/flipt?color=green&label=flipt%20version)

Please [create an issue](https://github.com/flipt-io/helm-charts/issues/new) or submit a pull request for any issues or missing features.

## Versioning

This project uses [Semantic Versioning](https://semver.org/).

Our versioning strategy is based on the version of application that is packaged in the chart:

- Each minor version bump of the application will also increase the minor version of the chart.
- Each patch version bump of the application will also increase the patch version of the chart.

**Note:** Some changes to the chart will not affect the application version. For example, if there is a bugfix or patch change to the chart that does not affect the application, the chart version will be incremented, but the application version will remain the same.

## Usage

[Helm](https://helm.sh) must be installed to use the charts.
Please refer to Helm's [documentation](https://helm.sh/docs/) to get started.

Once Helm is set up properly, add the repo as follows:

```console
helm repo add flipt https://helm.flipt.io
```

You can then run `helm search repo flipt` to see the charts.

## Installing

```console
helm install flipt flipt/flipt
```

## Upgrading

```console
helm upgrade flipt flipt/flipt
```

## Configuration

Flipt is configured using either a configuration file or via environment variables.

See the [Flipt documentation](https://flipt.io/docs/configuration) for more information.

### ConfigMap

You can configure this chart using a [ConfigMap](https://kubernetes.io/docs/concepts/configuration/configmap/) named `flipt` which is mounted as a volume available to the pods at `/etc/flipt/config/default.yaml`.

### Environment Variables

You can also override the default config values with environment variables via the `flipt.extraEnvVars` field in your `values.yaml` file.

Note the values must be still be named as `FLIPT_<CONFIG_KEY>` per the [documentation](https://flipt.io/docs/configuration#environment-variables).

### YAML

You can also configure this chart using YAML. See the [values.yaml](charts/flipt/values.yaml) file for the default values under `flipt.config`.

## Contributing

The source code of all [Flipt](https://flipt.io/) [Helm](https://helm.sh) charts can be found on Github: <https://github.com/flipt-io/helm-charts/>

## License

[MIT License](https://github.com/flipt-io/helm-charts/blob/main/LICENSE).
