install-podman:
	apt-get install -y podman-compose podman-docker

up:
	INFLUXDB_USERNAME=inf INFLUXDB_PASSWORD=lux GRAFANA_USERNAME=graf GRAFANA_PASSWORD=ana podman-compose up -d

down:
	INFLUXDB_USERNAME=inf INFLUXDB_PASSWORD=lux GRAFANA_USERNAME=graf GRAFANA_PASSWORD=ana podman-compose down
