include credentials.env
export $(shell sed 's/=.*//' credentials.env)

install-podman:
	apt-get install -y podman-compose podman-docker

up:
	podman-compose pull
	podman-compose up -d

down:
	podman-compose down
