---
title: "Win10fix"
date: 2021-12-08T13:29:35+08:00
draft: false
tags: 
    - "system"
categories :                             
    - "System Maintance"
keywords :                                 
    - "system"

#menu: main # Optional, add page to a menu. Options: main, side, footer

# Theme-Defined params
# thumbnail: "img/placeholder.png" # Thumbnail image
lead: "Win10 System Fix" # Lead text
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

## 使用SFC修复Windows 10

```shell
sfc /scannow
```

## 使用DISM修复Windows 10

```shell
DISM /Online /Cleanup-Image /CheckHealth

DISM/Online/Cleanup-Image/RestoreHealth/Source:repairSource\install.wim
```

## 使用命令提示符恢复出厂设置

```shell
systemreset-cleanpc
```

## 使用命令提示符进行系统还原

启用带命令提示符的安全模式

管理员帐户登录系统。打开cmd之后，请输入“rstrui.exe”，然后按“回车”继续。