docker run --privileged=true -d -P -v /root/gmod-server:/gmod-volume --name gmod-test -e "MAP=gm_flatgrass" -e "ARGS=+rcon_password test" suchipi/gmod-server
