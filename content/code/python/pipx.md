---
title: "Pipx"
date: 2020-03-07T08:51:51+08:00
draft: true
---

## pipx

pipx会为安装的每一个包自动创建隔离环境，并自动设置环境变量，安装的包能够被执行，非常使用安装那些命令行程序，比如block、httpie、poetry。

首先在系统级python环境中安装pipx

```shell
pip install pipx
```
验证安装成功

```shell
pipx list
```

## 安装 poetry

```shell
pipx install poetry 
pipx list

pipx upgrade poetry
```

## 在项目中使用 poetry

在系统中只有一个poetry就够了，接下来在各个项目中使用即可。

这里有一个项目APIPractice， 之前是pip +requirement.txt 半手动的方式管理依赖，接下来改为poetry

### 1. 初始化 pyproject.toml

在项目的根目录，执行poetry是， 并一路回车

```shell
C:\Users\san\github\APIPractice>poetry init

This command will guide you through creating your pyproject.toml config.

Package name [apipractice]:
Version [0.1.0]:
Description []:  三木的接口自动化测试练习v1
Author []:
License []:
Compatible Python versions [^3.9]:

Would you like to define your main dependencies interactively? (yes/no) [yes]
You can specify a package in the following forms:
  - A single name (requests)
  - A name and a constraint (requests@^2.23.0)
  - A git url (git+https://github.com/python-poetry/poetry.git)
  - A git url with a revision (git+https://github.com/python-poetry/poetry.git#develop)
  - A file path (../my-package/my-package.whl)
  - A directory (../my-package/)
  - A url (https://example.com/packages/my-package-0.1.0.tar.gz)

Search for package to add (or leave blank to continue):

Would you like to define your development dependencies interactively? (yes/no) [yes]
Search for package to add (or leave blank to continue):

Generated file

[tool.poetry]
name = "apipractice"
version = "0.1.0"
description = "三木的接口自动化测试练习v1"
authors = ["dongfangtianyu <7629022+dongfangtianyu@users.noreply.github.com>"]

[tool.poetry.dependencies]
python = "^3.9"

[tool.poetry.dev-dependencies]

[build-system]
requires = ["poetry-core>=1.0.0"]
build-backend = "poetry.core.masonry.api"


Do you confirm generation? (yes/no) [yes]
```

