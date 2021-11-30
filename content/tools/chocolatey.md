---
title: "Chocolatey"
date: 2021-11-25T08:47:44+08:00
draft: false

tags: 
    - "Tools"
    - "Install"
categories :                             
    - "Install"
    - "Documents"
keywords :                                 
    - "install"

menu: main # Optional, add page to a menu. Options: main, side, footer

# Theme-Defined params
# thumbnail: "img/placeholder.png" # Thumbnail image
lead: "Set Chocolatey" # Lead text
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

# Chocolate

## [官网](https://chocolatey.org/install)

管理员

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
```

## 常用包

```powershell
choco install -y 7zip.install adobereader notepadplusplus.install tim everything 

choco install -y 7zip.install adobereader notepadplusplus.install googlechrome firefox vscode  everything 

choco install 7zip.install -y
choco install adobereader -y
choco install notepadplusplus.install -y
choco install googlechrome -y
choco install firefox -y

choco install everything -y
choco install everything.portable -y
choco install everythingtoolbar -y

choco install vscode -y
choco install python3 -y
choco install git.install -y
choco install typora -y
choco info tim -y

# Microsoft Visual C++ Redistributable for Visual Studio 2015-2019 14.29.30040
choco install vcredist140 -y

# Microsoft .NET Framework 4.8 4.8.0.20190930
choco install dotnetfx -y

choco install kb3035131 -y

# Visual C++ Build Tools 2015 14.0.25420.1
choco install visualcppbuildtools -y

choco install microsoft-visual-cpp-build-tools -y

choco install vcredist-all -y
```

## 查询包

[Chocolatey Software | Packages](https://community.chocolatey.org/packages)

```powershell
choco list --local

choco outdated

choco upgrade --yes Firefox
choco upgrade --yes all
```

## 说明

Chocolatey 跟其他第三方软件管理器不同之处在于，其他软件管理器经常修改原来的安装包，从而可以夹带自己的广告，并且经常安装好之后发现并不是最新版本。但是 Chocolatey 不但**使用官网链接下载**，而且会在下载完成后使用数字摘要技术**检查安装包是否跟官网上的完全一致**，所以，你使用 Chocolatey 安装的就是最新纯净官网版本。

此外，通过使用 `info` 命令，你还可以查看程序的详细信息，便于你确认是否需要使用 Chocolatey 来安装这个程序：

```powershell
choco info Firefox
```

> choco 远多于 scoop。另一个，scoop 只能采用便携式（Portable）安装，choco 可选便携式、安装式，比如安装 git 可以选择 git.install 或者 git.portable。但 choco 并不总是提供便携式的选项。进阶来说，因为采用安装包的形式安装，choco 提供对安装包的控制，比如安装位置，比如 Everything 可以选择是否以服务形式安装，之类。


> choco自动配置path。许多要配置环境的软件包直接用choco安装，省时省力

