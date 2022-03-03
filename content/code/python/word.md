---
title: "Word"
date: 2022-03-02T09:35:54+08:00
draft: true
---

## 资料

+ [文档](https://www.osgeo.cn/python-docx/)
+ [word table 插入图片](https://www.sdk.cn/details/djgylbOGwjlobxAN1Z)

## Example

```python
# pip install python-docx
import pathlib
from docx import Document
from docx.shared import Inches, Pt

CurrentDir = pathlib.Path().cwd()
ImageDir = CurrentDir.joinpath("Pic")
WordDir = CurrentDir.joinpath("Word")

ImageDir.mkdir(parents=True, exist_ok=True)
WordDir.mkdir(parents=True, exist_ok=True)

StyleTableHead = dict(font_name='宋体', size=20, is_bold=True)

# code start

png1 = ImageDir.joinpath("hello1.png")

document = Document()

document.add_heading('设备领用人员列表', 0)


def chg_font(obj, font_name='微软雅黑', size=None, is_bold=False):
    obj.font.name = font_name

    # obj._element.rPr.rFonts.set(qn('w:eastAsia'), fontname)

    if size and isinstance(size, Pt):
        obj.font.size = size
    if isinstance(size, int):
        obj.font.size = Pt(size)

    obj.font.bold = is_bold


records = (
    ("小明", '101'),
    ("小红", '422'),
    ("韩梅梅", '631')
)

table = document.add_table(rows=1, cols=3)
hdr_cells = table.rows[0].cells
run = hdr_cells[0].paragraphs[0].add_run('姓名')
chg_font(run, **StyleTableHead)
run = hdr_cells[1].paragraphs[0].add_run('工号')
chg_font(run, **StyleTableHead)
run = hdr_cells[2].paragraphs[0].add_run('二维码')
chg_font(run, **StyleTableHead)

for p_name, p_id in records:
    row_cells = table.add_row().cells
    row_cells[0].text = str(p_name)
    row_cells[1].text = p_id
    row_cells[2].paragraphs[0].add_run().add_picture(png1.as_posix(), width=Inches(1.25))

document.add_page_break()

word_file = WordDir.joinpath('demo.docx')
document.save(word_file)

```
