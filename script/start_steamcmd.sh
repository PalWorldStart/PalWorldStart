#!/usr/bin/env bash

source pal_world.sh

echo "拉取镜像"
steamcmd_pull_image

echo "停止正在运行的task"
steamcmd_stop_task

echo "删除task"
steamcmd_delete_task

echo "删除容器"
steamcmd_delete_container

echo "启动steamcmd"
steamcmd_start

echo "查看状态"
steamcmd_show_state
