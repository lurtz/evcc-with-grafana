include credentials.env
export $(shell sed 's/=.*//' credentials.env)

.PHONY: install-podman
install-podman:
	apt-get install -y podman-compose podman-docker

evcc-with-grafana.service: evcc-with-grafana.service.template
	cp evcc-with-grafana.service.template evcc-with-grafana.service~
	sed --in-place -e "s#@EVCC_WITH_GRAFANA_WORKING_DIRECTORY@#${PWD}#" evcc-with-grafana.service~
	mv evcc-with-grafana.service~ evcc-with-grafana.service

.PHONY: install-service
install-service: evcc-with-grafana.service
	mkdir -p ~/.config/systemd/user
	cp evcc-with-grafana.service ~/.config/systemd/user/
	systemctl --user daemon-reload
	systemctl --user start evcc-with-grafana.service
	systemctl --user enable evcc-with-grafana.service

.PHONY: up
up:
	podman-compose pull
	podman-compose up -d

.PHONY: up-systemd
up-systemd:
	podman-compose pull
	podman-compose up

.PHONY: down
down:
	podman-compose down
