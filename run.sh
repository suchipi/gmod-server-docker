docker run --privileged=true -d -p 27015:27015/udp -v /root/gmod-server:/gmod-volume --name gmod-test -e "MAP=gm_flatgrass" -e "ARGS=+rcon_password test" suchipi/gmod-server
