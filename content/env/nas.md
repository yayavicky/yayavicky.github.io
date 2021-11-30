---
title: "群晖设置"
date: 2021-11-30T11:12:48+08:00
draft: false
tags: 
    - "Tools"
    - "Setting"
categories :                             
    - "Setting"
    - "Documents"
keywords :                                 
    - "setting"
    - "nas"

#menu: main # Optional, add page to a menu. Options: main, side, footer

# Theme-Defined params
# thumbnail: "img/placeholder.png" # Thumbnail image
lead: "pkg install on nas" # Lead text
comments: false # Enable Disqus comments for specific page
authorbox: true # Enable authorbox for specific page
pager: true # Enable pager navigation (prev/next) for specific page
toc: true 
mathjax: false # Enable MathJax for specific page
sidebar: "right" # Enable sidebar (on the right side) per page
widgets: # Enable sidebar widgets in given order per page
  - "search"
  - "recent"
  - "taglist"
---



## 直接使用套件中心

套件中心添加https://www.cphub.net 社区套件源，然后直接安装。

## 使用离线 ipk 文件。

打开 [community package hub](https://www.cphub.net/?id=37)，选择你的固件型号：

下载 `Easy Bootstrap Installer` 与 `iPKGui` 两个套件安装包。

###  安装

`Easy Bootstrap Installer` 主要为 `ipkg` 或 `opkg` 环境，`iPKGui` 则为 `ipkg` 的图形界面。因此，我们需要先安装 `Easy Bootstrap Installer` 后安装 `iPKGui` 。　　打开群晖 `套件中心`，选择 `手动安装`，选择刚才下载好的 `Easy Bootstrap Installer` spk 文件，依照提示安装后重启群晖即可。（需要注意的是，在装 `Easy Bootstrap Installer` 的过程中，由于会对源做刷新动作，而 `ipkg` 的源又被墙了，所以在网络状况不好的情况下，会非常慢。 ）　　之后使用 [ssh 连接并群晖获取 root 权限](https://www.iots.vip/post/synology-series-1.html#ssh-%E8%BF%9E%E6%8E%A5%E5%B9%B6%E8%8E%B7%E5%BE%97-root-%E6%9D%83%E9%99%90) ，执行 `ipkg` 能够正确执行后，依照前面方式在套件中心安装 `iPKGui` 的 spk 文件即可。至此，整个流程结束，完成 `ipkg` 的环境配置。

###  安装其他包

```bash
sudo /opt/bin/opkg update
sudo /opt/bin/opkg install lsof

sudo /opt/bin/lsof  | grep deleted 
sudo kill -9 PID

df -i
df -h
```

```bash

ls /dev/md*
/dev/md0  /dev/md1  /dev/md2

sudo mdadm --detail /dev/md0 /dev/md1
```