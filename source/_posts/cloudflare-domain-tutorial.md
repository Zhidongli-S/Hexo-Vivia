# Cloudflare 域名托管完整教程

本文将详细介绍如何将域名托管到 Cloudflare，包括注册账号、添加域名、修改 NS 服务器、开启 CDN 和 SSL 证书等完整流程。

## 一、注册 Cloudflare 账号

### 1.1 访问 Cloudflare 官网
打开 [https://www.cloudflare.com](https://www.cloudflare.com)，点击右上角的 **"Sign Up"** 按钮。

### 1.2 填写注册信息
- **Email**: 输入你的邮箱地址
- **Password**: 设置密码（建议使用强密码）
- 点击 **"Create Account"** 完成注册

### 1.3 验证邮箱
登录你的邮箱，点击 Cloudflare 发送的验证链接完成验证。

## 二、添加域名到 Cloudflare

### 2.1 登录后添加站点
1. 登录 Cloudflare 后，点击 **"Add a Site"** 或 **"+ Add Site"**
2. 在输入框中输入你的域名（例如：`example.com`）
3. 点击 **"Continue"**

### 2.2 选择套餐计划
Cloudflare 提供多种套餐：
- **Free**: 免费版，包含基础 CDN、SSL、DNS 等功能
- **Pro**: $20/月，包含更多高级功能
- **Business**: $200/月，适合企业用户
- **Enterprise**: 定制价格

对于个人博客，选择 **Free** 套餐即可，点击 **"Continue with Free"**。

### 2.3 等待 DNS 记录扫描
Cloudflare 会自动扫描你域名的现有 DNS 记录。这个过程可能需要几分钟。

扫描完成后，检查列出的 DNS 记录是否正确：
- **A 记录**: 指向你的服务器 IP
- **CNAME 记录**: 别名记录
- **MX 记录**: 邮件服务器记录
- **TXT 记录**: 文本记录

如有遗漏或错误，可以手动添加或修改。

## 三、修改域名 NS 服务器

### 3.1 获取 Cloudflare NS 服务器
在 DNS 记录确认页面，Cloudflare 会分配两个 NS 服务器地址，格式如下：
```
xxx.ns.cloudflare.com
yyy.ns.cloudflare.com
```

**记录下这两个地址**，稍后会用到。

### 3.2 登录域名注册商
前往你购买域名的注册商（如阿里云、腾讯云、GoDaddy、Namecheap 等）。

### 3.3 修改 NS 服务器
以常见注册商为例：

#### 阿里云
1. 登录阿里云控制台
2. 进入 **域名** → **域名列表**
3. 找到你的域名，点击 **管理**
4. 选择 **DNS 修改** 或 **DNS 服务器**
5. 点击 **修改 DNS 服务器**
6. 选择 **自定义 DNS**，填入 Cloudflare 提供的两个 NS 地址
7. 点击 **确定**

#### 腾讯云
1. 登录腾讯云控制台
2. 进入 **域名注册** → **我的域名**
3. 找到域名，点击 **管理**
4. 选择 **DNS 解析** → **修改 DNS 服务器**
5. 选择 **自定义 DNS**，填入 Cloudflare NS 地址
6. 点击 **提交**

#### GoDaddy
1. 登录 GoDaddy 账户
2. 进入 **My Products** → **Domains**
3. 点击域名旁边的 **DNS**
4. 找到 **Nameservers** 部分，点击 **Change**
5. 选择 **Enter my own nameservers**
6. 填入 Cloudflare NS 地址
7. 点击 **Save**

### 3.4 等待生效
NS 服务器修改后，需要等待 **24-48 小时** 全球生效（通常几分钟到几小时即可）。

回到 Cloudflare，点击 **"Done, check nameservers"**，Cloudflare 会自动检测 NS 是否修改成功。

## 四、开启 CDN 加速

### 4.1 确认 CDN 已启用
在 Cloudflare 的 **DNS** 设置页面：
- 找到 **Proxy status** 列
- 确保显示为 **"Proxied"**（橙色云朵图标）

如果显示 **"DNS only"**（灰色云朵），点击切换到 **"Proxied"**。

### 4.2 配置缓存规则（可选）
1. 进入 **Caching** → **Configuration**
2. 可以设置：
   - **Caching Level**: 建议选 **Standard**
   - **Browser Cache TTL**: 浏览器缓存时间
   - **Always Online**: 开启后网站离线时显示缓存页面

### 4.3 配置页面规则（可选）
1. 进入 **Rules** → **Page Rules**
2. 点击 **Create Page Rule**
3. 可以设置：
   - 缓存级别
   - 始终使用 HTTPS
   - 自动 HTTPS 重写
   - 等等

## 五、开启 SSL 证书

### 5.1 进入 SSL/TLS 设置
点击顶部菜单 **SSL/TLS**。

### 5.2 选择加密模式
在 **Overview** 页面，选择适合你网站的加密模式：

| 模式 | 说明 | 适用场景 |
|------|------|----------|
| **Off** | 不加密 | 不推荐 |
| **Flexible** | 用户到 Cloudflare 加密，Cloudflare 到服务器不加密 | 服务器没有 SSL 证书 |
| **Full** | 全程加密，但不验证服务器证书 | 服务器有自签名证书 |
| **Full (strict)** | 全程加密，验证服务器证书 | 服务器有有效 SSL 证书（推荐） |

**推荐选择**: **Full (strict)**

### 5.3 强制 HTTPS 重定向
1. 进入 **SSL/TLS** → **Edge Certificates**
2. 找到 **Always Use HTTPS**，开启开关
3. 这样所有 HTTP 请求会自动重定向到 HTTPS

### 5.4 自动 HTTPS 重写
在同一页面，开启 **Automatic HTTPS Rewrites**：
- 自动将页面中的 HTTP 链接重写为 HTTPS
- 避免混合内容警告

### 5.5 HSTS 设置（可选，高级）
1. 在 **Edge Certificates** 页面，找到 **HTTP Strict Transport Security (HSTS)**
2. 点击 **Enable HSTS**
3. 建议设置：
   - **Max Age**: 6 months (15552000 seconds)
   - 勾选 **Apply HSTS policy to subdomains**
   - 勾选 **Preload**

⚠️ **警告**: HSTS 一旦开启，浏览器会强制使用 HTTPS，请确保 HTTPS 完全配置好再开启。

## 六、验证配置

### 6.1 检查 SSL 证书
访问 `https://你的域名`，查看浏览器地址栏：
- 应该显示 🔒 安全锁标志
- 点击锁标志，查看证书是否由 Cloudflare 颁发

### 6.2 检查 CDN 是否生效
1. 打开命令提示符或终端
2. 运行命令：
   ```bash
   nslookup 你的域名
   ```
3. 查看返回的 IP 地址，如果是 Cloudflare 的 IP（以 104. 或 172. 开头），说明 CDN 已生效

### 6.3 检查响应头
使用浏览器开发者工具（F12）→ Network → 刷新页面 → 点击任意请求：
- 查看 Response Headers 中是否有 `cf-ray` 或 `cf-cache-status`
- 有则说明经过 Cloudflare CDN

## 七、常见问题

### Q1: 修改 NS 后网站无法访问？
- 等待 DNS 传播（最长 48 小时）
- 检查 Cloudflare DNS 记录是否正确
- 确认服务器 IP 没有变化

### Q2: SSL 证书显示无效？
- 确认选择了正确的 SSL 模式
- 如果是 Full (strict) 模式，确保服务器有有效证书
- 可以先用 Flexible 模式测试

### Q3: 如何暂停 Cloudflare？
- 进入 **Overview** 页面
- 点击 **Pause Cloudflare on Site**
- 这会临时绕过 Cloudflare，直接访问源站

### Q4: 如何完全移除 Cloudflare？
- 在域名注册商处将 NS 改回原来的地址
- 等待 DNS 传播完成
- 在 Cloudflare 删除该站点

## 八、进阶优化

### 8.1 开启 Brotli 压缩
1. 进入 **Speed** → **Optimization**
2. 开启 **Brotli**

### 8.2 开启 HTTP/2 和 HTTP/3
在 **Network** 设置中，确保开启：
- HTTP/2
- HTTP/3 (QUIC)
- 0-RTT Connection Resumption

### 8.3 配置防火墙规则
1. 进入 **Security** → **WAF**
2. 可以设置：
   - 阻止特定国家/地区
   - 阻止特定 IP
   - 设置速率限制

## 总结

完成以上步骤后，你的域名就成功托管到 Cloudflare 了：

✅ 享受 Cloudflare 的全球 CDN 加速  
✅ 免费的 SSL 证书和 HTTPS 加密  
✅ DDoS 防护和 Web 应用防火墙  
✅ DNS 解析加速  

如有问题，可以在 Cloudflare 社区或文档中寻找帮助。
