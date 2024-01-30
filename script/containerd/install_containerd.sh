#!/usr/bin/env bash

mkdir -p ~/workspace/containerd
cd ~/workspace/containerd
echo "开始下载containerd"
wget -q https://github.com/containerd/containerd/releases/download/v1.7.12/containerd-1.7.12-linux-amd64.tar.gz
echo "开始下载nerdctl"
wget -q https://github.com/containerd/nerdctl/releases/download/v1.7.2/nerdctl-1.7.2-linux-amd64.tar.gz
echo "开始下载containerd.service"
wget -q https://raw.githubusercontent.com/containerd/containerd/main/containerd.service
echo "开始下载runc"
wget -q https://github.com/opencontainers/runc/releases/download/v1.1.11/runc.amd64
echo "开始下载cni-plugins"
wget -q https://github.com/containernetworking/plugins/releases/download/v1.4.0/cni-plugins-linux-amd64-v1.4.0.tgz

echo "开始安装containerd"
tar Cxzvf /usr/local containerd-1.7.12-linux-amd64.tar.gz
echo "开始安装nerdctl"
tar Cxzvvf /usr/local/bin nerdctl-1.7.2-linux-amd64.tar.gz
echo "开始安装containerd.service"
mkdir -p /usr/local/lib/systemd/system
cp containerd.service /usr/local/lib/systemd/system/containerd.service
systemctl daemon-reload
systemctl enable --now containerd
echo "开始安装runc"
install -m 755 runc.amd64 /usr/local/sbin/runc
echo "开始安装cni-plugins"
mkdir -p /opt/cni/bin
tar Cxzvf /opt/cni/bin cni-plugins-linux-amd64-v1.4.0.tgz

echo "开始生成containerd默认配置文件"
mkdir -p /etc/containerd
containerd config default >/etc/containerd/config.toml

sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml

echo "重启containerd"
systemctl restart containerd

containerd -v
echo "containerd安装结束"
