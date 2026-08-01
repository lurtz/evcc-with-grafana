#!/bin/bash
set -euxo pipefail

source "$(dirname "$0")/functions.sh"

function install_and_check_service() {
	setup
	write_fake_credentials
	write_fake_evcc_config
	sudo make setup
	make install
	systemctl --user is-active podman-compose@evcc-with-grafana || journalctl --user -xeu podman-compose@evcc-with-grafana
}

install_and_check_service

echo -e "\nAll tests passed\n"
