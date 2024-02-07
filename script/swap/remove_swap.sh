#!/usr/bin/env bash

function remove_swap() {
  # 关闭swap
  sudo swapoff /swapfile
  # 删除swap文件
  sudo rm -f /swapfile
  # 删除开机启动
  sudo sed -i '/swapfile/d' /etc/fstab
  echo "swap删除成功"
  # 查看swap信息
  free -m
}

echo "开始删除swap"
remove_swap
