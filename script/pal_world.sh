#!/usr/bin/env bash

STEAMCMD_VERSION=latest
STEAMCMD_CONTAINER=steamcmd

STEAMCMD_IMAGE_NAME="docker.io/cm2network/steamcmd:$STEAMCMD_VERSION"

# 获取当前task的状态
function steamcmd_image_exist() {
  if [ "$STEAMCMD_IMAGE_NAME" = "$(ctr image ls | grep $STEAMCMD_IMAGE_NAME | awk '{print $1}')" ]; then
    return 0
  else
    return 1
  fi
}

# 获取当前task的状态
function get_task_status() {
  ctr t ls | grep $STEAMCMD_CONTAINER | awk '{print $3}'
}

# 检查task是否存在
function steamcmd_task_exist() {
  if [ "$STEAMCMD_CONTAINER" = "$(ctr t ls | grep $STEAMCMD_CONTAINER | awk '{print $1}')" ]; then
    return 0
  else
    return 1
  fi
}

# 检查container是否存在
function steamcmd_container_exist() {
  if [ "$STEAMCMD_CONTAINER" = "$(ctr c ls | grep $STEAMCMD_CONTAINER | awk '{print $1}')" ]; then
    return 0
  else
    return 1
  fi
}

# 拉取镜像
function steamcmd_pull_image() {
  if steamcmd_image_exist; then
    echo "$STEAMCMD_IMAGE_NAME镜像已存在"
  else
    ctr image pull $STEAMCMD_IMAGE_NAME
  fi
}

function steamcmd_stop_task() {
  STEAMCMD_TASK_STATUS=$(get_task_status)

  # 停止正在运行的task
  if [ "RUNNING" = "$STEAMCMD_TASK_STATUS" ]; then
    ctr t kill -s 9 $STEAMCMD_CONTAINER

    # 如果120s内task仍未退出则结束脚本
    for i in {1..120}; do
      echo -e "\r正在等待$STEAMCMD_CONTAINER task退出 $i秒...\c"
      sleep 1
      STEAMCMD_TASK_STATUS=$(get_task_status)
      if [ "RUNNING" != "$STEAMCMD_TASK_STATUS" ]; then
        break
      fi
    done

    STEAMCMD_TASK_STATUS=$(get_task_status)
    if [ "RUNNING" = "$STEAMCMD_TASK_STATUS" ]; then
      echo "无法停止正在运行的task==> $STEAMCMD_CONTAINER"
      exit 1
    fi
  fi
}

# 启动task
function steamcmd_start_task() {
  ctr t start -d $STEAMCMD_CONTAINER
}

# 删除task
function steamcmd_delete_task() {
  if steamcmd_task_exist; then
    ctr t rm $STEAMCMD_CONTAINER

    if steamcmd_task_exist; then
      echo "无法删除task==> $STEAMCMD_CONTAINER"
      exit 1
    fi
  fi
}

# 删除容器
function steamcmd_delete_container() {
  if steamcmd_container_exist; then
    ctr c rm $STEAMCMD_CONTAINER

    if steamcmd_container_exist; then
      echo "无法删除container==> $STEAMCMD_CONTAINER"
      exit 1
    fi
  fi
}

function steamcmd_start() {
  ctr run -d --net-host \
    --mount=type=bind,src=~/workspace/palworld/data/steamapps,dst=/home/steam/Steam/steamapps,options=rbind:rw \
    $STEAMCMD_IMAGE_NAME $STEAMCMD_CONTAINER
}

function steamcmd_show_state() {
  echo "【$STEAMCMD_CONTAINER($STEAMCMD_VERSION)】当前状态："
  ctr t ls | grep $STEAMCMD_CONTAINER
  ctr c ls | grep $STEAMCMD_CONTAINER
}

# 启动PalWorld
function palworld_start() {
  ctr t exec -d --exec-id restart_pal -t steamcmd /bin/bash -c "/home/steam/Steam/steamapps/common/PalServer/PalServer.sh"
}

function steamcmd_exec() {
  ctr tasks exec --exec-id steamcmd_exec -t steamcmd /bin/bash
}

function palworld_update() {
  ctr tasks exec --exec-id update_pal -t steamcmd /bin/bash -c "/home/steam/steamcmd/steamcmd.sh +login anonymous +app_update 2394010 validate +quit"
}
