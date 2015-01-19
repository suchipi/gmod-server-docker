#!/bin/sh
if [[ -z "$NO_UNION" ]]; then
  unionfs-fuse -o cow /gmod-volume=RW:/gmod-base=RO /gmod-union
  while true; do
    /gmod-union/srcds_run -game garrysmod +maxplayers ${MAXPLAYERS:=16} +hostname \"${G_HOSTNAME:="Miniserver"}\" +gamemode ${GAMEMODE:=sandbox} "${ARGS}" +map ${MAP:=gm_construct}
  done
else
  while true; do
    /gmod-base/srcds_run -game garrysmod +maxplayers ${MAXPLAYERS:=16} +hostname \"${G_HOSTNAME:="Miniserver"}\" +gamemode ${GAMEMODE:=sandbox} "${ARGS}" +map ${MAP:=gm_construct}
  done
fi

