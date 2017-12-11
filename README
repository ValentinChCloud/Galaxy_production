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
  
###########################################################################

