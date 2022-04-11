## 安装docker

### 1. 虚拟机 ubuntu 20.04

```
curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun
```

### 2. 设置国内镜像

```
vim /etc/docker/daemon.json
```

```json
{
	"registry-mirrors":[
	"https://registry.docker-cn.com",
	"https://kfwkfulq.mirror.aliyuncs.com",
	"https://pee6w651.mirror.aliyuncs.com",
	"https://21qq34jg.mirror.aliyuncs.com"
	]
}
```

### 3. 免sudo

需root权限， 如使用sudo命令，环境变量会变化，需要避免环境变量变化

```
sudo groupadd docker # 创建用户组
sudo usermod -aG docker $USER  #当前用户加入用户组
newgrp docker  # 刷新用户组权限
```

### 4. hello word

```
docker run hello-world
```

## docker 常用命令

C/S 结构

+ docker client 发送指令
+ docker server 接收指令，管理镜像、容器、系统资源



`docker --help`

docker 1.13 开始，命令分组

### 1. 镜像操作

`images`子命令



```shell
docker image --help
```



```shell
epds@epds-test-pc:~$ docker image --help

Usage:  docker image COMMAND

Manage images

Commands:
  build       Build an image from a Dockerfile
  history     Show the history of an image
  import      Import the contents from a tarball to create a filesystem image
  inspect     Display detailed information on one or more images
  load        Load an image from a tar archive or STDIN
  ls          List images
  prune       Remove unused images
  pull        Pull an image or a repository from a registry
  push        Push an image or a repository to a registry
  rm          Remove one or more images
  save        Save one or more images to a tar archive (streamed to STDOUT by default)
  tag         Create a tag TARGET_IMAGE that refers to SOURCE_IMAGE

Run 'docker image COMMAND --help' for more information on a command.
```



```shell
docker iamge pull hello-world #拉取镜像
docker image ls
docker image inspect api:v2   # 查看镜像详细信息
docker image save hello-world -o hello.img # 导出镜像为文件
docker image rm hello-world:latest  # 删除镜像
docker image ls # 检查是否删除成功
docker image load -i hello.img  # 导入镜像
```



### 2. 网络

环境部署的三个时代

+ 同一个服务器，部署多个网站，如果一个被入侵，全体挂掉
+ 同一个服务器，安装多个虚拟机，虚拟机里部署网站
+ 同一个服务器，多个容器（默认隔离）



如果要测试，需打破隔离。

-----

网络管理命令 `network` 子命令

```shell
$docker network --help

Usage:  docker network COMMAND

Manage networks

Commands:
  connect     Connect a container to a network
  create      Create a network
  disconnect  Disconnect a container from a network
  inspect     Display detailed information on one or more networks
  ls          List networks
  prune       Remove all unused networks
  rm          Remove one or more networks

Run 'docker network COMMAND --help' for more information on a command.
```



```shell
docker network create my_net
```



### 3. 文件存储(volume)



```shell
$docker volume --help

Usage:  docker volume COMMAND

Manage volumes

Commands:
  create      Create a volume
  inspect     Display detailed information on one or more volumes
  ls          List volumes
  prune       Remove all unused local volumes
  rm          Remove one or more volumes

Run 'docker volume COMMAND --help' for more information on a command.
```



### 4. 容器

```shell
$docker container --help

Usage:  docker container COMMAND

Manage containers

Commands:
  attach      Attach local standard input, output, and error streams to a running container
  commit      Create a new image from a container's changes
  cp          Copy files/folders between a container and the local filesystem
  create      Create a new container
  diff        Inspect changes to files or directories on a container's filesystem
  exec        Run a command in a running container
  export      Export a container's filesystem as a tar archive
  inspect     Display detailed information on one or more containers
  kill        Kill one or more running containers
  logs        Fetch the logs of a container
  ls          List containers
  pause       Pause all processes within one or more containers
  port        List port mappings or a specific mapping for the container
  prune       Remove all stopped containers
  rename      Rename a container
  restart     Restart one or more containers
  rm          Remove one or more containers
  run         Run a command in a new container
  start       Start one or more stopped containers
  stats       Display a live stream of container(s) resource usage statistics
  stop        Stop one or more running containers
  top         Display the running processes of a container
  unpause     Unpause all processes within one or more containers
  update      Update configuration of one or more containers
  wait        Block until one or more containers stop, then print their exit codes

Run 'docker container COMMAND --help' for more information on a command.
```

重点命令

1. run 从镜像创建并启动容器
2. stop 停止容器
3. kill 强杀容器
4. restart 重启容器
5. logs 查看容器日志

```shell
docker container run api:v2  # 启动容器
docker container run nginx
```

```shell
$docker container ls
CONTAINER ID   IMAGE     COMMAND                  CREATED              STATUS              PORTS     NAMES
a5c5008e9af4   nginx     "/docker-entrypoint.…"   About a minute ago   Up About a minute   80/tcp    peaceful_carson

$docker stop a5c5008e9af4  #关闭容器
$docker kill a5c5008e9af4  #强制关闭容器

$docker restart a5c5008e9af4 

$docker container logs a5c5008e9af4 # 查看容器控制台输出

```



`run` 参数

```shell
docker run
	--name my_hello  # 指定容器名称
	--rm  # 结束后自动删除
	--net my_net # 指定容器加入的网络
	--volume ${PWD}:/tmp  # 把当前目录挂载到容器中
	-it  #进入容器内部，挂载终端
	-d # 让容器后台运行
nginx
bash # 容器要执行的命令
```



## 搭建测试环境

### 1. 建立测试网络

```shell
docker network create test_net
```

### 2. 搭建 selenium grid 容器

```shell
docker run --net test_net --name my_selenium --rm -d -p 4444:4444 -p 6900:5900 --shm-size="2g" selenium/standalone-chrome:4.1.2-20220317
```

### 3. 启动UI录制容器

```shell
docker run --net test_net --name my_video --rm -d -v /tmp/videos:/videos selenium/video:ffmpeg-4.3.1-20220317
```



## 服务器性能

一般容器会控制大小，2核2G以内。

## 多容器交互

微服务特点

1. 对外暴露接口简单：一般只有一个HTTP接口
2. 对内服务特别多：接口、数据、redis、消息队列、日志收集

将测试代码放入微服务架构内：

1. 把测试代码打包为镜像
2. 容器编排：让容器们一起运行

docker-compose 用于定义和运行多容器的docker工具， 可以使用yaml配置程序和服务。

使用单个命令，创建并启动所有的服务。



### 1. 安装docker-compose

```shell
# ubuntu
sudo apt-get upgrade 
sudo apt-get install docker-compose
sudo apt-get clean
```



### 2. docker-compose 命令

```shell
$docker-compose --help
Define and run multi-container applications with Docker.

Usage:
  docker-compose [-f <arg>...] [options] [COMMAND] [ARGS...]
  docker-compose -h|--help

Options:
  -f, --file FILE             Specify an alternate compose file
                              (default: docker-compose.yml)
  -p, --project-name NAME     Specify an alternate project name
                              (default: directory name)
  --verbose                   Show more output
  --log-level LEVEL           Set log level (DEBUG, INFO, WARNING, ERROR, CRITICAL)
  --no-ansi                   Do not print ANSI control characters
  -v, --version               Print version and exit
  -H, --host HOST             Daemon socket to connect to

  --tls                       Use TLS; implied by --tlsverify
  --tlscacert CA_PATH         Trust certs signed only by this CA
  --tlscert CLIENT_CERT_PATH  Path to TLS certificate file
  --tlskey TLS_KEY_PATH       Path to TLS key file
  --tlsverify                 Use TLS and verify the remote
  --skip-hostname-check       Don't check the daemon's hostname against the
                              name specified in the client certificate
  --project-directory PATH    Specify an alternate working directory
                              (default: the path of the Compose file)
  --compatibility             If set, Compose will attempt to convert keys
                              in v3 files to their non-Swarm equivalent
  --env-file PATH             Specify an alternate environment file

Commands:
  build              Build or rebuild services
  bundle             Generate a Docker bundle from the Compose file
  config             Validate and view the Compose file
  create             Create services
  down               Stop and remove containers, networks, images, and volumes
  events             Receive real time events from containers
  exec               Execute a command in a running container
  help               Get help on a command
  images             List images
  kill               Kill containers
  logs               View output from containers
  pause              Pause services
  port               Print the public port for a port binding
  ps                 List containers
  pull               Pull service images
  push               Push service images
  restart            Restart services
  rm                 Remove stopped containers
  run                Run a one-off command
  scale              Set number of containers for a service
  start              Start services
  stop               Stop services
  top                Display the running processes
  unpause            Unpause services
  up                 Create and start containers
  version            Show the Docker-Compose version information
```

### 3. docker-compose.yaml

> + dockerfile 一定以FROM开头，指令建议大写。
> + docker-compose 一定以VERSION开头。指定了docker-compose版本
>   + 列举服务
>     + 镜像
>     + 容器名称，不是必须
>     + 启动方式
>     + 指定网络
>     + port
>     + 环境变量
>     + 卷
>     + 启动依赖



主要 ：

+ 服务节点
+ 服务直接的关系



### 4. 编排容器

接口项目容器 + 测试框架容器 = 测试结果容器

1. 构建镜像



编排的前提是有镜像



在指定文件夹运行

```shell
docker-compose up  #创建并启动
```

测试特别需求

当测试结束时，所有服务全部关闭

```shell
# 某一个镜像结束，全部服务停止
docker-compose up --abort-on-container-exit
```



```shell
 docker start allure
```



## 资料

+ [前言 - Docker — 从入门到实践  - gitbook.io](https://yeasy.gitbook.io/docker_practice/)

