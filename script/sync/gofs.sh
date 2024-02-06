#!/usr/bin/env bash

source init_secret.sh

GOFS_VERSION=latest
GOFS_CONTAINER=gofs
GOFS_IMAGE_NAME="docker.io/nosrc/gofs:$GOFS_VERSION"

WORKDIR=/workspace

# 获取当前task的状态
function gofs_image_exist() {
  if [ "$GOFS_IMAGE_NAME" = "$(ctr image ls | grep $GOFS_IMAGE_NAME | awk '{print $1}')" ]; then
    return 0
  else
    return 1
  fi
}

# 获取当前task的状态
function get_task_status() {
  ctr t ls | grep $GOFS_CONTAINER | awk '{print $3}'
}

# 检查task是否存在
function gofs_task_exist() {
  if [ "$GOFS_CONTAINER" = "$(ctr t ls | grep $GOFS_CONTAINER | awk '{print $1}')" ]; then
    return 0
  else
    return 1
  fi
}

# 检查container是否存在
function gofs_container_exist() {
  if [ "$GOFS_CONTAINER" = "$(ctr c ls | grep $GOFS_CONTAINER | awk '{print $1}')" ]; then
    return 0
  else
    return 1
  fi
}

# 拉取镜像
function gofs_pull_image() {
  if gofs_image_exist; then
    echo "$GOFS_IMAGE_NAME镜像已存在"
  else
    ctr image pull $GOFS_IMAGE_NAME
  fi
}

function gofs_stop_task() {
  GOFS_TASK_STATUS=$(get_task_status)

  # 停止正在运行的task
  if [ "RUNNING" = "$GOFS_TASK_STATUS" ]; then
    ctr t kill -s 9 $GOFS_CONTAINER

    # 如果120s内task仍未退出则结束脚本
    for i in {1..120}; do
      echo -e "\r正在等待$GOFS_CONTAINER task退出 $i秒...\c"
      sleep 1
      GOFS_TASK_STATUS=$(get_task_status)
      if [ "RUNNING" != "$GOFS_TASK_STATUS" ]; then
        break
      fi
    done

    GOFS_TASK_STATUS=$(get_task_status)
    if [ "RUNNING" = "$GOFS_TASK_STATUS" ]; then
      echo "无法停止正在运行的task==> $GOFS_CONTAINER"
      exit 1
    fi
  fi
}

# 启动task
function gofs_start_task() {
  ctr t start -d $GOFS_CONTAINER
}

# 删除task
function gofs_delete_task() {
  if gofs_task_exist; then
    ctr t rm $GOFS_CONTAINER

    if gofs_task_exist; then
      echo "无法删除task==> $GOFS_CONTAINER"
      exit 1
    fi
  fi
}

# 删除容器
function gofs_delete_container() {
  if gofs_container_exist; then
    ctr c rm $GOFS_CONTAINER

    if gofs_container_exist; then
      echo "无法删除container==> $GOFS_CONTAINER"
      exit 1
    fi
  fi
}

function gofs_start_server() {
  mkdir -p /workspace/gofs/remote-disk-server/dest
  cp -n ./cert/* /workspace/gofs

  ctr run -d --net-host \
    --env TZ=Asia/Shanghai \
    --mount=type=bind,src=/workspace/gofs,dst=$WORKDIR,options=rbind:rw \
    --mount=type=bind,src=/workspace/palworld/data/steamapps/common/PalServer/Pal/Saved,dst=$WORKDIR/remote-disk-server/source,options=rbind:rw \
    $GOFS_IMAGE_NAME $GOFS_CONTAINER \
    gofs \
    -source="rs://$GOFS_SERVER_ADDR:8105?mode=server&local_sync_disabled=true&path=$WORKDIR/remote-disk-server/source&fs_server=https://$GOFS_SERVER_ADDR" \
    -dest="$WORKDIR/remote-disk-server/dest" \
    -log_level=0 \
    -users="$GOFS_USER" \
    -tls_cert_file=cert.pem \
    -tls_key_file=key.pem \
    -token_secret="$GOFS_TOKEN_SECERT"
}

function init_gofs_client_workspace() {
  mkdir -p /workspace/gofs/remote-disk-client/source /workspace/gofs/remote-disk-client/dest
  cp -n ./cert/cert.pem /workspace/gofs
}

function gofs_start_client() {
  ctr run -d --net-host \
    --env TZ=Asia/Shanghai \
    --mount=type=bind,src=/workspace/gofs,dst=$WORKDIR,options=rbind:rw \
    $GOFS_IMAGE_NAME $GOFS_CONTAINER \
    gofs \
    -source="rs://$GOFS_SERVER_ADDR:8105" \
    -dest="$WORKDIR/remote-disk-client/dest" \
    -log_level=0 \
    -users="$GOFS_USER" \
    -tls_cert_file=cert.pem
}

function gofs_start_client_sync_once() {
  ctr run --rm --net-host \
    --env TZ=Asia/Shanghai \
    --mount=type=bind,src=/workspace/gofs,dst=$WORKDIR,options=rbind:rw \
    $GOFS_IMAGE_NAME gofs_once \
    gofs \
    -source="rs://$GOFS_SERVER_ADDR:8105" \
    -dest="$WORKDIR/remote-disk-client/dest" \
    -log_level=0 \
    -users="$GOFS_USER" \
    -tls_cert_file=cert.pem -sync_once
}

function gofs_show_state() {
  echo "【$GOFS_CONTAINER($GOFS_VERSION)】当前状态："
  ctr t ls | grep $GOFS_CONTAINER
  ctr c ls | grep $GOFS_CONTAINER
}
