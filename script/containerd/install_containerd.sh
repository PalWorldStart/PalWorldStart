#!/usr/bin/env bash

CONTAINERD_VERSION=1.7.13
NERDCTL_VERSION=1.7.3
RUNC_VERSION=1.1.12
CNI_PLUGINS_VERSION=1.4.0

set -e
trap 'echo "安装containerd失败"' ERR

echo "开始下载containerd v$CONTAINERD_VERSION"
wget -nc -q https://github.com/containerd/containerd/releases/download/v$CONTAINERD_VERSION/containerd-$CONTAINERD_VERSION-linux-amd64.tar.gz
echo "开始下载nerdctl v$NERDCTL_VERSION"
wget -nc -q https://github.com/containerd/nerdctl/releases/download/v$NERDCTL_VERSION/nerdctl-$NERDCTL_VERSION-linux-amd64.tar.gz
echo "开始下载containerd.service"
wget -nc -q https://raw.githubusercontent.com/containerd/containerd/main/containerd.service
echo "开始下载runc v$RUNC_VERSION"
wget -nc -q https://github.com/opencontainers/runc/releases/download/v$RUNC_VERSION/runc.amd64
echo "开始下载cni-plugins v$CNI_PLUGINS_VERSION"
wget -nc -q https://github.com/containernetworking/plugins/releases/download/v$CNI_PLUGINS_VERSION/cni-plugins-linux-amd64-v$CNI_PLUGINS_VERSION.tgz

echo "开始安装containerd v$CONTAINERD_VERSION"
sudo tar Cxzvf /usr/local containerd-$CONTAINERD_VERSION-linux-amd64.tar.gz
echo "开始安装nerdctl v$NERDCTL_VERSION"
sudo tar Cxzvvf /usr/local/bin nerdctl-$NERDCTL_VERSION-linux-amd64.tar.gz
echo "开始安装containerd.service"
sudo mkdir -p /usr/local/lib/systemd/system
sudo cp containerd.service /usr/local/lib/systemd/system/containerd.service
sudo systemctl daemon-reload
sudo systemctl enable --now containerd
echo "开始安装runc v$RUNC_VERSION"
sudo install -m 755 runc.amd64 /usr/local/sbin/runc
echo "开始安装cni-plugins v$CNI_PLUGINS_VERSION"
sudo mkdir -p /opt/cni/bin
sudo tar Cxzvf /opt/cni/bin cni-plugins-linux-amd64-v$CNI_PLUGINS_VERSION.tgz

echo "开始生成containerd默认配置文件"
if [ -d "/etc/containerd" ]; then
  CONTAINERD_BACKUP=containerd_bak_$(date +%Y%m%d%H%M%S).tar.gz
  cd /etc && sudo tar -zcvf $CONTAINERD_BACKUP containerd && cd - && sudo mv /etc/$CONTAINERD_BACKUP .
else
  sudo mkdir -p /etc/containerd
fi
containerd config default | sudo tee /etc/containerd/config.toml >/dev/null
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml

echo "重启containerd"
sudo systemctl restart containerd

containerd -v
echo "containerd安装结束"

for file in *; do
  if [ -f "$file" ]; then
    md5=$(md5sum "$file" | awk '{ print $1 }')
    ls -alh "$file" | awk -v md5="$md5" '{ print md5, $0 }'
  fi
done
