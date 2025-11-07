# 使用node镜像作为构建环境
FROM node:20-alpine AS builder

# 安装pnpm
RUN npm install -g pnpm

# 设置工作目录
WORKDIR /app

# 先复制所有需要文件（package.json, pnpm-lock.yaml 和 patches 目录）
COPY package.json pnpm-lock.yaml ./
COPY patches ./patches

# 构建参数 - 允许在构建时设置API URL
ARG REACT_APP_API_URL
ENV REACT_APP_API_URL=$REACT_APP_API_URL

# 安装依赖（这将应用补丁）
RUN pnpm install

# 复制源码
COPY . .

# 构建应用
RUN pnpm build

# 生产环境使用nginx提供服务
FROM nginx:alpine

# 复制nginx配置
COPY nginx.conf /etc/nginx/nginx.conf

# 复制构建结果到nginx目录
COPY --from=builder /app/build /usr/share/nginx/html

# 暴露端口
EXPOSE 80

# 启动nginx
CMD ["nginx", "-g", "daemon off;"]