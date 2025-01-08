# game-server-scripts
- A List of simple bash scripts that create and run basic Game Servers. 
- These Scripts were thrown together to test incus containers. 
- No guarantee these scripts will work on other systems. 


## Current Scripts
- Minecraft
- Project Zomboid



## Minecraft
```bash
#Update
sudo apt update

#upgrade
#sudo apt upgrade

# install curl?
sudo apt install curl

# java
sudo apt install openjdk-21-jdk

# minecraft server -- Modify to latest version
curl -OJ https://meta.fabricmc.net/v2/versions/loader/1.21.4/0.16.9/1.0.1/server/jar

# Write Start Server -- always use 6G of memory
echo "java -Xmx6G -Xmx6G -jar fabric-server-mc.1.21.4-loader.0.16.9-launcher.1.0.1.jar nogui" > start-server.sh

# First Run
bash start-server.sh

# eula
echo "eula=true" > eula.txt

# modify properties file
#cp -f toserv.properties server.properties

# start server
bash start-server.sh

```


## Project Zomboid
URL: (https://pzwiki.net/wiki/Dedicated_server)

```bash

#update
sudo apt -y update

#upgrade
# sudo apt -y upgrade

# get multiverse repository
sudo add-apt-repository multiverse
sudo dpkg --add-architecture i386
sudo apt update

# install steamcmd
sudo apt install steamcmd

#enable non-free repository if neccessary
#sudo apt-get install software-properties-common -y
#sudo apt-add-repository non-free

# No need to adduser - in container

# install server in /opt/pzserver
sudo mkdir /opt/pzserver
sudo chown ubuntu:ubuntu /opt/pzserver

# create update_zomboid
cat >$HOME/update_zomboid.txt <<'EOL'
// update_zomboid.txt
//
@ShutdownOnFailedCommand 1 //set to 0 if updating multiple servers at once
@NoPromptForPassword 1
force_install_dir /opt/pzserver/
//for servers which don't need a login
login anonymous
app_update 380870 validate
quit
EOL

# export route and run update_zomboid
export PATH=$PATH:/usr/games
steamcmd +runscript $HOME/update_zomboid.txt

# After running all these commands, cd to /opt/pzserver
# run the server with "bash start-server.sh"
# quit the server, than configure the systemd unit and socket

```

### To Create the Systemd Unit
##### Systemd unit

```bash
cat >/etc/systemd/system/zomboid.service <<'EOL'
[Unit]
Description=Project Zomboid Server
After=network.target

[Service]
PrivateTmp=true
Type=simple
User=pzuser
WorkingDirectory=/opt/pzserver/
ExecStart=/bin/sh -c "exec /opt/pzserver/start-server.sh </opt/pzserver/zomboid.control"
ExecStop=/bin/sh -c "echo save > /opt/pzserver/zomboid.control; sleep 15; echo quit > /opt/pzserver/zomboid.control"
Sockets=zomboid.socket
KillSignal=SIGCONT

[Install]
WantedBy=multi-user.target
EOL
```

#### Zomboid Socket
```bash
cat >/etc/systemd/system/zomboid.socket <<'EOL'
[Unit]
BindsTo=zomboid.service

[Socket]
ListenFIFO=/opt/pzserver/zomboid.control
FileDescriptorName=control
RemoveOnStop=true
SocketMode=0660
SocketUser=pzuser

EOL
```