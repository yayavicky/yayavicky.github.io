# CMD 文件夹权限处理

磁盘分区必须是 NTFS. FAT32不可用。



##  `cacls.exe` 

修改文件的访问控制表

```shell
cacls filename [/T] [/E] [/C] [/G username] [/R user[...]] [/P usererm[...]] [/D user [...]]
```



+ `cacls filename` 显示访问控制列表 ACL
+ T 更改当前目录及所有子目录中指定的文件的 ACL
+ E 编辑 ACL 而非替换
+ C 出现拒绝访问错误时继续
+ `/G username:perm` 赋予指定用户访问权限， perm 表示访问权限，具体为
  + R 读取
  + W 写入
  + C 更改、写入
  + F 完全控制
+ `/R user` 撤销指定用户访问权限，必须与 `/E` 配合使用
+ `/P user:perm` 替换指定用户访问权限， perm 同上，但多 `N` 选项，即 无
+ `/D user` 拒绝指定用户访问



## `icacls.exe`

### 1. 查看权限

```shell
icacls folder_path

icacls D:\log
D:\log BUILTIN\Administrators:(I)(F)
       BUILTIN\Administrators:(I)(OI)(CI)(IO)(F)
       NT AUTHORITY\SYSTEM:(I)(F)
       NT AUTHORITY\SYSTEM:(I)(OI)(CI)(IO)(F)
       NT AUTHORITY\Authenticated Users:(I)(M)
       NT AUTHORITY\Authenticated Users:(I)(OI)(CI)(IO)(M)
       BUILTIN\Users:(I)(RX)
       BUILTIN\Users:(I)(OI)(CI)(IO)(GR,GE)

已成功处理 1 个文件; 处理 0 个文件时失败
```

> 注意事项:
> 　　对于继承的声明要放到具体权限之前。例如: `(OI)(CI)(IO)(M)` 是对的，但 `(M)(OI)(CI)(IO)` 会提示无效的参数。



add test user

```shell
net user username password  /add
net user testabc 123456  /add
```

```shell
icacls name /save aclfile [/T] [/C] [/L] [/Q]
将匹配名称的文件和文件夹的 DACL 存储到 aclfile 中
以便将来与 /restore 一起使用。请注意，未保存 SACL、
所有者或完整性标签。

icacls directory [/substitute SidOld SidNew [...]] /restore aclfile
                 [/C] [/L] [/Q]
将存储的 DACL 应用于目录中的文件。
```


### 2. 授权

```shell
icacls D:\log\12 /grant username:(OI)(CI)(RX) /T
icacls D:\log\12 /grant testabc:(OI)(CI)(RX) /T

# 所有文件和文件夹
icacls D:\log\*.* /grant testabc:(OI)(CI)(RX) /T
```



删除部分权限

```shell
# 查看权限
icacls d:\log\12
d:\log\12 WIN10-DC1\testabc:(OI)(CI)(F)
          BUILTIN\Administrators:(I)(F)
          BUILTIN\Administrators:(I)(OI)(CI)(IO)(F)
          NT AUTHORITY\SYSTEM:(I)(F)
          NT AUTHORITY\SYSTEM:(I)(OI)(CI)(IO)(F)
          NT AUTHORITY\Authenticated Users:(I)(M)
          NT AUTHORITY\Authenticated Users:(I)(OI)(CI)(IO)(M)
          BUILTIN\Users:(I)(RX)
          BUILTIN\Users:(I)(OI)(CI)(IO)(GR,GE)
          

# 删除权限
icacls d:\log\12 /grant[:r]  testabc:(OI)(CI)(RX) /T
已处理的文件: d:\log\12
已处理的文件: d:\log\12\wifi.txt
已成功处理 2 个文件; 处理 0 个文件时失败

# 查看权限
icacls d:\log\12
d:\log\12 WIN10-DC1\testabc:(OI)(CI)(RX)
          BUILTIN\Administrators:(I)(F)
          BUILTIN\Administrators:(I)(OI)(CI)(IO)(F)
          NT AUTHORITY\SYSTEM:(I)(F)
          NT AUTHORITY\SYSTEM:(I)(OI)(CI)(IO)(F)
          NT AUTHORITY\Authenticated Users:(I)(M)
          NT AUTHORITY\Authenticated Users:(I)(OI)(CI)(IO)(M)
          BUILTIN\Users:(I)(RX)
          BUILTIN\Users:(I)(OI)(CI)(IO)(GR,GE)
```



`/grant[:r] sid:perm` 授予指定用户访问权限， 如果使用 `:r` 将替换以前授予的所有显式权限。



`/T` 指示在以该名称指定的目录下的所有匹配 文件 或目录 上 执行操作



### 3. 删除用户

```shell
icacls d:\log\12 /remove:g testabc /T
```

`/remove[:[g|d]] sid` 删除 ACL 中所有出现的SID

+ `:g` 将删除授予该 SID 的所有权限
+ `:d` 删除拒绝该 SID 的所有权限



### 4. 命令汇总

#### 1. 更改所有者

```shell
# 更改所有者
icacls file_or_folder /setowner username [/T] [/C] [/L] [/Q]

icacls d:\log\34  /setowner testabc  /T /C /L /Q
```

更改所有匹配名称的所有者。该选项不会强制更改所有身份；使用 takeown.exe 实用程序可实现该目的。



#### 2. 查找特定用户权限

```shell
icacls name /findsid sid  [/T] [/C] [/L] [/Q]
查找包含显式提及 SID 的 ACL 的所有匹配名称。

icacls d:\log\12 /findsid testabc  /T /C /L /Q
发现 SID: d:\log\12。
发现 SID: d:\log\12\wifi.txt。
已成功处理 2 个文件; 处理 0 个文件时失败
```



#### 3. 校验

查找其 ACL 不规范或长度与 ACE计数不一致的所有文件。

```shell
icacls name /verify [/T] [/C] [/L] [/Q]

icacls d:\log\12 /verify  /T /C /L /Q
```



#### 4. 重置

为所有匹配文件使用默认继承的 ACL 替换 ACL。

```shell
icacls name /reset [/T] [/C] [/L] [/Q]

icacls d:\log\12 /reset  /T /C /L /Q
```



#### 5. 指定权限

```shell
icacls name [/grant[:r] Sid:perm[...]]
       [/deny Sid:perm [...]]
       [/remove[:g|:d]] Sid[...]] [/T] [/C] [/L] [/Q]
       [/setintegritylevel Level:policy[...]]
```

+ `/grant[:r] Sid:perm`  授予指定的用户访问权限。
	如果使用 `:r`, 这些权限将替换以前授予的所有显式权限。
	如果不使用 `:r`，这些权限将添加到以前授予的所有显式权限。
	
+ `/deny Sid:perm`  显式拒绝指定的用户访问权限。
    将为列出的权限添加显式拒绝 ACE，
    并删除所有显式授予的权限中的相同权限。
    
+ `/remove[:[g|d]] Sid` 显式拒绝指定的用户访问权限。
    `:g`，将删除授予该 SID 的所有权限。
    `:d`，将删除拒绝该 SID 的所有权限。
    
+ `/setintegritylevel [(CI)(OI)]` 级别将完整性 ACE 显式添加到所有匹配文件。
	要指定的级别为以下级别之一:
	+ L[ow]
	
	+ M[edium]
	
	+ H[igh]
	
	  完整性 ACE 的继承选项可以优先于级别，但只应用于目录。

+ `/inheritance:e|d|r`
	+ `e`  启用继承
	+ `d`   禁用继承并复制 ACE
	+ `r`  删除所有继承的 ACE


>注意:
>+ Sid 可以采用数字格式或友好的名称格式。如果给定数字格式，那么请在 SID 的开头添加一个 `*`。
>+ `/T` 指示在以该名称指定的目录下的所有匹配文件/目录上执行此操作。
>+ `/C` 指示此操作将在所有文件错误上继续进行。仍将显示错误消息。
>+ `/L` 指示此操作在符号链接本身而不是其目标上执行。
>+ `/Q` 指示 icacls 应该禁止显示成功消息。



+  ICACLS 保留 ACE 项的规范顺序:
	1. 显式拒绝
	2. 显式授予
   3. 继承的拒绝
   4. 继承的授予
+ perm 是权限掩码，可以指定两种格式之一:
	1. 简单权限序列:
		+ N - 无访问权限
		+ F - 完全访问权限
		+ M - 修改权限
		+ RX - 读取和执行权限
		+ R - 只读权限
		+ W - 只写权限
		+ D - 删除权限
	2. 在括号中以逗号分隔的特定权限列表:
		+ DE - 删除
		+ RC - 读取控制
		+ WDAC - 写入 DAC
		+ WO - 写入所有者
		+ S - 同步
		+ AS - 访问系统安全性
		+ MA - 允许的最大值
		+ GR - 一般性读取
		+ GW - 一般性写入
		+ GE - 一般性执行
		+ GA - 全为一般性
		+ RD - 读取数据/列出目录
		+ WD - 写入数据/添加文件
		+ AD - 附加数据/添加子目录
		+ REA - 读取扩展属性
		+ WEA - 写入扩展属性
		+ X - 执行/遍历
		+ DC - 删除子项
		+ RA - 读取属性
		+ WA - 写入属性
	3. 继承权限可以优先于每种格式，但只应用于
        目录:
		+ `(OI)` - 对象继承
		+ `(CI)` - 容器继承
		+ `(IO)` - 仅继承
		+ `(NP)` - 不传播继承
		+ `(I)` - 从父容器继承的权限



#### 6. 例子

```shell
# 将 c:\windows 及其子目录下所有文件的 ACL 保存到 AclFile。
icacls c:\windows\* /save AclFile /T

# 将还原 c:\windows 及其子目录下存在的 AclFile 内所有文件的 ACL。
icacls c:\windows\ /restore AclFile

# 将授予用户对文件删除和写入 DAC 的管理员权限。
icacls file /grant Administrator:(D,WDAC)

# 将授予由 sid S-1-1-0 定义的用户对文件删除和写入 DAC 的权限。
icacls file /grant *S-1-1-0:(D,WDAC)

#递归移除某个文件夹及其子文件夹和文件的Users组权限
icacls.exe D:\1\ /inheritance:d  #关闭目录继承
icacls.exe D:\1\ /remove:g "Users"  #删除Users组权限


icacls D:\1\  /grant[:r] username:(OI)(CI)(M) /T
```

##  powershell

```shell
Get-Acl -Path <File or Folder Path> | Format-List
```



```powershell
# 文件权限
$account = "WINDATA1901\test"
$FileSystemRights = "FullControl"
$objType = [System.Security.AccessControl.AccessControlType]::Allow
$accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule ($account,$FileSystemRights,$objType)

$Folder = "D:\Test\test.txt"
$acl = Get-Acl $Folder
$acl.SetAccessRule($accessRule)

Set-Acl -Path $Folder -AclObject $acl
```

+ [InheritanceFlags Enum - microsoft](https://docs.microsoft.com/en-us/dotnet/api/system.security.accesscontrol.inheritanceflags?redirectedfrom=MSDN&view=net-6.0)
+ [PropagationFlags Enum - microsoft](https://docs.microsoft.com/en-us/dotnet/api/system.security.accesscontrol.propagationflags?redirectedfrom=MSDN&view=net-6.0)
+ [Setting Inheritance and Propagation flags with set-acl and powershell - stackoverflow](https://stackoverflow.com/questions/3282656/setting-inheritance-and-propagation-flags-with-set-acl-and-powershell)
+ Access Control Entries (ACEs)

```powershell
Get-Acl "d:\Test\test01.txt" | Set-Acl -Path "d:\Test\test02.txt"
```

```powershell
# 文件夹权限
$account = "WINDATA1901\test"
$FileSystemRights = "FullControl"
$InheritanceFlag = [System.Security.AccessControl.InheritanceFlags]::ObjectInherit
$PropagationFlag = [System.Security.AccessControl.PropagationFlags]::None
$objType = [System.Security.AccessControl.AccessControlType]::Allow

$accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule ($account,$FileSystemRights,$InheritanceFlag,$PropagationFlag,$objType)

$Folder = "d:\Test\"

$acl = Get-Acl $Folder
$acl.SetAccessRule($accessRule)

Set-Acl -Path $Folder -AclObject $acl
```



```powershell
PS D:\> (Get-Acl $env:windir).Access | Format-Table -wrap

           FileSystemRights AccessControlType IdentityReference   IsInherited       InheritanceFlags
           ---------------- ----------------- -----------------  -----------       ----------------
                  268435456             Allow CREATOR OWNER       False 		ContainerInherit, ObjectInherit
                  268435456             Allow NT AUTHORITY\SYSTEM  False ContainerInherit, ObjectInherit
        Modify, Synchronize             Allow NT AUTHORITY\SYSTEM                                          False                   None
                  268435456             Allow BUILTIN\Administrators                                       False ContainerInherit, Obje
                                                                                                                              ctInherit
        Modify, Synchronize             Allow BUILTIN\Administrators                                       False                   None
                -1610612736             Allow BUILTIN\Users                                                False ContainerInherit, Obje
                                                                                                                              ctInherit
ReadAndExecute, Synchronize             Allow BUILTIN\Users                                                False                   None
                  268435456             Allow NT SERVICE\TrustedInstaller                                  False       ContainerInherit
                FullControl             Allow NT SERVICE\TrustedInstaller                                  False                   None
ReadAndExecute, Synchronize             Allow APPLICATION PACKAGE AUTHORITY\ALL APPLICATION PACKAGES       False                   None
                -1610612736             Allow APPLICATION PACKAGE AUTHORITY\ALL APPLICATION PACKAGES       False ContainerInherit, Obje
                                                                                                                              ctInherit
ReadAndExecute, Synchronize             Allow APPLICATION PACKAGE AUTHORITY\所有受限制的应用程序包         False                   None
                -1610612736             Allow APPLICATION PACKAGE AUTHORITY\所有受限制的应用程序包         False ContainerInherit, Obje
                                                                                                                              ctInherit


```

## 增强工具 `xcals.exe`

在windows 2000资源工具包中，微软还提供了一个名为xcacls.exe的文件控制权限修改工具，其功能较cacls.exe更为强大，可以通过命令行设置所有可以在windows资源管理器中访问到的文件系统安全选项，我们可以从[windows - xcacls](http: //www.microsoft.com/windows2000/techinfo/reskit/tools/existing/xcacls-o.asp)下载，安装后即可使用。 

xcacls.exe命令的语法和参数与cacls.exe基本相同，但不同的是它通过显示和修改件的访问控制列表（acl）执行此操作。在“/g”参数后除保持原有的perm权限外，还增加了spec（特殊访问权限)的选项，另外还增加了“/y”的参数，表示禁止在替换用户访问权限时出现确认提示，而默认情况下，cacls.exe是要求确认的，这样在批处理中调用cacls.exe命令时，程序将停止响应并等待输入正确的答案，引入“/y”参数后将可以取消此确认，这样我们就可以在批处理中使用xcacls.exe命令了。 

### 1. 查看文件或文件夹的权限 

在“开始→运行”对话框或切换到命令提示符模式下，注意请事先将“c:\program files\resource kit”添加到“系统属性→高级→环境变量→系统变量”中，或者通过cd命令将其设置为当前路径，否则会提示找不到文件，然后键入如下命令： 

`xcacls C:\ruery `

此时，我们会看到图2所示的窗口，这里可以查看到所有用户组或用户对C:\ruery文件夹的访问控制权限，io表示此ace不应用于当前对象，ci表示从属窗口将继承此ace，oi表示从属文件将继承该ace，np表示从属对象不继续传播继承的ace，而每行末尾的字母表示不同级别的权限， 

+ f表示完全控制. 
+ c表示更改. 
+ w表示写入. 



### 2. 替换文件夹中的acl而不确认 

`xcacls C:\ruery /g administrator:rw/y`

以上命令将替换C:\ruery文件夹中所有文件和文件夹的acl，而不扫描子文件夹，也不会要求用户确认. 

### 3. 赋予某用户对文件夹的控制权限 

`xcacls h:\temp /g administrator:rwed;rw /e `

以上命令将赋予用户ruery对C:\ruery文件夹中所有新建文件的读取、写入、运行和删除权限，但需要说明的是，这条命令只是赋予了用户对文件夹本身的读写权限，而不包括子文件夹下的文件。 

对普通用户来说，cals.exe和xcacls.exe的作用可能不是那么明显，这在windows 2000/xp/server 2003的无人值守安装中特别有用，管理员可以为操作系统所在的文件夹设置初始访问权限；在将软件分发到服务器或工作站时，还可以借助 xcacls.exe提供单步保护，以防止用户误删除文件夹或文件。 





