#!/usr/bin/env bash

CONTAINERD_VERSION=1.7.13
NERDCTL_VERSION=1.7.3
RUNC_VERSION=1.1.12
CNI_PLUGINS_VERSION=1.4.0

echo "开始下载containerd v$CONTAINERD_VERSION"
wget -nc https://github.com/containerd/containerd/releases/download/v$CONTAINERD_VERSION/containerd-$CONTAINERD_VERSION-linux-amd64.tar.gz
echo "开始下载nerdctl v$NERDCTL_VERSION"
wget -nc https://github.com/containerd/nerdctl/releases/download/v$NERDCTL_VERSION/nerdctl-$NERDCTL_VERSION-linux-amd64.tar.gz
echo "开始下载containerd.service"
wget -nc https://raw.githubusercontent.com/containerd/containerd/main/containerd.service
echo "开始下载runc v$RUNC_VERSION"
wget -nc https://github.com/opencontainers/runc/releases/download/v$RUNC_VERSION/runc.amd64
echo "开始下载cni-plugins v$CNI_PLUGINS_VERSION"
wget -nc https://github.com/containernetworking/plugins/releases/download/v$CNI_PLUGINS_VERSION/cni-plugins-linux-amd64-v$CNI_PLUGINS_VERSION.tgz

echo "开始安装containerd v$CONTAINERD_VERSION"
tar Cxzvf /usr/local containerd-$CONTAINERD_VERSION-linux-amd64.tar.gz
echo "开始安装nerdctl v$NERDCTL_VERSION"
tar Cxzvvf /usr/local/bin nerdctl-$NERDCTL_VERSION-linux-amd64.tar.gz
echo "开始安装containerd.service"
mkdir -p /usr/local/lib/systemd/system
cp containerd.service /usr/local/lib/systemd/system/containerd.service
systemctl daemon-reload
systemctl enable --now containerd
echo "开始安装runc v$RUNC_VERSION"
install -m 755 runc.amd64 /usr/local/sbin/runc
echo "开始安装cni-plugins v$CNI_PLUGINS_VERSION"
mkdir -p /opt/cni/bin
tar Cxzvf /opt/cni/bin cni-plugins-linux-amd64-v$CNI_PLUGINS_VERSION.tgz

echo "开始生成containerd默认配置文件"
mkdir -p /etc/containerd
containerd config default >/etc/containerd/config.toml

sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml

echo "重启containerd"
systemctl restart containerd

containerd -v
echo "containerd安装结束"
