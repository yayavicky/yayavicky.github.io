---
title: "Pdf Combine"
date: 2021-11-30T09:34:29+08:00
draft: false
tags: 
    - "Tools"
    - "Script"
categories :                             
    - "Script"
    - "Documents"
keywords :                                 
    - "tools"
    - "script"

menu: footer # Optional, add page to a menu. Options: main, side, footer

# Theme-Defined params
# thumbnail: "img/placeholder.png" # Thumbnail image
lead: "Combine multiple pdf to one" # Lead text
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

```python
import PyPDF2,os
pdflist=[]
path= "D:/temp/hebin/"
dirs=os.listdir(path)
for filename in dirs:
    if filename.endswith('.pdf'):
        pdflist.append(filename)
pdflist.sort(key=str.lower)#按照字母顺序对列表元素排序
pdfwriter=PyPDF2.PdfFileWriter()
for filename in pdflist:
    pdffile=open(path+filename,'rb')
    pdfreader=PyPDF2.PdfFileReader(pdffile)
    for page in range(1,pdfreader.numPages):#去除封面
        pagepdf=pdfreader.getPage(page)#获取页面
        pdfwriter.addPage(pagepdf)#添加页面
pdfoutput=open('D:/temp/hebing.pdf','wb')
pdfwriter.write(pdfoutput)
pdfoutput.close()
```


```python
import PyPDF2
import os


def get_file_list(org_path):
    pdf_list = []
    file_list = os.listdir(org_path)
    for file_name in file_list:
        if file_name.lower().endswith('.pdf'):
            pdf_list.append(file_name)
    pdf_list.sort(key=str.lower)
    pdf_list = [os.path.join(org_path, item) for item in pdf_list]
    return pdf_list


def write_pdf(org_pdfs, out_pdf):
    pdf_writer = PyPDF2.PdfFileWriter()
    org_handle_list = []
    for pdf_file in org_pdfs:
        pdf_handle = open(pdf_file, 'rb')
        org_handle_list.append(pdf_handle)

        pdf_reader = PyPDF2.PdfFileReader(pdf_handle)
        for page_index in range(0, pdf_reader.numPages):
            print(f"file name-->{pdf_file}, page-->{page_index}")
            page_pdf = pdf_reader.getPage(page_index)
            pdf_writer.addPage(page_pdf)

    with open(out_pdf, 'wb') as pdf_out:
        pdf_writer.write(pdf_out)

    for handle in org_handle_list:
        handle.close()


pdf_files = get_file_list(r"D:\temp\hebin")
write_pdf(pdf_files, r"D:\temp\hebin.pdf")
```

```python
import os
from win32com import client
 
def doc2pdf(doc_name, pdf_name):
    try:
        word = client.DispatchEx("Word.Application")
        if os.path.exists(pdf_name):
            os.remove(pdf_name)
        worddoc = word.Documents.Open(doc_name, ReadOnly=1)
        worddoc.SaveAs(pdf_name, FileFormat=17)
        worddoc.Close()
        return pdf_name
    except:
        return 1
def main():
    print('开始转换，请稍等。。。')
    path=os.getcwd()
    files = os.scandir(path)
    files = [i for i in files if '.doc' in os.path.basename(i)]
    # print(files)
    for i in files:
        input = os.path.abspath(i)
        output = f'{path}\\{os.path.basename(i).split(".")[0]}.pdf'
        # print(output)
        rc = doc2pdf(input, output)
        if rc:
            print(os.path.basename(i),'转换成功')
        else:
            print(os.path.basename(i),'转换失败')
 
if __name__ == '__main__':
    main()
```