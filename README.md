# evcc-with-grafana
Docker setup to run evcc with time series database and grafana. evcc, InfluxDB and Grafana should be already connected but need configuration for the local network.

# Setup

To setup create a file `credentials.env` in this repo and call `make install-podman` and `make install-service`.
For automatic startups the user needs to be automatically logged in at startup.
At the Raspberry PI this can be done using `raspi-config`.

`credentials.env` must define the following environment variables:

- `INFLUXDB_USERNAME`
- `INFLUXDB_PASSWORD`
- `INFLUXDB_ADMIN_TOKEN`
- `INFLUXDB_TOKEN`
- `GRAFANA_USERNAME`
- `GRAFANA_PASSWORD`

# TODO

- [ ] add `credentials.env` template
