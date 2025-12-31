#!/bin/bash

# 构建 vocechat-web 并打包为 zip 文件的脚本

set -e

echo "开始构建 vocechat-web..."

# 检查是否安装了 pnpm
if ! command -v pnpm &> /dev/null; then
    echo "错误: 未找到 pnpm。请先安装 pnpm。"
    exit 1
fi

# 安装依赖
echo "安装依赖..."
pnpm install

# 构建应用
echo "构建应用..."
REACT_APP_API_URL=${REACT_APP_API_URL:-"http://localhost:3000"} REACT_APP_RELEASE=true pnpm build

# 打包构建结果
echo "打包构建结果..."
cd build
zip -r ../vocechat-web-build-$(date +%Y%m%d-%H%M%S).zip .
cd ..

echo "构建和打包完成！"
echo "构建的 zip 文件位于当前目录。"

# 如果提供了 API URL 参数，也记录下来
if [ ! -z "$REACT_APP_API_URL" ]; then
    echo "API URL: $REACT_APP_API_URL"
fi

echo "构建时间: $(date)"