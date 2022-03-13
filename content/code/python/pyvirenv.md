---
title: "Pyenv"
date: 2020-03-07T08:49:15+08:00
draft: true
---


市场上管理 Python 版本和环境的工具有很多，这里列举几个：

+ p：非常简单的交互式 python 版本管理工具。
+ pyenv：简单的 Python 版本管理工具。
+ Vex：可以在虚拟环境中执行命令。
+ virtualenv：创建独立 Python 环境的工具。
+ virtualenvwrapper：virtualenv 的一组扩展。

## virtualenv

由于 virtualenvwrapper 是 virtualenv 的一组扩展，所以如果要使用 virtualenvwrapper，就必须先安装 virtualenv。

```shell
$ pip install virtualenv

# 检查版本
$ virtualenv --version
```

### 创建

```shell
# 准备目录并进入
$ mkdir -p /home/wangbm/Envs
$ cd !$

# 创建虚拟环境（按默认的Python版本）
# 执行完，当前目录下会有一个my_env01的目录
$ virtualenv my_env01

# 你也可以指定版本
$ virtualenv -p /usr/bin/python2.7 my_env01
$ virtualenv -p /usr/bin/python3.6 my_env02

# 每次都要指定版本，相当麻烦
# 在Linux下，可以把这个选项写进入环境变量中
$ echo "export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python2.7" >> ~/.bashrc
```

### 进入/退出

```shell
$ cd /home/wangbm/Envs

# 进入
$ source my_env01/bin/activate

# 退出
$ deactivate
删除 删除虚拟环境，只需删除对应的文件夹就行了。并不会影响全局的Python和其他环境。

$ cd /home/wangbm/Envs
$ rm -rf my_env01
```


>注意： 创建的虚拟环境，不会包含原生全局环境的第三方包，其会保证新建虚拟环境的干净。

如果你需要和全局环境使用相同的第三方包。可以使用如下方法：

```shell
# 导出依赖包
$ pip freeze > requirements.txt

# 安装依赖包
$ pip install -r requirements.txt 
```


## virtualenvwrapper

virtualenv 虽然已经相当好用了，可是功能还是不够完善。

你可能也发现了，要进入虚拟环境，必须得牢记之前设置的虚拟环境目录，如果你每次按规矩来，都将环境安装在固定目录下也没啥事。但是很多情况下，人是会懒惰的，到时可能会有很多个虚拟环境散落在系统各处，你将有可能忘记它们的名字或者位置。

还有一点，virtualenv 切换环境需要两步，退出 -> 进入。不够简便。

为了解决这两个问题，virtualenvwrapper就诞生了。

### 安装

```shell
# 安装 - Linux
pip install virtualenvwrapper

# 安装 - Windows
pip install virtualenvwrapper-win
```

配置 先 find 一下 `virtualenvwrapper.sh` 文件的位置

```shell
sudo find / -name virtualenvwrapper.sh
/home/vicky/.local/bin/virtualenvwrapper.sh
```

若是 windows 则使用everything 查找 `virtualenvwrapper.bat` 脚本

```
C:\Python37\Scripts\virtualenvwrapper.bat
```


在~/.bashrc 文件新增配置

```
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/workspace
export VIRTUALENVWRAPPER_SCRIPT=/usr/bin/virtualenvwrapper.sh
export VIRTUALENVWRAPPER_SCRIPT=/home/vicky/.local/bin/virtualenvwrapper.sh

source /usr/bin/virtualenvwrapper.sh
```

windows 则新增环境变量：WORKON_HOME


基本语法：

`mkvirtualenv [-a project_path] [-i package] [-r requirements_file] [virtualenv options] ENVNAME`

常用方法

```
# 创建
$ mkvirtualenv my_env01

# 进入
$ workon my_env01

# 退出
$ deactivate

# 列出所有的虚拟环境，两种方法
$ workon
$ lsvirtualenv

# 在虚拟环境内直接切换到其他环境
$ workon my_env02

# 删除虚拟环境
$ rmvirtualenv my_env01
```

其他命令

```
# 列出帮助文档
$ virtualenvwrapper

# 拷贝虚拟环境
$ cpvirtualenv ENVNAME [TARGETENVNAME]

# 在所有的虚拟环境上执行命令
$ allvirtualenv pip install -U pip

# 删除当前环境的所有第三方包
$ wipeenv

# 进入到当前虚拟环境的目录
$ cdsitepackages

# 进入到当前虚拟环境的site-packages目录
$ cdvirtualenv

# 显示 site-packages 目录中的内容
$ lssitepackages
```

更多内容，可查看 官方文档 https://virtualenvwrapper.readthedocs.io/en/latest/command_ref.html



## WORKON_HOME

```py
pip install pipenv
pipenv install --python 3.7.8
pipenv shell
```



## ISSUE

### 1. UPX is not available

https://upx.github.io/



### 2. pyinstaller打包成exe后运行出错。报Failed to execute script XXXX

通过不带-w的参数打包在控制台看程序执行情况。



C:\Python37\Lib\site-packages\PySide2\__init__.py

```py
import sys
import os
dir_name = os.path.dirname(__file__)
plugin_path = os.path.join(dir_name, 'plugins', 'platforms')
os.environ['QT_QPA_PLATFORM_PLUGIN_PATH'] = plugin_path
```



D:\python\pyenv\M30G_HB_V1.0.1-LzumDEdF\Scripts\pyinstaller.exe --noconfirm --onefile --windowed --icon D:\yang\testcode\M30G_HB_V1.0.1\epds_logo.ico test_app.py