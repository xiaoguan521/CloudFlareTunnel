---
title: Cloudflare Tunnel Manager
description: A Spring Boot application for managing Cloudflare Tunnel public hostnames
---

# Cloudflare Tunnel Manager

## 项目概述

**Cloudflare Tunnel Manager** 是一个基于 Spring Boot 的 Web 应用程序，用于管理 Cloudflare Tunnel 的公共主机名。它通过 Cloudflare API 实现主机名的添加、查看和删除操作，并同步更新 DNS CNAME 记录，简化了 Tunnel 配置流程。

### 功能特点
- **批量添加主机名**：支持一次性添加多个子域及其服务地址。
- **主机名列表**：展示当前 Tunnel 配置中的所有主机名。
- **删除主机名**：移除指定主机名并同步删除 DNS 记录。
- **DNS 管理**：自动为新增主机名创建 CNAME 记录，删除时移除对应记录。
- **Docker 支持**：提供 Dockerfile 和 Docker Compose 配置，便于容器化部署。
- **CI/CD 支持**：集成 GitHub Actions 自动构建和发布 Docker 镜像。

### 技术栈
- **后端**：Spring Boot 3.x, OkHttp3, FastJSON2
- **前端**：Thymeleaf, HTML/CSS/JavaScript
- **依赖**：Maven, Hutool, Lombok
- **容器化**：Docker
- **CI/CD**：GitHub Actions

## 快速开始

### 前提条件
- Java：17 或更高版本
- Maven：3.6 或更高版本
- Docker：可选，用于容器化部署
- Cloudflare 账户：需要 API Token、Account ID、Tunnel ID 和 Zone ID

### 安装与运行（本地）

克隆项目
```bash
git clone <your-repository-url>
cd cloudflare-tunnel-manager
```

2. **配置环境**
   编辑 `src/main/resources/application.yml`：
   ```yaml
   server:
     port: ${SERVER_PORT:9995}
   cloudflare:
     auth: ${CLOUDFLARE_AUTH:}
     account-id: ${CLOUDFLARE_ACCOUNT_ID:your_account_id}
     tunnel-id: ${CLOUDFLARE_TUNNEL_ID:your_tunnel_id}
     api-token: ${CLOUDFLARE_API_TOKEN:your_api_token}
     zone-id: ${CLOUDFLARE_ZONE_ID:your_zone_id}
   ```
   替换 `your_account_id` 等为实际值。

3. **构建项目**
   ```bash
   mvn clean package
   ```

4. **运行**
   ```bash
   java -jar target/cloudflare-tunnel-manager-1.0.0.jar
   ```

5. **访问**
   打开浏览器，访问 `http://localhost:9995`。

---

## GitHub Actions CI/CD

本项目使用 GitHub Actions 实现持续集成和持续部署。每当代码推送到 `main` 分支时，会自动构建项目并发布 Docker 镜像。

### 工作流程

工作流程包含两个主要任务：

1. **构建 (build)**：
   - 检出代码
   - 设置 JDK 17
   - 使用 Maven 构建项目
   - 上传构建的 JAR 文件作为构件

2. **Docker (docker)**：
   - 下载构建的 JAR 文件
   - 登录到 Docker Hub
   - 构建 Docker 镜像
   - 推送镜像到 Docker Hub

### 设置步骤

要使用此工作流，您需要在 GitHub 仓库中设置以下 Secrets：

1. **DOCKER_HUB_USERNAME**：您的 Docker Hub 用户名
2. **DOCKER_HUB_TOKEN**：您的 Docker Hub 访问令牌（不是密码）

#### 如何设置 GitHub Secrets

1. 在您的 GitHub 仓库中，点击 "Settings"
2. 在左侧菜单中，点击 "Secrets and variables" > "Actions"
3. 点击 "New repository secret"
4. 添加 `DOCKER_HUB_USERNAME` 和 `DOCKER_HUB_TOKEN`

#### 如何获取 Docker Hub 访问令牌

1. 登录到 [Docker Hub](https://hub.docker.com/)
2. 点击您的用户名，然后选择 "Account Settings"
3. 在左侧菜单中，点击 "Security"
4. 点击 "New Access Token"
5. 输入令牌描述，选择适当的权限
6. 点击 "Generate"
7. 复制生成的令牌（这是您唯一能看到它的机会）

### 手动触发工作流

1. 在 GitHub 仓库中，点击 "Actions" 标签
2. 在左侧列表中选择 "Build and Deploy" 工作流
3. 点击 "Run workflow" 按钮
4. 选择分支，然后点击 "Run workflow"

---

## Docker 部署

### 构建镜像

1. **确保 JAR 文件已生成**
   ```bash
   mvn clean package
   ```

2. **编写 Dockerfile**
   ```dockerfile
   FROM eclipse-temurin:17-jre
   WORKDIR /app
   COPY target/*.jar app.jar
   EXPOSE 9995
   ENTRYPOINT ["java", "-jar", "app.jar"]
   ```

3. **构建镜像**
   ```bash
   docker build -t yourusername/cloudflare-tunnel-manager:latest .
   ```
    - 替换 `yourusername` 为你的 Docker Hub 用户名。

### 运行容器

使用环境变量指定配置：
```bash
docker run -d \
  -p 9995:9995 \
  -e SERVER_PORT=9995 \
  -e CLOUDFLARE_AUTH="your_auth" \
  -e CLOUDFLARE_ACCOUNT_ID="your_account_id" \
  -e CLOUDFLARE_TUNNEL_ID="your_tunnel_id" \
  -e CLOUDFLARE_API_TOKEN="your_api_token" \
  -e CLOUDFLARE_ZONE_ID="your_zone_id" \
  --name cloudflare-tunnel-manager \
  yourusername/cloudflare-tunnel-manager:latest
```

### 使用 Docker Compose（推荐）

1. **创建 `docker-compose.yml`**
   ```yaml
   version: '3.8'
   services:
     cloudflare-tunnel-manager:
       image: xlike0616/cloudflare-tunnel-manager:latest
       build: .
       ports:
         - "9995:9995"
       environment:
         - SERVER_PORT=9995
         - CLOUDFLARE_AUTH=your_auth
         - CLOUDFLARE_ACCOUNT_ID=your_account_id
         - CLOUDFLARE_TUNNEL_ID=your_tunnel_id
         - CLOUDFLARE_API_TOKEN=your_api_token
         - CLOUDFLARE_ZONE_ID=your_zone_id
       container_name: cloudflare-tunnel-manager
   ```

2. **启动**
   ```bash
   docker-compose up -d --build
   ```

3. **停止**
   ```bash
   docker-compose down
   ```

---

## 推送镜像到 Docker Hub

1. **登录 Docker Hub**
   ```bash
   docker login -u yourusername
   ```

2. **标记镜像**
   ```bash
   docker tag cloudflare-tunnel-manager:latest yourusername/cloudflare-tunnel-manager:latest
   ```

3. **推送**
   ```bash
   docker push xlike0616/cloudflare-tunnel-manager:latest
   ```

4. **他人使用**
   ```bash
   docker pull xlike0616/cloudflare-tunnel-manager:latest
   docker run -d -p 9995:9995 -e CLOUDFLARE_ACCOUNT_ID="their_id" ... xlike0616/cloudflare-tunnel-manager:latest
   ```

---

## 使用说明

### 添加主机名
- 在页面输入子域列表（每行一个，例如 `sub1.example.com`）和服务 URL（例如 `http://localhost:8080`）。
- 点击"提交"，主机名和 DNS CNAME 记录将自动添加。

### 查看主机名
- 页面加载时自动显示当前主机名列表。

### 删除主机名
- 在列表中点击"删除"按钮，主机名及其 DNS 记录将被移除。

---

## 配置项

| 环境变量              | 说明                  | 默认值   |
|-----------------------|-----------------------|----------|
| `SERVER_PORT`         | 服务端口              | 9995     |
| `CLOUDFLARE_AUTH`     | 认证参数      | 空       |
| `CLOUDFLARE_ACCOUNT_ID` | Cloudflare 账户 ID  | 空       |
| `CLOUDFLARE_TUNNEL_ID`  | Tunnel ID          | 空       |
| `CLOUDFLARE_API_TOKEN`  | API Token          | 空       |
| `CLOUDFLARE_ZONE_ID`   | Zone ID            | 空       |

---

## 优化镜像大小

当前镜像大小约为 400 MB，可通过以下方法优化：
1. **使用 JRE 而非 JDK**：基础镜像改为 `eclipse-temurin:17-jre`，减至 160-200 MB。
2. **多阶段构建**：在 Dockerfile 中分离构建和运行阶段。

优化后的 Dockerfile：
```dockerfile
FROM maven:3.8.6-openjdk-17-slim AS builder
WORKDIR /build
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

FROM eclipse-temurin:17-jre
WORKDIR /app
COPY --from=builder /build/target/*.jar app.jar
EXPOSE 9995
ENTRYPOINT ["java", "-jar", "app.jar"]
```

---

## 注意事项

- **API Token 权限**：需包含 `Zero Trust > Edit` 和 `Zone > DNS > Edit`。


