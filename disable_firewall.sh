#!/bin/bash

# Setup IPTABLES to block all internet traffic, except the DOMJudge servers and IP printers, and ssh in
iptables -F
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT
#iptables-save > /etc/iptables/rules.v4

ip6tables -F
ip6tables -P INPUT ACCEPT
ip6tables -P FORWARD ACCEPT
ip6tables -P OUTPUT ACCEPT
#ip6tables-save > /etc/iptables/rules.v6
