#!/bin/bash

timeout=60;
[ -z "$ELASTICSEARCH_INIT_TIMEOUT" ] || timeout="$ELASTICSEARCH_INIT_TIMEOUT"

wait-for-it.sh localhost:9200 -s -t ${timeout} -- sh /usr/bin/init-openpaas.sh &
elasticsearch -Des.discovery.zen.ping.multicast.enabled=false
