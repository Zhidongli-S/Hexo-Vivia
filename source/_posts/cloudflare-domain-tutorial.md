---
layout: post
title: Cloudflare 域名托管完整教程
date: 2026-02-24 21:00:00
categories: 傻瓜教程
description: 本文详细介绍如何将域名托管到 Cloudflare，包括注册账号、添加域名、修改 NS 服务器、开启 CDN 加速和 SSL 证书等完整流程。
---

Cloudflare 是全球领先的 CDN 和 DNS 服务提供商，提供免费的域名解析、SSL 证书、DDoS 防护等功能。本文将手把手教你完成域名托管的全流程。

---

### 注册 Cloudflare 账号

访问 [Cloudflare 官网](https://www.cloudflare.com)，点击右上角 **Sign Up** 按钮。

填写注册信息：
- **Email**: 输入你的邮箱地址
- **Password**: 设置强密码

点击 **Create Account** 完成注册，然后登录邮箱点击验证链接激活账号。

---

### 添加域名到 Cloudflare

登录 Cloudflare 后，点击 **Add a Site** 按钮。

在输入框中输入你的域名（例如 `example.com`），点击 **Continue**。

选择套餐计划：
- **Free**: 免费版，包含基础 CDN、SSL、DNS 等功能
- **Pro**: $20/月，包含更多高级功能
- **Business**: $200/月，适合企业用户

个人博客选择 **Free** 套餐即可，点击 **Continue with Free**。

Cloudflare 会自动扫描你域名的现有 DNS 记录，请检查并确认记录是否正确。

---

### 修改域名 NS 服务器

在 DNS 记录确认页面，Cloudflare 会分配两个 NS 服务器地址，格式如下：

```
xxx.ns.cloudflare.com
yyy.ns.cloudflare.com
```

记录下这两个地址，然后登录你的域名注册商（阿里云、腾讯云、GoDaddy 等），将域名的 NS 服务器修改为 Cloudflare 提供的地址。

**阿里云操作步骤：**
1. 登录阿里云控制台，进入 **域名** → **域名列表**
2. 找到域名，点击 **管理**
3. 选择 **DNS 修改** → **修改 DNS 服务器**
4. 选择 **自定义 DNS**，填入 Cloudflare 提供的两个 NS 地址
5. 点击 **确定**

**腾讯云操作步骤：**
1. 登录腾讯云控制台，进入 **域名注册** → **我的域名**
2. 找到域名，点击 **管理**
3. 选择 **DNS 解析** → **修改 DNS 服务器**
4. 选择 **自定义 DNS**，填入 Cloudflare NS 地址
5. 点击 **提交**

NS 服务器修改后，需要等待 24-48 小时全球生效（通常几分钟到几小时即可）。回到 Cloudflare，点击 **Done, check nameservers**，Cloudflare 会自动检测 NS 是否修改成功。

---

### 开启 CDN 加速

在 Cloudflare 的 **DNS** 设置页面，找到 **Proxy status** 列。

确保显示为 **Proxied**（橙色云朵图标），这表示 CDN 已启用。如果显示 **DNS only**（灰色云朵），点击切换到 **Proxied**。

进入 **Caching** → **Configuration**，可以配置：
- **Caching Level**: 建议选 **Standard**
- **Browser Cache TTL**: 浏览器缓存时间
- **Always Online**: 开启后网站离线时显示缓存页面

---

### 开启 SSL 证书

点击顶部菜单 **SSL/TLS**，进入 SSL 设置页面。

选择加密模式：

| 模式 | 说明 | 适用场景 |
|------|------|----------|
| **Off** | 不加密 | 不推荐 |
| **Flexible** | 用户到 Cloudflare 加密 | 服务器没有 SSL 证书 |
| **Full** | 全程加密，不验证证书 | 服务器有自签名证书 |
| **Full (strict)** | 全程加密，验证证书 | 服务器有有效证书（推荐） |

推荐选择 **Full (strict)**。

进入 **SSL/TLS** → **Edge Certificates**：
- 开启 **Always Use HTTPS**: 强制所有 HTTP 请求重定向到 HTTPS
- 开启 **Automatic HTTPS Rewrites**: 自动将页面中的 HTTP 链接重写为 HTTPS

---

### 验证配置

访问 `https://你的域名`，查看浏览器地址栏：
- 应该显示 🔒 安全锁标志
- 点击锁标志，查看证书是否由 Cloudflare 颁发

打开命令提示符，运行：

```bash
nslookup 你的域名
```

如果返回的 IP 地址以 104. 或 172. 开头，说明 CDN 已生效。

使用浏览器开发者工具（F12）→ Network → 刷新页面：
- 查看 Response Headers 中是否有 `cf-ray` 或 `cf-cache-status`
- 有则说明经过 Cloudflare CDN

---

### 常见问题

**修改 NS 后网站无法访问？**
- 等待 DNS 传播（最长 48 小时）
- 检查 Cloudflare DNS 记录是否正确
- 确认服务器 IP 没有变化

**SSL 证书显示无效？**
- 确认选择了正确的 SSL 模式
- 如果是 Full (strict) 模式，确保服务器有有效证书
- 可以先用 Flexible 模式测试

**如何暂停 Cloudflare？**
- 进入 **Overview** 页面
- 点击 **Pause Cloudflare on Site**
- 这会临时绕过 Cloudflare，直接访问源站

---

### 进阶优化

开启 Brotli 压缩：
1. 进入 **Speed** → **Optimization**
2. 开启 **Brotli**

开启 HTTP/2 和 HTTP/3：
进入 **Network** 设置，确保开启：
- HTTP/2
- HTTP/3 (QUIC)
- 0-RTT Connection Resumption

配置防火墙规则：
1. 进入 **Security** → **WAF**
2. 可以设置阻止特定国家/地区、特定 IP、速率限制等

---

### 总结

完成以上步骤后，你的域名就成功托管到 Cloudflare 了：

✅ 享受 Cloudflare 的全球 CDN 加速  
✅ 免费的 SSL 证书和 HTTPS 加密  
✅ DDoS 防护和 Web 应用防火墙  
✅ DNS 解析加速

如有问题，可以在 Cloudflare 社区或文档中寻找帮助。
