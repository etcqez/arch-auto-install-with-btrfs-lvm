#!/bin/sh
set -ue

systemctl stop reflector.service
ping -c 2 baidu.com
timedatectl set-ntp true #将系统时间与网络时间进行同步
timedatectl status       #检查服务状态
echo init succes
