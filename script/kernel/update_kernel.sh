#!/usr/bin/env bash

echo "当前系统的内核版本：$(uname -rs)"
echo "导入ELRepo仓库的公钥信息"
rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
echo "安装RHEL-9 ELRepo"
yum install -y https://www.elrepo.org/elrepo-release-9.el9.elrepo.noarch.rpm
echo "当前可用的内核发行版本："
yum --disablerepo="*" --enablerepo="elrepo-kernel" list available
echo "开始安装长期支持版本kernel-lt"
yum --enablerepo=elrepo-kernel install -y kernel-lt
echo "当前kernel信息："
grubby --info=ALL | grep ^kernel
echo "当前系统的默认内核：$(grubby --default-kernel)"
echo "更新默认kernel"
grubby --set-default "/boot/vmlinuz-6.1.75-1.el9.elrepo.x86_64"

for i in {1..10}; do
  echo -e "\r$((10 - i + 1))秒后重启...\c"
  sleep 1
  if [ $i == 10 ]; then
    reboot
  fi
done
