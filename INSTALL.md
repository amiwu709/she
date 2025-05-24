# ContextFlow 安装部署文档

## 目录
1. [系统要求](#系统要求)
2. [安装步骤](#安装步骤)
3. [配置说明](#配置说明)
4. [启动服务](#启动服务)
5. [验证安装](#验证安装)
6. [故障排除](#故障排除)

## 系统要求

### 基础环境
- Python 3.8 或更高版本
- pip 包管理器
- 虚拟环境工具 (推荐使用 venv 或 conda)

### 硬件要求
- CPU: 双核或更高
- 内存: 最少 4GB RAM
- 磁盘空间: 最少 1GB 可用空间

### 操作系统支持
- Linux (推荐 Ubuntu 20.04 或更高版本)
- macOS (10.15 或更高版本)
- Windows 10/11

## 安装步骤

### 1. 克隆代码仓库
```bash
git clone <repository_url>
cd map_context_plugin
```

### 2. 创建并激活虚拟环境
```bash
# 使用 venv
python -m venv myenv
source myenv/bin/activate  # Linux/macOS
myenv\\Scripts\\activate   # Windows

# 或使用 conda
conda create -n contextflow python=3.8
conda activate contextflow
```

### 3. 安装依赖
```bash
# 安装 Python SDK
cd contextflow/sdk/python
pip install -e .

# 安装项目依赖
cd ../../..
pip install -r requirements.txt
```

## 配置说明

### 1. 基础配置
配置文件位置：`contextflow/config.py`

主要配置项：
```python
DEBUG = True  # 开发环境设置为 True，生产环境设置为 False
HOST = '127.0.0.1'  # 服务器主机地址
PORT = 5001  # 主应用端口
MOCK_PORT = 3002  # Mock 服务器端口
```

### 2. 安全配置
```python
SECRET_KEY = 'your-secret-key'  # 修改为您的密钥
ACCESS_CONTROL = {
    'require_auth': True,  # 是否启用认证
    'test_api_key': 'your-api-key'  # 测试用 API 密钥
}
```

### 3. HTTPS 配置（可选）
```python
USE_HTTPS = False  # 是否启用 HTTPS
SSL_CERT = 'path/to/cert.pem'  # SSL 证书路径
SSL_KEY = 'path/to/key.pem'  # SSL 密钥路径
```

## 启动服务

### 1. 使用启动脚本（推荐）
```bash
# 添加执行权限
chmod +x start.sh

# 启动服务
./start.sh
```

### 2. 手动启动
```bash
# 启动 Mock 服务器
python contextflow/demo/mock_server.py &

# 等待 2 秒确保 Mock 服务器完全启动
sleep 2

# 启动主应用
python contextflow/app.py
```

## 验证安装

### 1. 检查服务状态
- Mock 服务器应运行在 http://127.0.0.1:3002
- 主应用应运行在 http://127.0.0.1:5001

### 2. 测试接口
```bash
# 测试主页
curl http://127.0.0.1:5001/

# 测试上下文保存
curl -X POST http://127.0.0.1:5001/api/context \
  -H "Content-Type: application/json" \
  -d '{"user_id": "test", "content": "test message"}'
```

### 3. 访问演示页面
在浏览器中访问以下地址：
- 插件介绍页面：http://127.0.0.1:5001/plugin_intro
- 知识问答演示：http://127.0.0.1:5001/demo/knowledge_demo
- 天气查询演示：http://127.0.0.1:5001/demo/weather

## 故障排除

### 1. 端口占用问题
如果遇到端口已被占用的错误：
```bash
# 查找占用端口的进程
lsof -i :3002,5001

# 终止进程
kill -9 <PID>
```

### 2. SDK 相关问题
如果遇到 SDK 导入或方法缺失问题：
```bash
# 重新安装 SDK
cd contextflow/sdk/python
pip uninstall contextflow-sdk
pip install -e .
```

### 3. 日志查看
- 服务器日志位于 `server.log`
- 查看实时日志：
```bash
tail -f server.log
```

### 4. 常见错误
1. `ImportError: No module named 'contextflow_sdk'`
   - 解决方案：确保正确安装了 SDK
   
2. `Address already in use`
   - 解决方案：使用 `start.sh` 脚本启动，它会自动处理端口占用问题

3. `'ContextFlowClient' object has no attribute 'list_contexts'`
   - 解决方案：更新到最新版本的 SDK

## 支持与帮助

如果您在安装或使用过程中遇到问题，请：
1. 查看详细的错误日志
2. 检查配置文件是否正确
3. 确保所有依赖都已正确安装
4. 参考项目文档或提交 Issue 