## 汉化版



+ [汉化地址](https://hub.docker.com/r/twang2218/gitlab-ce-zh)



`docker run -d -p 3000:80 twang2218/gitlab-ce-zh:11.1.4`

gitlab 虚拟机配置

+ RAM至少 2G



`/usr/local/gitlab/docker-compose.yaml`



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
	        gitlab_rails['gitlab_shell_ssh_port'] = 2222
	        unicorn['port'] = 8888
	        nginx['listen_port'] = 80
        ports:
	        - '8080:80'
    	    - '8443:443'
        	- '2222:22'
        volumes:
        	- /usr/local/docker/gitlab/config:/etc/gitlab
	        - /usr/local/docker/gitlab/data:/var/opt/gitlab
    	    - /usr/local/docker/gitlab/logs:/var/log/gitlab
        networks:
        	- gitlab_net
```



+ [备份方案](https://www.zhaokeli.com/article/8633.html)

## 配置

root 用户配置

1. 去掉头像系统
2. 关闭注册



### SSH

```shell
ssh-keygen -t rsa -C "vicky_yang@iepds.com"
```

小乌龟的ssh 客户端需要改成 git 原生ssh.exe



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
2.  重新生成配置 `gitlab-ctl reconfigure`
3. 重启gitlab 服务 `gitlab-ctl restart`
4.  备份数据 `docker exec -it gitlabzh gitlab-rake gitlab:backup:create`
5. 恢复数据
   1. `gdocker exec -it gitlabzh gitlab-rake gitlab:backup:restore BACKUP=1530156812_2018_06_28_10.8.4`







