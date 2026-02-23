---
layout: past
title: 如何使用Hexo轻松构建一个博客网站
date: 2025-12-19 22:11:29
categories: 傻瓜教程
description: 本文面向初学者，手把手教你使用 Hexo 静态博客框架从零搭建个人博客。只需安装 Node.js 和 Git，通过几条简单命令即可完成项目初始化、本地预览，远端部署，快速生成美观高效的静态网站。
photos:
  - https://hexo.io/icon/og-image-wide.png
---
### 什么是Hexo？
Hexo 是一个快速、简洁且高效的博客框架。 Hexo 使用 Markdown（或其他标记语言）解析文章，在几秒内，即可利用靓丽的主题生成静态网页。

---
###  前提条件
确保已安装以下工具：
- **Node.js**(Node.js 版本需不低于 10.13)
- **Git**

> 你可以从 [Node.js 官网](https://nodejs.org/) 下载安装，安装时会自动包含 Npm。

---

###  1. 安装 Hexo CLI
打开命令提示符，运行：

```bash
npm install -g hexo-cli
```

---

### 2. 初始化博客项目
在磁盘内新建一个空文件夹，并用 `Git Bash` 打开，执行命令:

```bash
hexo init
```

这会创建一个Hexo 项目，并安装所需依赖。

---

###  3. 本地预览博客
并用 `Git Bash` 打开你的文件夹，输入以下命令，启动本地服务器：

```bash
hexo server
```

然后在浏览器访问 `http://localhost:4000`，即可看到默认博客页面。

> 按 `Ctrl + C` 停止服务器。

---

### 5. 更换主题

Hexo 默认使用 Landscape 主题，你可以更换为其他主题来个性化你的博客。以下以更换为 Vivia 主题为例：

1. 在项目根目录下执行命令安装主题：

```bash
git clone https://github.com/adamralph/vivia.git themes/vivia
```

2. 复制主题配置文件：

```bash
cp themes/vivia/_config.vivia.yml _config.vivia.yml
```

3. 修改 Hexo 配置文件 `_config.yml`，将主题设置为 vivia：

```yaml
theme: vivia
```

4. 重新启动本地服务器查看效果：

```bash
hexo clean
hexo server
```

> 更多主题可访问 [Hexo 官方主题库](https://hexo.io/themes/) 查找和安装。

---

### 6. 创建 GitHub 仓库

将项目托管至 GitHub。具体操作步骤如下：

1. 访问 [GitHub](https://github.com) 并使用个人账号登录
2. 点击页面右上角的 "+" 图标，选择 "New repository"
3. 输入仓库名称，添加项目描述（可选）
4. 选择 "Public" 选项，**不要**勾选 "Initialize this repository with a README"
5. 点击 "Create repository" 完成创建

返回本地项目目录，执行以下命令完成初始化：

```bash
git init
git add .
git commit -m "Initial commit"
git branch -M main
git remote add origin https://github.com/你的用户名/你的仓库名.git
git push -u origin main
```

执行完毕后，项目代码将成功推送至 GitHub 远程仓库。

---

### 7. 部署至 Cloudflare Pages

完成 GitHub 托管后，可通过 Cloudflare Pages 实现自动化部署。该服务提供免费的静态网站托管，并支持自定义域名。

部署流程：

1. 访问 [Cloudflare](https://dash.cloudflare.com) 注册账号并完成验证
2. 登录后导航至 "Pages" 页面，点击 "Create a project"
3. 选择 "Connect to Git" 选项，从列表中选择已创建的 GitHub 仓库
4. 点击 "Begin setup" 进入配置界面
5. 配置构建参数：
   - **Framework preset**: 选择 Hexo
   - **Build command**: 输入 `npm install -g hexo; hexo clean; hexo generate`
   - **Build output directory**: 输入 `/public`
6. 点击 "Save and Deploy" 启动部署

部署完成后，Cloudflare Pages 将提供 `https://项目名.pages.dev` 格式的访问地址。如需使用自定义域名，可在 "Custom domains" 选项卡中添加并进行 DNS 配置。

---

### 总结

通过以上步骤，您已成功完成 Hexo 博客的本地搭建、代码托管和线上部署。后续可根据需要安装主题、配置插件及撰写文章，进一步完善个人博客功能。