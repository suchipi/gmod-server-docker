#!/bin/sh
unionfs-fuse -o cow /gmod-volume=RW:/gmod-base=RO /gmod-union
${MAXPLAYERS:=8}
${MAP:=gm_construct}
while true; do
/gmod-union/srcds_run -game garrysmod +maxplayers $MAXPLAYERS ${ARGS} +map $MAP
done

