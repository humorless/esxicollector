#!/bin/bash
community=$1
host=$2
version="2c"


date=$(date +%s)
count=0
list=$(snmpdf -v $version -c $community $host)


echo "["
while read -r line; do
	if (($count != 0)); then
		if (($count > 1)); then
			echo -n ","
		fi

		index=$(echo $line | awk  '{print $1}')
		index=$(echo $index | xargs) #trim the white space
		size=$(echo $line | awk  '{print $2}')
		size=$(echo $size | xargs) #trim the white space
		used=$(echo $line | awk  '{print $5}')
		used=$(echo $used | xargs -d% | xargs) #trim the white space
		echo "{\
		    \"endpoint\"   : \"$host\",\
		    \"tags\"       : \"mount=$index\",\
		    \"timestamp\"  : $date,\
		    \"metric\"     : \"esxi.df.size.kilobytes\",\
		    \"value\"      : $size,\
		    \"counterType\": \"GAUGE\",\
		    \"step\"       : 60}"
		echo ",{\
		    \"endpoint\"   : \"$host\",\
		    \"tags\"       : \"mount=$index\",\
		    \"timestamp\"  : $date,\
		    \"metric\"     : \"esxi.df.used.percentage\",\
		    \"value\"      : $used,\
		    \"counterType\": \"GAUGE\",\
		    \"step\"       : 60}"
	fi
        count=$((count+1))
done <<< "$list"

echo "]"

