# About

![Version: 0.1.3](https://img.shields.io/badge/Version-0.1.3-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: v0.1.1](https://img.shields.io/badge/AppVersion-v0.1.1-informational?style=flat-square) [![Artifact Hub](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/mediawiki-backup)](https://artifacthub.io/packages/search?repo=mediawiki-backup)

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
