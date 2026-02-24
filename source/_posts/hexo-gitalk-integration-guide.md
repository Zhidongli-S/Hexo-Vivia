---
layout: post
title: Hexo 博客集成 Gitalk 评论系统完整指南
date: 2026-02-24 23:30:00
categories: 傻瓜教程
description: 本文记录为 Hexo 博客集成 Gitalk 评论系统的完整过程，包括配置步骤、注意事项以及如何实现自动创建 Issue 的解决方案。
---

为 Hexo 博客添加评论系统是提升互动性的重要步骤。本文将分享集成 Gitalk 的完整过程。

---

### Gitalk 简介

Gitalk 是一个基于 GitHub Issue 的评论系统，具有以下特点：

- **免费开源**：基于 GitHub Issue，无需额外服务器
- **Markdown 支持**：评论支持 Markdown 语法
- **代码高亮**：评论中的代码块自动高亮
- **通知集成**：通过 GitHub 通知回复
- **多语言支持**：内置中文等多种语言

---

### 创建 GitHub OAuth 应用

首先需要在 GitHub 上创建 OAuth 应用：

1. 登录 GitHub，进入 **Settings** → **Developer settings** → **OAuth Apps**
2. 点击 **New OAuth App**
3. 填写应用信息：
   - **Application name**: 你的博客名称
   - **Homepage URL**: 博客地址（如 `https://yourdomain.com`）
   - **Authorization callback URL**: 博客地址
4. 点击 **Register application**
5. 记录生成的 **Client ID** 和 **Client Secret**

---

### 创建 Gitalk 插件文件

在主题目录下创建 `layout/_plugins/gitalk.ejs`：

```html
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/gitalk@1.7.2/dist/gitalk.css">
<script src="https://cdn.jsdelivr.net/npm/gitalk@1.7.2/dist/gitalk.min.js"></script>
<script src="https://cdn.bootcss.com/blueimp-md5/2.10.0/js/md5.js"></script>
<div id="gitalk-container"></div>
<script type="text/javascript">
  var gitalk = new Gitalk({
    clientID: '<%= theme.gitalk.ClientID %>',
    clientSecret: '<%= theme.gitalk.ClientSecret %>',
    repo: '<%= theme.gitalk.repo %>',
    owner: '<%= theme.gitalk.owner %>',
    admin: <%- JSON.stringify(theme.gitalk.adminUser) %>,
    id: md5(location.pathname),
    labels: '<%= theme.gitalk.labels %>'.split(',').filter(l => l),
    perPage: <%= theme.gitalk.perPage %>,
    pagerDirection: '<%= theme.gitalk.pagerDirection %>',
    createIssueManually: <%= theme.gitalk.createIssueManually %>,
    distractionFreeMode: <%= theme.gitalk.distractionFreeMode %>
  })
  gitalk.render('gitalk-container')
</script>
```

**注意：**
- **admin 参数必须使用 JSON.stringify 输出数组格式**，否则会导致权限不足无法创建 Issue
- **id 使用 md5(location.pathname)** 避免中文路径编码后超过 50 字符限制

---

### 修改文章页面模板

在 `layout/post.ejs` 和 `layout/page.ejs` 中添加：

```html
<% if (theme.gitalk.enable) { %>
    <%- partial('_plugins/gitalk') %>
<% } %>
```

---

### 添加主题配置

在主题配置文件 `_config.yml` 或 `_config.vivia.yml` 中添加：

```yaml
gitalk:
  enable: true
  ClientID: 你的ClientID
  ClientSecret: 你的ClientSecret
  repo: 仓库名
  owner: GitHub用户名
  adminUser: ['GitHub用户名']
  ID: location.pathname
  labels: ['Gitalk']
  perPage: 10
  pagerDirection: last
  createIssueManually: false
  distractionFreeMode: false
```

**注意：**
- **owner 必须与 GitHub 用户名大小写完全一致**，否则会出现 404 错误无法加载 Issue
- **如果主题目录下有多个配置文件**（如 `_config.yml` 和 `_config.vivia.yml`），建议两个文件保持同步修改

---

### 样式优化

为了让 Gitalk 与 Vivia 主题风格统一，在 `source/css/_partial/comment.styl` 中添加：

```stylus
.gt-container
  margin-top: 32px
  padding: 0 article-side-padding

  .gt-header
    @extend $card
    padding: 24px
    margin-bottom: block-margin

  .gt-header-textarea
    background: var(--input-field) !important
    color: var(--neut-L90) !important
    border: none !important
    border-radius: inner-radius !important

  .gt-btn
    @extend $text-btn
    border: none !important

  .gt-btn-public
  .gt-btn-login
    background: var(--primary-btn-bg) !important
    color: var(--primary-btn-text) !important

  .gt-comment
    @extend $card
    padding: 20px 24px !important
    margin-bottom: block-margin !important

  .gt-link
    color: var(--link) !important
    border-bottom: none !important
```

**注意：**
- **Gitalk 默认样式没有适配深色主题**，需要使用 CSS 变量覆盖以确保在深色模式下正常显示

---

### 自动创建 Issue 方案

Gitalk 默认需要手动点击"初始化评论"创建 Issue，通过 GitHub Actions 可以实现自动创建。

创建 `.github/workflows/create-gitalk-issues.yml`：

```yaml
name: Create Gitalk Issues

on:
  push:
    branches: [ main, master ]
    paths:
      - 'source/_posts/**'
      - 'source/_pages/**'

jobs:
  create-issues:
    runs-on: ubuntu-latest
    permissions:
      issues: write
      contents: read
    
    steps:
    - name: Checkout repository
      uses: actions/checkout@v4
      with:
        fetch-depth: 0
    
    - name: Setup Node.js
      uses: actions/setup-node@v4
      with:
        node-version: '20'
    
    - name: Install dependencies and generate
      run: |
        npm install
        npm install -g hexo-cli
        hexo generate
    
    - name: Create GitHub Issues for new posts
      uses: actions/github-script@v7
      with:
        script: |
          const fs = require('fs');
          const crypto = require('crypto');
          
          function getAllHtmlFiles(dir, files = []) {
            const items = fs.readdirSync(dir);
            for (const item of items) {
              const fullPath = require('path').join(dir, item);
              const stat = fs.statSync(fullPath);
              if (stat.isDirectory()) {
                getAllHtmlFiles(fullPath, files);
              } else if (item.endsWith('.html') && item !== 'index.html') {
                files.push(fullPath);
              }
            }
            return files;
          }
          
          const htmlFiles = getAllHtmlFiles('public');
          const posts = [];
          
          for (const file of htmlFiles) {
            const content = fs.readFileSync(file, 'utf-8');
            const titleMatch = content.match(/<title>([^<]+)<\/title>/);
            const title = titleMatch ? titleMatch[1].replace(/\s*\|\s*Hexo$/, '') : 'Untitled';
            const relativePath = file.replace('public', '').replace(/index\.html$/, '');
            const id = crypto.createHash('md5').update(relativePath).digest('hex');
            posts.push({ title, path: relativePath, id });
          }
          
          const { data: existingIssues } = await github.rest.issues.listForRepo({
            owner: context.repo.owner,
            repo: context.repo.repo,
            state: 'all',
            labels: 'Gitalk',
            per_page: 100
          });
          
          const existingTitles = existingIssues.map(issue => issue.title);
          
          for (const post of posts) {
            const issueTitle = `Gitalk: ${post.title}`;
            if (existingTitles.includes(issueTitle)) {
              console.log(`Issue already exists for: ${post.title}`);
              continue;
            }
            try {
              await github.rest.issues.create({
                owner: context.repo.owner,
                repo: context.repo.repo,
                title: issueTitle,
                body: `This issue is for comments on the post: **${post.title}**\n\nPath: ${post.path}\nID: ${post.id}\n\nPlease do not delete this issue. It is used by Gitalk for storing comments.`,
                labels: ['Gitalk']
              });
              console.log(`Created issue for: ${post.title}`);
            } catch (error) {
              console.error(`Failed to create issue for ${post.title}:`, error.message);
            }
          }
```

---

### 最终文件结构

```
themes/vivia/
├── layout/
│   ├── _plugins/
│   │   └── gitalk.ejs
│   ├── post.ejs
│   └── page.ejs
└── source/
    └── css/
        └── _partial/
            └── comment.styl

.github/
└── workflows/
    └── create-gitalk-issues.yml
```
