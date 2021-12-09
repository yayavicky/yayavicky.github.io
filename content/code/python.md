---
title: "Python"
date: 2021-12-09T15:10:08+08:00
draft: false
tags: 
    - "Script"
    - "Code"
categories :                             
    - "Script"
    - "Code"
keywords :                                 
    - "code"
    - "script"

menu: footer # Optional, add page to a menu. Options: main, side, footer

# Theme-Defined params
# thumbnail: "img/placeholder.png" # Thumbnail image
lead: "Python Common Used" # Lead text
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

## 字典扩展类

原来需要这样用：`dic['website'] = 'taobao.com' `
有了这个类，可以这样用：`dic.websites = 'taobao.com' `

```python
class EasyAccessDict(dict):
    def __getattr__(self,name):
        if name in self:
            return self[name]
        n=easyaccessdict()
        super().__setitem__(name, n)
        return n
    def __getitem__(self,name):
        if name not in self:
            super().__setitem__(name,nicedict())
        return super().__getitem__(name)
    def __setattr__(self,name,value):
        super().__setitem__(name,value)
```