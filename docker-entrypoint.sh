#!/bin/bash
set -e

if [ "$1" = '/docker-command.sh' ]; then

	# check for package installation
	if [ ! -f /etc/shellinabox/pkgs_installed ] && [ -n "$SHELLINABOX_INSTALL_PKGS" ]; then
		apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install $(echo $SHELLINABOX_INSTALL_PKGS | tr "," " ")
		echo $SHELLINABOX_INSTALL_PKGS | tr "," "\n" >/etc/shellinabox/pkgs_installed
	fi

	# get host internal ip
	export DOCKER_HOST=$(/sbin/ip route|awk '/default/ { print $3 }')
	echo "discovered docker host: $DOCKER_HOST"

	if [ -n "$SHELLINABOX_USER" ] && ! id -u "$SHELLINABOX_USER" >/dev/null 2>&1; then
		echo "creating user: $SHELLINABOX_USER"
		if [ -n "$SHELLINABOX_ALLOW_SUDO" ]; then
			useradd -m -g users -G sudo $SHELLINABOX_USER
		else
			useradd -m -g users $SHELLINABOX_USER
		fi
		# set user password
		if [ -n "$SHELLINABOX_PASSWORD" ]; then
			echo "set password for user: $SHELLINABOX_USER"
			echo "$SHELLINABOX_USER:$SHELLINABOX_PASSWORD" | chpasswd
		fi
	fi
	unset SHELLINABOX_PASSWORD
fi

exec $@

