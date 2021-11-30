---
title: "Offlinepython"
date: 2021-11-30T09:39:56+08:00
draft: false
tags: 
    - "Tools"
    - "Script"
categories :                             
    - "Script"
    - "Documents"
keywords :                                 
    - "tools"
    - "script"

menu: main # Optional, add page to a menu. Options: main, side, footer

# Theme-Defined params
# thumbnail: "img/placeholder.png" # Thumbnail image
lead: "set python run environment" # Lead text
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

## get help

```shell
python.exe /?

/passive            : display progress without requiring user interaction
/quiet              : install/uninstall without displaying any UI
/simple             : prevent user customization
/uninstall          : remove python(without confirmation)
/layout [directory] : pre-download all components
/log [filename]     : to specify log files location
```

>[find other options](https://docs.python.org/3.7/using/windows.html)

>1. `PrependPath =0` Add install and Scripts directories to PATH and .PY to PATHEXT
>2. `InstallAllUsers = 0` Perform a system-wide installation.

```shell
python-3.7.8-amd64.exe /passive InstallAllUsers=1 PrependPath=1 Include_exe=1 Include_pip=1 Include_lib=1
```

unattend.xml

```xml
<Options>
    <Option Name="InstallAllUsers" Value="yes" />
    <Option Name="Include_launcher" Value="0" />
    <Option Name="Include_test" Value="no" />
    <Option Name="Include_test" Value="no" />
    <Option Name="Include_test" Value="no" />
    <Option Name="Include_test" Value="no" />
    <Option Name="SimpleInstall" Value="yes" />
    <Option Name="SimpleInstallDescription">For All Users.</Option>
</Options>
```

1. Install Offline
  `python-3.7.8-amd64.exe /layout [optional target directory]`
2. 生成安装列表
  `pip freeze >packages.txt`
3. 下载离线安装包
  `pip download -d  [savetest\whls]  -r [packages.txt]`
4. 新环境离线安装
  `pip install --no-index --find-links=[savetest\whls] -r [packages.txt]`

