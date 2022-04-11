## 汉化版



+ [汉化地址](https://hub.docker.com/r/twang2218/gitlab-ce-zh)



`docker run -d -p 3000:80 twang2218/gitlab-ce-zh:11.1.4`

gitlab 虚拟机配置

+ RAM至少 2G



`/usr/local/docker/gitlab/docker-compose.yaml`



https://docs.gitlab.com/omnibus/settings/smtp.html



```yaml
version: '3'
services:
	gitlab:
		image: 'twang2218/gitlab-ce-zh:11.1.4'
		container_name: gitlabzh
		restart: always
		hostname: '192.168.2.160'
		environment:
        	TZ: 'Asia/Shanghai'
	        GITLAB_OMNIBUS_CONFIG: |
	        external_url 'http://192.168.2.160:80'
	        gitlab_rails['time_zone'] = 'Asia/Shanghai'	        	        		   
	        gitlab_rails['smtp_enable'] = true
	        gitlab_rails['smtp_address'] = 'smtphz.qiye.163.com'
	        gitlab_rails['smtp_port'] = 994
	        gitlab_rails['smtp_user_name'] = 'info@cetsc.com'
	        gitlab_rails['smtp_password'] = '授权码'
	        gitlab_rails['smtp_domain'] = '163.com'
	        gitlab_rails['smtp_authentication'] = 'login'
	        gitlab_rails['smtp_enable_starttls_auto'] = true
	        gitlab_rails['smtp_tls'] = true
	        gitlab_rails['gitlab_email_from'] = 'info@cetsc.com'
	        gitlab_rails['gitlab_email_reply_to'] = 'info@cetsc.com' 
	        gitlab_rails['smtp_pool'] = true
	        gitlab_rails['gitlab_shell_ssh_port'] = 2222
	        unicorn['port'] = 8888
	        nginx['listen_port'] = 443
	        nginx['redirect_http_to_https']= true
	        nginx['ssl_certificate']= "/etc/gitlab/ssl/server.crt"
	        nginx['ssl_certificate_key']= "/etc/gitlab/ssl/server.key"
        ports:
	        - '8080:80'
    	    - '443:443'
        	- '2222:22'
        volumes:
        	- /usr/local/docker/gitlab/config:/etc/gitlab
	        - /usr/local/docker/gitlab/data:/var/opt/gitlab
    	    - /usr/local/docker/gitlab/logs:/var/log/gitlab
        networks:
        	- gitlab_net
```

>区别：
>
>1. `STARTTLS` 是对纯文本通信协议的扩展。它将纯文本连接升级为加密连接（`TLS` 或 `SSL`）， 而不是使用一个单独的加密通信端口。
>2. RFC 2595定义了`IMAP`和`POP3` 的 `STARTTLS`，RFC 3207定义了SMTP的 `STARTTLS`，RFC 4642定义了`NNTP`的`STARTTLS`。
>3. `TLS` 是独立于应用层的协议。高层协议可以透明地分布在 `TLS` 协议上面。然而，`TLS` 标准并没有规定应用程序如何在 `TLS` 上增加安全性。

+ [备份方案](https://www.zhaokeli.com/article/8633.html)

## 配置

root 用户配置

1. 去掉头像系统
2. 关闭注册



### SSH

```shell
ssh-keygen -t rsa -C "info@cetsc.com"
```

小乌龟的ssh 客户端需要改成 git 原生ssh.exe



ssh 连不上，debug

```shell
# port default 22
ssh -vvvT git@ip:port
```



## 进入gitlab docker



```shell
docker exec -it gitlab /bin/sh
docker exec -it 477f32b29454 /bin/sh
 
 
# 停止数据连接服务
# gitlab-ctl stop unicorn
ok: down: unicorn: 1s, normally up

# gitlab-ctl stop sidekiq
ok: down: sidekiq: 8s, normally up

# 备份数据
# gitlab-rake gitlab:backup:create
Dumping database ...
Dumping PostgreSQL database gitlabhq_production ... [DONE]
done
Dumping repositories ...
done
Dumping uploads ...
done
Dumping builds ...
done
Dumping artifacts ...
done
Dumping pages ...
done
Dumping lfs objects ...
done
Dumping container registry images ...
[DISABLED]
Creating backup archive: 1648025589_2022_03_23_11.1.4_gitlab_backup.tar ... done
Uploading backup archive to remote storage  ... skipped
Deleting tmp directories ... done
done
done
done
done
done
done
done
Deleting old backups ... skipping
```



## 备份

1. 进入容器 `docker exec -it gitlabzh /bin/sh`
2. 重新生成配置 `gitlab-ctl reconfigure`
3. 重启gitlab 服务 `gitlab-ctl restart`
4. 备份数据 `docker exec -it gitlabzh gitlab-rake gitlab:backup:create`
5. 恢复数据
   1. `gdocker exec -it gitlabzh gitlab-rake gitlab:backup:restore BACKUP=1530156812_2018_06_28_10.8.4`



## image 备份

```shell
docker image save twang2218/gitlab-ce-zh:11.1.4  -o gitlab-ce-zh_11.1.4.img  # 备份镜像

docker image load -i gitlab-ce-zh_11.1.4.img  # 导入镜像

docker network create gitlab_net
docker-compose up  #创建并启动
```



### 修改文件格式

```shell
vi file_name

# 查看原格式
:set ff

# 修改编码格式
:set ff=unix
```

> Unix及类Unix系统里，每行结尾只有换行“\n”，Windows系统里面，每行结尾是换行+回车“\n\r”，编码格式不一样。





## 本地https证书

```shell
# 1. 建立权限并生成证书
mkdir -p /etc/gitlab/ssl && chmod 700 /etc/gitlab/ssl && cd/etc/gitlab/ssl

# 2. 创建服务器私钥，需要输入一个密码，之后也会用到，我设置的 1qaz2wsx
openssl genrsa -des3 -out server.key 1024

# 3. 创建签名的证书（csr）
openssl req -new -key server.key -out server.csr

# 国家 ch
# 省份 js
# 城市 wx
# 公司 epds
# 公司部门 epds
# common Name 192.168.2.160
# email address info@iepds.com
# challenge password 1qaz2wsx

# 4. 备份key
cp server.key server.key.org

# 5. 直接覆盖了server.key了
openssl rsa -in server.key.org -out server.key

# 6. 标记证书使用上述私钥和CSR：（把csr标记后转换成了crt nginx要用key和crt文件）
openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt
```

>企业邮箱 https://qy.163.com/login/





