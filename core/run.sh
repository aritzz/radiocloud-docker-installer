#!/bin/bash
while true; do
	pidof radiocore >/dev/null
	if [[ $? -ne 0 ]] ; then
	        echo "Radiocore starting:     $(date)" > /uplog.txt
	        /radiocore/bin/radiocore /radiocore/bin/radiocore.conf
	fi
	sleep 600
done
