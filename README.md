
# Galaxy 17.09 in production, virtual machine on cloud based on Openstack
##	Galaxy
### Create galaxy user and install it
First connect as root user to your new machine, then create a new user galaxy and give root Privileges 

```
ssh root@192.XXX.XXX.XX
#Change root password
passwd root
adduser galaxy
# Choose password

# edit the sudoers file, to give galaxy root privileges
# add galaxy ALL=(ALL:ALL) ALL
visudo
```

Now use the script galaxy_install.sh 
```
cd $HOME
sudo bash galaxy_install.sh
```
This script install : galaxy, docker, npm, node and nginx.



You should downgrade node version , because galaxy work only with <0.11. We use Node Version Manager from[lien](https://github.com/creationix/nvm)
```
	#Add this to your .bashrc
	export NVM_DIR="$HOME/.nvm"
	[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm
```
		
	Then execute
```
	wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.33.1/install.sh | bash
	source .bashrc
	nvm install 0.10
	nvm use 0.10
    cd $GALAXY_ROOT/lib/galaxy/web/proxy/js && npm install
```
You can check if it work with `node -v `should retourn
```
galaxy@65mo-galaxy-prod:~$ node -v
v0.10.48

```
##	Tolshed
### Create Toolshed user and install it
It's recommanded to install your toolshed on another machine.
```
ssh root@192.XXX.XXX.XX
#Change root password
passwd root
adduser toolshed
# Choose password

# edit the sudoers file, to give galaxy root privileges
# add toolshed ALL=(ALL:ALL) ALL
visudo
```

You can use the script shell
```
bash toolshed.ini
```
it will download, and copy config files.

After that start the toolshed in daemon mod



# PostgreSQL
## Galaxy database
* Start a new machine, connect ,change root password, add user, install postgreSql and create user and database galaxy *
```
ssh root@192.XXX.XXX.XX
#Change root password
passwd root
adduser galaxy
apt-get update

apt-get install -y postgresql postgresql-contrib
sudo -u postgres createuser --interactive
sudo -u galaxy createdb galaxy
```
Now you have to give database acces to your galaxy server. You have to add  in `/etc/postgresql/9.5/main/pg_hba.conf` :
```
#Type of connection		#Database		#User			#Adress							#Option connection ( don't need password in this case)

host    				galaxy          galaxy          192.XXX.XXX.XX/32               trust
```
And after that you have to specifiy than postgresql should accepte request from your galaxy server.

Change in `/etc/postgresql/9.5/main/postgresql.conf`

`listen_addresses = 'localhost' -> '192.XXX.XXX.XX'`

or

`listen_addresses = 'localhost' -> '*' `

for all

and restart the server
```
  /etc/init.d/postgresql restart
```
 After that you have to change in `$GALAXY_ROOT/config/galaxy.ini`
 ```
 #database_connection = sqlite:///./database/universe.sqlite?isolation_level=IMMEDIATE
 ```
 to
  ```
 database_connection = postgresql://galaxy:password@192.XXX.XXX.XX:5432/galaxy
 ```
 Please refer to this ::: `postgresql://username:password@localhost/mydatabase` 
 
 localhost is the adress of the machine where your postgresql server is runing
 
## Toolshed database

```
adduser toolshed
sudo -u postgres createuser --interactive
sudo -u toolshed createdb toolshed
```
Now you have to give database acces to your toolsed server. You have too add  in /etc/postgresql/9.5/main/pg_hba.conf :
#Type of connection		#Database		#User			#Adress							#Option connection ( don't need password in this case)
host    				toolshed          toolshed          192.XXX.XXX.XX/32               trust

And after that you have to specifiy than postgresql should accepte request from your toolshed server machine.

 Change in `/etc/postgresql/9.5/main/postgresql.conf`

`listen_addresses = 'localhost'  to '192.XXX.XXX.XX'`

or

`listen_addresses = 'localhost' to '*' `

for all

and restart the server

`  /etc/init.d/postgresql restart`

After that you have to change in tool_shed.ini
 ```
 #database_connection = sqlite:///./database/community.sqlite?isolation_level=IMMEDIATE
 ```
 to
  ```
 database_connection = postgresql://toolshed:pasword@192.XXX.XXX.XX:5432/toolshed
 ```
 Please refer to this ::: `postgresql://username:password@localhost/mydatabase` 
 
 localhost is the adress of the machine where your postgresql server is runing
# Galaxy interactive environnements : Docker

You can have your Docker server and the Galaxy server on the same machine. It could be interesting in one case to launch your container on 
the same machine. I will present 2 cases.

:warning::warning:In any case you have to install docker on your Galaxy server's machine. The `galaxy_install.sh` already did it for you.

:pushpin: : You should pull all the image before their used, because Galaxy launch the command and if the image doesn't exists, docker will
pull it, but for somes images like Jupyter it could be really long, so do it before

:pushpin::pushpin: Wait for the part #Mount Volume, before pull any image, or you risk to run out space your machine.



## Docker on the same machine.
	So you don't have to do something...
	
	Congratulations it's complete :clap: :clap:
	
	Refer to this [page](https://docs.galaxyproject.org/en/master/admin/interactive_environments.html)
## Docker an another host	
	
```
ssh root@192.XXX.XXX.XX
passwd root

adduser docker
# Choose password

# edit the sudoers file, to give galaxy root privileges
# add docker ALL=(ALL:ALL) ALL
visudo
```
then install docker

```
apt-get install -y docker.io
usermod -a -G docker $(whoami)
dockerd -H 0.0.0.0:4243
```

Then you have to change the config.ini file of your GIE . For example with jupyter

```
[main]

[docker]
command = docker -H tcp://192.XXX.XXX.XX:4243 {docker_args}
image = bgruening/docker-ipython-notebook:dev
docker_hostname = 192.XXX.XXX.XX
```

# Mount volumes (optionnal)
To add some space to your machines you can add volumes.

Please see [lien](http://www.genouest.org/outils/genostack/volumes.html)

## Docker

From [this](https://forums.docker.com/t/how-do-i-change-the-docker-image-installation-directory/1169)

1) Stop docker: service docker stop. Verify no docker process is running ps faux

2) Double check docker really isn't running. Take a look at the current docker directory: ls /var/lib/docker/

2b) Make a backup - tar -zcC /var/lib docker > /mnt/pd0/var_lib_docker-backup-$(date +%s).tar.gz

3) Move the /var/lib/docker directory to your new partition: mv /var/lib/docker /mnt/pd0/docker

4) Make a symlink: ln -s /mnt/pd0/docker /var/lib/docker

5) Take a peek at the directory structure to make sure it looks like it did before the mv: ls /var/lib/docker/ (note the trailing slash to resolve the symlink)

6) Start docker back up service docker start


## Files 
In case on many users one solution to storage all their data is to use volume
Once your volume mount, you have to move the data and create a symlink
```
mv $GALAXY_ROOT/database/files/ /path/to/your/partition
ln -s /path/to/your/partition $GALAXY_ROOT/database/files/
```
Example
```
mkfs.ext4 /dev/vdb
mount /dev/vdb /home/galaxy/data_Galaxy/
mv $GALAXY_ROOT/database/files/ /home/galaxy/data_Galaxy/
ln -s /home/galaxy/data_Galaxy/files/ $GALAXY_ROOT/database/files/
```


# Security groups
To acces to your machine from the outside you need to open some port



