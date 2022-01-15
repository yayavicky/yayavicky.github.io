---
title: "Windows Activate"
date: 2018-01-15T15:59:24+08:00
draft: false
tags: 
    - "Tools"
    - "Setting"
categories :                             
    - "Setting"
    - "Documents"
keywords :                                 
    - "setting"
    - "windows"

#menu: main # Optional, add page to a menu. Options: main, side, footer

# Theme-Defined params
# thumbnail: "img/placeholder.png" # Thumbnail image
lead: "kms setting" # Lead text
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

## 系统信息

以下均需管理员权限

查看系统版本

```shell
wmic os get caption
```

设置系统key

```shell
slmgr /ipk xxxxx-xxxxx-xxxxx-xxxxx-xxxxx
```

设置服务器

```shell
slmgr /skms Your IP or Domain:1688
```
 
激活

```shell
slmgr /ato
```

## Office

关于 Office 的激活，要求必须是 VOL 版本，否则无法激活。
找到你的 Office 安装目录，32 位默认一般为 `C:\Program Files (x86)\Microsoft Office\Office16`
64 位默认一般为 `C:\Program Files\Microsoft Office\Office1`。
Office16 是 Office 2016，Office15 就是 Office 2013，Office14 就是 Office 2010。
打开以上所说的目录，应该有个 OSPP.VBS 文件。
使用管理员权限运行 cmd 进入 Office 目录，命令如下：



```shell
cd "C:\Program Files (x86)\Microsoft Office\Office16"
```

```shell
cscript ospp.vbs /sethst:Your IP or Domain
cscript ospp.vbs /act
```




## keys

+ [windows 10](https://docs.microsoft.com/zh-cn/windows-server/get-started/kms-client-activation-keys)
+ [Office 2016 & 2019](https://docs.microsoft.com/en-us/DeployOffice/vlactivation/gvlks)