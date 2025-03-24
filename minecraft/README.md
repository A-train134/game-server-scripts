# README

## UFW Configuration
```
sudo ufw allow 25565/tcp
sudo ufw allow 25565/udp
```

## Iptables Configuration
```
sudo iptables -A INPUT -p tcp --dport 25565 -j ACCEPT
sudo iptables -A INPUT -p udp --dport 25565 -j ACCEPT
```
