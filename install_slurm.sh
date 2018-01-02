#!/bin/env bash

set -o errexit
set -o pipefail
set -o nounset
__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
__file="${__dir}/$(basename "${BASH_SOURCE[0]}")"
__base="$(basename ${__file} .sh)"


#Package munge + creating the secrete key don't forget to share it for all nodes 
apt update
apt install -y libmunge-dev 
dd if=/dev/urandom bs=1 count=1024 >/etc/munge/munge.key
# Need improvement to the next two lines in one only one 
wget -N https://download.schedmd.com/slurm/slurm-17.11.0-0rc2.tar.bz2
md5sum -c <<<"e1851c120199ea82b4aae414c7c82737 *$__dir/slurm-17.11.0-0rc2.tar.bz2"

#Installation slurm

__slurm_dir="$__dir/slurm-17.11.0-0rc2"
tar -xaf $slurm_dir.tar.bz2
cd $slurm_dir
# TODO option to mutliple slurmd --enable-multiple-slurmd
bash ./configure	
make
make install
ldconfig -n /usr/local/lib
/etc/init.d/munge start

# PAS OUBLIER DACTIVER BASE DE DONN2E SLURM
# Install slurm-drmaa
curl -#o slurm-drmaa-1.0.7.tar.gz http://apps.man.poznan.pl/trac/slurm-drmaa/downloads/9
tar -xf slurm-drmaa-1.0.7.tar.gz
cd slurm-drmaa-1.0.7

./configure #CFLAGS="-g -O0"
make
make install
export DRMAA_LIBRARY_PATH=/usr/local/lib/libdrmaa.so
# TODO
#sudo chown :group_galaxy /etc/slurm_drmaa.conf
#sudo chmod g+w /etc/slurm_drmaa.conf


# TEST
#echo 'echo "Test executed on host $(hostname) by user $USER"' > test.drmaa
#drmaa-run bash test.drmaa

