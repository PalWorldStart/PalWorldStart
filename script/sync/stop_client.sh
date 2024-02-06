#!/usr/bin/env bash

source gofs.sh

echo "停止正在运行的task"
gofs_stop_task

echo "删除task"
gofs_delete_task

echo "删除容器"
gofs_delete_container

echo "查看状态"
gofs_show_state
