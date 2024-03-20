---
tags:
title: 基本配置
date created: 2023-04-04
date modified: 2023-04-26
---

![](https://chelsechen-img.oss-cn-hangzhou.aliyuncs.com/20221220114622.png)

您可以大胆想象，九头龙的每只龙头都在帮您管理着一个子项目，而您只需要骑在龙身上发号施令的场景，这基本上就是我们使用 Lerna 时的直观感受。

当多个子项目放在一个代码仓库，并且子项目之间又相互依赖时，我们面临的棘手问题有两个：

1. **如果我们需要在多个子目录执行相同的命令，我们需要手动进入各个目录，并执行命令**；
2. **当一个子项目更新后，我们只能手动追踪依赖该项目的其他子项目，并升级其版本**。

# 基本配置

在项目根目录使用  `npx lerna init`  初始化后，我们的根目录会新增一个  `lerna.json`  文件, 并修改成

```
{
  "packages": ["packages/*"],
  "npmClient": "yarn",
  "version": "independent",
  "useWorkspaces": true,
}
```

# 命令使用

Lerna 提供了很多 CLI 命令以满足我们的各种需求，但根据 2/8 法则，您应该首先关注以下这些命令：

- `lerna bootstrap`：等同于  `lerna link` + `yarn install`，用于创建符合链接并安装依赖包；
- `lerna run`：会像执行一个 for 循环一样，在所有子项目中执行 npm script 脚本，并且，它会非常智能的识别依赖关系，并从根依赖开始执行命令；
- `lerna exec`：像  `lerna run`  一样，会按照依赖顺序执行命令，不同的是，它可以执行任何命令，例如 shell 脚本；
- `lerna publish`：发布代码有变动的 package，因此首先您需要在使用 Lerna 前使用  `git commit`  命令提交代码，好让 Lerna 有一个 baseline；
- `lerna add`：将本地或远程的包作为依赖添加至当前的 monorepo 仓库中，该命令让 Lerna 可以识别并追踪包之间的依赖关系，因此非常重要；

## Lerna 高级命令

除了上面介绍到的常用命令外，Lerna 还提供了一些参数满足我们更灵活的需求，例如：

- `--concurrency <number>`：参数可以使 Lerna 利用计算机上的多个核心，并发运行，从而提升构建速度；
- `--scope '@mono/{pkg1,pkg2}'`：`--scope`  参数可以指定 Lerna 命令的运行环境，通过使用该参数，Lerna 将不再是一把梭的在所有仓库中执行命令，而是可以精准地在我们所指定的仓库中执行命令，并且还支持示例中的模版语法；
- `--stream`：该参数可使我们查看 Lerna 运行时的命令执行信息；

# 本地发布

，您可能想要亲自体验一把使用 Lerna 管理/发布 monorepo 项目的感觉。可是很快您会发现，将示例代码发布到真实世界的 npm 仓库并非一个好主意，这多少有些令人沮丧，但是别担心，您可以使用[[Verdaccio]]  
在本地创建一个 npm 仓库作为代理，然后尽情体验 Lerna 的种种强大之处。
