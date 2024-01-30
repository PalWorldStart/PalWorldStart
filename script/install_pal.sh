#!/usr/bin/env bash

mkdir -p /workspace/palworld
mkdir -p /workspace/palworld/data/steamapps
chmod 777 /workspace/palworld/data/steamapps

echo "开始安装并启动steamcmd"
source start_steamcmd.sh

echo "开始安装PalWorld"
source update_pal.sh

echo "开始启动PalWorld"
source start_pal.sh