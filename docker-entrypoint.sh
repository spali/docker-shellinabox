#!/bin/bash
set -e

if [ "$1" = '/docker-command.sh' ]; then
	# get host internal ip
	export DOCKER_HOST=$(/sbin/ip route|awk '/default/ { print $3 }')
	echo "discovered docker host: $DOCKER_HOST"

	if [ -n "$SHELLINABOX_USER" ]; then
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

