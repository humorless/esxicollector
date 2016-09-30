#!/bin/bash

community="COMMUNITY_STRING"
host="example.com"
version="2c"
snmpbulkwalk="snmpbulkwalk"
snmpdf="snmpdf"
snmpnetstat="snmpnetstat"
snmptable="snmptable"

# hrProcesssorLoad
echo "show cpu load: value 0~32"
snmpbulkwalk -v $version -c $community $host .1.3.6.1.2.1.25.3.3.1.2

# HOST-RESOURCES-MIB::hrSystemProcesses.0
echo "show system process:"
snmpbulkwalk -v $version -c $community $host 1.3.6.1.2.1.25.1.6.0

# vmwMemory
echo "show memory details:"
snmpbulkwalk -v $version -c $community $host 1.3.6.1.4.1.6876.3.2

# HOST-RESOURCES-MIB::hrStorageAllocationFailures
echo "show disk failures: if not equal 0, there is disk failures"
snmpbulkwalk -v $version -c $community $host .1.3.6.1.2.1.25.2.3.1.7

echo "show df"
snmpdf -v $version -c $community $host

echo "show netstat"
snmpnetstat -v $version -Ci -c $community $host

# vmwVmTable
echo "show number of VMs"
snmptable -v $version -c $community $host  1.3.6.1.4.1.6876.2.1

# HOST-RESOURCES-MIB::hrSystemNumUsers.0
echo "show number of Logged users"
snmpbulkwalk -v $version -c $community $host 1.3.6.1.2.1.25.1.5.0
