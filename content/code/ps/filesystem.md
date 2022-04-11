---
title: "Filesystem"
date: 2022-03-29T08:47:29+08:00
draft: true
---



+ 管理员需要执行许多涉及文件系统的任务。
+ 文件系统是一个层次结构信息模型。

## 1. 文件系统命令概览

别名|	描述	|命令
--  | -- | --
cp, cpi	 |复制文件或者目录 |	Copy-Item
Dir, ls, gci	|列出目录的内容	|Get-Childitem
type, cat, gc	|基于文本行来读取内容	|Get-Content
gi	|获取指定的文件或者目录	|Get-Item
gp	|获取文件或目录的属性	|Get-ItemProperty
ii	|使用对应的默认windows程序运行文件或者目录	|Invoke-Item
—	|连接两个路径为一个路径	| Join-Path
mi, mv, move	|移动文件或者目录	|Move-Item
ni	|创建新文件或者目录|	New-Item
ri, rm, rmdir,del, erase, rd	|删除空目录或者文件|	Remove-Item
rni, ren	|重命名文件或者路径	|Rename-Item
rvpa	|处理相对路径或者包含通配符的路径	|Resolve-Path
sp	|设置文件或路径的属性	|Set-ItemProperty
Cd,chdir, sl	|更改当前目录的位置	|Set-Location
—	|提取路径的特定部分，例如父目录，驱动器，文件名	|Split-Path
—	|测试指定的路径是否存在	|Test-Path


## 2. 访问文件和目录

`Get-ChildItem` 列出目录的内容。预定义的别名为Dir和ls，`Get-ChildItem`执行了一些很重要的任务：

+ 显示目录内容
+ 递归地搜索文件系统查找确定的文件
+ 获取文件和目录的对象
+ 把文件传递给其它命令，函数或者脚本

>+ Windows管理员一般在实践中，使用 `Get-ChildItem`的别名Dir。
>+ `ls`（来自UNIX家族）也可以代替下面例子中的Dir或者`Get-ChildItem`。

### 列出目录的内容

```powershell
PS D:\> dir *.txt


    目录: D:\


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----         2021/8/16     15:45             76 wifi.txt


PS D:\> ls *.txt


    目录: D:\


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----         2021/8/16     15:45             76 wifi.txt
```

Dir甚至能支持数组，能让你一次性列出不同驱动器下的内容。下面的命令会同时列出 PowerShell 根目录下的PowerShell脚本和Windows根目录下的所有日志文件。

```powershell
Dir $pshome\*.ps1, $env:windir\*.log

dir D:\log\*.log , $env:windir\*.log


    目录: D:\log


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----         2022/3/13     17:53           4760 info_2022-03-13.log
-a----         2022/3/22     16:26           1588 info_2022-03-22.log


    目录: C:\WINDOWS


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----         2021/8/16     16:01            753 comsetup.log
-a----         2022/1/28     16:12         199416 DPINST.LOG
-a----        2020/11/19      7:59           2885 DtcInstall.log
-a----        2020/11/18     23:48           1380 lsasetup.log
-a----         2022/3/29      8:02         168002 PFRO.log
-a----         2022/3/18      8:33           2440 setupact.log
-a----         2021/8/16     15:57              0 setuperr.log
-a----         2022/1/28     16:12            606 Synaptics.log
-a----         2022/1/28     16:12           2424 Synaptics.PD.log
-a----        2021/10/16      8:22           5613 unsu.log
-a----         2022/3/29      9:01            276 WindowsUpdate.log

```

只对一个目录下的项目名称感兴趣，使用-Name参数，Dir就不会获取对象(Files和directories)，只会以纯文本的形式返回它们的名称。

```powershell
Dir -name
```

>一些字符在PowerShell中有特殊的意义，比如方括号。方括号用来访问数组元素的。这也就是为什么使用文件的名称会引起歧义。当你使用-literalPath参数来指定文件的路径时，所有的特殊字符被视为路径片段，PowerShell解释器也不会处理。
>Dir 默认的参数为`-Path`。假如你当前文件夹下有个文件名为`.\a[0].txt`，因为方括号是PowerShell中的特殊字符，会解释器被解析。为了能正确获取到`.\a[0].txt`的文件信息，此时可以使用`-LiteralPath`参数，它会把你传进来的值当作纯文本。



### 递归搜索整个文件系统

```powershell
# ps 2.0 不能正确工作
Dir *.ps1 -recurse

Dir $home\d* -recurse
```

> 2.0不能工作解析：
>
> Dir总是会获取目录中的内容为文件对象或者目录对象。如果你设置了-recurse开关，Dir会递归遍历目录对象。但是你在上面的例子中使用的通配符只获取扩展名为ps1的文件，没有目录，所以-recurse会跳过。这个概念刚开始使用时可能有点费解，但是下面的使用通配符例子能够递归遍历子目录，正好解释了这点。



### 过滤和排除标准

```powershell
Dir $home -filter *.ps1 -recurse

Dir $home -include *.ps1 -recurse
```

`-filter`的执行效率明显高于`-include`：

```powershell
(Measure-Command {Dir $home -filter *.ps1 -recurse}).TotalSeconds
4,6830099
(Measure-Command {Dir $home -include *.ps1 -recurse}).TotalSeconds
28,1017376
```

`-include`支持**正则表达式**,从内部实现上就更加复杂

`-filter`只支持**简单的模式匹配**

使用`-include`进行更加复杂的过滤

```powershell
# -filter 查询所有以 "[A-F]"打头的脚本文件，屁都没找到
Dir $home -filter [a-f]*.ps1 -recurse
# -include 能够识别正则表达式，所以可以获取a-f打头，以.ps1收尾的文件
Dir $home -include [a-f]*.ps1 -recurse
```

与`-include`相反的是`-exclude`。在你想排除特定文件时，可以使用`-exclude`。不像-filter，`-include`和`-exclude`还支持数组，能让你获取你的家目录下所有的图片文件。

```powershell
Dir $home -recurse -include *.bmp,*.png,*.jpg, *.gif
```

> 不要混淆了 `-filter` 和 `-include`。选择这两个参数中的其中一个：**具体为当你的过滤条件没有正则表达式时，使用-filter，可以显著提高效率**。



> 不能使用 `filters` 在Dir中，列出确定大小的文件列表。因为Dir的限制条件只在文件和目录的名称级别。如果你想使用其它标准来过滤文件，可以尝试 `Where-Object`。



获取 100MB 以上文件



```powershell
Dir $home -recurse | Where-Object { $_.length -gt 100MB }
```



### 获取文件和目录的内容

Dir直接获取一个单独的文件，因为Dir会返回一个目录下所有的文件和目录对象。下面的例子会得到这个文件的FileInfo信息：

```powershell
$file = dir D:\CDriver\UltraISO.exe
$file |Format-List *


PSPath            : Microsoft.PowerShell.Core\FileSystem::D:\CDriver\UltraISO.exe
PSParentPath      : Microsoft.PowerShell.Core\FileSystem::D:\CDriver
PSChildName       : UltraISO.exe
PSDrive           : D
PSProvider        : Microsoft.PowerShell.Core\FileSystem
PSIsContainer     : False
Mode              : -a----
VersionInfo       : File:             D:\CDriver\UltraISO.exe
                    InternalName:     UltraISO
                    OriginalFilename: ultraiso.exe
                    FileVersion:      9.3.0.2612
                    FileDescription:  UltraISO Premium
                    Product:          UltraISO Premium
                    ProductVersion:   V9.3
                    Debug:            False
                    Patched:          False
                    PreRelease:       False
                    PrivateBuild:     False
                    SpecialBuild:     False
                    Language:         英语(美国)

BaseName          : UltraISO
Target            : {}
LinkType          :
Name              : UltraISO.exe
Length            : 1056256
DirectoryName     : D:\CDriver
Directory         : D:\CDriver
IsReadOnly        : False
Exists            : True
FullName          : D:\CDriver\UltraISO.exe
Extension         : .exe
CreationTime      : 2022/3/29 13:49:42
CreationTimeUtc   : 2022/3/29 5:49:42
LastAccessTime    : 2022/3/29 18:02:07
LastAccessTimeUtc : 2022/3/29 10:02:07
LastWriteTime     : 2022/3/29 13:49:42
LastWriteTimeUtc  : 2022/3/29 5:49:42
Attributes        : Archive

```



Get-Item是访问单个文件的另外一个途径， 下面的3条命令都会返回同样的结果：你指定的文件的文件对象。

```
$file = Dir D:\CDriver\UltraISO.exe
$file = Get-Childitem D:\CDriver\UltraISO.exe
$file = Get-Item D:\CDriver\UltraISO.exe
```



但是在访问目录而不是文件时，`Get-Childitem` 和 `Get-Item`表现迥异。

+ Get-Item 获取的是目录对象本身

### 向命令，函数和文件脚本传递文件

因为**Dir**的结果中返回的是独立的文件或目录对象，Dir可以将这些对象直接交付给其它命令或者你自己定义的函数与脚本。这也使得Dir成为了一个非常重要的的**选择命令**。使用它你可以非常方便地在一个驱动盘下甚至多个驱动盘下递归查找特定类型的所有文件。

要做到这点，在管道中使用 `Where-Object` 来处理Dir返回的结果，然后再使用 `ForEach-Object`，或者你自定义的管道过滤。

**小知识**:你还可以将多个Dir 命令执行的结果结合起来。在下面的例子中，两个分开的Dir命令，产生两个分开的文件列表。然后PowerShell将它们结合起来发送给管道进行深度处理。这个例子获取Windows目录和安装程序目录下的所有的dll文件，然后返回这些dll文件的名称，版本，和描述：



```powershell
$list1 = Dir $env:windir\system32\*.dll
$list2 = Dir $env:programfiles -recurse -filter *.dll
$totallist = $list1 + $list2
$totallist | ForEach-Object {
	$info =
		[system.diagnostics.fileversioninfo]::GetVersionInfo($_.FullName);
		"{0,-30} {1,15} {2,-20}" -f $_.Name, `
		$info.ProductVersion, $info.FileDescription
}
```

因为Dir获取的文件和目录是一样的，有时限制结果中只包含文件或者只包含目录很重要。有很多途径可以做到这点。

可以验证返回对象的属性，PowerShell PSIsContainer属性，或者对象的类型。



```powershell
# 只列出目录::
Dir | Where-Object { $_ -is [System.IO.DirectoryInfo] }
Dir | Where-Object { $_.PSIsContainer }
Dir | Where-Object { $_.Mode.Substring(0,1) -eq "d" }
# 只列出文件:
Dir | Where-Object { $_ -is [System.IO.FileInfo] }
Dir | Where-Object { $_.PSIsContainer -eq $false}
Dir | Where-Object { $_.Mode.Substring(0,1) -ne "d" }
```

前面的例子（识别对象类型）是目前速度最快的，而后面的（文本比较）比较复杂和低效。

Where-Object也可以根据其它属性来过滤。

比如下面的例子通过管道过滤2007年5月12日后更改过的文件：

```powershell
Dir | Where-Object { $_.CreationTime -gt [datetime]::Parse("May 12, 2007") }
```

使用相对时间获取2周以内更改过的文件：

```powershell
Dir | Where-Object { $_.CreationTime -gt (Get-Date).AddDays(-14) }
```



## 3. 导航文件系统

**Get-Location**命令获取当前工作的目录

如果你想导航到文件系统的另外一个位置，可以使用**Set-Location**或者它的别名**

**用于指定相对路径的四个重要的特殊字符** 


| 字符 | 意义         | 示例  | 示例描述                     |
| ---- | ------------ | ----- | ---------------------------- |
| `.`  | 当前目录     | Ii .  | 用资源浏览器打开当前目录     |
| `..` | 父目录       | Cd .. | 切换到父目录                 |
| `\`  | 驱动器根目录 | Cd \  | 切换到驱动器的顶级根目录     |
| `~`  | 家目录       | Cd ~  | 切换到PowerShell初始化的目录 |



### 相对路径转换成绝对路径 `Resolve-Path`

```powershell
 Resolve-Path .\UltraISO.exe

Path
----
D:\CDriver\UltraISO.exe

```



> Resolve-Path命令只有在文件确实存在时，才会有效。如果你的当前文件夹中没有一个名为 `UltraISO.exe` 的是，Resolve-Path报错。

> 指定的路径中包含了通配符，Resolve-Path还可以返回多个结果



Resolve-Path可以在下行函数中扮演选择过滤器的的角色



```powershell
notepad.exe (Resolve-Path  $pshome\types.ps1xml).providerpath
```

如果没有符合标准的文件，`Resolve-Path`会抛出一个异常，记录在`$?`变量中，在错误发生时表达式`!$?`一直会统计，在True的情况下，代表可能没找到文件。



```powershell
function edit-file([string]$path = $(Throw "请输入相对路径!")) {
    # 处理相对路径，并抑制错误
    $files = Resolve-Path $path -ea SilentlyContinue
    # 验证是否有错误产生:
    if (!$?) {
        # 如果是，没有找到符合标准的文件，给出提醒并停止：
        "没有找到符合标准的文件.";
        break
    }
    # 如果返回结果为数组，表示有多个文件:
    if ($files -is [array]) {
        # 此种情况下，列出你想打开的文件:
        Write-Host -ForegroundColor "Red" -BackgroundColor "White" `
            "你想打开这些文件吗?"
        foreach ($file in $files) {
            "- " + $file.Path
        }
 
        # 然后确认这些文件是否为用户想打开的：
        $yes = ([System.Management.Automation.Host.ChoiceDescription]"&yes")
        $no = ([System.Management.Automation.Host.ChoiceDescription]"&no")
        $choices = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no)
        $result = $host.ui.PromptForChoice('Open files', 'Open these files?', $choices, 1)
        # 如果用户确认，使用"&"操作符启动所有的文件
        if ($result -eq 0) {
            foreach ($file in $files) {
                & $file
            }
        }
    }
    else {
        # 如果是单个文件，可以直接使用"&"启动：
        & $files
    }
}
```

### 保存目录位置

当前的目录可以使用 `Push-Location` 命令保存到目录堆栈的顶部，每一个 `Push-Location` 都可以将新目录添加到堆栈的顶部。使用 `Pop-Location` 可以返回。

因此，如果你要运行一个任务，不得不离开当前目录，可以在运行任务前将用`Push-Location`存储当前路径，然后运行结束后再使用`Pop-Location`返回到当前目录。`cd $home`总是会返回到你的家目录，`Push-Location` 和 `Pop-Location`支持堆栈参数。

可以创建很多堆栈，比如一个任务，一个堆栈。

+ `Push-Location -stack job1`会把当前目录保存到 `job1`堆栈中，而不是标准堆栈中。
+ 想重新回到这个位置时，也需要在Pop-Location中指定这个参数-stack job1。

### 查找特殊的目录

Windows使用了很多特殊的目录，根据系统的安装，可能稍有不同。一些非常重要的目录的路径同时也保存在Windows环境变量中，这样PowerShell 可以非常方便和清晰的访问它们。你也可以使用.NET framework中的Environment类去访问其它特殊目录。



**存储在环境变量中的Windows****特殊目录** 


| 特殊目录                                  | 描述                           | 示例                    |
| -------------------------------- | ------------------------------ | ----------------------- |
| Application data                          | 存储在本地机器上的应用程序数据 | $env:localappdata       |
| User profile                              | 用户目录                       | $env:userprofile        |
| Data used incommon                        | 应用程序公有数据目录           | $env:commonprogramfiles |
| Public directory                          | 所有本地用户的公有目录         | $env:public             |
| Program directory                         | 具体应用程序安装的目录         | $env:programfiles       |
| Roaming Profiles                          | 漫游用户的应用程序数据         | $env:appdata            |
| Temporary files(private)                  | 当前用户的临时目录             | $env:tmp                |
| Temporary files                           | 公有临时文件目录               | $env:temp               |
| Windows directory                         | Windows系统安装的目录          | $env:windir             |

```powershell
# 在桌面上创建一个快捷方式:
$path = [Environment]::GetFolderPath("Desktop") + "\EditorStart.lnk"
$comobject = New-Object -comObject WScript.Shell
$link = $comobject.CreateShortcut($path)
$link.targetpath = "notepad.exe"
$link.IconLocation = "notepad.exe,0"
$link.Save()
```

Sepcial Folder



```powershell
[System.Environment+SpecialFolder] | Get-Member -static -memberType Property | select -ExpandProperty Name
```

预览所有`GetFolderPath()`支持的目录内容，可以使用下面的例子：

```powershell
[System.Environment+SpecialFolder] |
Get-Member -static -memberType Property |
ForEach-Object { "{0,-25}= {1}" -f $_.name, [Environment]::GetFolderPath($_.Name) }
```

### 构造路径

路径名称由文本构成，能让你随心所欲地构造他们。你也应当看到了上面例子中构造用户桌面快捷方式的过程了：

```
path = [Environment]::GetFolderPath("Desktop") + "\file.txt"
$path
C:\Users\mosser\Desktop\file.txt
```

一定要确保你的路径中的反斜杠个数正确。这也就是为什么前面的例子中在file.txt前面使用了一个反斜杠。还有一个更可靠的方式，就是使用命令 Join-Path方法，或者.NET中的Path静态类。



```powershell
path = Join-Path ([Environment]::GetFolderPath("Desktop")) "test.txt"
$path
C:\Users\mosser\Desktop\test.txt
$path = [System.IO.Path]::Combine([Environment]::`
GetFolderPath("Desktop"), "test.txt")
$path
C:\Users\mosser\Desktop\test.txt
```

Path类还包含了许多用来合并或者获取目录特定信息的额外方法。你只需要在下面表格中列出的方法中前加`[System.IO.Path]::`，比如：

```powershell
[System.IO.Path]::ChangeExtension("test.txt", "ps1")
test.ps1
```

 **构造路径的方法**   


| **方法**                        | **描述**                                           | **示例**                                          |
| ------------------------------- | -------------------------------------------------- | ------------------------------------------------- |
| `ChangeExtension()`           | 更改文件的扩展名                                   | *ChangeExtension(“test.txt”, “ps1”)*              |
| `Combine()`                     | 拼接路径字符串; 对应Join-Path                      | *Combine(“C:\test”, “test.txt”)*                  |
| `GetDirectoryName()`            | 返回目录对象：对应Split-Path -parent               | *GetDirectoryName(“c:\test\file.txt”)*            |
| `GetExtension()`                | 返回文件扩展名                                     | *GetExtension(“c:\test\file.txt”)*                |
| `GetFileName()`                 | 返回文件名：对应Split-Path -leaf                   | *GetFileName(“c:\test\file.txt”)*                 |
| `GetFileNameWithoutExtension()` | 返回不带扩展名的文件名                             | *GetFileNameWithoutExtension(“c:\test\file.txt”)* |
| `GetFullPath()`                 | 返回绝对路径                                       | *GetFullPath(“.\test.txt”)*                       |
| `GetInvalidFileNameChars()`     | 返回所有不允许出现在文件名中字符                   | *GetInvalidFileNameChars()*                       |
| `GetInvalidPathChars()`         | 返回所有不允许出现在路径中的字符                   | *GetInvalidPathChars()*                           |
| `GetPathRoot()`                 | 返回根目录：对应Split-Path -qualifier              | *GetPathRoot(“c:\test\file.txt”)*                 |
| `GetRandomFileName()`           | 返回一个随机的文件名                               | *GetRandomFileName()*                             |
| `GetTempFileName()`             | 在临时目录中返回一个临时文件名                     | *GetTempFileName()*                               |
| `GetTempPath()`                 | 返回临时文件目录                                   | *GetTempPath()*                                   |
| `HasExtension()`                | 如果路径中包含了扩展名，则返回True                 | *HasExtension(“c:\test\file.txt”)*                |
| `IsPathRooted()`                | 如果是绝对路径，返回为True; Split-Path -isAbsolute | *IsPathRooted(“c:\test\file.txt”)*                |



## 4. 使用目录和文件工作

`Get-ChildItem` 和 `Get-Item` 命令可以获取已经存在的文件和目录。你也可以创建自己的文件和目录，重命名它们，给它们填充内容，复制它们，移动它们，当然也可以删除它们。

### 创建新目录

创建一个新目录最方便的方式是使用MD函数，它内部调用的是 `New-Item` 命令，指定参数`–type` 的值为“Directory”：

```powershell
md Test1

New-Item Test2 -type Directory

# 一次性创建多层子目录，如果指定的目录不存在，PowerShell会自动创建这些目录
md test\subdirectory\somethingelse
```



### 创建新文件

```powershell
New-Item "new file.txt" -type File
```

文件通常会在你保存数据时，自动被创建。因为空文件一般没多大用处。此时重定向和 `Out-File`，`Set-Content`这两个命令可以帮助你：

```powershell
Dir > info1.txt
.\info1.txt
Dir | Out-File info2.txt
.\info2.txt
Dir | Set-Content info3.txt
.\info3.txt
Set-Content info4.txt (Get-Date)
.\info4.txt
```

操作上**重定向**和**Out-File**非常的类似：

+ 当PowerShell转换管道结果时，文件的内容就像它在控制台上面输出的一样。
+ Set-Content呢，稍微有所不同。它在文件中只列出目录中文件的名称列表,因为在你使用Set-Content时，PowerShell不会自动将对象转换成文本输入。相反，Set-Content会从对象中抽出一个标准属性。上面的情况下，这个属性就是Name了。

```powershell
Dir | ConvertTo-HTML | Out-File report1.htm
.\report1.htm
Dir | ConvertTo-HTML | Set-Content report2.htm
.\report2.htm

# 选择对象属性后转html
Dir | Select-Object name, length, LastWriteTime |
ConvertTo-HTML | Out-File report.htm
.\report.htm
```

在重定向的过程中，控制台的编码会自动指定特殊字符在文本中应当如何显示。你也可以在使用**Out-File**命令时，使用-encoding参数来指定。

> 结果导出为逗号分割符列表，可以使用 `Export-CSV` 代替 `Out-File`。



可以使用**双重定向**和**Add-Content**向一个文本文件中追加信息



```powershell
Set-Content info.txt "First line"
"Second line" >> info.txt
Add-Content info.txt "Third line"
Get-Content info.txt
First Line
S e c o n d L i n e
Third line
```

> 双箭头重定向可以工作，但是文本中显示的字符有间隔。重定向操作符通常使用的是控制台的字符集，如果你的文本中碰巧同时包含了ANSI和Unicode字符集，可能会引起意外的结果。相反，使用 `Set-Content`，`Add-Content` 和 `Out-File` 这几条命令，而不使用重定向，可以有效地规避前面的风险。这三条命令都支持 `-encoding` 参数，你可以用它来选择字符集。



### 创建新驱动器

PowerShell允许你创建新的驱动器。并且不会限制你只创建基于网络的驱动器。你还可以使用驱动器作为你的文件系统中重要目录，甚至你自定义的文件文件系统的一个方便的快捷方式。

使用 `New-PSDrive` 命令来创建一个新的驱动器。可以像下面那样创建一个网络驱动器。



```powershell
New-PSDrive -name network -psProvider FileSystem -root \\127.0.0.1\share

Name           Used (GB)     Free (GB) Provider      Root                                               CurrentLocation
----           ---------     --------- --------      ----                                               ---------------
network                                FileSystem    \\127.0.0.1\share

PS>  dir network:


    目录: \\127.0.0.1\share


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----         2021/8/21     12:25        4196888 1.WIN7最新软改激活工具.zip
-a----         2021/3/23     13:58      514886017 kis15.0 不限计算机 不限时间 模块 10用户.rar
-a----         2021/12/8     12:57      381671656 pycharm-community-2021.1.exe
-a----        2021/11/30     10:02       38981797 Raspberry Pi Beginner's Guide.pdf
-a----         2021/12/1     13:16            187 raspi.list
-a----         2021/12/1     13:16            235 sources.list
-a----         2021/8/18     11:08       25387808 SourceTreeSetup-3.4.5.exe
-a----        2021/11/30     10:27       57700677 The Official Raspberry Pi Handbook 2021.pdf
-a----         2021/7/11     23:49       83340872 TIM3.3.8.22043.exe
-a----         2021/8/17     15:20        5183512 XunLeiWebSetup11.2.5.1778dl.exe

```

在工作目录中创建一个快捷方式也非常方便。下面的命令行会创建一个名为desktop: 和 docs:的驱动器，它可以代表你的”**桌面**“目录和Windows目录：“**我的文档**”。



```powershell
New-PSDrive desktop FileSystem `
([Environment]::GetFolderPath("Desktop")) | out-null
New-PSDrive docs FileSystem `
([Environment]::GetFolderPath("MyDocuments")) | out-null
```



使用 `Remove-PSDrive` 来删除你创建的驱动器。如果该驱动器正在使用则不能删除。注意在使用 `New-PSDrive` 和 `Remove-PSDrive` 创建或删除驱动器时，指定的字母不能包含冒号，但是在使用驱动器工作时必须指定冒号。
