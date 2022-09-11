# About

This is a small dockerfile and helm chart to perform backups for
[MediaWiki](https://www.mediawiki.org/wiki/MediaWiki) installed in Kubernetes.

See the readme in the chart folder for more details.

## TL;DR

```console
$ helm repo add mediawiki-backup https://fernferret.github.io/mediawiki-backup
$ helm install my-release mediawiki-backup/mediawiki-backup
```

## Development

### Prereqs

If you want to build the chart documentation, you'll need a copy of
[`helm-docs`](https://github.com/norwoodj/helm-docs).

### Building

To build your own copy of the container just run:

```console
make container
```

To build the chart locally, just run:

```console
make chart
```
