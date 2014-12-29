#!/bin/bash
collection_id=$1
authkey=$2
gamemode=$3
map=$4

outputname=$5

workshop_requires=${@:6}

# assemble Dockerfile
sed "s/collection_id/$1/g" Dockerfile.in > Dockerfile.in2
sed "s/steam_web_key/$2/g" Dockerfile.in2 > Dockerfile.in3
sed "s/gamemode/$3/g" Dockerfile.in3 > Dockerfile.in4
sed "s/map/$4/g" Dockerfile.in4 > Dockerfile
rm Dockerfile.in2 Dockerfile.in3 Dockerfile.in4

# assemble workshop.lua
echo "if SERVER then" > workshop.lua
for id in "${workshop_requires}"; do
	echo "resource.AddWorkshop(\"$id\")" >> workshop.lua
done
echo "end" >> workshop.lua

# you have to Ctrl+C manually when the server segfaults at this part. I wish I knew why.
docker run -it --name workshopbuild suchipi/gmod-server /gmod-base/srcds_run -game garrysmod +maxplayers 1 +host_workshop_collection $collection_id -authkey $authkey +map gm_construct +exit
docker commit workshopbuild suchipi/gmod-server-workshopbuild
docker rm workshopbuild
docker build -t $outputname .
docker rmi suchipi/gmod-server-workshopbuild

rm Dockerfile
rm workshop.lua
