# 存档同步备份

本教程使用[gofs](https://github.com/no-src/gofs)将服务器上的数据文件实时同步到其他服务器上，以防止数据丢失

## 准备条件

### 下载本项目

将本项目分别克隆到PalWorld服务端所在的服务器，以及另一台用于数据备份的服务器上

```bash
git clone https://github.com/PalWorldStart/PalWorldStart.git
```

然后分别进入各自的`sync`脚本目录，赋予执行权限

```bash
cd PalWorldStart/script/sync
chmod +x *.sh
```

### 修改同步配置信息

打开`init_secret.sh`脚本，分别修改其中的各个参数，说明如下：

- `GOFS_SERVER_ADDR` 同步程序服务端IP地址，即PalWorld服务端所在的服务器IP地址
- `GOFS_USER` 同步程序登录使用的用户名密码及权限，格式为`用户名|密码|权限`，例如`gofs|password|r`，随机设置一个账号密码即可
- `GOFS_TOKEN_SECERT` 服务程序内部使用的密钥，可以随机指定一个字符串，长度为16、24或者32字节

### 配置证书

如果你拥有自己的证书，则直接替换`cert`目录下的测试证书

如果没有则可以直接使用以下命令生成证书并自动覆盖到`cert`目录下

```bash
./generate_cert.sh
```

## 启动同步服务

### 启动同步程序的服务端

在PalWorld的服务端启动同步服务器

```bash
./start_server.sh
```

### 启动同步程序的客户端

在另一台用于数据备份的主机中启动同步客户端

```bash
./start_client.sh
```

执行完毕，就可以将PalWorld服务器上的`/workspace/palworld/data/steamapps/common/PalServer/Pal/Saved`目录下的文件，
实时同步到备份服务器上的`/workspace/gofs/remote-disk-client/source`目录中