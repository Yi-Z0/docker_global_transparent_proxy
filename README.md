# docker_global_transparent_proxy
使用clash +docker 进行路由转发实现全局透明代理

## 食用方法
1. 开启混杂模式

    `ip link set eth0 promisc on`

1. docker创建网络,注意将网段改为你自己的

    `docker network create -d macvlan --subnet=192.168.1.0/24 --gateway=192.168.1.1 -o parent=eth0 macnet`

1. 提前准备好正确的clash config , 必须打开redir在7892, 以及dns在53端口

1. 运行容器

    `sudo docker run --name clash_tp -d -v /your/path/clash_config:/clash_config  --network macnet --ip 192.168.1.100 --privileged zhangyi2018/clash_transparent_proxy`

1. 将手机/电脑等客户端 网关设置为容器ip,如192.168.1.100 ,dns也设置成这个


## 附注 : 

1. 只要规则设置的对, 支持国内直连,国外走代理
1. 只在linux 测试过,win没试过, mac是不行, 第二步创建网络不行, docker自己的问题, 说不定以后哪天docker for mac支持了?

## 构建方法
`docker buildx build --platform linux/386,linux/amd64,linux/arm/v7,linux/arm64/v8 -t zhangyi2018/clash_transparent_proxy:1.0.7 -t zhangyi2018/clash_transparent_proxy:latest . --push`
