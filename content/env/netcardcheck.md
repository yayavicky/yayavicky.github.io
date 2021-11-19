---
title: "Net Card Check"
date: 2021-11-17T15:26:42+08:00
draft: false
toc: true # Enable Table of Contents for specific page

tags: 
    - "Linux"
    - "Env"
categories :                             
    - "Tec"
    - "Documents"
keywords :                                 
    - "linux"
    - "net"

menu: main # Optional, add page to a menu. Options: main, side, footer

# Theme-Defined params
# thumbnail: "img/placeholder.png" # Thumbnail image
lead: "Check Net Card"
comments: false # Enable Disqus comments for specific page
authorbox: true # Enable authorbox for specific page
pager: true # Enable pager navigation (prev/next) for specific page
toc: true 
mathjax: true # Enable MathJax for specific page
sidebar: "right" # Enable sidebar (on the right side) per page
widgets: # Enable sidebar widgets in given order per page
  - "search"
  - "recent"
  - "taglist"
---

## Ubuntu查看有线网卡eth0和eth1分别对应网卡型号

1. 查看网卡的型号: `lspci | grep -i net`
2. 通过driver区分多个网卡的型号: `ethtool -i eth0`

## Centos 查看网卡型号

1. 安装lspci: `yum install pciutils`
2. 查看网卡型号：`lspci | grep Ethernet`