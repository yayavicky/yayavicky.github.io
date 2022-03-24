ESxi安装

## 资料

+ [Vmware ESXi 配置 IP 地址](https://techexpert.tips/zh-hans/vmware-zh-hans/vmware-esxi%e9%85%8d%e7%bd%aeip%e5%9c%b0%e5%9d%80/)


## 1. 进入设置 

按F2 进入配置界面



配置 IP，DNS

Troubleshooting Options 选项中打开 ssh， shell



## 2. 检查系统配置



```shell
[xxx@ServerHost:~] df -h
Filesystem   Size   Used Available Use% Mounted on
VMFS-6      14.5T   2.1G     14.5T   0% /vmfs/volumes/datastore1
vfat       249.7M 148.4M    101.3M  59% /vmfs/volumes/e81b9b74-8045e3bd-4b51-d7552bfeb866
vfat         4.0G   4.9M      4.0G   0% /vmfs/volumes/6234553d-3be733cc-0421-34735aa48f92
vfat       249.7M   4.0K    249.7M   0% /vmfs/volumes/b83de17b-5e9b7fed-0b99-964b1e02b466
vfat       285.8M 173.8M    112.0M  61% /vmfs/volumes/62345536-210a1700-08d4-34735aa48f92
[xxx@ServerHost:~] fdisk -l

***
*** The fdisk command is deprecated: fdisk does not handle GPT partitions.  Please use partedUtil
***

fdisk: device has more than 2^32 sectors, can't use all of them
Found valid GPT with protective MBR; using GPT

Disk /dev/disks/naa.64cd98f0425d0b0029c70f903a432c6b: 4294967295 sectors, 4095M
Logical sector size: 512
Disk identifier (GUID): ac8bc8f9-3711-4348-91d9-c5278d46a107
Partition table holds up to 128 entries
First usable sector is 34, last usable sector is 31253856222

Number  Start (sector)    End (sector)  Size Name
     1              64            8191 4064K
     2         7086080        15472639 4095M
     3        15472640     31253856222 14.5T
     5            8224          520191  249M
     6          520224         1032191  249M
     7         1032224         1257471  109M
     8         1257504         1843199  285M
     9         1843200         7086079 2560M
     
     
 partedUtil -l
Usage:
 Get Partitions : get <diskName>
 Set Partitions : set <diskName> ["partNum startSector endSector type attr"]*
 Delete Partition : delete <diskName> <partNum>
 Resize Partition : resize <diskName> <partNum> <start> <end>
 Get Partitions : getptbl <diskName>
 Set Partitions : setptbl <diskName> <label> ["partNum startSector endSector type/guid attr"]*
 Fix Partition Table : fix <diskName>
 Create New Label (all existing data will be lost): mklabel <diskName> <label>
 Show commonly used partition type guids : showGuids
 Get usable first and last sectors : getUsableSectors <diskName>
 Fix GPT Table interactively : fixGpt <diskName>
 Show Partition Information : partinfo <diskName> <partNum>
 Add Partition Information : add <diskName> <label> ["partNum startSector endSector type/guid attr"]
```



## 3. 快捷键

`F2` 关机

`F`  重启

ssh命令

1. 查看虚拟机： vim-cmd vmsvc/getallvms
   会显示当前esxi上的虚拟机数量，每一个都有编号。 --获取所有虚拟机的vmid信息。

2. 停用虚拟机：vim-cmd vmsvc/power.suspend + 之前命令显示编号即可》
   例： vim-cmd vmsvc/power.suspend 1

3. 启动虚拟机：vim-cmd vmsvc/power.on + 之前命令显示编号即可》

4. 重启虚拟机： vim-cmd vmsvc/power.reboot + 之前命令显示编号即可》

5. 帮助命令：vim-cmd vmsvc help



## 4. 常用命令



### 1. 查看Esxi版本

`vmware –v1`

### 2. 查看显示ESXi硬件，内核，存储，网络等信息

+ `esxcfg-info -a`（显示所有相关的信息）

+ `esxcfg-info -w`（显示esx上硬件信息）

### 3. 列出esxi里知道的服务

`esxcfg-firewall –s`

### 4. 查看具体服务的情况

`esxcfg-firewall -q sshclinet`

### 5. 重新启动vmware服务

`service mgmt-vmware restart`

### 6. 修改root的密码

`passwd root`

### 7. 设置kernel高级选项

`esxcfg-advcfg -d`（将系统内核恢复默认值）

### 8. 管理资源组

`esxcfg-resgrp -l`（显示所有资源组）



### 9. 列出你当前的虚拟交换机

`esxcfg-vswitch -l`

`esxcfg-vswitch -v 10 -p "Service Console" vSwitch0` (将vSwitch0上的Service Console划分到vLan 10上，如果vLan号为0则不设置vLan)

### 10. 查看控制台的设置

+ `esxcfg-vswif -l`  （列出已添加的网卡）

+ `esxcfg-vswif -a` （添加网卡）

### 11. 列出系统的网卡

`esxcfg-nics –l`

### 12. 添加一个虚拟交换机，名字叫（internal）连接到两块物理网卡，（重新启动服务，vi就能看见了）


```shell
esxcfg-vswitch -a vSwitch1
esxcfg-vswitch -A internal vSwitch1
esxcfg-vswitch -L vmnic1 vSwitch1
esxcfg-vswitch -L vmnic2 vSwitch1
```


### 13.  删除交换机,(注意，别把控制台的交换机也删了）

`esxcfg-vswitch -D vSwitch1`


### 14.  删除交换机上的网卡

`esxcfg-vswitch -u vmnic1 vswitch2`


### 15.  删除portgroup

`esxcfg-vswitch -D internel vswitch1`


### 16.  创建 vmkernel switch，如果你希望使用vmotion，iscsi的这些功能，你必须创建(通常是不需要添加网关的）

```shell
esxcfg-vswitch -l
esxcfg-vswitch -a vswitch2
esxcfg-vswitch -A "vm kernel" vswitch2
esxcfg-vswitch -L vmnic3 vswitch2
esxcfg-vmknic -a "vm kernel" -i 172.16.1.141 -n 255.255.252.0 （添加一个vmkernel）
```

### 17.  防火墙设置

```shell
esxcfg-firewall -e sshclient （打开防火墙ssh端口）
esxcfg-firewall -d sshclient （关闭防火墙ssh端口）
esxcfg-firewall -e veritasNetBackup（允许Veritas Netbackup服务）
esxcfg-firewall -o 123，udp，out，ntp（为ntp服务打开UDP协议中的123端口的输出）
```


### 18.  路由管理

```shell
esxcfg-route（VM生成网卡的路由管理）
esxcfg-route（显示路由表）
esxcfg-route 172.16.0.254（设置vmkernel网关）
```

### 19.  创建控制台

```shell
esxcfg-vswitch -a vSwitch0
esxcfg-vswitch -A "service console" vSwitch0
esxcfg-vswitch -L vmnic0 vSwitch0
esxcfg-vswif -a vswif0 -p "service console" -i 172.16.1.140 -n 255.255.252.0
```


### 20.  添加nas设备(a添加标签，-o，是nas服务器的名字或ip，-s是nas输入的共享名字）

`esxcfg-nas -a isos -o nas.vmwar.cn -s isos`


### 21.  nas连接管理

```shell
esxcfg-nas -r （强迫esx去连接nas服务器）
esxcfg-nas -l   (用esxcfg-nas -l来看看结果）
esxcfg-nas -a（添加NAS文件系统到/vmfs目录下）
esxcfg-nas -d（删除NAS文件系统）
```


### 22.  扫描SCSI设备上的LUN信息

`esxcfg-rescan <vmkernel SCSI adapter name>`


### 23.  连接iscsi设备(e:enable q:查询 d, disable s:强迫搜索）

`esxcfg-swiscsi -e`


### 24.  设置targetip

`vmkiscsi-tool -D -a 172.16.1.133 vmhba40`


### 25.  列出和target的连接

`vmkiscsi-tool -l -T vmhba40`


### 26.  列出当前的磁盘

`ls -l /vmfs/devices/disks`


### 27.  内核dump管理工具

`esxcfg-dumppart -l`（显示当前dump分区配置信息）


### 28.  路径管理

```shell
esxcfg-mpath -l（显示所有路径）

esxcfg-mpath -a（显示所有HBA卡）
```

### 29.  ESX授权管理配置

```shell
esxcfg-auth

esxcfg-auth --enablenis（运行NIS验证）
```


### 30.  管理启动设备

```shell
esxcfg-boot

esxcfg-boot -b（更新启动设备）
```


### 31.  执行initrd的初始化设置

```shell
esxcfg-init

esxcfg-init（初始化设备）
```

### 32.  esxcfg-linuxnet（在linux debug模式中，转换vswif设备命名为linux自带的eth命名规则）

`esxcfg-linuxnet --setup`


### 33.  升级

```
esxcfg-upgrade（ESX2.X升级到ESX3.X）
```


## 使用命令更改Service Console IP


在CLI下更改 `service console` 的ip地址，注意大小写，vmware是把物理nic虚拟成vmnic，在vmnic上创建虚拟交换机vswitch，是把网卡当成交换机来使用，不能对网卡进行ip地址的设置，只能在vswitch上创建interface就是vswif，对vswif进行ip设置

 

###  1.  使用CLI创建Service Console

```shell
esxcfg-vswitch -a vSwitch0     #创建vSwitch0
esxcfg-vswitch -A "Service Console" vSwitch0   #在vSwitch0上创建Portgroup,命名为Service Console

esxcfg-vswitch -L vmnic0 vSwitch0              #将vmnic0绑定在vSwitch0
esxcfg-vswitch –l         #可以看到service console已经绑定 vmnic0


Switch Name   Num Ports  Used Ports Configured Ports MTU    Uplinks  
vSwitch0      64         5          64               1500   vmnic0   
PortGroup Name   VLAN ID    Used Ports Uplinks
Service Console    0         1          vmnic0   


esxcfg-vswif -a vswif0 -p "Service Console" -i 192.168.1.1 -n 255.255.255.0               
 #创建vswif0并与service console绑定,在ESXi里ip地址只能跟vswif0绑定,也就是虚拟交换机的interface

esxcfg-vswif –l     #可以看到Service console的IP已经配置到vswif0
Name    Port Group      IP Address    Netmask         Broadcast      Enabled  DHCP

vswif0  Service Console 192.168.1.50   255.255.255.0    192.168.1.255  true  false 

esxcfg-vswitch –l
Switch Name   Num Ports  Used Ports Configured Ports MTU    Uplinks  
vSwitch0      64         5          64               1500   vmnic0   
PortGroup Name   VLAN ID    Used Ports Uplinks
Service Console    0         1          vmnic0 

service mgmt-vmware restart          #重启服务,到这里正常情况下就可以使用VI连接到ESX
```

>如果不小心配置错了要删除，请看下面

```shell
esxcfg-vswif –l   #vswif0代表的虚拟网卡的interface0，service console对应vswif0
Name   Port Group      IP Address    Netmask       Broadcast     Enabled  DHCP

vswif0 Service Console 192.168.1.1  255.255.255.0  192.168.1.255  true    false 

esxcfg-vswif -d vswif0                 #删除vswif0
esxcfg-vswitch -l

Switch Name   Num Ports  Used Ports Configured Ports MTU    Uplinks  
vSwitch0      64         5          64               1500   vmnic0   
PortGroup Name   VLAN ID    Used Ports Uplinks
Service Console    0         1          vmnic0          


esxcfg-vswitch –D “Service Console” vSwitch0    #删除vSwitch0上面portgroup
esxcfg-vswitch –D “VM Network” vSwitch0
esxcfg-vswitch -d vSwitch0                #删除vswitch0
esxcfg-vswitch –l           #之前操作删除了vswitch信息,现在是空白

Switch Name   Num Ports  Used Ports Configured Ports MTU    Uplinks  
PortGroup Name   VLAN ID    Used Ports Uplinks
```


如果不行检查一下以下配置文件.

```shelll
vi /etc/sysconfig/network                 #这里纪录主机名字和网关

NETWORKING=yes
HOSTNAME=VI3      
GATEWAY=192.168.251.12         #网关
GATEWAYDEV=vswif0                #网关指定在vswif0


vi /etc/sysconfig/network-scripts/ifcfg-vswif0        #看看这里的信息是否跟之前配置吻合

DEVICE=vswif0                        #之前把service cosole与vswif0关联     
MACADDR=00:50:56:43:a3:52
PORTGROUP=portgroup6     #这里的protgroup与service console一致 
BOOTPROTO=static
BROADCAST=192.168.251.255
IPADDR=192.168.251.60                        #与service console一致
NETMASK=255.255.255.0
ONBOOT=yes
```

如果以上不一致,可以手动更改

在vi编辑器中,i键是插入模式,进行文本更改,esc键退出插入模式,:wq保存并退出.

编辑完成reboot.可能启动后显示地址跟设置不同,但是可以使用VI连接到ESX

 

补：如果只想修改Service Console的IP可以直接执行以下命令：

esxcfg-vswif -i xxx.xxx.xxx.xxx vswif<X>


## 网络

### 1. VMKernel 端口用途

+ IP 存储、vSphere vMotion 迁移、vSphere Fault Tolerance、 vSAN 和 vSphere Replication
+ 用于 ESXi管理网络

### 2. 添加上行链路

虚拟交换机，添加上行链路



+ ESXi支持802.1Q VLAN标记功能。
  + 802.1Q 是中继协议。
+ 虚拟交换机标记是受支持的标记策略中的一种
  + 在来自虚拟机的帧从虚拟交换机传出时，为其添加相应的标记。
  + 到达虚拟交换机的已标记帧在发送到目标虚拟机之前会被取消相应的标记。
  + 对性能的影响微乎其微。
+ ESXi通过为端口组指定 VLAN ID来提供 VLAN 支持。
+ 虚拟网络支持以下虚拟交换机
  + 标准交换机
    + 单个主机的虚拟交换机配置
  + 分布式交换机
    + 可为在多台主机之间迁移的虚拟机提供一致网络配置的虚拟交换机



### 3. 列出IP

```shell
esxcli network ip interface ipv4 get
Name  IPv4 Address   IPv4 Netmask   IPv4 Broadcast  Address Type  Gateway      DHCP DNS
----  -------------  -------------  --------------  ------------  -----------  --------
vmk0  192.168.2.230  255.255.255.0  192.168.2.255   DHCP          192.168.2.1     false
```

### 4. 配置静态IP

进入维护模式
```shell
esxcli system maintenanceMode set --enable true
```

```shell
[root@ServerHost:~] esxcli network ip interface ipv4 set -i vmk0 -I 192.168.2.230 -N 255.255.255.0 -t static -g 192.168.2.1
[root@ServerHost:~] esxcli network ip interface ipv4 get
Name  IPv4 Address   IPv4 Netmask   IPv4 Broadcast  Address Type  Gateway      DHCP DNS
----  -------------  -------------  --------------  ------------  -----------  --------
vmk0  192.168.2.230  255.255.255.0  192.168.2.255   STATIC        192.168.2.1     false
```

一个 Vmware ESXi 主机上只能配置一个默认网关

使用以下命令在 Vmware ESXi 服务器上配置默认路由：

```shell
esxcli network ip route ipv4 add --gateway 192.168.2.1 --network 0.0.0.0

[root@ServerHost:~] esxcli network ip route ipv4 list
Network      Netmask        Gateway      Interface  Source
-----------  -------------  -----------  ---------  ------
default      0.0.0.0        192.168.2.1  vmk0       DHCP
192.168.2.0  255.255.255.0  0.0.0.0      vmk0       MANUAL
```

修改服务器名称

```shell
esxcli system hostname set --host=newhostname
```

添加DNS

```shell
esxcli network ip dns server add --server=8.8.8.8
esxcli network ip dns server list
```

退出维护模式

```shell
esxcli system maintenanceMode set --enable false
reboot
```


### 5. 安全策略

+ 可在标准交换机级别和端口组级别定义安全策略
  + Promiscuous mode 混杂模式
    + 无论目标是什么，虚拟交换机或端口组都可以转发所有流量
  + MAC address changes MAC地址更改
    + 客户机更改了MAC地址的情况下接受或拒绝入站流量
  + Forged transmits 伪信号
    + 客户机更改MAC地址的情况下接受或拒绝出站流量
+ 默认时，标准交换机级别设置的策略将应用于标准交换机上的所有端口组。
+ 可用的网络策略
  + 安全性
  + 流量调整
  + 网卡绑定和故障转移
+ 策略在以下级别定义
  + 标准交换机级别
    + 适用于标准交换机上所有端口的默认策略
  + 端口组级别
    + 有效策略，该级别定义的策略将覆盖在标准交换机级别设置的默认策略。

### 6. 负载均衡

1. 源虚拟端口ID
2. 源MAC哈希路由
3. 基于IP哈希进行路由
   1. IP包括 源和目标
   2. 必须在物理交换机上做端口聚合



### 7. 基本存储

+ 数据存储类型

  + VMFS - 块操作

  + NFS - 文件写入

+ 存储技术

  + 直接连接 - 只服务于某台机器
  + 光纤通道 - FcSAN
  + FCoE - 基于以太网
  + iSCSI - IPSAN
  + vSAN - 软件虚拟SAN
  + NAS

+ 存储协议

  + 光纤通道
  + FCoE
  + iSCSI
  + NFS
  + DAS
  + vSAN

+ 数据存储

  + 可使用一个或多个物理设备上的磁盘空间的逻辑存储单元
  + 可用于存储虚拟机文件、模板和ISO镜像
  + 数据存储类型
    + VMFS
    + NFS
    + vSAN
