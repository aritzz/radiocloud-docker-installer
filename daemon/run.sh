#!/bin/bash
while true; do
	pidof rc-daemon >/dev/null
	if [[ $? -ne 0 ]] ; then
	        echo "RC daemon starting:     $(date)" > /uplog.txt
	        ./rc-daemon
	fi
	sleep 600
done
