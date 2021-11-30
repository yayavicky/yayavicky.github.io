---
title: "Hugo"
date: 2021-11-16T11:53:29+08:00
draft: false

tags: 
    - "Tools"
    - "Web"
categories :                             
    - "Tec"
    - "Documents"
keywords :                                 
    - "hugo"
    - "web"

# menu: main # Optional, add page to a menu. Options: main, side, footer

# Theme-Defined params
# thumbnail: "img/placeholder.png" # Thumbnail image
lead: "How to use hugo to create a static website." # Lead text
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


## Windows install

```powershell
choco install hugo -y

choco install hugo-extended  -y

hugo help
```

## documents

+ [quickstart](https://www.gohugo.org/doc/overview/quickstart/)
+ [offical quickstart](https://gohugo.io/getting-started/quick-start/)

## public

软连接

```powershel
mklink /j d:\code\web\public d:\code\web\Notes\public
```

+ 本地预览的命令为 `hugo server -D`
+ 生成生产版 public 的命令为 `hugo`
+ 加上清理和压缩的参数，可以用 `hugo --gc --minify --cleanDestinationDir`。
+ 添加新页面 `hugo new name.md`

## 自动发布


1. 创建 yayavicky.github.io 仓库, public
2. 将 yayavicky.github.io.source 仓库克隆到本地，开始初始化 Hugo 系统：

```shell
# 克隆 source 仓库
git clone git@github.com:yayavicky/yayavicky.github.io.git


# 进入仓库
cd yayavicky.github.io./ 

# 在当前目录生成 Hugo 源码
hugo new site . 

# 为当前博客选取一个主题，你可以不执行这一命令使用默认的主题
#git submodule add https://github.com/halogenica/beautifulhugo.git themes/beautifulhugo 
git submodule add https://github.com/vimux/mainroad themes/mainroad

# 编辑 config.toml 配置文件，使 mainroad 主题生效
echo 'theme = "mainroad"' >> config.toml

# 此时你就可以运行预览效果
hugo serve

git add .
git commit -m "first commit"
git push -u origin main
#git branch -M main

```

### 配置 Github 自动构建发布 Actions 即可

>为 notes.github.io.source 仓库配置 Actions。


main.yml

```yaml
name: GitHub Pages

# Controls when the workflow will run
on: [push]


# A workflow run is made up of one or more jobs that can run sequentially or in parallel
jobs:
  # This workflow contains a single job called "build"
  build:
    # The type of runner that the job will run on
    runs-on: ubuntu-20.04
    concurrency:
      group: ${{ github.workflow }}-${{ github.ref }}
    

    # Steps represent a sequence of tasks that will be executed as part of the job
    steps:
      # Checks-out your repository under $GITHUB_WORKSPACE, so your job can access it
      - uses: actions/checkout@v2
        with:
          submodules: true
          fetch-depth: 0
          
      - name: Setup Hugo
        uses: peaceiris/actions-hugo@v2
        with:
          hugo-version: '0.85.0'
          # extended: true

      - name: Build
        run: hugo --minify

      - name: Deploy
        uses: peaceiris/actions-gh-pages@v3
        if: ${{ github.ref == 'refs/heads/main' }}
        with:
          github_token: ${{ secrets.DEPLOY_TOKEN }}
          keep_files: false
          publish_dir: ./public
          publish_branch: gh-pages
```