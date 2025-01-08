## Systemd unit

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


## Zomboid Socket
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
