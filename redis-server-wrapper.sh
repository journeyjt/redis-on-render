#!/bin/sh
# Always load the config file, then any flags (see Dockerfile).
exec /usr/local/bin/redis-server /usr/local/etc/redis/redis.conf "$@"
