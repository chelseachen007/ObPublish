---
tags:
title: 快速使用
date created: 2023-04-04
date modified: 2023-04-26
---

[Verdaccio](https://verdaccio.org/)

# 快速使用

安装运行 Verdaccio 非常简单，您只需运行：

```
npm install --global verdaccio
```

在全局安装 Verdaccio 应用，然后在 shell 中输入：

```
verdaccio
```

即可通过  `localhost:4837`  访问您的本地代理 npm 仓库，别忘了在您的项目根目录创建  `.npmrc`  文件，并在文件中将 npm 仓库地址改写为您的本地代理地址：

```
registry="http://localhost:4873/"
```

大功告成 🙌！每当您执行  `lerna publish`  时，子项目所构建成的 package 将会发布在本地 npm 仓库中，而当您执行  `lerna bootstrap`  时，Verdaccio 将会放行，让您成功从远程 npm 仓库中拉取相应的代码。
