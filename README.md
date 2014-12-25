gmod-server-docker
==================

This is a set of Dockerfile and scripts that will create a container that runs a [Garry's Mod](http://www.garrysmod.com/) Server. 

The container uses [unionfs-fuse](https://github.com/rpodgorny/unionfs-fuse) to make a union filesystem layering `/gmod-volume` over `/gmod-base`, where the server is installed. 
`/gmod-volume` is exposed as a docker volume. 
This allows you to customize the server and/or run multiple servers with different configs without needing a copy of the (~3GB) base server for each one. 
Any file you put in `/gmod-volume` will override the files in `/gmod-base`, and attempting to write to any file in `/gmod-base` that doesn't exist in `/gmod-volume` will instead copy it to `/gmod-volume` and make the changes there (Copy-On-Write). 
You can also create a `start-server.sh` in the volume to customize what happens when the server is started (for instance, you may want to automatically update it, or use a more sophisticated crash detection system).

#### Notes/Todo
Everything *appears* to be working right now, but I'm having trouble connecting to the server after it's started. I'm not sure if the Source Engine uses more ports than its documented 27015 for inbound connections (I didn't think it did?)

Also, right now the container needs to be run with `--privileged=true` for fuse to work, but this gives more permissions to the container than are necessary. I should figure out which options are actually needed and use docker's `-o` switch instead.

I might also rewrite this in the future to be a game-agnostic Source Engine server container, with facilitation for mounting content. But first I want to get this implementation working.

The Source Engine doesn't seem to find out which port it's *actually* running on, so it tells the master servers that it's running on 27015 (or whatever `-port` you specified at runtime) even if you assign with `-p` dynamically. I've explored several potential solutions to this but the bottom line is that the Source Engine Dedicated Server wasn't really set up with this type of NATing in mind (or maybe, for that matter, any type of NAT). If you want this piece to work properly, you should probably just use the same port on the docker host as within the container.

`build.sh` and `run.sh` are just convenience scripts; they aren't used by the build process.
