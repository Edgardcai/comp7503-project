@echo off
chcp 65001 >nul
cls

echo ==================================
echo COMP7503 智慧城市项目
echo 启动脚本 v1.0
echo ==================================
echo.

REM 检查Docker是否安装
where docker >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo 错误: Docker未安装
    echo 请先安装Docker Desktop: https://docs.docker.com/desktop/install/windows-install/
    pause
    exit /b 1
)

REM 检查Docker Compose是否安装
where docker-compose >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo 错误: Docker Compose未安装
    pause
    exit /b 1
)

echo ✓ Docker已安装
docker --version
echo ✓ Docker Compose已安装
docker-compose --version
echo.

REM 检查Docker是否运行
docker info >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo 错误: Docker Desktop未运行
    echo 请先启动Docker Desktop
    pause
    exit /b 1
)

echo ✓ Docker正在运行
echo.

REM 停止可能存在的旧容器
echo 正在检查并清理旧容器...
docker-compose down >nul 2>nul

REM 启动服务
echo.
echo 正在启动服务...
echo - Node-RED (端口 1880)
echo - MongoDB (端口 27017)
echo - Mongo Express (端口 8081)
echo.

docker-compose up -d

REM 等待服务启动
echo.
echo 等待服务启动...
timeout /t 10 /nobreak >nul

REM 检查服务状态
echo.
echo 检查服务状态...
docker-compose ps

REM 显示访问信息
echo.
echo ==================================
echo 服务启动成功！
echo ==================================
echo.
echo 请访问以下地址：
echo.
echo 1. Node-RED编辑器:
echo    http://localhost:1880
echo.
echo 2. Dashboard界面:
echo    http://localhost:1880/ui
echo.
echo 3. MongoDB管理界面:
echo    http://localhost:8081
echo    用户名: admin
echo    密码: admin123
echo.
echo ==================================
echo 下一步操作：
echo ==================================
echo.
echo 1. 打开浏览器访问 http://localhost:1880
echo 2. 点击右上角菜单 → Import
echo 3. 选择 SmartCity.Flow.json 文件
echo 4. 点击 Deploy 按钮部署流程
echo 5. 访问 http://localhost:1880/ui 查看Dashboard
echo.
echo 查看日志: docker-compose logs -f
echo 停止服务: docker-compose stop
echo 完全清理: docker-compose down -v
echo.
echo 详细使用说明请查看 README.md
echo.

pause
