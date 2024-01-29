#!/usr/bin/env bash

source gofs.sh

echo "拉取镜像"
gofs_pull_image

echo "停止正在运行的task"
gofs_stop_task

echo "删除task"
gofs_delete_task

echo "删除容器"
gofs_delete_container

echo "启动gofs client"
gofs_start_client

echo "查看状态"
gofs_show_state