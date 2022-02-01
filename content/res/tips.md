---
title: "Tips"
date: 2022-01-28T21:28:18+08:00
draft: false
tags: 
    - "Tips"
categories :                             
    - "Tips"
keywords :                                 
    - "tips"

#menu: main # Optional, add page to a menu. Options: main, side, footer

# Theme-Defined params
# thumbnail: "img/placeholder.png" # Thumbnail image
lead: "常用小技巧" # Lead text
comments: false # Enable Disqus comments for specific page
authorbox: true # Enable authorbox for specific page
pager: true # Enable pager navigation (prev/next) for specific page
toc: true 
mathjax: false # Enable MathJax for specific page
sidebar: "right" # Enable sidebar (on the right side) per page
widgets: # Enable sidebar widgets in given order per page
  - "search"
  - "taglist"
---

## 修改Hosts临时解决GitHub的raw.githubusercontent.com无法链接的问题

### 查询真实IP
通过 `IPAddress.com` , 输入 `raw.githubusercontent.com` 查询到真实IP地址： `199.232.68.133`

### 修改hosts

CentOS及macOS直接在终端输入

`sudo vi /etc/hosts`

添加以下内容保存即可

`199.232.4.133 raw.githubusercontent.com`