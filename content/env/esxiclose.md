---
title: "Esxi Auto Close When Power Off"
date: 2020-12-16T17:19:19+08:00
draft: false
tags: 
    - "Tools"
    - "Setting"
categories :                             
    - "Setting"
    - "Documents"
keywords :                                 
    - "setting"
    - "nas"

#menu: main # Optional, add page to a menu. Options: main, side, footer

# Theme-Defined params
# thumbnail: "img/placeholder.png" # Thumbnail image
lead: "UPS与ESXI联动实现断电自动关机" # Lead text
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

[from](https://cloud.tencent.com/developer/article/1855904)

## 开启ESXI的ssh功能，并ssh登录ESXI创建ups脚本

### 1 进入到ESXI web控制台，开启ssh功能

### 2 ssh连接到ESXI，创建必要文件及脚本

>脚本逻辑：
每1分钟ping一次指定IP，每次只ping一次，如果达到2次，三分钟后再ping一次，此时如果还是不通，就记录时间写入日志到ups.log，并执行关机命令，具体时间和逻辑你可以随意更改：

```sh
[root@localhost:~] cd /vmfs/volumes/data   #cd到对应硬盘卷，以你的硬盘命名为准
[root@localhost:/vmfs/volumes/5f174c56-6a79f5cc-c990-a03e6ba0a187]mkdir ups
[root@localhost:/vmfs/volumes/5f174c56-6a79f5cc-c990-a03e6ba0a187]cd ups
[root@localhost:/vmfs/volumes/5f174c56-6a79f5cc-c990-a03e6ba0a187/ups]touch ups.log  #写日志用
[root@localhost:/vmfs/volumes/5f174c56-6a79f5cc-c990-a03e6ba0a187/ups]vim ups.sh  #创建以下脚本
#!/bin/sh 
UPS_LOG=/vmfs/volumes/data/ups/ups.log
count=0
IP=192.168.1.200   # 写你的网关IP，只要是断电ping不通的IP都行
while :;do
ping -c 1 $IP > /dev/null
if [ $? -eq 0 ]; then 
        :
else
        count=$(expr $count + 1);
fi

sleep 60

if [ $count -ge 2 ]; then
        echo "$(date) AC Power maybe off, checking again after 3 minutes ! " >> $UPS_LOG
        sleep 180
        ping -c 1 $IP &>/dev/null
        if [ "$?" -eq 0 ]; then
                echo "$(date) Checkagain, AC Power OK ! " >> $UPS_LOG
        else
                echo "$(date) AC Power is already off, shut down Virtual Machine Now! " >> $UPS_LOG
                /sbin/powerOffVms

                echo "$(date) Finish shut down Virtual Machine Now! Will shutdown host " >> $UPS_LOG

                /bin/shutdown.sh &&  /bin/poweroff
                halt
        fi

else

        continue

fi
done
[root@localhost:/vmfs/volumes/5f174c56-6a79f5cc-c990-a03e6ba0a187/ups]chmod +x ups.sh  #给个执行权限就行，没必要777
[root@localhost:/vmfs/volumes/5f174c56-6a79f5cc-c990-a03e6ba0a187/ups]
```

### 3. 验证脚本是否生效

ESXI的sh是链接到busybox的，相当于裁剪版bash，所以语法不可能和bash完全一样：

```sh
 ls -l $(which sh)
lrwxrwxrwx    1 root     root            35 Aug  5  2019 /bin/sh -> /usr/lib/vmware/busybox/bin/busybox
[1]+  Done                       /bin/sh ./ups_daemon.sh
```

前面加过执行权限了，`./ups.sh` 和 `sh ups.sh` 都行，为了看到脚本处理逻辑，加个`-x`参数

ping是通的，所以`$_`上一个命令的返回码为`0`，对标表达式，满足条件，`:`占位符表示什么都不做，休眠60秒后继续ping，此时说明脚本正常，如果你想看到整个脚本处理逻辑，ping一个不通的IP即可。

## 守护进程与NOHUP

这里有两种方式，一种是守护进程，一种是 `nohup + 后台运行`，写入到开机自启脚本，两种方式选一种即可

### 1.守护进程方式

所谓守护进程，顾名思义，就是守护它要守护的进程，如何实现？最简单的守护进程就是间隔指定时间去检查进程是否正常运行，没有在运行就调用启动脚本或命令让进程运行起来，一直守护它整个生命周期。

```sh
[root@localhost:/vmfs/volumes/5f174c56-6a79f5cc-c990-a03e6ba0a187/ups]vim ups_daemon.sh  #写入以下脚本

#!/bin/sh

result=$(ps -c |awk '!/awk/&&/ups.sh/{print}'|wc -l)  #通过awk和wc判断进程是否在运行

if [ "${result}" -lt "1" ]; then
        /vmfs/volumes/data/ups/ups.sh &
        echo "$(date) UPS daemon process running" >> /vmfs/volumes/data/ups/ups.log

fi
exit 0
```

写入到开机自启：

```sh
[root@localhost:/vmfs/volumes/5f174c56-6a79f5cc-c990-a03e6ba0a187/ups]cat /etc/rc.local.d/local.sh
/bin/kill $(cat /var/run/crond.pid)
/bin/echo '*/3  *  *  *  *   /vmfs/volumes/data/ups/ups_daemon.sh' >> /var/spool/cron/crontabs/root
/bin/crond
exit 0
[root@localhost:/vmfs/volumes/5f174c56-6a79f5cc-c990-a03e6ba0a187/ups]
```

ESXI的crond进程重启后会把写入的定时任务清空，只保留系统的，写到开机自启脚本以确保每次重启在crond里面有守护进程任务，每三分钟执行一次守护进程脚本，也就是每三分钟判断一次ups.sh脚本是否在正常运行。

### 2. NOHUP
懒人专用，一条命令即可，开机或重启后自动运行：

```sh
[root@localhost:/vmfs/volumes/5f174c56-6a79f5cc-c990-a03e6ba0a187/ups]vim /etc/rc.local.d/local.sh #写入以下内容
{ nohup sh /vmfs/volumes/data/ups/ups.sh; } &>/dev/null & #nohup后台运行脚本，并禁止在控制台输出stdout或stderr，禁止输出文本
[root@localhost:/vmfs/volumes/5f174c56-6a79f5cc-c990-a03e6ba0a187/ups]
```

使用此方式后只有下次开机才会运行脚本，为了不重启直接运行一遍即可：

```sh
{ nohup sh /vmfs/volumes/data/ups/ups.sh; } &>/dev/null &
```

### 3. 确保进程在后台正常运行
这个就不用过多赘述了，ps命令直接看，和其他linux发行版的ps入参有些不一样：

```sh
ps -c | grep ups.sh
```

整个UPS和ESXI联动已经做完，可反复断电测试，一劳永逸；如果你本地做了DDNS，可以配合dnspod的D监控功能，一旦感知到`IP:PORT`或URL无法访问，发短信/邮件告警，真正做到千里之外感知到家里断电及恢复时间。

## 查看系统当前计划任务

```sh
 cat /var/spool/cron/crontabs/root
```


