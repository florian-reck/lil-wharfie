#!/bin/bash -e
ip link add pubnet-shim link eth0 type macvlan  mode bridge
ip addr add 192.168.178.254/32 dev pubnet-shim
ip link set pubnet-shim up
ip route add 192.168.178.252/30 dev pubnet-shim
ip route add 192.168.178.253/30 dev pubnet-shim
