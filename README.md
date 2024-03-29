# PalWorldStart

Welcome to PalWorld!

## 准备条件

克隆本项目到本地

```bash
git clone https://github.com/PalWorldStart/PalWorldStart.git
```

然后进入脚本目录

```bash
cd PalWorldStart/script
```

赋予脚本执行权限

```bash
chmod +x *.sh
```

安装containerd

```bash
cd containerd
chmod +x install_containerd.sh
./install_containerd.sh
cd ../
```

## 安装PalWorld服务器

```bash
./install_pal.sh
```

安装完毕后，使用IP+8211端口进行访问即可，例如：`127.0.0.1:8211`

## 更新PalWorld服务器

通过以下命令来更新服务器到最新版本

```bash
./update_pal.sh
```

## 重启PalWorld服务器

服务器内存过高或者修改完配置文件后，可以执行以下命令来重启服务器

```bash
./restart_pal.sh
```

## 配置文件

运行时配置文件

```text
/workspace/palworld/data/steamapps/common/PalServer/Pal/Saved/Config/LinuxServer/PalWorldSettings.ini
```

默认配置文件模板

```text
/workspace/palworld/data/steamapps/common/PalServer/DefaultPalWorldSettings.ini
```

## 存档同步备份

如果想要对游戏的存档数据进行实时同步备份，可以参照[存档同步备份](Sync.md)文档进行操作

## 虚拟内存

### 启用虚拟内存

如果你的服务器内存不是很充裕，可以使用以下命令启用虚拟内存来缓解内存压力

```bash
cd PalWorldStart/script/swap
./add_swap.sh
```

### 禁用虚拟内存

使用以下命令可以删除上述添加的虚拟内存

```bash
cd PalWorldStart/script/swap
./remove_swap.sh
```