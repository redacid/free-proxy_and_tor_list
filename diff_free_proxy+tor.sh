#!/bin/sh

logfile="access.log"

wget -q -O - "https://github.com/fate0/proxylist/raw/master/proxy.list" | grep -Eo '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | sort -u > free_proxy_list.txt
wget -q -O - "https://check.torproject.org/exit-addresses" | grep -E "([0-9]{1,3}\.){3}[0-9]{1,3}" | cut -d " " -f2 | sort -u > tor_list.txt

cat free_proxy_list.txt tor_list.txt | sort -u | egrep -v "^10\.|^127\.|^192\.168\.|^172\.1[6789]\.|^172\.2[0-9]\.|^172\.3[01]\." > free_proxy_list_tor.txt

cat $logfile | cut -d " " -f1 | sort | uniq > list_fplt.txt

for SUBNET in `cat list_fplt.txt | diff free_proxy_list_tor.txt - | grep -E "([0-9]{1,3}\.){3}[0-9]{1,3}" | grep "<" | cut -f 2 -d " " ` ; do
        echo $SUBNET >> tmpfplt.txt
done

diff tmpfplt.txt free_proxy_list_tor.txt | grep ">" | cut -d " " -f2 > result_fplt.txt

rm tmpfplt.txt
rm list_fplt.txt
rm free_proxy_list.txt
rm tor_list.txt
#rm free_proxy_list_tor.txt

cat $logfile | cut -d " " -f1 | sort | uniq -c > countlist_fplt.txt

for SUBNET in `cat result_fplt.txt` ; do
        cat countlist_fplt.txt | grep $SUBNET
done
