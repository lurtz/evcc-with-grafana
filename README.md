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

# TODO

- [ ] TLS connection to the internet (letsencrypt)
