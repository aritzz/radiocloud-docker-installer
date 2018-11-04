#!/bin/bash
while true; do
	sleep 120
	pidof radiocore >/dev/null
	if [[ $? -ne 0 ]] ; then
	        echo "Radiocore starting:     $(date)" > /uplog.txt
	        /radiocore/bin/radiocore /radiocore/bin/radiocore.conf
	fi
done
