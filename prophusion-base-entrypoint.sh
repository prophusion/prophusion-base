#!/usr/bin/env bash

mkdir -p /usr/local/phpenv/versions/.unverified

requestedversion=$PHP_VERSION

if [ "$requestedversion" != "" ]
then
  source /etc/bash.bashrc.phpenv_setup
  install_subcommand=""
  if [ -z "$PHP_INSTALL_CMD" ]
  then
    install_subcommand="global"
  else
    install_subcommand="$PHP_INSTALL_CMD"
  fi
  prophusion $install_subcommand "$requestedversion"
  if [ $? -ne 0 ]
  then
    >&2 echo "FAILED to install php version $requestedversion, aborting container!"
    exit 1
  fi
fi

# TODO: re-evaluate if this is that important. Lets you run as non-root, but slows things down if using a cache volume.
chmod a+rwx -R /usr/local/phpenv/versions

cmd=$1
if [ -z "$cmd" -a "$CONTAINER_CMD" != "" ]
then
  cmd="$CONTAINER_CMD"
fi

if [ "$cmd" == "" ]
then
  cmd="/bin/bash"
fi

exec $cmd
