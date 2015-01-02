#!/bin/bash
base_image=$1
collection_id=$2
authkey=$3
gamemode=$4
map=$5

hostname=$6
outputname=$7

workshop_requires=${@:8}

echo "---"
echo "Building new workshop image."
echo "base image: $base_image"
echo "collection id: $collection_id"
echo "steam web api key: $authkey"
echo "gamemode: $gamemode"
echo "map: $map"
echo "hostname: $hostname"
echo "outputname: $outputname"
echo "workshop requires: $workshop_requires"
echo "---"

# assemble Dockerfile
sed "s/collection_id/$collection_id/g" Dockerfile.in > Dockerfile.in2
sed "s/steam_web_key/$authkey/g" Dockerfile.in2 > Dockerfile.in3
sed "s/gamemode/$gamemode/g" Dockerfile.in3 > Dockerfile.in4
sed "s/map/$map/g" Dockerfile.in4 > Dockerfile.in5
sed "s/hostname/$hostname/g" Dockerfile.in5 > Dockerfile
rm Dockerfile.in2 Dockerfile.in3 Dockerfile.in4 Dockerfile.in5

# assemble workshop.lua
echo "if SERVER then" > workshop.lua
for id in "${workshop_requires}"; do
	echo "resource.AddWorkshop(\"$id\")" >> workshop.lua
done
echo "end" >> workshop.lua

# you have to Ctrl+C manually when the server segfaults at this part. I wish I knew why.
docker run -it --name workshopbuild $base_image /gmod-base/srcds_run -game garrysmod +maxplayers 1 +host_workshop_collection $collection_id -authkey $authkey +map gm_construct +exit
docker commit workshopbuild workshopbuild-interim
docker rm workshopbuild
docker build -t $outputname .
docker rmi workshopbuild-interim

rm Dockerfile
rm workshop.lua
