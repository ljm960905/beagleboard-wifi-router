#!/bin/bash

# timezone
rm /etc/localtime; ln -s /usr/share/zoneinfo/America/New_York /etc/localtime

#pacman -S hostapd dnsmasq ntpd php

# make backups
cd /etc
mv dnsmasq.conf dnsmasq.conf.dist
cd hostapd
cp hostapd.conf hostapd.conf.dist
cd ../iptables
cp iptables.rules iptables.rules.dist

mkdir /etc/conf.d

# copy config files into places
cd /root/bbsetup/etc
cp systemd/system/* /etc/systemd/system/
cp dnsmasq.conf /etc/
cp conf.d/network\@wlan0 /etc/conf.d/
cp conf.d/network\@wlan1 /etc/conf.d/
cp iptables/iptables.rules /etc/iptables/
cp sysctl.d/30-ipforward.conf /etc/sysctl.d/

# enable ssh
systemctl enable sshd
systemctl start sshd

# start interface
#systemctl enable network\@wlan0
#systemctl start network\@wlan0
#systemctl enable network\@wlan1
#systemctl start network\@wlan1

# start forwarding now. sysctl.d file will trigger on reboot
sysctl net.ipv4.ip_forward=1

# firewall with masquerading
systemctl enable iptables
systemctl start iptables

# enable ntpd
systemctl enable ntpd
systemctl start ntpd

# disable wicd for eth0 ... ifplugd takes care of dhcp on our ethernet port
systemctl stop wicd
systemctl disable wicd

systemctl enable hostapd
systemctl start hostapd

systemctl enable dnsmasq
systemctl start dnsmasq
