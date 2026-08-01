# evcc-with-grafana
Docker setup to run evcc with time series database and grafana. evcc, InfluxDB and Grafana should be already connected but need configuration for the local network.

# Setup

To setup create a file `.env` in this repo and call `make install-podman`.

`.env` must define the following environment variables:

- `GRAFANA_USERNAME`
- `GRAFANA_PASSWORD`
- `VICTORIAMETRICS_USER`
- `VICTORIAMETRICS_PASSWORD`

## Automated startup

Call `make install-service`.
For automatic startups the user needs to be automatically logged in at startup.
At the Raspberry PI this can be done using `raspi-config`.

## `podman-compose systemd` integration

Based on [podman-compose and systemd](https://www.it-hure.de/2024/02/podman-compose-and-systemd/) there is now an alternative to `make install-service`, which does not need automatic user login.

To use it this call `sudo make setup && make install`.

If that fails to download containers, [because no sub groups or sub user ids are available](https://github.com/podman-container-tools/podman/blob/main/docs/tutorials/rootless_tutorial.md#etcsubuid-and-etcsubgid-configuration) run:

```
# usermod --add-subuids 100000-165535 --add-subgids 100000-165535 $USER
```

# Howto development versions of evcc

Patch [docker-compose.yml](docker-compose.yml)

```bash
git apply own-build.patch
```

Then build evcc and rebuild the container.
Make sure that the base image version in [evcc-own-build.Dockerfile](evcc-own-build.Dockerfile) approximately matches that of the code (nightly version or release).

```
cd evcc
devcontainer up --workspace-folder .
devcontainer exec --workspace-folder . bash
make build
exit
cp evcc ../evcc-with-grafana/evcc-bin
systemctl --user stop evcc-with-grafana
podman rmi localhost/evcc-with-grafana_evcc:latest
systemctl --user start evcc-with-grafana
```

# TODO

- [ ] TLS connection to the internet (letsencrypt)
