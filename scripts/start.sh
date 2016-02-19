#!/bin/bash

wait-for-it.sh localhost:9200 -s -t 30 -- sh /usr/bin/init-openpaas.sh &
elasticsearch -Des.discovery.zen.ping.multicast.enabled=false
