#!/bin/bash

# Hexo 部署脚本

echo "=== 开始部署 ==="

# 清理并生成
echo "清理旧文件..."
hexo clean

echo "生成静态文件..."
hexo generate

# 检查生成的 CSS 是否包含 Gitalk 样式
echo "检查 CSS 文件..."
if grep -q "gt-container" public/css/style.css; then
    echo "✓ Gitalk 样式已包含在 CSS 中"
else
    echo "✗ Gitalk 样式未找到！"
    exit 1
fi

# 显示 CSS 文件大小
echo "CSS 文件大小:"
ls -lh public/css/style.css

# 提交到 Git
echo "提交更改到 Git..."
git add -A
git commit -m "更新评论样式 $(date '+%Y-%m-%d %H:%M:%S')" || echo "没有更改需要提交"

echo "推送到远程仓库..."
git push origin main

echo "=== 部署完成 ==="
echo "请检查 Cloudflare Pages 构建状态"
