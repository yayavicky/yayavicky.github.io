---
title: "Qrcode"
date: 2018-03-02T08:34:22+08:00
draft: false
tags: 
    - "Code"
categories :                                 
    - "Code"
keywords :                                 
    - "code"

#menu: main # Optional, add page to a menu. Options: main, side, footer

# Theme-Defined params
# thumbnail: "img/placeholder.png" # Thumbnail image
lead: "生成二维码" # Lead text
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

+ [python-qrcode](https://github.com/lincolnloop/python-qrcode)


## 安装库

```shell
pip install qrcode
```

## Example

```python
qr = qrcode.QRCode(version=3,
                error_correction=qrcode.constants.ERROR_CORRECT_Q,
                box_size=20,
                border=4, )
crypt_str = CryptTool.content_encrypt_str(input_str)    
qr.add_data(crypt_str)
qr.make(fit=True)

img = qr.make_image(fill_color='black', back_color='white')
img.show()
img.save(png_name)
```

1. version参数为一个取值范围1-40的整数（或字符串），用于控制二维码的尺寸。
    最小的尺寸1是一个21格*21格的矩阵。
    该值设置为None（默认），并且调用make函数时fit参数为True（默认）时，模块会自己决定生成二维码的尺寸。
2. error_correction
    + ERROR_CORRECT_L：大约7%或者更少的错误会被更正。
    + ERROR_CORRECT_M：默认值，大约15%或者更少的错误会被更正。
    + ERROR_CORRECT_Q：大约25%或者更少的错误会被更正。
    + ERROR_CORRECT_H：大约30%或者更少的错误会被更正。
3. box_size参数控制二维码中每个格子的像素数，默认为10。
4. border参数控制边框（二维码四周留白）包含的格子数（默认为4，是标准规定的最小值）。
5. image_factory参数是一个继承于qrcode.image.base.BaseImage的类，用于控 make_image函数返回的图像实例。
    image_factory参数可以选择的类保存在模块根目录的image文件夹下。
    image文件夹里面有五个.py文件，
    + `__init__.py`
    + `base.py`。
    + `pil.py`提供了默认的`qrcode.image.pil.PilImage`类。
    + `pure.py`提供了`qrcode.image.pure.PymagingImage`类。
    + `svg.py`提供了`SvgFragmentImage`、`SvgImage`和`SvgPathImage`三个类。

## SVG格式的二维码

+ qrcode可以生成三种不同的svg图像
    1. 用路径表示的svg, svg.py中的SvgPathImage
    2. 用矩形集合表示的完整svg文件, svg.py中的 SvgImage
    3. 用矩形集合表示的svg片段, svg.py中的 SvgFragmentImage
    
第一种用路径表示的svg其实就是矢量图，可以在图像放大的时候保持图片质量，而另外两种可能会在格子之间出现空隙。

`qrcode.image.svg.SvgFillImage` 和`qrcode.img.svg.SvgPathFillImage`。分别继承自SvgImage和SvgPathImage。这两个并没有其他改变，只不过是默认把背景颜色设置为白色而已。

```python
import qrcode
import qrcode.image.svg

if method == 'basic':
    # Simple factory, just a set of rects.
    factory = qrcode.image.svg.SvgImage
elif method == 'fragment':
    # Fragment factory (also just a set of rects)
    factory = qrcode.image.svg.SvgFragmentImage
else:
    # Combined path factory, fixes white space that may occur when zooming
    factory = qrcode.image.svg.SvgPathImage

img = qrcode.make('Some data here', image_factory=factory)

```

### 二维码中放入LOGO

```python
from PIL import Image
import qrcode

# 初步生成二维码图像
qr = qrcode.QRCode(version=5,error_correction=qrcode.constants.ERROR_CORRECT_H,box_size=8,border=4)
qr.add_data("https://www.cnblogs.com")
qr.make(fit=True)

# 获得Image实例并把颜色模式转换为RGBA
img = qr.make_image()
img = img.convert("RGBA")

# 打开logo文件
icon = Image.open("favicon.jpg")

# 计算logo的尺寸
img_w,img_h = img.size
factor = 4
size_w = int(img_w / factor)
size_h = int(img_h / factor)

# 比较并重新设置logo文件的尺寸
icon_w,icon_h = icon.size
if icon_w >size_w:
    icon_w = size_w
if icon_h > size_h:
    icon_h = size_h
icon = icon.resize((icon_w,icon_h),Image.ANTIALIAS)

# 计算logo的位置，并复制到二维码图像中
w = int((img_w - icon_w)/2)
h = int((img_h - icon_h)/2)
icon = icon.convert("RGBA")
img.paste(icon,(w,h),icon)

# 保存二维码
img.save('createlogo.jpg')
```



