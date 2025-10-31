# 基于官方 Node-RED 镜像
FROM nodered/node-red:latest

# 切换到 root 用户以安装额外的包
USER root

# 安装额外的系统依赖（如果需要）
RUN apk add --no-cache \
    python3 \
    py3-pip \
    tzdata

# 设置时区
ENV TZ=Asia/Hong_Kong

# 切换回 node-red 用户
USER node-red

# 安装常用的 Node-RED 节点
RUN npm install --save \
    node-red-dashboard \
    node-red-node-mongodb \
    node-red-contrib-aggregator \
    node-red-contrib-moment \
    node-red-contrib-statistics \
    node-red-node-smooth

# 工作目录
WORKDIR /data

# 暴露端口
EXPOSE 1880

# 启动 Node-RED
CMD ["npm", "start"]
