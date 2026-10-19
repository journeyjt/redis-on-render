FROM redis:7.4-alpine

# Render's service runs a Docker Command (`redis-server --port 6379 ...`) that
# replaces the image's entrypoint, so a config file passed there was never
# read. The wrapper below shadows redis-server on PATH (/usr/local/sbin comes
# before /usr/local/bin), so whatever starts Redis loads redis.conf first;
# flags on the command line still override it.
COPY redis.conf /usr/local/etc/redis/redis.conf
COPY redis-server-wrapper.sh /usr/local/sbin/redis-server
RUN chmod +x /usr/local/sbin/redis-server && mkdir -p /var/lib/redis

ENTRYPOINT ["redis-server"]
