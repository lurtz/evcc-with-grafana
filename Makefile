include credentials.env
export $(shell sed 's/=.*//' credentials.env)

install-podman:
	apt-get install -y podman-compose podman-docker

install-service:
	mkdir -p ~/.config/systemd/user
	cp evcc-with-grafana.service ~/.config/systemd/user/
	systemctl --user daemon-reload
	systemctl --user start evcc-with-grafana.service
	systemctl --user enable evcc-with-grafana.service

up:
	podman-compose pull
	podman-compose up -d

down:
	podman-compose down
