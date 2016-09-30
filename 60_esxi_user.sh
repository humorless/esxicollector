#!/bin/bash
community=$1
host=$2
version="2c"


date=$(date +%s)
process=$(snmpbulkwalk -v $version -c $community $host 1.3.6.1.2.1.25.1.6.0)
user=$(snmpbulkwalk -v $version -c $community $host 1.3.6.1.2.1.25.1.5.0)
VmGuestState=$(snmpbulkwalk -v $version -c $community $host 1.3.6.1.4.1.6876.2.1.1.8)
numOfVhost=$(echo $VmGuestState|wc -l)

echo "["
value=$(echo $process | awk -F= '{print $2}' | awk -F: '{print $2}')
value=$(echo $value | xargs) #trim the white space
echo "{\
    \"endpoint\"   : \"$host\",\
    \"tags\"       : \"\",\
    \"timestamp\"  : $date,\
    \"metric\"     : \"esxi.current.process\",\
    \"value\"      : $value,\
    \"counterType\": \"GAUGE\",\
    \"step\"       : 60}"
value=$(echo $user | awk -F= '{print $2}' | awk -F: '{print $2}')
value=$(echo $value | xargs) #trim the white space
echo ",{\
    \"endpoint\"   : \"$host\",\
    \"tags\"       : \"\",\
    \"timestamp\"  : $date,\
    \"metric\"     : \"esxi.current.user\",\
    \"value\"      : $value,\
    \"counterType\": \"GAUGE\",\
    \"step\"       : 60}"
echo ",{\
    \"endpoint\"   : \"$host\",\
    \"tags\"       : \"\",\
    \"timestamp\"  : $date,\
    \"metric\"     : \"esxi.current.vhost\",\
    \"value\"      : $numOfVhost,\
    \"counterType\": \"GAUGE\",\
    \"step\"       : 60}"

echo "]"

