---
tags:
title: Volta
date created: 2023-04-04
date modified: 2023-04-26
---

# Volta

[Volta](https://volta.sh/)  是一个 JavaScript 工具管理器，它可以让我们轻松地在项目中锁定 node，npm 和 yarn 的版本。你只需在安装完 Volta 后，在项目的根目录中执行  `volta pin`  命令，那么无论您当前使用的 node 或 npm（yarn）版本是什么，volta 都会自动切换为您指定的版本。

因此，除了使用 Docker 和显示在文档中声明 node 和 npm（yarn）的版本之外，您就有了另一个锁定环境的强力工具。

而且相较于 nvm，Volta 还具有一个诱人的特性：当您项目的 CLI 工具与全局 CLI 工具不一致时，Volta 可以做到在项目根目录下自动识别，切换到项目指定的版本，这一切都是由 Volta 默默做到的，开发者不必关心任何事情。
