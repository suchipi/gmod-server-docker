#!/bin/bash
if [ -n "$UNION" ]; then
  unionfs-fuse -o cow /gmod-volume=RW:/gmod-base=RO /gmod-union
  while true; do
    /gmod-union/srcds_run -game garrysmod -norestart -port ${PORT} +maxplayers ${MAXPLAYERS} +hostname "${G_HOSTNAME}" +gamemode ${GAMEMODE} "${ARGS}" +map ${MAP}
  done
else
  while true; do
    /gmod-base/srcds_run -game garrysmod -norestart -port ${PORT} +maxplayers ${MAXPLAYERS} +hostname "${G_HOSTNAME}" +gamemode ${GAMEMODE} "${ARGS}" +map ${MAP}
  done
fi

