# Cloudflare Pages 部署指南

## 构建设置

在 Cloudflare Pages 控制台中，按照以下配置：

### 构建设置

- **构建命令**: `npm install && npm install -g hexo-cli && hexo generate`
- **构建输出目录**: `public`
- **根目录**: `/`

### 环境变量

不需要设置特殊环境变量。

## 故障排查

### 问题：评论样式不生效

**原因**：CSS 文件被缓存或 Stylus 文件没有被正确编译

**解决方案**：

1. 确保 `hexo-renderer-stylus` 已安装：
   ```bash
   npm list hexo-renderer-stylus
   ```

2. 检查 `package.json` 中的依赖：
   ```json
   "hexo-renderer-stylus": "^3.0.1"
   ```

3. 强制重新构建：
   - 在 Cloudflare Pages 控制台中点击 "重试部署"
   - 或推送一个空提交触发重新构建：
     ```bash
     git commit --allow-empty -m "触发重新构建"
     git push
     ```

4. 清除 Cloudflare 缓存：
   - 进入 Cloudflare Dashboard
   - Caching → Configuration → Purge Everything

### 问题：CSS 文件没有更新

**原因**：浏览器或 CDN 缓存了旧的 CSS 文件

**解决方案**：

已在 `head.ejs` 中添加 CSS 版本号，每次构建时 URL 会变化：
```html
/css/style?v=20250225
```

### 问题：Stylus 文件没有被编译

**检查步骤**：

1. 本地构建测试：
   ```bash
   hexo clean
   hexo generate
   grep "gt-container" public/css/style.css
   ```

2. 如果本地正常但远程不正常，检查 Cloudflare Pages 的构建日志

3. 确保 `themes/vivia/source/css/style.styl` 中正确引用了 `comment.styl`：
   ```stylus
   @import "_partial/comment"
   ```

## 验证部署

部署完成后，检查以下内容：

1. 打开博客页面
2. 按 F12 打开开发者工具
3. 检查 `css/style.css` 是否加载
4. 搜索 `gt-container` 确认 Gitalk 样式是否存在
5. 检查评论区是否正常显示

## 手动触发部署

如果需要手动触发部署：

```bash
# 方法1：推送空提交
git commit --allow-empty -m "重新部署"
git push

# 方法2：修改任意文件
echo "# $(date)" >> README.md
git add README.md
git commit -m "触发部署"
git push
```
