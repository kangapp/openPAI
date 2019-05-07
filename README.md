# openPAI

## 相关介绍

[OpenPAI简介](https://www.msra.cn/zh-cn/news/features/openpai)  

[OpenPAI GitHub地址](https://github.com/Microsoft/pai/blob/master/README_zh_CN.md)

## 配置介绍
 
### 集群管理节点

- 系统：Ubuntu Server 16.04
- 内存：16G
- cpu核数：4核

### 集群节点（3台）

- 系统：Ubuntu Server 16.04
- 内存：64G
- cpu核数：16核

## 环境要求

> - 确保每台服务器都有静态IP地址，可以互相通信
>- 确保服务器可以访问互联网，可以拉取OpenPAI的Docker镜像
>- 确保SSH服务已启用，所有服务器使用相同的用户名的密码，并启用sudo权限
>- 确保NTP服务已启用

## 安装步骤

### 准备部署环境

> 这里有两种方式进行环境部署  
> - [使用dev-box container作为环境](https://github.com/microsoft/pai/blob/master/docs/zh_CN/pai-management/doc/how-to-setup-dev-box.md)  
> - [直接在主机上安装依赖的软件](https://github.com/microsoft/pai/blob/master/docs/zh_CN/pai-management/doc/how-to-install-depdencey.md)  
>
>`如果您想在属于OpenPAI的计算机上管理群集，请选择选项2.否则，强烈建议使用选项1`

***
我这里选择选项1，大家可以按照实际要求进行部署
***
#### dev-box安装

>Dev-Box是一个docker容器，其中包含用于paictl部署和管理集群的必要依赖软件。使用开发盒，您不再需要在主机环境中安装软件，使主机环境的软件包保持干净。

- 安装docker并拉取dev-box
```
sudo apt-get -y install docker.io  
#最好能指定版本，后面配置文件需要指明版本
sudo docker pull docker.io/openpai/dev-box:v0.12.0
```

- 运行dev-box
```
sudo docker run -itd \  
        -e COLUMNS=$COLUMNS -e LINES=$LINES -e TERM=$TERM \  
        -v /var/run/docker.sock:/var/run/docker.sock \  
        -v /pathConfiguration:/cluster-configuration  \  
        -v /hadoop-binary:/hadoop-binary  \  
        --pid=host \  
        --privileged=true \  
        --net=host \  
        --name=dev-box \  
        docker.io/openpai/dev-box:v0.12.0
```

- 登录dev-box
```
sudo docker exec -it dev-box /bin/bash  
cd /pai
```

#### 集群配置

- 编写quick-start.yaml
```
cd /pai/deployment/quick-start/  
cp quick-start-example.yaml quick-start.yaml  
vim quick-start.yaml
```
替换自己的集群ip和ssh信息
```
# quick-start.yaml

# (Required) Please fill in the IP address of the server you would like to deploy OpenPAI
machines:

  - 192.168.1.11
  - 192.168.1.12
  - 192.168.1.13

# (Required) Log-in info of all machines. System administrator should guarantee
# that the username/password pair or username/key-filename is valid and has sudo privilege.
ssh-username: pai
ssh-password: pai-password

# (Optional, default=None) the key file that ssh client uses, that has higher priority then password.
#ssh-keyfile-path: <keyfile-path>

# (Optional, default=22) Port number of ssh service on each machine.
#ssh-port: 22

# (Optional, default=DNS of the first machine) Cluster DNS.
#dns: <ip-of-dns>

# (Optional, default=10.254.0.0/16) IP range used by Kubernetes. Note that
# this IP range should NOT conflict with the current network.
#service-cluster-ip-range: <ip-range-for-k8s>
```
- 生成配置文件
```
cd /pai  
        python paictl.py config generate -i /pai/deployment/quick-start/quick-start.yaml -o ~/pai-config -f
```