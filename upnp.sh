#!/bin/bash

# will be returned by wget in case of successful connection
WGET_SUCCESS_CODE=0
# will be returned by wget for connection problems not handled by it's retry mechanism
NETWORK_FAILURE_CODE=4
# timeout for custom retry mechanism in case of network failure described above, seconds
NETWORK_FAILURE_TIMEOUT=20
# relative time when custom retryies will be stopped
END_TIME=$(( SECONDS + NETWORK_FAILURE_TIMEOUT ))

while
    wget -q --retry-connrefused --waitretry=2 --tries=20 --spider https://www.duckdns.org && break
    [[ $? -eq $NETWORK_FAILURE_CODE && $SECONDS -lt $END_TIME ]] # loop continue condition
do
    continue
done

if [ $? -eq $WGET_SUCCESS_CODE ]; then
    wget -q https://www.duckdns.org/update/jsh-hub1/cc8cc1f9-bac1-4144-9a60-5aba19417328 > /dev/null
    upnpc -e 'SSH on Raspberry Pi' -r 22 TCP > /dev/null
    upnpc -e 'HTTP Raspberry Pi' -r 80 TCP > /dev/null
fi
