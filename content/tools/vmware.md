---
title: "Vmware Auto Act"
date: 2021-11-25T08:58:02+08:00
draft: false
tags: 
    - "Tools"
    - "Setting"
categories :                             
    - "Setting"
    - "Documents"
keywords :                                 
    - "setting"
    - "auto"

menu: footer # Optional, add page to a menu. Options: main, side, footer

# Theme-Defined params
# thumbnail: "img/placeholder.png" # Thumbnail image
lead: "Vmware Auto Start" # Lead text
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

## Vmware 开机

```bash
vmrun -T (ws|fusion|player) start "指定虚拟机vmx文件路径" [gui|nogui]

vmrun -T ws start "D:\VirtualBox VMs\openwrt\openwrt.vmx" nogui
```

`ws` 代表workstation, `nogui`  代表无界面后台运行。

## 1. 用组策略来实现

组合键(Windows键+R键) 在 “运行” 中输入 `gpedit.msc` 打开组策略编辑器。

在组策略中，依次选择

用户配置—Windows设置—脚本(登录|注销) 右边，名称下选择 “登录”

## 2. 命令创建一个快捷方式，将其放入启动文件夹

打开运行或者文件资源管理器，输入 `shell:startup` ，打开启动文件夹，或者直接打开目录 `%appdata%\Microsoft\Windows\Start Menu\Programs\Startup` ，将快捷方式放进去。

## Vmware 关机

```bash
# 挂起
vmrun -T (ws|fusion|player) suspend "指定虚拟机vmx文件路径"

# 关机
vmrun -T (ws|fusion|player) stop "指定虚拟机vmx文件路径"  soft
```

>soft 不可漏，会使虚拟机执行操作系统指定的关机程序

1. `gpedit.msc` 
2. 本地计算机策略 - 计算机配置 - Windows设置 - 脚本
3. 右侧选择关机
4. 将需要执行的关机或挂起命令写入 bat 文件