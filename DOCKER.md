# VoceChat Web Docker 部署

## 构建和运行

### 使用Docker Compose (推荐) - 包含后端服务器

```bash
# 构建并启动完整的VoceChat应用栈（前端+后端）
docker-compose up -d

# 访问应用
# 打开浏览器并访问 http://localhost
# 后端API在端口 1114 (映射到3000) 可用于管理或其他用途
```

### 单独运行前端 (假设后端服务器已在运行)

```bash
# 构建镜像
docker build -t vocechat-web .

# 运行容器，连接到外部后端服务
docker run -d -p 80:80 --name vocechat-web vocechat-web
```

## 发布到Docker仓库

### 使用构建和推送脚本

1. 设置环境变量:
   ```bash
   export DOCKER_REGISTRY=your-registry.com  # 例如: docker.io, your-acr.azurecr.io
   export IMAGE_NAME=vocechat-web
   export TAG=latest
   ```

2. 运行构建和推送脚本:
   ```bash
   ./build-and-push.sh
   ```

### 手动构建和推送

```bash
# 构建镜像 (可选设置API URL)
docker build -t your-registry/vocechat-web:latest --build-arg REACT_APP_API_URL=http://your-server:3000 .

# 推送到仓库
docker push your-registry/vocechat-web:latest
```

## 配置

### 环境变量

React应用支持以下环境变量（在构建时设置）：

- `REACT_APP_API_URL` - 后端API服务器地址
- `PUBLIC_URL` - 应用的基础URL路径

### 端口映射

- Web前端: 80 (HTTP)
- 后端服务器: 1114 -> 3000 (HTTP API)

## 自定义配置

### 连接到现有后端服务器

如果已有VoceChat后端服务器运行，可以通过修改docker-compose.yml来连接：

```yaml
version: '3.8'

services:
  vocechat-web:
    build:
      context: .
      dockerfile: Dockerfile
    ports:
      - "80:80"
    environment:
      - NODE_ENV=production
      - REACT_APP_API_URL=http://your-existing-vocechat-server:3000
    restart: unless-stopped
```

### 自定义数据卷路径

在docker-compose.yml中修改volumes设置：

```yaml
  vocechat-server:
    image: privoce/vocechat-server:latest
    container_name: vocechat-server
    ports:
      - "1114:3000"
    volumes:
      - /your/custom/path:/home/vocechat-server/data  # 修改此路径
    restart: unless-stopped
```

## Nginx配置

Nginx配置文件 `nginx.conf` 已包含React应用所需的基本配置，包括：
- 静态文件服务
- URL重写以支持React Router
- Gzip压缩
- API代理到后端服务器