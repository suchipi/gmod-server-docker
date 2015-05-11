FROM debian:wheezy

MAINTAINER Suchipi Izumi "me@suchipi.com"

# ------------
# Prepare Gmod
# ------------

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install lib32gcc1 wget
RUN mkdir /steamcmd
WORKDIR /steamcmd
RUN wget http://media.steampowered.com/installer/steamcmd_linux.tar.gz
RUN tar -xvzf steamcmd_linux.tar.gz
RUN mkdir /gmod-base
RUN /steamcmd/steamcmd.sh +login anonymous +force_install_dir /gmod-base +app_update 4020 validate +quit

# ----------------
# Annoying lib fix
# ----------------

RUN mkdir /gmod-libs
WORKDIR /gmod-libs
RUN wget http://launchpadlibrarian.net/195509222/libc6_2.15-0ubuntu10.10_i386.deb
RUN dpkg -x libc6_2.15-0ubuntu10.10_i386.deb .
RUN cp lib/i386-linux-gnu/* /gmod-base/bin/
WORKDIR /
RUN rm -rf /gmod-libs
RUN cp /steamcmd/linux32/libstdc++.so.6 /gmod-base/bin/

RUN mkdir /root/.steam
RUN mkdir /root/.steam/sdk32/
RUN cp /gmod-base/bin/libsteam.so /root/.steam/sdk32

# ----------------------
# Setup Volume and Union
# ----------------------

RUN mkdir /gmod-volume
VOLUME /gmod-volume
RUN mkdir /gmod-union
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install unionfs-fuse

# ---------------
# Setup Container
# ---------------

ADD start-server.sh /start-server.sh
EXPOSE 27015/udp

ENV PORT="27015"
ENV MAXPLAYERS="16"
ENV G_HOSTNAME="Garry's Mod"
ENV GAMEMODE="sandbox"
ENV MAP="gm_construct"

CMD ["/bin/sh", "/start-server.sh"]
