#!/usr/bin/env bash

source pal_world.sh

echo "停止正在运行的task"
steamcmd_stop_task

echo "删除task"
steamcmd_delete_task

echo "查看状态"
steamcmd_show_state
