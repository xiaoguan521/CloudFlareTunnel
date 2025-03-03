# GitHub Actions 工作流使用说明

本项目使用 GitHub Actions 自动构建 Java 应用并发布 Docker 镜像。

## 工作流程

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

## 触发条件

工作流在以下情况下触发：
- 推送到 `main` 分支
- 创建针对 `main` 分支的 Pull Request
- 手动触发（通过 GitHub 界面）

注意：Docker 镜像只在推送到 `main` 分支时构建，不会在 Pull Request 中构建。

## 设置步骤

要使用此工作流，您需要在 GitHub 仓库中设置以下 Secrets：

1. **DOCKER_HUB_USERNAME**：您的 Docker Hub 用户名
2. **DOCKER_HUB_TOKEN**：您的 Docker Hub 访问令牌（不是密码）

### 如何设置 GitHub Secrets

1. 在您的 GitHub 仓库中，点击 "Settings"
2. 在左侧菜单中，点击 "Secrets and variables" > "Actions"
3. 点击 "New repository secret"
4. 添加 `DOCKER_HUB_USERNAME` 和 `DOCKER_HUB_TOKEN`

### 如何获取 Docker Hub 访问令牌

1. 登录到 [Docker Hub](https://hub.docker.com/)
2. 点击您的用户名，然后选择 "Account Settings"
3. 在左侧菜单中，点击 "Security"
4. 点击 "New Access Token"
5. 输入令牌描述，选择适当的权限
6. 点击 "Generate"
7. 复制生成的令牌（这是您唯一能看到它的机会）

## 自定义

您可以根据需要自定义工作流：

- 修改 Docker 镜像名称：更改 `images` 参数
- 调整标签策略：修改 `tags` 部分
- 添加测试步骤：在 Maven 构建后添加测试命令
- 配置通知：添加通知步骤，如 Slack 或邮件通知

## 手动触发工作流

1. 在 GitHub 仓库中，点击 "Actions" 标签
2. 在左侧列表中选择 "Build and Deploy" 工作流
3. 点击 "Run workflow" 按钮
4. 选择分支，然后点击 "Run workflow" 