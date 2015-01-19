#!/bin/sh
unionfs-fuse -o cow /gmod-volume=RW:/gmod-base=RO /gmod-union
while true; do
/gmod-union/srcds_run -game garrysmod +maxplayers ${MAXPLAYERS:=16} +hostname ${G_HOSTNAME:="Miniserver"} +gamemode ${GAMEMODE:=sandbox} "${ARGS}" +map ${MAP:=gm_construct}
done

