#!/usr/bin/env bash

source pal_world.sh

echo "更新PalWorld"
palworld_update

echo "查看状态"
steamcmd_show_state
