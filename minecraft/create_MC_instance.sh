#Update
sudo apt update

#upgrade
sudo apt upgrade

# install curl?
sudo apt install curl

# java
sudo apt install openjdk-21-jdk

# minecraft server
curl -OJ https://meta.fabricmc.net/v2/versions/loader/1.21.4/0.16.9/1.0.1/server/jar

# Write Start Server
echo "java -Xmx6G -Xmx6G -jar fabric-server-mc.1.21.4-loader.0.16.9-launcher.1.0.1.jar nogui" > start-server.sh

# First Run
bash start-server.sh

# eula
echo "eula=true" > eula.txt

# modify properties file
#cp -f toserv.properties server.properties

# start server
bash start-server.sh
