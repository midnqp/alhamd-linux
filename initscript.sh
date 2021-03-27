#!/bin/bash
systemctl unmask cpufreqd.service &
systemctl unmask loadcpufreq.service   & 
systemctl unmask cpufrequtils.service &
cpufreq-set -c 1 -d 1600000 -u 2100000 -g performance &               
cpufreq-set -c 0 -d 1600000 -u 2100000 -g performance & 

rfkill block all &
rfkill unblock all  &
systemctl unmask NetworkManager &
systemctl start NetworkManager &
sleep 15 &
systemctl mask NetworkManager  &

systemctl mask cpufreqd.service  &
systemctl mask loadcpufreq.service  &
systemctl mask cpufrequtils.service &
systemctl disable cpufrequtils.service &
