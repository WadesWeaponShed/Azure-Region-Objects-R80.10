#!/bin/bash
_input="$1"
grpname=$(echo "$1" | cut -f 1 -d '-')
# set IFS (internal field separator) to |
# read file using while loop
while IFS='/' read -r ip netmask
do
printf "mgmt_cli -s id.txt --port 4434 add network name Azure-$grpname-$ip subnet $ip mask-length $netmask groups Azure-$grpname\n";
done < "$_input"
