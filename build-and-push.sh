#!/bin/bash

# VoceChat Web 镜像构建和推送脚本

# 用法:
# 1. 设置环境变量:
#    export DOCKER_REGISTRY=your-registry.com
#    export IMAGE_NAME=vocechat-web
#    export TAG=latest
# 2. 运行脚本: ./build-and-push.sh

set -e  # 遇到错误时退出

# 默认值
DOCKER_REGISTRY=${DOCKER_REGISTRY:-"docker.io"}
IMAGE_NAME=${IMAGE_NAME:-"vocechat-web"}
TAG=${TAG:-"latest"}
FULL_TAG="${DOCKER_REGISTRY}/${IMAGE_NAME}:${TAG}"

echo "正在构建镜像: ${FULL_TAG}"

# 构建镜像
docker build -t ${FULL_TAG} .

echo "构建完成: ${FULL_TAG}"

# 登录到Docker注册表（如果需要）
if [ "$DOCKER_REGISTRY" != "docker.io" ]; then
    echo "正在登录到 ${DOCKER_REGISTRY}"
    docker login ${DOCKER_REGISTRY}
fi

echo "正在推送镜像: ${FULL_TAG}"
docker push ${FULL_TAG}

echo "推送完成: ${FULL_TAG}"

# 可选: 清理本地镜像
echo "是否要删除本地镜像以节省空间? [y/N]"
read -r response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    docker rmi ${FULL_TAG}
    echo "已删除本地镜像: ${FULL_TAG}"
fi

echo "完成！"