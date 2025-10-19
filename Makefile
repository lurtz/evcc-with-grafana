TAG_NAME := 0.209.2-lurtz
IMAGE_NAME := lurtz/evcc:$(TAG_NAME)
TAG_FILE := .image_track_dir/$(TAG_NAME)
export IMAGE_NAME

# podman docker compatibility, might not be needed
export BUILDAH_FORMAT=docker

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
	systemctl --user stop evcc-with-grafana.service
	systemctl --user disable evcc-with-grafana.service
	rm -f ~/.config/systemd/user/evcc-with-grafana.service
	systemctl --user daemon-reload

.image_track_dir:
	mkdir -p .image_track_dir

$(TAG_FILE): .image_track_dir
	echo "Building $(IMAGE_NAME) image..." ; \
	podman rmi --force localhost/$(IMAGE_NAME) || true
	podman build --tag $(IMAGE_NAME) https://github.com/lurtz/evcc.git#$(TAG_NAME)
	touch $(TAG_FILE)

.PHONY: build
build: $(TAG_FILE)

.PHONY: up
up: build
	podman-compose up --pull --detach

.PHONY: up-systemd
up-systemd: build
	podman-compose up --pull

.PHONY: down
down:
	podman-compose down
