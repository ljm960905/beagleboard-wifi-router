#!/bin/bash

# timezone
rm /etc/localtime; ln -s /usr/share/zoneinfo/America/New_York /etc/localtime

mkdir /etc/conf.d

# copy config files into places
cd /root/bbsetup/etc
cp systemd/system/* /etc/systemd/system/
cp dhcpd.conf /etc/
cp hostapd/hostapd.conf /etc/hostapd/
cp conf.d/network\@wlan0 /etc/conf.d/
cp iptables/iptables.rules /etc/iptables/
cp sysctl.d/30-ipforward.conf /etc/sysctl.d/

# enable ssh
systemctl enable sshd
systemctl start sshd

# start macspoofing
systemctl enable macspoof
systemctl start macspoof

# start interface
systemctl enable network\@wlan0
systemctl start network\@wlan0

# start forwarding now. sysctl.d file will trigger on reboot
sysctl net.ipv4.ip_forward=1

# firewall with masquerading
systemctl enable iptables
systemctl start iptables

# enable ntpd
systemctl enable ntpd
systemctl start ntpd

# disable wicd for eth0 ... ifplugd takes care of dhcp on our ethernet port

# enable dhcpd4
systemctl enable dhcpd4@wlan0
systemctl start dhcpd4@wlan0

systemctl enable hostapd
systemctl start hostapd
