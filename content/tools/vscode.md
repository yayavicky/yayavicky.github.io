---
title: "VS Code"
date: 2021-11-16T16:07:38+08:00
draft: false

tags: 
    - "Tools"
    - "GO"
categories :                             
    - "Tec"
    - "Documents"
keywords :                                 
    - "tools"
    - "vs"
    - "vscode"

# menu: main # Optional, add page to a menu. Options: main, side, footer

# Theme-Defined params
# thumbnail: "img/placeholder.png" # Thumbnail image
lead: "VS Code Setting" # Lead text
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



# VS Code

Go 扩展默认是使用大量的 Go 工具来提供各种功能的, 每个工具提供某个方面的能力, 比如代码提示是依靠 gocode 的.

不过微软在开发 VS Code 过程中, 定义一种协议, 语言服务器协议, [Language Server Protocol]([https://microsoft.github.io/language-server-protocol/](https://microsoft.github.io/language-server-protocol/)). 

这可是个好东西, 如果你需要开发编辑器或 IDE, 就不需要再为每种语言实现诸如自动完成, 代码提示等功能了, 直接利用 **语言服务器协议** 就行了.

gopls 就是官方的语言服务器, 当前处于 alpha 状态.

## Remote Extensions 

+ Remote - SSH
+ Remote - Containers
+ Remote - WSL

### 安装 SSH Client：

```powershell
Get-WindowsCapability -Online | ? Name -like 'OpenSSH*'
Name  : OpenSSH.Client~~~~0.0.1.0
State : NotPresent
Name  : OpenSSH.Server~~~~0.0.1.0
State : NotPresent

Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0
```

```cmd
cd %USERPROFILE%/.ssh

ssh-keygen -t rsa -b 4096

SET REMOTEHOST=your-user-name-on-host@host-fqdn-or-ip-goes-here

scp %USERPROFILE%\.ssh\id_rsa.pub %REMOTEHOST%:~/tmp.pub
ssh %REMOTEHOST% "mkdir -p ~/.ssh && chmod 700 ~/.ssh && cat ~/tmp.pub >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys &&  rm -f ~/tmp.pub"
```

vscode `ctrl + shift + p`, 搜索 remote

## 安装并设置 GO 环境 gopls

### 安装方式一

打开 VS Code 的设置, 搜索 `go.useLanguageServe`, 并勾选上. 默认情况下, Go 扩展会提示你安装 gopls.

如果长时间安装不上, 可以尝试手动安装, [官方安装指南](https://link.zhihu.com/?target=https%3A//github.com/golang/tools/blob/master/gopls/doc/user.md).

### 安装方式二

[https://github.com/golang/tools/tree/master/gopl](https://github.com/golang/tools/tree/master/gopls)下载, 然后使用 `go install github.com/golang/tools/cmd/gopls` 安装.

### 安装方式三

网络好, 或者设置 goproxy 代理后, 可以直接手动安装 gopls, 官方提示不要使用 -u.

`go get golang.org/x/tools/gopls@latest`

### 配置

装完之后, 添加如下的配置, 如果使用第一种安装方式, 那么第一行已经存在了:

```bash
"go.useLanguageServer": **true**,
"[go]": {
    "editor.snippetSuggestions": "none",
    "editor.formatOnSave": **true**,
    "editor.codeActionsOnSave": {
        "source.organizeImports": **true**}
},
"gopls": {
    "usePlaceholders": **true**, // add parameter placeholders when completing a function
    "wantCompletionDocumentation": **true** // for documentation in completion items
},
"files.eol": "\n", // formatting only supports LF line endings
```

如果你需要在不同的编辑器中使用 gopls, 请参考官方安装文档中的设置.

目前支持以下的编辑器:

- VSCode
- Vim / Neovim
- Emacs
- Acme
- Sublime Text