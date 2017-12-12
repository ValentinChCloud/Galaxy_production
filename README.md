###########################################################################
# Galaxy 17.09 in production, virtual machine on cloud based on Openstack
##	Galaxy
# Create galaxy user
First connect as root user to your new machine, then create a new user galaxy and give root Privileges 

```
ssh root@192.XXX.XXX.XX

adduser galaxy
# Choose password

# edit the sudoers file, to give galaxy root privileges
# add galaxy ALL=(ALL:ALL) ALL
visudo
```

Now use the script galaxy_install.sh 
```
cd $HOME
bash galaxy_install.sh
```
This script install : galaxy, docker, npm, node and nginx. For the last one an sample file is provided, you have to replace all the ip adress
ofyour machine. Quickly you can get it with
```
hostname -I
```
get the first one.
Otherwise, it's given on your user Openstack interface

You should downgrade node version , because galaxy work only with <0.11
```
		#Add this to your .bashrc
		export NVM_DIR="$HOME/.nvm"
		[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm
		
		#Then execute
		nvm install 0.10
		nvm use 0.10
        cd $GALAXY_ROOT/lib/galaxy/web/proxy/js && npm install
```
##	Tolshed
###########################################################################
# Toolshed
It's commanded to install your toolshed on another machine.
Same steps for galaxy 
```
ssh root@192.XXX.XXX.XX

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
```

```
2- #database_connection = sqlite:///./database/community.sqlite?isolation_level=IMMEDIATE
	As galaxy replace as follow  database_connection = postgresql://toolshed:toolshed@192.XXX.XXX.XX:5432/toolshed
	Please refer to this ::: postgresql://username:password@localhost/mydatabase
	localhost is the adress of the machine where yout postgresql server is runing
###########################################################################
# PostgreSQL
## Galaxy database
# Start a new machine, connect ,change root password, add user, install postgreSql and create user and database galaxy
```
ssh root@192.XXX.XXX.XX
passwd root
adduser galaxy
apt-get update

apt-get install -y postgresql postgresql-contrib
sudo -u postgres createuser --interactive
sudo -u galaxy createdb galaxy
```
Now you have to give database acces to your galaxy server. You have to add  in `/etc/postgresql/9.5/main/pg_hba.conf` :
`
#Type of connection		#Database		#User			#Adress							#Option connection ( don't need password in this case)

host    				galaxy          galaxy          192.XXX.XXX.XX/32               trust
`
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
 After that you have to change in galaxy.ini
 ```
 #database_connection = sqlite:///./database/universe.sqlite?isolation_level=IMMEDIATE
 ```
 to
  ```
 database_connection = postgresql://galaxy:galaxy@192.XXX.XXX.XX:5432/galaxy
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
host    				galaxy          galaxy          192.XXX.XXX.XX/32               trust

And after that you have to specifiy than postgresql should accepte request from your galaxy server.

`listen_addresses = 'localhost' -> '192.XXX.XXX.XX'`

or

`listen_addresses = 'localhost' -> '*' `

for all

and restart the server

`  /etc/init.d/postgresql restart`


###########################################################################
# Galaxy interactive environnements : Docker

You can have your Docker server and the Docker server on the same machine. It could be interesting in one case to launch your container on 
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

adduser docker
# Choose password

# edit the sudoers file, to give galaxy root privileges
# add docker ALL=(ALL:ALL) ALL
visudo
```
