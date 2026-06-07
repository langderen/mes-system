#!/bin/bash

# MES系统快速启动脚本
# 适用于Linux/Mac环境

echo "=========================================="
echo "    MES制造执行系统 - 快速启动"
echo "=========================================="
echo ""

# 检查是否有Java环境
if ! command -v java &> /dev/null; then
    echo "❌ 错误: 未找到Java环境，请先安装JDK 8或更高版本"
    exit 1
fi

# 检查Maven环境
if ! command -v mvn &> /dev/null; then
    echo "⚠️  警告: 未找到Maven，将尝试使用已编译的JAR文件"
fi

# 检查JAR文件是否存在
JAR_FILE="mes/target/mes-1.0.0.jar"

if [ ! -f "$JAR_FILE" ]; then
    echo "📦 未找到编译后的JAR文件，开始编译项目..."
    cd mes
    if command -v mvn &> /dev/null; then
        mvn clean package -DskipTests
        if [ $? -ne 0 ]; then
            echo "❌ 编译失败，请检查错误信息"
            exit 1
        fi
    else
        echo "❌ 无法编译项目，请先安装Maven或确保JAR文件存在"
        exit 1
    fi
    cd ..
fi

echo ""
echo "✅ 找到JAR文件: $JAR_FILE"
echo ""

# 检查Docker是否可用
if command -v docker &> /dev/null; then
    echo "🚀 检测到Docker环境"
    echo ""
    echo "请选择启动方式:"
    echo "1. Docker Compose启动（推荐，包含MySQL和Redis）"
    echo "2. 直接运行JAR文件（需要本地MySQL和Redis）"
    echo "3. 仅打包项目"
    echo ""
    read -p "请输入选项 (1-3): " choice

    case $choice in
        1)
            echo ""
            echo "🐳 使用Docker Compose启动..."
            
            # 检查docker-compose.yml是否存在
            if [ ! -f "docker-compose.yml" ]; then
                echo "❌ 错误: 未找到docker-compose.yml文件"
                exit 1
            fi
            
            # 启动服务
            docker-compose up -d
            
            echo ""
            echo "✅ 服务正在启动中，请稍候..."
            echo ""
            echo "📋 查看日志: docker-compose logs -f"
            echo "📋 停止服务: docker-compose down"
            echo ""
            echo "🌐 访问地址: http://localhost/"
            echo "🌐 API文档: http://localhost/swagger-ui.html"
            ;;
        2)
            echo ""
            echo "🚀 直接运行JAR文件..."
            cd mes
            java -jar target/mes-1.0.0.jar --spring.profiles.active=dev
            ;;
        3)
            echo ""
            echo "📦 仅打包项目..."
            cd mes
            mvn clean package -DskipTests
            if [ $? -eq 0 ]; then
                echo ""
                echo "✅ 打包成功！"
                echo "📦 JAR文件位置: mes/target/mes-1.0.0.jar"
            fi
            ;;
        *)
            echo "❌ 无效选项"
            exit 1
            ;;
    esac
else
    echo "⚠️  未检测到Docker环境，将直接运行JAR文件"
    echo ""
    echo "请确保本地已安装并启动MySQL和Redis"
    echo ""
    read -p "按Enter继续，或Ctrl+C退出..."

    cd mes
    java -jar target/mes-1.0.0.jar --spring.profiles.active=dev
fi

echo ""
echo "=========================================="
echo "   感谢使用MES制造执行系统！"
echo "=========================================="
