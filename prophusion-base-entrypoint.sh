#!/usr/bin/env bash

mkdir -p /usr/local/phpenv/versions/.unverified

if [ "$requestedversion" == "" ]
then
  requestedversion=$PHP_VERSION
fi

if [ "$requestedversion" != "" ]
then
  source /etc/bash.bashrc.phpenv_setup
  prophusion global "$requestedversion"
fi

chmod a+rwx -R /usr/local/phpenv/versions

cmd=$1
if [ "$cmd" == "" ]
then
  cmd="/bin/bash"
fi

exec $cmd
