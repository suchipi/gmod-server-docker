#!/bin/sh
unionfs-fuse -o cow /gmod-volume=RW:/gmod-base=RO /gmod-union
/bin/sh /gmod-union/start-server.sh
exit 0
