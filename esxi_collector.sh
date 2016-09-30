#!/bin/bash

# workdir refers to the directory where 60_esxi_*.sh scripts reside. 
workdir=.
# community refers to the "community string" in snmpcmd
community="COMMUNITY_STRING"
# targets refers to the "AGENT" array in snmpcmd 
targets=( example1.com example2.com )
# httpprex refers to the open-falcon agent that can receive json.
httpprex=127.0.0.1:1988

for host in "${targets[@]}"
do 
	curl -s -X POST -d "$($workdir/60_esxi_cpu.sh $community "${host}" | python -m json.tool)" "$httpprex/api/push" &
	curl -s -X POST -d "$($workdir/60_esxi_df.sh $community "${host}" | python -m json.tool)" "$httpprex/api/push" &
	curl -s -X POST -d "$($workdir/60_esxi_disk.sh $community "${host}" | python -m json.tool)" "$httpprex/api/push" &
	curl -s -X POST -d "$($workdir/60_esxi_if_in.sh $community "${host}" | python -m json.tool)" "$httpprex/api/push" &
	curl -s -X POST -d "$($workdir/60_esxi_if_out.sh $community "${host}" | python -m json.tool)" "$httpprex/api/push" &
	curl -s -X POST -d "$($workdir/60_esxi_memory.sh $community "${host}" | python -m json.tool)" "$httpprex/api/push" &
	curl -s -X POST -d "$($workdir/60_esxi_user.sh $community "${host}" | python -m json.tool)" "$httpprex/api/push" &
done

