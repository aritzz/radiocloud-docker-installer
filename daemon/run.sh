#!/bin/bash
while true; do
	sleep 120
	pidof rc-daemon >/dev/null
	if [[ $? -ne 0 ]] ; then
	        echo "RC daemon starting:     $(date)" > /uplog.txt
	        ./rc-daemon
	fi
done
