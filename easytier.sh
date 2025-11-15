
#!/bin/bash

ip=$(ip addr show | grep -E 'inet [0-9]' | awk '{print $2}' | awk -F '/' '{print $1}'| grep -v '127.0.0.1' )
echo "IP:$ip"


"HOME/bin/easytier/easytier" --hostname host  -i $ip  -l  ws://0.0.0.0:1102  --network-secret punk.pr.oof.com --no-tun #ws

