---
title: "Python 虚拟环境"
date: 2020-02-02T15:41:52+08:00
draft: false
---

## 环境

1. Windows 10 
2. windows 则新增环境变量：`WORKON_HOME`
3. 安装virtualenvwrapper
	+ `pip install virtualenvwrapper-win`
4. 创建虚拟环境
	+ 语法 `mkvirtualenv [-a project_path] [-i package] [-r requirements_file] [virtualenv options] ENVNAME`


```shell
# 创建虚拟环境 virname
mkvirtualenv -r requirements.txt --python=python3.7.8 virname
mkvirtualenv testweb -p C:\Python\Python37\python.exe
```

5. 进入虚拟环境
   + `workon hotbar`
6. 退出虚拟环境
   + `deactivate`
7. 列出虚拟环境
   + workon
   + lsvirtualenv
8. 切换虚拟环境
   + workon another_env_name
9. 删除虚拟环境
   + rmvirtualenv hotbar
    

## pipenv

```shell
# 初始化虚拟环境（可自己指定python版本）
pipenv --python 3.7.8

# 激活当前项目虚拟环境
pipenv shell

# 安装开发依赖包
pipenv install black --dev

# 生成lock文件
pipenv lock
```
