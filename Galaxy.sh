#!/bin/env bash
# Maintener Valentin Chambon MNHN

set -o errexit
set -o pipefail
set -o nounset
__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
__file="${__dir}/$(basename "${BASH_SOURCE[0]}")"
__base="$(basename ${__file} .sh)"


function docker_install {
        apt-get install -y docker.io
        user_name=$(whoami)
        usermod -a -G docker $user_name
        test_path_interactive_set=$(cat $GALAXY_ROOT/config/galaxy.ini |grep "interactive_environment_plugins_directory =" |cut -d"=" -f2)
        if [ -n "$test_path_interactive_set" ]; then
                echo "The path is already set : $test_path_interactive_set"
        else
                echo "Add the path to config/plugins/interactive_environments to galaxy.ini"
                sed -i 's/\(#interactive_environment_plugins_directory =\)/interactive_environment_plugins_directory = config\/plugins\/interactive_environments/' "$GALAXY_ROOT/config/galaxy.ini"
        fi
        echo "Ca marche là?"
        #Install node,sqlite3 and npm
        apt-get install -y nodejs
        ln -s /usr/bin/nodejs /usr/bin/node ||true
        wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.33.1/install.sh | bash
        
        #Sqlite3
        apt-get install -y sqlite3
        #Npm
        apt-get install -y npm
		# TODO, nvm don't install new version
		~/.nvm/nvm.sh install 0.10
        cd $GALAXY_ROOT/lib/galaxy/web/proxy/js && npm install
}


function disable_dev_set {
	sed -i "s/use_interactive = True/use_interactive = false/" $GALAXY_ROOT/config/galaxy.ini
}











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

galaxy_ini_check_return=$(ls /root/galaxy/config/ |grep "galaxy.ini$") || true
echo " Que vaut $galaxy_ini_check_return"

if [ -n "$galaxy_ini_check_return" ]; then
        echo "The file already exits"
else
        echo "Coping galaxy.ini.sample to galaxy.ini"
        cp $GALAXY_ROOT/config/galaxy.ini.sample $GALAXY_ROOT/config/galaxy.ini
fi
echo "Avant mon script"
docker_install
disable_dev_set


# Logrotate galaxy's log files
printf  "$GALAXY_ROOT/*.log { \n weekly \n rotate 8 \n copytruncate \n compress \n missingok \n notifempty \n}" > /etc/logrotate.d/galaxy

#Install nginx and rm the /etc/nginx/nginx.conf and cp there nginx.conf.sample
apt-get install -y nginx
rm /etc/nginx/nginx.conf || true
cp $__dir/Nginx/nginx.conf /etc/nginx/nginx.conf
service nginx restart
