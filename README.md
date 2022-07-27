# Flipt Helm Charts

<!-- Keep full URL links to repo files because this README syncs from main to gh-pages.  -->

![Latest Version](https://img.shields.io/github/v/release/flipt-io/helm-charts?label=version&style=flat-square)

These charts are still a work in progress.

Please [create an issue](https://github.com/flipt-io/helm-charts/issues/new) or submit a pull request for any issues or missing features.

## Usage

[Helm](https://helm.sh) must be installed to use the charts.
Please refer to Helm's [documentation](https://helm.sh/docs/) to get started.

Once Helm is set up properly, add the repo as follows:

```console
helm repo add flipt https://helm.flipt.io
```

You can then run `helm search repo flipt` to see the charts.

### Installing

```console
helm install flipt flipt/flipt
```

### Upgrading

```console
helm upgrade flipt flipt/flipt
```

## Contributing

The source code of all [Flipt](https://flipt.io/) [Helm](https://helm.sh) charts can be found on Github: <https://github.com/flipt-io/helm-charts/>

## License

[MIT License](https://github.com/flipt-io/helm-charts/blob/main/LICENSE).
