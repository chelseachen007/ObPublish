---
tags:
title: 线上部署 React 文件
date created: 2023-04-04
date modified: 2023-04-26
---

# 线上部署 React 文件

在安装以前，我们最好先更新一下系统，并安装可能用到的基础包。通过 sudo 命令来安装这些系统包：

```
sudo apt-get update
sudo apt-get install vim openssl build-essential libssl-dev wget curl git
```

还是之前安装 npm 时候的原因，为了保证更快、更稳定的安装速度，我们也可以采用 cnpm 来替代 npm 下载包信息：

安装 nvm

```
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
nvm install v15.5.1
node -v
```

```js
npm --registry=https://registry.npm.taobao.org install -g cnpm
cnpm -v
4.2.0
```

cnpm 有 15 分钟的同步周期，有时候会遇到你需要的模块 cnpm 上不是最新的，怎么办呢？可以通过 sync 命令来同步，同步以后，就可以用 cnpm 安装了。

```js
cnpm sync koa
```

好了，Node.js 安装完了，我们再顺手把一些常用的全局工具包安装一下吧：

```js
npm install pm2 -g
```

至此 Node.js 的环境就安装好了，下一节我们就来安装数据库的环境。

## Nginx

```
sudo vi  /etc/nginx/conf.d/imooc-com-4321.conf
```

```
# 通过 upstream 我们可以设定一个简单的负载均衡策略，以应对将来可能的升级
# 首先定义一个 server 集群 gougou，里面可以加多个 server，每个 server 对应的值可以用域名，也可以直接用 IP，但我们通常不会用 IP 来访问，而是通过域名:
upstream imooc {
    server 127.0.0.1:4321;
}
server {
    listen 80;
    server_name deploy-static.iblack7.com;
    # Gzip Compression
    gzip on;
    gzip_comp_level 6;
    gzip_vary on;
    gzip_min_length  1000;
    gzip_proxied any;
    gzip_types text/plain text/css application/json application/x-javascript text/xml application/xml application/xml+rss text/javascript;
    gzip_buffers 16 8k;

    location / {
        # remote_addr 代表客户端的 IP
        proxy_set_header X-Real-IP $remote_addr;
        # proxy_add_x_forwarded_for 获取真实的 IP
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        # http_host 表示请求的 host 头
        proxy_set_header Host $http_host;
        proxy_set_header X-NginX-Proxy true;

        # proxy_pass 指令实现代理。把域名代理到集群名上面
        proxy_pass http://imooc;
        proxy_redirect off;
    }
}
```

保存后，通过 sudo nginx -t 来验证配置是否正确，有没有语法错误，然后我们把 Nginx 的服务重启一下。

```
sudo service nginx restart
```

再把 URL 中的端口号去掉，我们访问下：

```
http://deploy-static.iblack7.com
```

当里个当，我们大功告成！

/www/user-circle/production/current/dist;

查看 nginx 进程

```
ps -ef |grep nginx
```

netstat -ntpl

sudo vi  /etc/nginx/conf.d/user-circle-8080.conf

```yaml
apps:

- script: app.js

name: UserCircle

env:

COMMON_VARIABLE: true

env_production:

NODE_ENV: production

deploy:

production:

user: root

host:

- 47.102.255.84

port: '7822'

ref: origin/master

repo: git@gitee.com:chelsechen/user-circle.git

path: /www/user-circle/production

ssh_options: StrictHostKeyChecking=no

pre-deploy: git fetch --all

post-deploy: 'cnpm install && cnpm run build&&pm2 startOrRestart ecosystem.yaml --env production'

env:

NODE_ENV: production
```

ssh -p 7822 root@47.102.255.84

pm2 deploy ecosystem.yaml production
