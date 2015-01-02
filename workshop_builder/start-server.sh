#!/bin/sh
echo $HOSTNAME > /gmod-base/garrysmod/data/container_id.txt
unionfs-fuse -o cow /gmod-volume=RW:/gmod-base=RO /gmod-union
while true; do
/gmod-union/srcds_run -game garrysmod +host_workshop_collection ${COLLECTION_ID} -authkey ${STEAM_WEB_KEY} +maxplayers ${MAXPLAYERS:=16} +hostname ${G_HOSTNAME} "${ARGS}" +gamemode ${GAMEMODE} +map ${MAP}
done
