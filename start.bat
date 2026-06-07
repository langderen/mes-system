@echo off
chcp 65001 >nul
echo ==========================================
echo    MES制造执行系统 - 快速启动
echo ==========================================
echo.

REM 检查Java环境
where java >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ❌ 错误: 未找到Java环境，请先安装JDK 8或更高版本
    pause
    exit /b 1
)

REM 检查JAR文件是否存在
set JAR_FILE=mes\target\mes-1.0.0.jar

if not exist "%JAR_FILE%" (
    echo 📦 未找到编译后的JAR文件，开始编译项目...
    cd mes
    
    where mvn >nul 2>nul
    if %ERRORLEVEL% NEQ 0 (
        echo ❌ 无法编译项目，请先安装Maven或确保JAR文件存在
        cd ..
        pause
        exit /b 1
    )
    
    call mvn clean package -DskipTests
    if %ERRORLEVEL% NEQ 0 (
        echo ❌ 编译失败，请检查错误信息
        cd ..
        pause
        exit /b 1
    )
    
    cd ..
)

echo.
echo ✅ 找到JAR文件: %JAR_FILE%
echo.

REM 检查Docker是否可用
where docker >nul 2>nul
if %ERRORLEVEL% EQU 0 (
    echo 🚀 检测到Docker环境
    echo.
    echo 请选择启动方式:
    echo 1. Docker Compose启动（推荐，包含MySQL和Redis）
    echo 2. 直接运行JAR文件（需要本地MySQL和Redis）
    echo 3. 仅打包项目
    echo.
    set /p choice=请输入选项 (1-3): 
    
    if "%choice%"=="1" (
        echo.
        echo 🐳 使用Docker Compose启动...
        
        if not exist "docker-compose.yml" (
            echo ❌ 错误: 未找到docker-compose.yml文件
            pause
            exit /b 1
        )
        
        docker-compose up -d
        
        echo.
        echo ✅ 服务正在启动中，请稍候...
        echo.
        echo 📋 查看日志: docker-compose logs -f
        echo 📋 停止服务: docker-compose down
        echo.
        echo 🌐 访问地址: http://localhost/
        echo 🌐 API文档: http://localhost/swagger-ui.html
    ) else if "%choice%"=="2" (
        echo.
        echo 🚀 直接运行JAR文件...
        cd mes
        java -jar target\mes-1.0.0.jar --spring.profiles.active=dev
    ) else if "%choice%"=="3" (
        echo.
        echo 📦 仅打包项目...
        cd mes
        call mvn clean package -DskipTests
        if %ERRORLEVEL% EQU 0 (
            echo.
            echo ✅ 打包成功！
            echo 📦 JAR文件位置: mes\target\mes-1.0.0.jar
        )
    ) else (
        echo ❌ 无效选项
        pause
        exit /b 1
    )
) else (
    echo ⚠️  未检测到Docker环境，将直接运行JAR文件
    echo.
    echo 请确保本地已安装并启动MySQL和Redis
    echo.
    pause
    
    cd mes
    java -jar target\mes-1.0.0.jar --spring.profiles.active=dev
)

echo.
echo ==========================================
echo   感谢使用MES制造执行系统！
echo ==========================================
pause
