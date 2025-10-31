# COMP7503 智慧城市项目 - 快速入门指南

基于香港开放数据的智慧城市数据采集、分析与可视化系统

---

## 项目简介

本项目使用Node-RED和MongoDB构建了一个完整的智慧城市数据分析平台，主要功能包括：

- **实时数据采集**: 从 data.gov.hk 自动采集空气质量、天气、交通等数据
- **数据存储**: 使用MongoDB存储时间序列数据
- **数据分析**: 关联分析、趋势分析、异常检测
- **可视化展示**: 交互式Dashboard实时展示数据和分析结果

## 快速开始

### 前置要求

确保您的系统已安装：

- **Docker**: 20.10 或更高版本
- **Docker Compose**: 2.0 或更高版本
- **浏览器**: Chrome/Firefox/Safari 最新版本

检查安装：
```bash
docker --version
docker-compose --version
```

### 安装步骤

#### 1. 启动服务

在项目目录下运行：

```bash
# 启动所有服务（Node-RED + MongoDB + Mongo Express）
docker-compose up -d

# 查看服务状态
docker-compose ps

# 查看日志
docker-compose logs -f
```

预期输出：
```
NAME                    STATUS              PORTS
comp7503-nodered        running             0.0.0.0:1880->1880/tcp
comp7503-mongodb        running             0.0.0.0:27017->27017/tcp
comp7503-mongo-express  running             0.0.0.0:8081->8081/tcp
```

#### 2. 访问Node-RED

打开浏览器访问：**http://localhost:1880**

您将看到Node-RED的流程编辑器界面。

#### 3. 导入Flow

1. 点击右上角菜单（三条横线）→ **Import**
2. 选择 **select a file to import**
3. 选择 `SmartCity.Flow.json` 文件
4. 点击 **Import**

#### 4. 配置MongoDB连接

导入flow后，需要配置MongoDB连接：

1. 双击任意MongoDB节点
2. 点击 **Server** 旁边的铅笔图标
3. 填写配置：
   - **Host**: `mongodb`
   - **Port**: `27017`
   - **Database**: `smartcity`
   - **Name**: `MongoDB Connection`
4. 点击 **Update** 和 **Done**

#### 5. 部署Flow

点击右上角的红色 **Deploy** 按钮。

部署成功后，数据采集将自动开始：
- 空气质量数据：每15分钟
- 天气数据：每30分钟
- 交通数据：每10分钟

#### 6. 访问Dashboard

打开新标签页访问：**http://localhost:1880/ui**

您将看到智慧城市Dashboard，包含：
- 实时空气质量指数
- 各区AQI柱状图
- 温度趋势图
- 交通状况分布

## 服务端口

| 服务 | 端口 | URL | 说明 |
|------|------|-----|------|
| Node-RED | 1880 | http://localhost:1880 | 流程编辑器 |
| Dashboard | 1880 | http://localhost:1880/ui | 数据可视化界面 |
| MongoDB | 27017 | mongodb://localhost:27017 | 数据库 |
| Mongo Express | 8081 | http://localhost:8081 | 数据库管理界面 |

## 项目结构

```
hw/
├── docker-compose.yml          # Docker编排配置
├── Dockerfile                  # 自定义Node-RED镜像（可选）
├── package.json                # Node.js依赖声明
├── SmartCity.Flow.json         # Node-RED流程定义
├── 解决方案文档.md             # 详细的技术方案
├── 项目报告模板.md             # 项目报告模板
└── README.md                   # 本文件
```

## 主要功能

### 1. 数据采集

系统自动从以下数据源采集数据：

- **空气质量**: 环保署空气质量健康指数API
- **天气数据**: 香港天文台天气API
- **交通数据**: 运输署交通快拍API（当前为模拟数据）

### 2. 数据存储

MongoDB中的主要集合：

- `air_quality`: 空气质量数据
- `traffic_flow`: 交通流量数据
- `weather_data`: 天气数据
- `analysis_results`: 分析结果

### 3. 数据分析

- **相关性分析**: 空气质量与交通流量的关系
- **趋势分析**: 移动平均、季节性分析
- **异常检测**: 基于Z-score的异常值识别

### 4. 可视化

Dashboard提供多种图表：
- **Gauge**: 实时指标展示
- **Line Chart**: 时间序列趋势
- **Bar Chart**: 对比分析
- **Pie Chart**: 分类占比
- **Table**: 详细数据列表

## 数据库管理

### 使用Mongo Express

访问 http://localhost:8081

- 用户名: `admin`
- 密码: `admin123`

在这里可以：
- 浏览所有集合
- 执行查询
- 查看数据统计
- 手动修改数据

### 使用命令行

进入MongoDB容器：
```bash
docker exec -it comp7503-mongodb mongosh
```

常用命令：
```javascript
// 切换到smartcity数据库
use smartcity

// 查看所有集合
show collections

// 查询最新的10条空气质量数据
db.air_quality.find().sort({timestamp: -1}).limit(10)

// 查看集合中的文档数量
db.air_quality.countDocuments()

// 查询特定站点的数据
db.air_quality.find({station: "中西区"})

// 删除所有数据（谨慎使用！）
db.air_quality.deleteMany({})
```

## 常见问题

### Q1: 启动后无法访问Node-RED

**解决方案**:
```bash
# 检查容器状态
docker-compose ps

# 查看Node-RED日志
docker-compose logs node-red

# 如果容器未运行，尝试重启
docker-compose restart node-red
```

### Q2: Dashboard不显示数据

**原因**:
- 数据库中还没有数据（刚启动需要等待第一次采集）
- MongoDB连接配置错误

**解决方案**:
```bash
# 1. 检查是否有数据
docker exec -it comp7503-mongodb mongosh smartcity --eval "db.air_quality.countDocuments()"

# 2. 如果没有数据，手动触发一次采集
# 在Node-RED编辑器中，点击inject节点左侧的按钮

# 3. 检查Debug节点输出
# 在Node-RED编辑器中，打开右侧的Debug面板
```

### Q3: MongoDB连接失败

**错误信息**: `Error: connect ECONNREFUSED`

**解决方案**:
```bash
# 1. 确保MongoDB容器正在运行
docker-compose ps mongodb

# 2. 重启MongoDB
docker-compose restart mongodb

# 3. 等待30秒后重启Node-RED
docker-compose restart node-red
```

### Q4: 端口被占用

**错误信息**: `Bind for 0.0.0.0:1880 failed: port is already allocated`

**解决方案**:

方法1 - 停止占用端口的服务：
```bash
# 查找占用端口的进程（macOS/Linux）
lsof -i :1880

# 杀死进程
kill -9 <PID>
```

方法2 - 修改docker-compose.yml中的端口映射：
```yaml
services:
  node-red:
    ports:
      - "1881:1880"  # 改为1881端口
```

### Q5: 如何清空所有数据重新开始

```bash
# 停止所有服务
docker-compose down

# 删除数据卷（会清空所有数据！）
docker volume rm hw_mongodb-data hw_node-red-data

# 重新启动
docker-compose up -d
```

## 自定义和扩展

### 添加新的数据源

1. 在Node-RED中添加新的flow
2. 使用 `inject` 节点定时触发
3. 使用 `http request` 节点调用API
4. 使用 `function` 节点解析数据
5. 使用 `mongodb out` 节点存储数据

### 修改采集频率

在inject节点中修改 **Repeat** 参数：
- 单位：秒
- 例如：900秒 = 15分钟

### 添加新的Dashboard图表

1. 从左侧面板拖入Dashboard节点（如 `ui_chart`）
2. 配置图表类型和样式
3. 连接到数据源节点
4. 部署并刷新Dashboard页面

### 创建自定义分析

在 `function` 节点中编写JavaScript代码：

```javascript
// 示例：计算过去1小时的平均AQI
var data = msg.payload; // 从MongoDB查询的数据

if (Array.isArray(data) && data.length > 0) {
    var sum = 0;
    data.forEach(function(record) {
        sum += record.aqi;
    });

    var average = sum / data.length;

    msg.payload = {
        average: average,
        count: data.length,
        timestamp: new Date()
    };
} else {
    msg.payload = {
        average: 0,
        count: 0,
        error: "No data available"
    };
}

return msg;
```

## 停止和清理

### 停止服务（保留数据）

```bash
docker-compose stop
```

### 重新启动

```bash
docker-compose start
```

### 完全停止并删除容器（保留数据）

```bash
docker-compose down
```

### 完全清理（删除容器和数据）

```bash
# 警告：这将删除所有数据！
docker-compose down -v
```

## 性能优化建议

### 1. 调整采集频率

如果系统资源有限，可以降低采集频率：
- 空气质量：15分钟 → 30分钟
- 天气数据：30分钟 → 1小时
- 交通数据：10分钟 → 15分钟

### 2. 启用数据聚合

使用MongoDB的聚合功能预计算统计数据，减少Dashboard查询负担。

### 3. 限制历史数据量

在Chart节点中设置 `removeOlder` 参数，只保留必要的历史数据：
```javascript
{
    "removeOlder": 24,
    "removeOlderUnit": "3600"
}
```

### 4. 添加索引

在MongoDB中为常用查询字段添加索引：
```javascript
db.air_quality.createIndex({timestamp: -1});
db.air_quality.createIndex({station: 1, timestamp: -1});
```

## 调试技巧

### 1. 使用Debug节点

在关键位置添加Debug节点，查看数据流：
- 拖入 `debug` 节点
- 连接到要调试的节点
- 打开右侧Debug面板查看输出

### 2. 查看日志

```bash
# Node-RED日志
docker-compose logs -f node-red

# MongoDB日志
docker-compose logs -f mongodb

# 所有服务日志
docker-compose logs -f
```

### 3. 手动触发采集

点击inject节点左侧的小方块，立即触发一次数据采集，无需等待定时器。

## 数据备份与恢复

### 备份MongoDB数据

```bash
# 创建备份目录
mkdir -p backup

# 备份所有数据
docker exec comp7503-mongodb mongodump --db=smartcity --out=/data/backup

# 复制到本地
docker cp comp7503-mongodb:/data/backup ./backup
```

### 恢复数据

```bash
# 复制备份到容器
docker cp ./backup comp7503-mongodb:/data/backup

# 恢复数据
docker exec comp7503-mongodb mongorestore --db=smartcity /data/backup/smartcity
```

## 项目提交

提交时需要包含以下文件：

1. **SmartCity.Flow.json** - Node-RED流程文件
2. **docker-compose.yml** - Docker配置
3. **项目报告.pdf** - 详细报告
4. **README.md** - 本文件

可选文件：
- Dockerfile
- package.json
- 其他说明文档

## 相关链接

- **Node-RED官方文档**: https://nodered.org/docs/
- **MongoDB文档**: https://www.mongodb.com/docs/
- **Docker文档**: https://docs.docker.com/
- **香港开放数据平台**: https://data.gov.hk/
- **COMP7503课程主页**: [填写课程网址]

## 技术支持

如遇到问题：

1. 查看本README的常见问题部分
2. 查看 `解决方案文档.md` 中的详细说明
3. 检查Docker和MongoDB日志
4. 联系小组成员或助教

## 许可证

本项目仅用于COMP7503课程学习目的，未经授权不得用于其他用途。

## 致谢

- 香港政府数据开放平台提供的数据API
- Node-RED社区的丰富节点库
- MongoDB优秀的时间序列数据存储能力

---

**祝您使用愉快！**

如果您觉得这个项目有帮助，欢迎给个星标⭐
