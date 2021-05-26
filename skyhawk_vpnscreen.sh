#!/bin/sh

#ssh -O forward -S/home/nathaniel/.ssh/analvpn -R 7168:localhost:22 3.120.37.115 &
#sleep 5

PID=`pidof openvpn`

sudo rm /var/log/openvpn.log

if [ -z "$PID" ]; then
	sudo openvpn --log /var/log/openvpn.log --config /home/nathaniel/keys/flughafen.ovpn &
fi

#sleep 
IP=`sudo grep "ip addr add dev tun0" /var/log/openvpn.log | cperl 'if ($_ =~ /(\d{1,3}\.\d\d{1,3}\.\d{1,3}\.\d{1,3})/) {  print "$1"; }'`

while [ -z "$IP" ]; do
  sleep 1
  IP=`sudo grep "ip addr add dev tun0" /var/log/openvpn.log | cperl 'if ($_ =~ /(\d{1,3}\.\d\d{1,3}\.\d{1,3}\.\d{1,3})/) {  print "$1"; }'`
done

echo $IP > /tmp/ip
scp -i "/home/nathaniel/.ssh/aws.pem" /tmp/ip openvpnas2:/home/nathaniel/log/skyhawk.ip
scp /tmp/ip mx.ewb.ai:/home/nathaniel/log/skyhawk.ip

while [ -n "$IP" ]; do
  sleep 1
done
