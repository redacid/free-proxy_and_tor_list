#!/bin/sh

wget -q -O - "https://github.com/fate0/proxylist/raw/master/proxy.list" | grep -Eo '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | sort -u > free_proxy_list.txt
wget -q -O - "https://check.torproject.org/exit-addresses" | grep -Eo "([0-9]{1,3}\.){3}[0-9]{1,3}" | cut -d " " -f2 | sort -u > tor_list.txt

cat free_proxy_list.txt tor_list.txt | sort -u | egrep -v "^10\.|^127\.|^192\.168\.|^172\.1[6789]\.|^172\.2[0-9]\.|^172\.3[01]\." > free_proxy_list_tor.txt
