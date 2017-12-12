###########################################################################
# Galaxy 17.09 in production, virtual machine on cloud based on Openstack

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


###########################################################################
# PostgreSQL
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
Now you have to give database acces to your galaxy server. You have too add  in /etc/postgresql/9.5/main/pg_hba.conf :
#Type of connection		#Database		#User			#Adress							#Option connection ( don't need password in this case)
host    				galaxy          galaxy          192.XXX.XXX.XX/32               trust

And after that you have to specifiy than postgresql should accepte request from your galaxy server.

listen_addresses = 'localhost' -> '192.XXX.XXX.XX'
or
listen_addresses = 'localhost' -> '*' 
for all

and
  /etc/init.d/postgresql restart
  
 After that you have to change in galaxy.ini
 ```
 #database_connection = sqlite:///./database/universe.sqlite?isolation_level=IMMEDIATE
 ```
 to
  ```
 database_connection = postgresql://galaxy:galaxy@192.XXX.XXX.XX:5432/galaxy
 ```
 Please refer to this ::: postgresql://username:password@localhost/mydatabase
 localhost is the adress of the machine where yout postgresql server is runing 
###########################################################################
# Toolshed
Now 

