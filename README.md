# esxicollector
The scripts that can collect data from VMware ESXi system through SNMP protocol in open-falcon json format

# Why use esxicollector?

You have a dedicated server with VMware ESXi operating system and you want to monitor the snmp information through open-falcon. 
Then you will need some scripts that can translate the snmp OIDs information into certain metric in json-format. 

# How to use it?

	1. Install SNMP command.
		``` yum -y install net-snmp net-snmp-utils ```
	2. Download VMware ESXi MIB files and copy all the mibs files to directory like ```/usr/share/snmp/mibs```
	3. Setup SNMP config
		``` mkdir ~/.snmp ```
                ``` echo "mibs +ALL" > ~/.snmp/snmp.conf ```
        4. Fill proper content into the variables in `exsi_collector.sh`
        5. Setup cronjobs
                ``` * * * * * exsi_collector.sh ```
	
