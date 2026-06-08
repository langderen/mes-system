# MES 系统部署说明

## 项目概述

本项目是一个基于 Spring Boot 2.1.7、MyBatis-Plus 和 Freemarker 的 MES 系统。

- 主启动类：`com.wangziyang.mes.SparchetypeApplication`
- 打包产物：`mes-1.0.0.jar`
- 默认开发端口：`9090`
- Docker 对外端口示例：`80`

## 运行环境

- JDK 8
- Maven 3.6+
- MySQL 5.7 / 8.0
- Redis 5.x / 6.x

## 配置文件

项目默认配置文件：

- [application.yml](./mes/src/main/resources/application.yml)
- [application-dev.yml](./mes/src/main/resources/application-dev.yml)
- [application-pro.yml](./mes/src/main/resources/application-pro.yml)

`application.yml` 默认激活 `dev` 环境：

```yaml
spring:
  profiles:
    active: dev
```

## 构建打包

在仓库根目录执行：

```powershell
cd mes
./mvnw clean package -DskipTests
```

如果没有使用 Maven Wrapper，也可以执行：

```powershell
cd mes
mvn clean package -DskipTests
```

打包完成后，Jar 文件位于：

```text
mes/target/mes-1.0.0.jar
```

## 启动应用

### Windows

```powershell
java -jar mes\target\mes-1.0.0.jar
```

### Linux

```bash
java -jar mes/target/mes-1.0.0.jar
```

如需切换生产环境：

```powershell
java -jar mes\target\mes-1.0.0.jar --spring.profiles.active=pro
```

如需显式指定端口：

```powershell
java -jar mes\target\mes-1.0.0.jar --server.port=8080
```

## MySQL 部署说明

### 方式一：Docker Compose

根目录已提供 [docker-compose.yml](./docker-compose.yml)，其中包含 MySQL 服务：

- 镜像：`mysql:5.7`
- 容器名：`mes-mysql`
- 主机端口：`3306`
- 容器端口：`3306`
- 默认库：`mes2026`
- 默认 root 密码：`mes2026`

启动命令：

```bash
docker compose up -d mysql
```

首次启动后，MySQL 数据会持久化到命名卷 `mysql-data`。

### 方式二：手工部署

如果使用本机 MySQL，请按以下要求准备：

- 创建数据库：`mes2026`
- 字符集建议：`utf8mb4`
- 时区建议：`Asia/Shanghai`
- 账号需要有建表、读写权限

示例初始化参数：

```sql
CREATE DATABASE mes2026 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

然后修改对应环境配置中的数据库连接：

- 开发环境：`mes/src/main/resources/application-dev.yml`
- 生产环境：`mes/src/main/resources/application-pro.yml`

### 数据库连接说明

开发环境默认使用类似下面的 JDBC 地址：

```text
jdbc:mysql://mysql6.sqlpub.com:3311/mes2026?useUnicode=true&characterEncoding=utf8&useSSL=false&serverTimezone=Asia/Shanghai&allowPublicKeyRetrieval=true
```

生产环境请替换成你自己的 MySQL 地址、账号和密码。

## Redis 部署说明

### 方式一：Docker Compose

根目录 [docker-compose.yml](./docker-compose.yml) 已包含 Redis 服务：

- 镜像：`redis:6-alpine`
- 容器名：`mes-redis`
- 主机端口：`6379`
- 容器端口：`6379`
- 数据卷：`redis-data`

启动命令：

```bash
docker compose up -d redis
```

### 方式二：手工部署

本机安装 Redis 后，确保应用可以连接到：

- 主机：`localhost`
- 端口：`6379`

如需设置密码，请同步修改配置文件里的 Redis 密码项。

## 一键部署

仓库根目录的 [docker-compose.yml](./docker-compose.yml) 已将应用、MySQL 和 Redis 编排到同一个网络中。

### 启动全部服务

```bash
docker compose up -d
```

### 访问地址

- 应用访问：`http://localhost`
- MySQL：`127.0.0.1:3306`
- Redis：`127.0.0.1:6379`

## Docker Compose 说明

当前 `docker-compose.yml` 的关键点：

- `mes-system` 容器通过 `SPRING_DATASOURCE_URL`、`SPRING_DATASOURCE_USERNAME`、`SPRING_DATASOURCE_PASSWORD` 覆盖数据库配置
- `SPRING_REDIS_HOST=redis` 指向同网络中的 Redis 容器
- `FILE_UPLOAD_DIR=/upload` 对应挂载卷 `mes-upload`
- 应用容器对外映射为 `80:9090`

也就是说，容器内应用仍然监听 `9090`，外部通过宿主机 `80` 端口访问。

## 手工 Docker 部署

如果不使用 `docker compose`，也可以分开部署：

1. 启动 MySQL
2. 启动 Redis
3. 打包应用 Jar
4. 挂载 Jar 文件并启动应用容器

示例应用容器启动方式：

```bash
docker run -d --name mes-system -p 80:9090 -v ./mes/target/mes-1.0.0.jar:/app.jar openjdk:8-jdk-alpine sh -c "java -Djava.security.egd=file:/dev/./urandom -jar /app.jar"
```

## 文件上传目录

项目配置中默认上传目录为：

- Windows：`E:/mes-upload`
- Docker Compose：`/upload`

部署前请确保目录存在，并且应用进程有读写权限。

## 常见问题

### 1. `java run xxx.jar` 报错

正确命令应为：

```powershell
java -jar mes\target\mes-1.0.0.jar
```

### 2. MySQL 连接失败

检查以下内容：

- 数据库是否已启动
- 地址、端口、用户名、密码是否正确
- 数据库是否允许远程访问
- JDBC URL 是否与数据库时区一致

### 3. Redis 连接失败

检查以下内容：

- Redis 是否已启动
- `host` 和 `port` 是否正确
- 是否启用了密码认证

### 4. 上传失败

检查上传目录是否存在，以及应用是否有写权限。

## 版本信息

- 项目版本：`1.0.0`
- Spring Boot：`2.1.7.RELEASE`
- Java：`1.8`
