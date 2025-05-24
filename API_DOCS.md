# ContextFlow API 文档

## 目录
1. [简介](#简介)
2. [基础配置](#基础配置)
3. [认证](#认证)
4. [API 端点](#api-端点)
5. [错误处理](#错误处理)
6. [示例](#示例)

## 简介

ContextFlow API 提供了一套完整的上下文管理接口，支持多模型对话系统中的上下文存储、检索和传递。

## 基础配置

- 基础 URL: `http://127.0.0.1:5001`
- Mock 服务器: `http://127.0.0.1:3002`
- 默认响应格式: JSON
- 编码: UTF-8

## 认证

大多数 API 端点默认不需要认证。如需启用认证：

```json
{
    "ACCESS_CONTROL": {
        "require_auth": true,
        "test_api_key": "your_api_key"
    }
}
```

在请求头中添加：
```
X-API-Key: your_api_key
```

## API 端点

### 上下文管理

#### 保存上下文

- **端点**: `/api/context`
- **方法**: POST
- **描述**: 保存用户对话上下文

**请求体**:
```json
{
    "user_id": "string",
    "content": "string | object",
    "model_type": "string"
}
```

**响应**:
```json
{
    "message": "Context saved successfully",
    "context": {
        "id": "string",
        "user_id": "string",
        "content": "object",
        "type": "string",
        "created_at": "string",
        "metadata": "object"
    }
}
```

#### 获取上下文

- **端点**: `/api/context/<user_id>`
- **方法**: GET
- **描述**: 获取用户的上下文信息

**查询参数**:
- `model_type`: 模型类型（可选）
- `history`: 是否返回历史记录（布尔值，默认 false）
- `limit`: 历史记录数量限制（整数，默认 10）

**响应**:
```json
{
    "id": "string",
    "user_id": "string",
    "model_type": "string",
    "content": "object",
    "created_at": "string"
}
```

#### 删除上下文

- **端点**: `/api/context/<user_id>`
- **方法**: DELETE
- **描述**: 删除用户的上下文信息

**查询参数**:
- `context_id`: 特定上下文 ID（可选）

**响应**:
```json
{
    "message": "Context deleted successfully"
}
```

### 上下文传递

#### 模型间上下文传递

- **端点**: `/api/transfer`
- **方法**: POST
- **描述**: 在不同模型间传递和转换上下文

**请求体**:
```json
{
    "user_id": "string",
    "source_model": "string",
    "target_model": "string",
    "context": "object"
}
```

**响应**:
```json
{
    "status": "success",
    "message": "Context transferred successfully",
    "source_format": "string",
    "target_format": "string",
    "context": {
        "content": "object",
        "model_type": "string"
    }
}
```

### 模型管理

#### 获取支持的模型列表

- **端点**: `/api/models`
- **方法**: GET
- **描述**: 获取系统支持的 AI 模型列表

**响应**:
```json
{
    "message": "Models retrieved successfully",
    "models": ["array of strings"]
}
```

### 配置管理

#### 获取/更新配置

- **端点**: `/api/config`
- **方法**: GET/POST
- **描述**: 获取或更新系统配置

**GET 响应**:
```json
{
    "models": "object"
}
```

**POST 请求体**:
```json
{
    "config_key": "value"
}
```

## 错误处理

API 使用标准 HTTP 状态码表示请求状态：

- 200: 成功
- 400: 请求参数错误
- 401: 未授权
- 404: 资源不存在
- 500: 服务器内部错误

错误响应格式：
```json
{
    "error": "错误描述"
}
```

## 示例

### Python 示例

```python
import requests

# 保存上下文
response = requests.post(
    "http://127.0.0.1:5001/api/context",
    json={
        "user_id": "user123",
        "content": "对话内容",
        "model_type": "gpt"
    }
)

# 获取上下文
response = requests.get(
    "http://127.0.0.1:5001/api/context/user123",
    params={"model_type": "gpt"}
)

# 传递上下文
response = requests.post(
    "http://127.0.0.1:5001/api/transfer",
    json={
        "user_id": "user123",
        "source_model": "gpt",
        "target_model": "claude",
        "context": "上下文内容"
    }
)
```

### cURL 示例

```bash
# 保存上下文
curl -X POST http://127.0.0.1:5001/api/context \
     -H "Content-Type: application/json" \
     -d '{"user_id": "user123", "content": "对话内容", "model_type": "gpt"}'

# 获取上下文
curl http://127.0.0.1:5001/api/context/user123?model_type=gpt

# 传递上下文
curl -X POST http://127.0.0.1:5001/api/transfer \
     -H "Content-Type: application/json" \
     -d '{
         "user_id": "user123",
         "source_model": "gpt",
         "target_model": "claude",
         "context": "上下文内容"
     }'
``` 