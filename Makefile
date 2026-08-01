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
	mv evcc-with-grafana.service ~/.config/systemd/user/
	systemctl --user daemon-reload
	systemctl --user start evcc-with-grafana.service
	systemctl --user enable evcc-with-grafana.service

.PHONY: uninstall-service
uninstall-service:
	-systemctl --user stop evcc-with-grafana.service
	-systemctl --user disable evcc-with-grafana.service
	rm -f ~/.config/systemd/user/evcc-with-grafana.service
	systemctl --user daemon-reload

.PHONY: up
up:
	podman-compose up --pull --detach

.PHONY: up-systemd
up-systemd:
	podman-compose up --pull

.PHONY: down
down:
	podman-compose down

# new way to run evcc with grafana, using systemd service
.PHONY: status
status:
	systemctl --user status 'podman-compose@evcc-with-grafana'

# needs root
.PHONY: setup
setup:
	loginctl enable-linger $(shell whoami)
	podman-compose systemd -a create-unit
	# ensure newest image is pulled
	sed --in-place 's|up --no-start|up --no-start --pull|g' /etc/systemd/user/podman-compose@.service; \
	# fix failure in github actions, but not observed locally with newer podman-compose versions
	if [ "`podman-compose --version | grep podman-compose | cut -d' ' -f3`" \< "1.3.0" ]; then \
		echo "podman-compose version < 1.3.0 detected, patching systemd service file"; \
		sed --in-place 's|up --no-start|--in-pod 1 up --no-start|g' /etc/systemd/user/podman-compose@.service; \
	fi

.PHONY: start
start:
	systemctl --user start 'podman-compose@evcc-with-grafana'

.PHONY: stop
stop:
	systemctl --user stop 'podman-compose@evcc-with-grafana'

.PHONY: install
install:
	podman-compose systemd -a register
	podman-compose down
	systemctl --user daemon-reload
	systemctl --user enable 'podman-compose@evcc-with-grafana'
	systemctl --user start 'podman-compose@evcc-with-grafana'

.PHONY: uninstall
uninstall:
	-systemctl --user stop 'podman-compose@evcc-with-grafana'
	-systemctl --user disable 'podman-compose@evcc-with-grafana'
# not available in all podman-compose versions
# 	podman-compose systemd -a unregister || true
# 	systemctl --user daemon-reload
