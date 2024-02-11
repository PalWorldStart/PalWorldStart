#!/usr/bin/env bash

function add_swap() {
  # 获取当前内存大小
  MEMORY_SIZE=$(free -m | awk '/^Mem:/{print $2}')
  # 创建swap文件
  sudo dd if=/dev/zero of=/swapfile bs=1M count=$MEMORY_SIZE
  sudo chmod 600 /swapfile
  # 格式化swap文件
  sudo mkswap /swapfile
  # 启用swap文件
  sudo swapon /swapfile
  # 设置开机启动
  echo "/swapfile swap swap defaults 0 0" | sudo tee -a /etc/fstab
  echo "swap创建成功"
  # 查看swap信息
  free -m
}

function add_swap_if_not_exist() {
  if [ -f /swapfile ]; then
    echo "swap已存在，如需重新创建请先删除"
  else
    echo "开始创建swap"
    add_swap
  fi
}

add_swap_if_not_exist
