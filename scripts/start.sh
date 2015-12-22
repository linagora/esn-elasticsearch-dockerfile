#!/bin/bash

sh -c "sleep 20; /usr/bin/initRiver.sh" &
elasticsearch -Des.discovery.zen.ping.multicast.enabled=false
