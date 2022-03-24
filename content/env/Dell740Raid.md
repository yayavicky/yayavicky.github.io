# Dell R740服务器新版Raid设置图文教程

## 1. 进入BIOS

开机后，在此界面时按F2键进入BIOS

![在这里插入图片描述](.\picdell\01.bios.png)

## 2. 启动方式 

进入“System BIOS”→“Boot Settings” →“Boot Mode”，选择“UEFI”

![在这里插入图片描述](.\picdell\02.system.bios.png)

![在这里插入图片描述](.\picdell\02bootSetting.png)

![在这里插入图片描述](.\picdell\02bootSetting2.png)


## 3. Device Setting
返回主界面，进入 “Device Settings”

![在这里插入图片描述](.\picdell\03.device.png)

选择“RAID Controller in Slot 6:Dell  Utility”


![在这里插入图片描述](.\picdell\03.device.raid.png)

### 3.1 Main Menu

通过Tab键进行切换，选择“Main Menu”


![在这里插入图片描述](.\picdell\03.device.config.png)

选择“Configuration Management”，配置Raid

![在这里插入图片描述](.\picdell\03.main.config.png)

当前并没有Raid，选择“Create Virtual Disk”创建一个虚拟磁盘



![在这里插入图片描述](.\picdell\03.virdisk.png)

在该服务器上只有两块本地磁盘，只能创建Raid0或Raid1，这里我们创建Raid1，然后点击“Select Physical Disks”选择需要加入此Raid的磁盘



![在这里插入图片描述](.\picdell\03.disk.conf.png)

将本地的两块磁盘全部选择上，然后点击“Apply Changes”进行提交，并点击“OK”

![在这里插入图片描述](.\picdell\03.apply.disk.png)

![在这里插入图片描述](.\picdell\03.apply.disk2.png)

在虚拟磁盘的配置选项中，只需要将“Default Initialization”设置为Fast，表示创建该虚拟磁盘后，进行快速初始化；然后点击“Create Virtual Disk”创建虚拟磁盘



![在这里插入图片描述](.\picdell\03.create.virdisk.png)

确实是否提交该操作，利用光标键在“Confirm”前面的方框中打上勾并点击“Yes”进行确认，并点击“OK”

![在这里插入图片描述](.\picdell\03.create.virdisk2.png)

![在这里插入图片描述](.\picdell\03.create.virdisk3.png)

接下来使用“Esc”键返回到主界面，并再次按“Esc”退出键，提示是否退出，选择“Yes”退出

![在这里插入图片描述](.\picdell\04.exit)

4）Raid配置好后，接下来将操作系统的ISO文件映射到服务器，开始安装操作系统