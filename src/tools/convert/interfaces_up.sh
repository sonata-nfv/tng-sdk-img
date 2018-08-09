#!/bin/bash

get_ip() {
  interface_ip=`/sbin/ifconfig $1 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}'`
}

get_network() {
  network=`/sbin/route -n | grep 'ens4' | grep '255.255.255.224' | awk '{ print $1}'`
}

get_gateway() {
  first_number=`echo $network | tr "." "\t" | awk '{ print $1"."$2"."$3"."}'`
  last_number=`echo $network | tr "." "\t" | awk '{ print $4}'`
  let last_number++
  gateway=`echo $first_number$last_number`
}

set_route(){
  get_ip $1
  get_network
  get_gateway
  ip route add $network dev $1 src $interface_ip table rt2
  ip route add default via $gateway dev $1 table rt2
  ip rule add from $interface_ip/32 table rt2
  ip rule add to $interface_ip/32 table rt2
  echo "Interface: $1"
  echo "IP: $interface_ip"
  echo "Network: $network"
  echo "Gateway: $gateway"
  ip route list table rt2
}

echo "Setting advanced ip routing"
if [ $# -ne 1 ]; then
  echo "[ERROR] Use $0 interface_name"
  exit 1
else
  set_route $1
fi
