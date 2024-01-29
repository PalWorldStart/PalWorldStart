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

echo "初始化gofs client工作目录"
init_gofs_client_workspace
echo "执行一次全量同步"
gofs_start_client_sync_once
echo "开始监听服务器变更进行数据同步"
gofs_start_client

echo "查看状态"
gofs_show_state
