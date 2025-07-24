#!/bin/sh
set -e

# Stack launch
docker-compose -f hawkbit_monolith_mysql_fixed.yml up -d
