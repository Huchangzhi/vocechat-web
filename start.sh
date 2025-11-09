#!/bin/sh

# 启动 vocechat-server 后台运行
/home/vocechat-server/vocechat-server &
VOCECHAT_PID=$!

# 启动 nginx
nginx -g "daemon off;" &

# 等待进程
wait $VOCECHAT_PID