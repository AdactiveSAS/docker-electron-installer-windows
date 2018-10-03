FROM circleci/node:9
LABEL maintainer="moroine.bentefrit@adactive.com"

ENV DEBIAN_FRONTEND noninteractive

RUN sudo apt-get update && \
  sudo apt-get install -y software-properties-common apt-transport-https && \
  sudo dpkg --add-architecture i386 && \
  curl -L https://dl.winehq.org/wine-builds/Release.key > /tmp/Release.key && \
  sudo apt-key add /tmp/Release.key && \
  sudo apt-add-repository https://dl.winehq.org/wine-builds/debian && \
  sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF && \
  sudo apt-add-repository https://download.mono-project.com/repo/debian && \
  sudo apt-get update && \
  sudo apt-get -y purge software-properties-common libdbus-glib-1-2 python3-dbus python3-gi python3-pycurl python3-software-properties && \
  sudo apt-get install -y --install-recommends winehq-stable && \
  sudo apt-get install -y --install-recommends mono-devel && \
  sudo apt-get clean && sudo rm -rf /var/lib/apt/lists/* && unlink /tmp/Release.key

ENV WINEPREFIX /home/circleci/.wine
