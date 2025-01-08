
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
