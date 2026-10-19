# Redis on Render

This is an example repo with a Dockerfile for running a Redis cache with persistence as a **private service** on Render.

Render private services are only visible to other Render services in your account. They have internal URLs (e.g. `redis:6379`), can speak any protocol (like [RESP](https://redis.io/topics/protocol)), and can listen on any port.

Backing Redis with a disk makes it resilient to data loss in the case of restarts or deploys, and Render makes this easy to do with Render Disks.

## Deployment

### One Click Deploy

Use the button below to deploy a persistent Redis instance on Render.

[![Deploy to Render](http://render.com/images/deploy-to-render-button.svg)](https://render.com/deploy)

### Manual Deployment

1. Select **New Private Service** on your Render dashboard and use your fork of this repo to create the service.

2. Make sure the `Environment` is set to `Docker`, and enter a name for the service (this will be used to generate the private URL). 

3. Add a new disk in the `Advanced` section. Give it a name and set the mount path to `/var/lib/redis`. You can also change the default size for your disk: `1 GB` should be enough for small projects.

Click `Save` and you're good to go! Once deployed, your Redis instance will be available on a URL similar to `redis:10000`, and you can start using your Redis URL from other services in your Render account. Be sure to prepend `redis://` to the URL displayed in your dashboard.

If you need help, you can always chat with us at https://render.com/chat.


## eventpoll4 (EventMoot) configuration

This fork runs Redis 7.4 for eventpoll4. `redis.conf` keeps data on the Render disk at `/var/lib/redis` (append-only file plus snapshots), listens on 6379, and uses `maxmemory 256mb` with `noeviction` (BullMQ needs it).

The Render service has a Docker Command (`redis-server --port 6379 ...`) that replaces the image's entrypoint. `redis-server-wrapper.sh`, installed as `/usr/local/sbin/redis-server`, makes any such command load `redis.conf` first. Flags on the command still override it. Without it, Redis ran on built-in defaults and lost all data on every restart until 2026-10.

Pushing to `master` deploys (Render auto-deploy). A deploy restarts Redis. After one, restart eventpoll4 too: it re-registers its BullMQ job schedulers at startup.
