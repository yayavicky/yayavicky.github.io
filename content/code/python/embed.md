---
title: "Embed Python"
date: 2022-03-02T17:15:20+08:00
draft: true
---

## 文档

+ [embedded-distribution](https://docs.python.org/3.6/using/windows.html#embedded-distribution)
+ [python-3910](https://www.python.org/downloads/release/python-3910/)
+ [pip with embedded python](https://stackoverflow.com/questions/42666121/pip-with-embedded-python)
+ [TK install](https://zhuanlan.zhihu.com/p/77338198)


## Embed版本

1. 自带打包工具
2. 没有pip

## 添加pip

找到自己 `python-embedded` 文件夹下的 `python39._pth`

修改前

```txt
python39.zip
.

# Uncomment to run site.main() automatically
#import site
```

修改后

```txt
python39.zip
.

# Uncomment to run site.main() automatically
#import site
```

[下载 pip](https://pip.pypa.io/en/stable/installation/)

保存到 python-embedded文件夹下

```
full_path\python.exe get-pip.py
```

至此 pip已经塞到了python-embedded里面 与此同时setuptools&wheel也安装完成

```
full_path\Scripts\pip.exe install xxx

full_path\Scripts\pip.exe install xxx.whl
```


