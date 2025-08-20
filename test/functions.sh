#!/bin/bash

function setup() {
	# Restore old state exit
	# TODO Running the tests in a container would be more robust
	trap "make uninstall-service || true; make down; mv .env-back .env; mv evcc-provisioning/evcc.yaml-back evcc-provisioning/evcc.yaml" EXIT

	# Save previous state
	touch .env
	touch evcc-provisioning/evcc.yaml
	mv .env .env-back
	mv evcc-provisioning/evcc.yaml evcc-provisioning/evcc.yaml-back
}

function write_fake_credentials() {
	cat <<EOF > .env
VICTORIAMETRICS_USER=victoria
VICTORIAMETRICS_PASSWORD=metrics
GRAFANA_USERNAME=graf
GRAFANA_PASSWORD=ana
EOF
}

function write_fake_evcc_config() {
	cat <<EOF > evcc-provisioning/evcc.yaml
network:
  schema: http
  host: evcc.local # .local suffix announces the hostname on MDNS
  port: 7070

log: debug
levels:
  cache: error

# unique installation id
plant: 6666666666666666666666666666666666666666666666666666666666666666

interval: 30s # control cycle interval

influx:
  url: http://victoria:metrics@victoria-metrics:8428

meters:
  - name: my_battery
    type: template
    template: demo-battery
    usage: battery
    power: 3000
    soc: 0.5
  - name: my_grid
    type: template
    template: demo-meter
    usage: grid
    power: 5000
  - name: my_pv
    type: template
    template: demo-meter
    usage: pv
    power: 6000

chargers:
  - name: wallbox4
    type: template
    template: demo-charger
    status: A # Ladezustand, [A, B, C]

loadpoints:
  - title: Garage1
    charger: wallbox4
    mode: minpv

site:
  title: Baumhaus
  meters:
    grid: my_grid
    pv:
      - my_pv
    battery:
      - my_battery
EOF
}
