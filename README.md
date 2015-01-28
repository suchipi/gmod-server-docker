gmod-server-docker
==================

This is a set of Dockerfile and scripts that will create a container that runs a [Garry's Mod](http://www.garrysmod.com/) Server. 

The container optionally uses [unionfs-fuse](https://github.com/rpodgorny/unionfs-fuse) to make a union filesystem layering `/gmod-volume` over `/gmod-base`, where the server is installed. 
`/gmod-volume` is exposed as a docker volume. 
This allows you to customize the server and/or run multiple servers with different configs without needing a copy of the (~3GB) base server for each one. 
Any file you put in `/gmod-volume` will override the files in `/gmod-base`, and attempting to write to any file in `/gmod-base` that doesn't exist in `/gmod-volume` will instead copy it to `/gmod-volume` and make the changes there (Copy-On-Write). 
You can also create a `start-server.sh` in the volume to customize what happens when the server is started (for instance, you may want to automatically update it, or use a more sophisticated crash detection system).

Using unionfs-fuse requires the container to be run with `--privileged=true` and the environment variable `UNION` to be set. 

#### Examples

Start a server on port 27015 without using the union filesystem:

`docker run -d -p 27015:27015/udp suchipi/gmod-server`

Start a server on an automatically allocated port, mounting the contents of /home/srcds/gmod-1 over the internal base:

`docker run --privileged=true -d -P -e UNION=1 -v /home/srcds/gmod-1:/gmod-volume suchipi/gmod-server`


#### Notes/Todo
You can set the environment variables MAXPLAYERS, MAP, GAMEMODE, G_HOSTNAME, and ARGS to change the startup arguments to the srcds_run command. For example:

`docker run -d -P -e MAXPLAYERS=32 -e MAP=gm_flatgrass -e GAMEMODE=my_cool_gamemode -e G_HOSTNAME="My awesome gmod server" -e ARGS="-insecure +exec something.cfg" suchipi/gmod-server`

The Source Engine doesn't seem to find out which port it's *actually* running on, so it tells the master servers that it's running on 27015 (or whatever `-port` you specified at runtime) even if you assign with `-p` dynamically. I've explored several potential solutions to this but the bottom line is that the Source Engine Dedicated Server wasn't really set up with this type of NATing in mind (or maybe, for that matter, any type of NAT). If you want this piece to work properly, you should probably just use the same port on the docker host as within the container.

`build.sh` and `run.sh` are just convenience scripts; they aren't used by the Dockerfile.
