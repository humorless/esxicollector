#!/bin/bash
community=$1
host=$2
version="2c"


date=$(date +%s)
echo "["
count=0
list=$(snmpbulkwalk -v $version -c $community $host .1.3.6.1.2.1.25.2.3.1.7)

while read -r line; do
        if (($count != 0)); then
           echo -n ","
        fi

        index=$(echo $line | awk -F= '{print $1}' | awk -F. '{print $2}')
        index=$(echo $index | xargs) #trim the white space
        value=$(echo $line | awk -F= '{print $2}' | awk -F: '{print $2}')
        value=$(echo $value | xargs) #trim the white space
        echo "{\
            \"endpoint\"   : \"$host\",\
            \"tags\"       : \"$index\",\
            \"timestamp\"  : $date,\
            \"metric\"     : \"esxi.disk.allocationfailure\",\
            \"value\"      : $value,\
            \"counterType\": \"GAUGE\",\
            \"step\"       : 60}"
        count=$((count+1))
done <<< "$list"

echo "]"

