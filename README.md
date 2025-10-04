# evcc-with-grafana
Docker setup to run evcc with time series database and grafana. evcc, InfluxDB and Grafana should be already connected but need configuration for the local network.

# Setup

To setup create a file `.env` in this repo and call `make install-podman` and `make install-service`.
For automatic startups the user needs to be automatically logged in at startup.
At the Raspberry PI this can be done using `raspi-config`.

`.env` must define the following environment variables:

- `GRAFANA_USERNAME`
- `GRAFANA_PASSWORD`
- `VICTORIAMETRICS_USER`
- `VICTORIAMETRICS_PASSWORD`

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
