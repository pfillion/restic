# restic

[![Build Status](https://drone.pfillion.com/api/badges/pfillion/restic/status.svg?branch=master)](https://drone.pfillion.com/pfillion/restic)
![GitHub](https://img.shields.io/github/license/pfillion/restic)
[![GitHub last commit](https://img.shields.io/github/last-commit/pfillion/restic?logo=github)](https://github.com/pfillion/restic "GitHub projet")

[![Docker Image Version (tag latest semver)](https://img.shields.io/docker/v/pfillion/restic/latest?logo=docker)](https://hub.docker.com/r/pfillion/restic "Docker Hub Repository")
[![Docker Image Size (latest by date)](https://img.shields.io/docker/image-size/pfillion/restic/latest?logo=docker)](https://hub.docker.com/r/pfillion/restic "Docker Hub Repository")
[![MicroBadger Layers (tag)](https://img.shields.io/microbadger/layers/pfillion/restic/latest?logo=docker)](https://microbadger.com/images/pfillion/restic "Get your own commit badge on microbadger.com")

[restic](https://restic.net) is a backup program that is fast, efficient and secure. It supports the three major operating systems (Linux, macOS, Windows) and a few smaller ones (FreeBSD, OpenBSD). For detailed usage check out the [documentation](https://restic.readthedocs.io/en/latest)

These projet is a adapted docker image of the [official one](https://hub.docker.com/r/restic/restic). Mainly, it's to manage environnement variable by **secrets**.

## Versions

* [0.12.0](https://github.com/pfillion/restic/tree/master) available as ```pfillion/restic:0.12.0``` at [Docker Hub](https://hub.docker.com/r/pfillion/restic/)

## Environment Variables

When you start the `restic` image, you can adjust the backup program by passing one or more environment variables on the `docker run` command line.

### `RESTIC_PASSWORD`

This variable is mandatory and indicate to the program to read the repository password from a file.

### `RESTIC_REPOSITORY`

This variable is mandatory and specifies the repository to backup to or restore from.

### `RESTIC_KEY_HINT`

This variable is optional and allows you to specify the key ID of key to try decrypting first.

## Docker Secrets

As an alternative to passing sensitive information via environment variables, `_FILE` may be appended to the previously listed environment variables, causing the initialization script to load the values for those variables from files present in the container. In particular, this can be used to load passwords from Docker secrets stored in `/run/secrets/<secret_name>` files. For example:

```console
docker run --rm -e RESTIC_REPOSITORY_FILE=/run/secrets/restic-repo -e RESTIC_PASSWORD_FILE=/run/secrets/restic-password pfillion/restic:latest restic snapshots
```

Currently, this is only supported for `RESTIC_PASSWORD`, `RESTIC_REPOSITORY` and `RESTIC_KEY_HINT`.

## Authors

* [pfillion](https://github.com/pfillion)

## License

MIT
