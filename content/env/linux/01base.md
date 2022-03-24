---
title: "01base"
date: 2022-03-14T17:02:46+08:00
draft: true
---

## sudo 免密码

```shell
sudo cp /etc/sudoers .
sudo chmod 744 sudoers
```

```shell
sudo visudo sudoers
 
# 在文件最后一行添加yourusername ALL=(ALL) NOPASSWD:ALL
# or在文件最后一行添加: %sudo   ALL=(ALL:ALL) NOPASSWD: ALL
# 保存退出操作: ctrl + x，然后输入y
```

```
echo "epds ALL=(ALL) NOPASSWD:ALL">epds
```

## 开启 SSH

```
sudo apt update
sudo apt install openssh-server

sudo systemctl status ssh

<!-- ufw 自带防火墙 -->
sudo ufw allow ssh

ssh username@ip_address
```

禁用ssh

`sudo systemctl disable --now ssh`

启用 ssh

`sudo systemctl enable --now ssh`

## docker

+ [gitlab version](https://hub.docker.com/r/gitlab/gitlab-ce/tags/)
