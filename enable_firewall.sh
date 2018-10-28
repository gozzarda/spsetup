#!/bin/bash

# Setup IPTABLES to block all internet traffic, except the DOMJudge servers and IP printers
iptables -F
iptables -P INPUT DROP
iptables -P FORWARD ACCEPT
iptables -P OUTPUT DROP
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT
iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
# contest.sppregional.org
iptables -A OUTPUT -d 192.254.188.84/32 -p tcp -m tcp --dport 80 -j ACCEPT
# DOMjudge
iptables -A OUTPUT -d 167.99.29.149/32 -p tcp -m tcp --dport 80 -j ACCEPT
# Backup DOMjudge
iptables -A OUTPUT -d 174.138.121.10/32 -p tcp -m tcp --dport 80 -j ACCEPT
iptables-save > /etc/iptables/rules.v4

ip6tables -F
ip6tables -P INPUT DROP
ip6tables -P FORWARD DROP
ip6tables -P OUTPUT DROP
ip6tables-save > /etc/iptables/rules.v6
