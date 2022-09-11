# mediawiki-backup

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.0.1](https://img.shields.io/badge/AppVersion-0.0.1-informational?style=flat-square)

A simple CronJob based backup for MediaWiki.

This chart will backup both the MariaDB database and file uploads from
MediaWiki.

## TL;DR

```console
$ helm repo add mediawiki-backup https://fernferret.github.io/mediawiki-backup
$ helm install my-release mediawiki-backup/mediawiki-backup
```

**Homepage:** <https://github.com/fernferret/mediawiki-backup>

## About

I wanted a very simple/flexible backup cron job for MediaWiki to
replace my old shell script that I was running with `cron`. Since I'd moved my
local MediaWiki into Kubernetes, I decided to build this chart.

It should work with any flavor of MediaWiki in Kubernetes as long as it is
indeed running inside kubernetes. This is because the `uploads` backup is done
via a `kubectl cp` command. The database can be hosted externally.

It uses a very simple alpine based container that includes `kubectl`,
`mysqldump` and `bash`.

It's recommended you run this as non-root as you really dont' need to run it as
root. See the `Example` section for a complete values file that acomplishes
this.

## Example

Here's my values file that I use with the [Bitnami MediaWiki
chart](https://artifacthub.io/packages/helm/bitnami/mediawiki).

```yaml
# helm diff upgrade wiki-backup -f my-mediawiki-backup.yaml -n wiki mediawiki-backup/mediawiki-backup

fullnameOverride: wiki-backup

persistence:
  enabled: true
  mode: "managed-pv"
  managedPv:
    node: node001
    path: /mnt/data1/mediawiki_backups

securityContext:
  capabilities:
    drop:
    - ALL
  readOnlyRootFilesystem: true
  runAsNonRoot: true
  runAsUser: 1000

podSecurityContext:
  runAsNonRoot: true
  fsGroup: 1000

backupTarget:
  labelSelector: app.kubernetes.io/name=mediawiki

backup:
  mariadb:
    host: "mediawiki-mariadb"
    username: "bn_mediawiki"
    dbName: "bitnami_mediawiki"
    passwordSecret:
      name: mediawiki-creds
      key: mariadb-password

  path: /bitnami/
```

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| fernferret | fernferret@gmail.com | https://github.com/fernferret |

## Source Code

* <https://github.com/fernferret/mediawiki-backup>

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` | Set the pod `affinity`, see https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#affinity-and-anti-affinity |
| backoffLimit | int | `6` | Set the number of pods that will be run before considering the Job failed. |
| backup.mariadb.dbName | string | `"mediawiki-database"` | Set the name of the database inside MariaDB to be backed up |
| backup.mariadb.host | string | `"my-mediawiki"` | Set the mariadb hostname, can be a service name. |
| backup.mariadb.passwordSecret.key | string | `"mariadb-password"` | Set the key inside the secret current namespace that contains the password use to connect to MariaDB |
| backup.mariadb.passwordSecret.name | string | `"mediawiki-credentials"` | Set the name of the secret in the current namespace that contains the password use to connect to MariaDB |
| backup.mariadb.port | int | `3306` | Set the port to connect to mariadb on |
| backup.mariadb.username | string | `"mediawiki-user"` | Set the username used to connect to the MariaDB instance |
| backup.path | string | `"/bitnami/"` | Set the directory that contains the uploads, skins and other files you wish to backup from MediaWiki. If you're using the Bitnami chart, this should be /bitnami/ |
| backupTarget.labelSelector | string | `"app.kubernetes.io/name=mediawiki"` | **REQUIRED**: This argument will be passed to `kubectl get pods -l <labelSelector>` to get the name of the mediawiki pod to use for backup. If the `labelSelector` returns more than one pod, the first is used. Example: `app.kubernetes.io/name=mediawiki` |
| backupTarget.retries | int | `1000` | Set the number of retries passed to kubectl when performing backups |
| concurrencyPolicy | string | `"Forbid"` | Set the CronJob's `concurrencyPolicy`, see `kubectl explain cronjob.spec.concurrencyPolicy` for details. For backups you likely don't want these running concurrently, so you should set `Forbid` (this chart's default). |
| failedJobsHistoryLimit | int | `1` | Set the number of failed backup jobs to keep around. |
| fullnameOverride | string | `""` | Set the `fullnameOverride`, this will be used in all places that need a name of the chart |
| image.pullPolicy | string | `"IfNotPresent"` | Set the `imagePullPolicy` to use when creating pods, see https://kubernetes.io/docs/concepts/containers/images/#image-pull-policy |
| image.repository | string | `"ghcr.io/fernferret/mediawiki-backup"` | Set the image repository to use when creating pods |
| image.tag | string | `""` | Overrides the image tag whose default is the chart appVersion. |
| imagePullSecrets | list | `[]` | Set the imagePullSecrets used to pull the container from a registry, see: https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/#create-a-pod-that-uses-your-secret |
| nameOverride | string | `""` | Set the `nameOverride`, this will be used in place of the `.Chart.Name` |
| nodeSelector | object | `{}` | Set the pod `nodeSelector`, see https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector |
| persistence.enabled | bool | `false` | Set to enable persistent backups. **WARNING:** not enabling persistence means your backups won't be saved after the backup job finished. **Only use for testing.** |
| persistence.managedPv.node | string | `""` | Set the node that the created local PersistentVolume will reside on. |
| persistence.managedPv.path | string | `""` | Set the path on the disk to use for backups. You must make this path yourself. |
| persistence.mode | string | `"pvc"` | Set the persistence mode, this can be either `pvc` or `managed-pv`. See the README.md for more info on persistence mode. |
| persistence.storageClassName | string | `""` | The storage class to use if `persistence.mode`` is pvc |
| podAnnotations | object | `{}` | Set arbitrary annotations on the pod |
| podSecurityContext | object | `{}` | Set the security context for the  pod for the backup job, see: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-container |
| rbac.create | bool | `true` | If false, do not create role and role binding. NOTE: file backups will not work unless RBAC is setup properly as this chart utilizes the kubectl cp function to perform backup of the uploads dir. |
| resources | object | `{}` | Set resources for the pod created for every backup job instantiation, see https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/ |
| restartPolicy | string | `"Never"` | Set the pod's restart policy, for cron jobs you likely want this set to `Never`, as restarts will be handled by the Job Controller. |
| schedule | string | `"0 1 * * *"` | Set the schedule for when backups should run. The default value will run at `0100` each day. |
| securityContext | object | `{}` | Set the security context for the container within the pod for the backup job, see: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-container |
| serviceAccount.annotations | object | `{}` | Set annotations to add to the service account |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created, a service account is used by the pod to perform a `kubectl cp` of the uploads directory within mediawiki |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| successfulJobsHistoryLimit | int | `3` | Set the number of successful backup jobs to keep around. |
| suspend | bool | `false` | If set, no new cron jobs are executed, does not affect the current run. |
| tolerations | list | `[]` | Set the pod `tolerations`, see https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/ |
