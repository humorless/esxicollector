#!/bin/bash
community=$1
host=$2
version="2c"


date=$(date +%s)
count=0
list=$(snmpbulkwalk -v $version -c $community $host ifName)
listUcast=$(snmpbulkwalk -v $version -c $community $host ifHCInUcastPkts)
listMulticast=$(snmpbulkwalk -v $version -c $community $host ifHCInMulticastPkts)
listBroadcast=$(snmpbulkwalk -v $version -c $community $host ifHCInBroadcastPkts)


echo "["
while read -r line; do
	if (($count != 0)); then
		echo -n ","
	fi

        num=$((count+1))
	inner=$(echo "$listUcast" | sed "${num}q;d")
	index=$(echo $line | awk -F= '{print $2}' | awk -F: '{print $2}')
	index=$(echo $index | xargs) #trim the white space
	value=$(echo $inner | awk -F= '{print $2}' | awk -F: '{print $2}' )
	value=$(echo $value | xargs) #trim the white space
	echo "{\
	    \"endpoint\"   : \"$host\",\
	    \"tags\"       : \"iface=$index\",\
	    \"timestamp\"  : $date,\
	    \"metric\"     : \"esxi.net.in.ucast.pkts\",\
	    \"value\"      : $value,\
	    \"counterType\": \"COUNTER\",\
	    \"step\"       : 60}"

	inner=$(echo "$listMulticast"| sed "${num}q;d")
	index=$(echo $line | awk -F= '{print $2}' | awk -F: '{print $2}')
	index=$(echo $index | xargs) #trim the white space
	value=$(echo $inner | awk -F= '{print $2}' | awk -F: '{print $2}')
	value=$(echo $value | xargs) #trim the white space
	echo ",{\
	    \"endpoint\"   : \"$host\",\
	    \"tags\"       : \"iface=$index\",\
	    \"timestamp\"  : $date,\
	    \"metric\"     : \"esxi.net.in.multicast.pkts\",\
	    \"value\"      : $value,\
	    \"counterType\": \"COUNTER\",\
	    \"step\"       : 60}"

	inner=$(echo "$listBroadcast" | sed "${num}q;d")
	index=$(echo $line | awk -F= '{print $2}' | awk -F: '{print $2}')
	index=$(echo $index | xargs) #trim the white space
	value=$(echo $inner | awk -F= '{print $2}' | awk -F: '{print $2}')
	value=$(echo $value | xargs) #trim the white space
	echo ",{\
	    \"endpoint\"   : \"$host\",\
	    \"tags\"       : \"iface=$index\",\
	    \"timestamp\"  : $date,\
	    \"metric\"     : \"esxi.net.in.broadcast.pkts\",\
	    \"value\"      : $value,\
	    \"counterType\": \"COUNTER\",\
	    \"step\"       : 60}"

        count=$((count+1))
done <<< "$list"

echo "]"

