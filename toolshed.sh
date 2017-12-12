#!/bin/env bash
# Maintener Valentin Chambon MNHN

set -o errexit
set -o pipefail
set -o nounset
__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
__file="${__dir}/$(basename "${BASH_SOURCE[0]}")"
__base="$(basename ${__file} .sh)"

#Main
#############################################
#apt-get update && sudo apt-get upgrade -y
cd $HOME
git clone -b release_17.09 https://github.com/galaxyproject/galaxy.git || true
#Set the .bashrc
if [ -n "$(cat ~/.bashrc |grep "GALAXY_ROOT")" ];then
        echo "GALAXY_ROOT already set"
else
echo "#Galaxy stuff">>~/.bashrc
echo 'export GALAXY_ROOT="$HOME/galaxy"'>>~/.bashrc
fi

#Check galaxy.ini already exists

toolshed_ini_check_return=$(ls /root/galaxy/config/ |grep "toolshed.ini$") || true
if [ -n "$toolshed_ini_check_return" ]; then
        echo "The file already exits"
else
        echo "Coping tool_shed.ini.sample to tool_shed.ini"
        cp $GALAXY_ROOT/config/tool_shed.ini.sample  $GALAXY_ROOT/config/tool_shed.ini
fi