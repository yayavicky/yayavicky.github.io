---
title: "Utf8bom"
date: 2021-12-03T08:46:17+08:00
draft: false
tags: 
    - "coding"
categories :                             
    - "File Coding"
keywords :                                 
    - "coding"

#menu: main # Optional, add page to a menu. Options: main, side, footer

# Theme-Defined params
# thumbnail: "img/placeholder.png" # Thumbnail image
lead: "Windows BOM Coding" # Lead text
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

UTF-8 + BOM编码方式一般会在windows操作系统中出现，比如WINDOWS自带的记事本等软件，在保存一个以UTF-8编码的文件时，会在文件开始的地方插入三个不可见的字符（`0xEF` `0xBB` `0xBF`，即BOM）。它是一串隐藏的字符，用于让记事本等编辑器识别这个文件是否以UTF-8编码。

```python
import os

def strip_remove_65279(file_path):
    with open(file_path, 'r', encoding='utf-8') as f:
        lines = f.readlines()
        dir_name, file_full_name = os.path.split(file_path)
        file_name, extension = os.path.splitext(file_full_name)
        new_file = os.path.join(dir_name, file_name + "_strip" + extension)
        with open(new_file, 'a', encoding='utf-8') as ff:
            for line in lines:
                line = line.replace(chr(65279), '')
                ff.write(line)


def replace_remove_65279(file_path):
    with open(file_path, 'r', encoding='utf-8') as f:
        lines = f.readlines()

    with open(file_path, 'w', encoding='utf-8') as ff:
        for line in lines:
            line = line.replace(chr(65279), '')
            ff.write(line)

```
