#!/bin/sh
unionfs-fuse -o cow /gmod-volume=RW:/gmod-base=RO /gmod-union
while true; do
/gmod-union/srcds_run -game garrysmod +host_workshop_collection ${COLLECTION_ID} -authkey ${STEAM_WEB_KEY} +maxplayers ${MAXPLAYERS:=16} +hostname ${HOSTNAME} "${ARGS}" +gamemode ${GAMEMODE} +map ${MAP}
done
