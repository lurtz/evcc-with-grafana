#!/bin/bash
set -euxo pipefail

source "$(dirname "$0")/functions.sh"

function startup_starts_all_containers_with_credentials_setup() {
	setup
	write_fake_credentials
	write_fake_evcc_config

	# bring it up
	make up

	# wait until all is running
	while podman exec evcc pidof evcc; ss=$?; [ 1 -eq $ss ]; do
		sleep 1
	done

	# check all daemons run
	# check environment is as expected
	[ 1 == $(podman exec evcc pidof evcc) ]
	[ 1 == $(podman exec evcc-with-grafana_grafana_1 pidof grafana) ]
	[ 1 == $(podman exec evcc-with-grafana_victoria-metrics_1 pidof /victoria-metrics-prod) ]
	[ 1 == $(podman exec evcc-with-grafana_telegraf_1 pidof telegraf) ]

	# check configuration is correct
	local grafana_env="$(podman exec evcc-with-grafana_grafana_1 env)"
	local telegraf_env="$(podman exec evcc-with-grafana_telegraf_1 env)"
	local vm_command="$(podman exec evcc-with-grafana_victoria-metrics_1 cat /proc/1/cmdline)"

	echo "$grafana_env" | grep -q "VM_USER=victoria"
	echo "$grafana_env" | grep -q "VM_PASSWORD=metrics"
	echo "$grafana_env" | grep -q "GF_SECURITY_ADMIN_PASSWORD=ana"
	echo "$grafana_env" | grep -q "GF_SECURITY_ADMIN_USER=graf"
	echo "$grafana_env" | grep -q "GF_AUTH_ANONYMOUS_ENABLED=true"
	echo "$grafana_env" | grep -q "GF_AUTH_ANONYMOUS_ORG_ROLE=Viewer"

	echo "$telegraf_env" | grep -q "VM_USER=victoria"
	echo "$telegraf_env" | grep -q "VM_PASSWORD=metrics"

	echo "$vm_command" | grep -q "Auth.usernamevictoria"
	echo "$vm_command" | grep -q "Auth.passwordmetrics"
}


startup_starts_all_containers_with_credentials_setup

echo -e "\nAll tests passed\n"
