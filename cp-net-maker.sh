#!/bin/bash
_input="$1"
grpname=$(echo "$1" | cut -f 1 -d '.')
# set IFS (internal field separator) to |
# read file using while loop
while IFS=' ' read -r objname ip netmask
do
printf "mgmt_cli -s id.txt add network name $objname subnet $ip subnet-mask $netmask groups $grpname\n";
done < "$_input"
