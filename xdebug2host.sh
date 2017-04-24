#!/bin/bash

HOST_IP=$(/sbin/ip -4 route list 0/0 | /usr/bin/awk '/default/ { print $3 }')
XDEBUG_CONFIG="remote_enable=1 remote_mode=req remote_host=$HOST_IP remote_port=9000"

# Print the xdebug config, but only if stdout is a tty
if [ -t 1 ]
then
	echo $XDEBUG_CONFIG
fi

export XDEBUG_CONFIG

if [ "$XDEBUG2HOST" != "" ]
then
  export PHP_IDE_CONFIG="$XDEBUG2HOST"
fi
