#!/bin/bash

echo "OpenPaaS :: Creating Indexes"
sh /opt/openpaas/config/scripts/create-indexes.sh

echo "OpenPaaS :: Creating Rivers"
sh /usr/bin/init-rivers.sh
