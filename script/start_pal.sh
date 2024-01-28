#!/usr/bin/env bash

source pal_world.sh

echo "启动PalWorld"
palworld_start

echo "查看状态"
steamcmd_show_state
