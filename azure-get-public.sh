### Get Region Names ###
curl_cli --insecure https://download.microsoft.com/download/7/1/D/71D86715-5596-4529-9B13-DA13A5DE5B63/ServiceTags_Public_20200622.json --output azure.json
cat azure.json |jq --raw-output '.values[] | .name' >region_names.txt

## Build Region IP Files ##
while read RegionName
 do
  echo "$RegionName Files"
  cat azure.json |jq --raw-output --arg v "$RegionName" '.values[] | select(.name==$v) | .properties.addressPrefixes[]' >$RegionName-ip.txt; ./cp-net-maker.sh $RegionName-ip.txt > $RegionName-import.txt
done <region_names.txt

##Create Clean Import Files##
rm *-ip.txt
for i in *-import.txt;
  do
    groupname=$(echo "$i" | cut -f 1 -d '-')
    echo -e "mgmt_cli -r true login > id.txt\nmgmt_cli -s id.txt add group name $groupname " | cat - $i > temp && mv temp $i
    echo "mgmt_cli -s id.txt publish" >> $i
    echo "mgmt_cli -s id.txt logout" >> $i
    chmod +x $i
done
