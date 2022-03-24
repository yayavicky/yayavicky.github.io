图形界面 

"compmgmt.msc" 

## 1. 添加用户


```shell
net user username password  /add
net user xt2 xt2 /add
net user xt3 xt3 /add
net user xt4 xt4 /add
net user xt5 xt5 /add
net user xt6 xt6 /add
```


## 2. 命令设置用户不能更改密码

```shell
net user xt1 xt1 /passwordchg:no
net user xt2 xt2 /passwordchg:no
net user xt3 xt3 /passwordchg:no
net user xt4 xt4 /passwordchg:no
net user xt5 xt5 /passwordchg:no
```



## 3.  把用户添加用户组

administrators

```shell
net localgroup "administrators" xt1 /add
net localgroup "administrators" xt2 /add
net localgroup "administrators" xt3 /add
net localgroup "administrators" xt4 /add
net localgroup "administrators" xt5 /add
net localgroup "administrators" xt6 /add
net localgroup "administrators" xt7 /add
```



## 4. 设置密码用不过期

***********************************
 用NetUser命令设置用户密码永不过期（帮助勾选）     
net user /expires:... 命令  只能实现账户的过期时间。
net user命令并没有提供设置用户密码永不过期的勾选命令。
所以我们必须用到外部命令来实现，那就是NetUser命令。



使用方法：
netuser username /pwnexp:y  <-- 设置username 用户密码永不过期

软件工具文件：netuser到c:\windows\system32盘，然后执行如下命令：
***********************************
netuser  xt1 /pwnexp:y
netuser xt2 /pwnexp:y
netuser xt3 /pwnexp:y
netuser xt4 /pwnexp:y





## 命令

### 1. 添加用户



net user 用户名 密码 /add 建立用户

other:
net use \\ip\ipc$ " " /user:" " 建立IPC空链接
net use \\ip\ipc$ "密码" /user:"用户名" 建立IPC非空链接
net use h: \\ip\c$ "密码" /user:"用户名" 直接登陆后映射对方C：到本地为

H:
net use h: \\ip\c$ 登陆后映射对方C：到本地为H:
net use \\ip\ipc$ /del 删除IPC链接
net use h: /del 删除映射对方到本地的为H:的映射
net user 用户名 密码 /add 建立用户
net user guest /active:yes 激活guest用户
net user 查看有哪些用户
net user 帐户名 查看帐户的属性
net localgroup administrators 用户名 /add 把“用户”添加到管理员中使其

具有管理员权限,注意：administrator后加s用复数
net start 查看开启了哪些服务
net start 服务名 开启服务；(如:net start telnet， net start schedule)
net stop 服务名 停止某服务
net time \\目标ip 查看对方时间
net time \\目标ip /set 设置本地计算机时间与“目标IP”主机的时间同步,加

上参数/yes可取消确认信息
net view 查看本地局域网内开启了哪些共享
net view \\ip 查看对方局域网内开启了哪些共享
net config 显示系统网络设置
net logoff 断开连接的共享
net pause 服务名 暂停某服务
net send ip "文本信息" 向对方发信息
net ver 局域网内正在使用的网络连接类型和信息
net share 查看本地开启的共享
net share ipc$ 开启ipc$共享
net share ipc$ /del 删除ipc$共享
net share c$ /del 删除C：共享
net user guest 12345 用guest用户登陆后用将密码改为12345
net password 密码 更改系统登陆密码