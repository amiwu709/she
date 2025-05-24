#!/bin/bash

# 设置日志文件
LOG_FILE="server.log"
MAX_RETRIES=3
RETRY_INTERVAL=2

# 记录日志的函数
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a $LOG_FILE
}

# 检查端口是否被占用
check_port() {
    local port=$1
    if lsof -i :$port > /dev/null 2>&1; then
        return 0 # 端口被占用
    else
        return 1 # 端口未被占用
    fi
}

# 清理端口的函数
cleanup_port() {
    local port=$1
    local pid=$(lsof -t -i:$port)
    if [ ! -z "$pid" ]; then
        log "正在清理端口 $port (PID: $pid)..."
        kill -9 $pid 2>/dev/null
        sleep 1
        if check_port $port; then
            log "警告: 端口 $port 清理失败"
            return 1
        else
            log "端口 $port 清理成功"
            return 0
        fi
    fi
    return 0
}

# 启动服务的函数
start_service() {
    local name=$1
    local cmd=$2
    local port=$3
    local retries=0

    while [ $retries -lt $MAX_RETRIES ]; do
        log "正在启动 $name (尝试 $((retries + 1))/$MAX_RETRIES)..."
        
        # 先检查端口
        if check_port $port; then
            log "端口 $port 被占用，尝试清理..."
            cleanup_port $port
            if [ $? -ne 0 ]; then
                log "错误: 无法清理端口 $port"
                return 1
            fi
        fi

        # 启动服务
        eval "$cmd" &
        local pid=$!
        log "$name 已启动 (PID: $pid)"

        # 等待服务启动
        sleep $RETRY_INTERVAL
        if ! check_port $port; then
            log "错误: $name 启动失败"
            ((retries++))
            continue
        fi

        # 检查进程是否还在运行
        if kill -0 $pid 2>/dev/null; then
            log "$name 启动成功"
            return 0
        else
            log "错误: $name 进程已退出"
            ((retries++))
        fi
    done

    log "错误: $name 启动失败，已达到最大重试次数"
    return 1
}

# 清理日志文件
echo "" > $LOG_FILE
log "开始启动服务..."

# 启动 mock server
if ! start_service "Mock Server" "python contextflow/demo/mock_server.py" 3002; then
    log "错误: Mock Server 启动失败"
    exit 1
fi

# 等待 mock server 完全启动
sleep 2

# 启动主应用
if ! start_service "主应用" "python contextflow/app.py" 5001; then
    log "错误: 主应用启动失败"
    # 清理 mock server
    cleanup_port 3002
    exit 1
fi

log "所有服务启动成功"
log "Mock Server 运行在 http://127.0.0.1:3002"
log "主应用运行在 http://127.0.0.1:5001"

# 等待所有后台进程
wait 