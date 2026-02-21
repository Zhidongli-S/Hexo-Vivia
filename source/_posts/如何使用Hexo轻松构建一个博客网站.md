---
layout: past
title: 如何使用Hexo轻松构建一个博客网站
date: 2025-12-19 22:11:29
categories: 傻瓜教程
description: 本文面向初学者，手把手教你使用 Hexo 静态博客框架从零搭建个人博客。只需安装 Node.js 和 Git，通过几条简单命令即可完成项目初始化、本地预览，快速生成美观高效的静态网站。
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





