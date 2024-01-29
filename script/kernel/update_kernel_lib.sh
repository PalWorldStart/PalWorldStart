#!/usr/bin/env bash

echo "当前系统的内核版本：$(uname -rs)"
echo "当前内核开发包信息："
rpm -qa | grep kernel

echo "移除老的内核开发包："
yum remove -y kernel-core-5.14.0-202.el9.x86_64 \
  kernel-modules-5.14.0-202.el9.x86_64 \
  kernel-5.14.0-202.el9.x86_64 \
  kernel-headers-5.14.0-202.el9.x86_64 \
  kernel-devel-5.14.0-202.el9.x86_64 \
  kernel-tools-libs-5.14.0-202.el9.x86_64 \
  kernel-tools-5.14.0-202.el9.x86_64

echo "安装新的内核开发包："
yum --enablerepo=elrepo-kernel install -y kernel-lt-devel kernel-lt-headers kernel-lt-tools kernel-lt-tools-libs kernel-lt-tools-libs-devel kernel-lt-doc gcc

echo "更新软件包"
yum --enablerepo=elrepo-kernel update -y
