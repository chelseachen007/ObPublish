---
tags:
title: V2
date created: 2023-04-04
date modified: 2023-04-26
---

2016 年，yarn 发布，yarn 也采用**扁平化 node_modules 结构**。它的出现是为了解决 npm v3 几个最为迫在眉睫的问题：依赖安装速度慢，不确定性。

## 提升安装速度

在 npm 中安装依赖时，安装任务是串行的，会按包顺序逐个执行安装，这意味着它会等待一个包完全安装，然后再继续下一个。

为了加快包安装速度，yarn 采用了并行操作，在性能上有显著的提高。而且在缓存机制上，yarn 会将每个包缓存在磁盘上，在下一次安装这个包时，可以脱离网络实现从磁盘离线安装。

## lockfile 解决不确定性

yarn 更大的贡献是发明了 yarn.lock。

在依赖安装时，会根据 package.josn 生成一份 yarn.lock 文件。

[[npm]] 在一年后的 v5 才发布了 package-lock.json。

但是，yarn 依然和 npm 一样是扁平化的 node_modules 结构，没有解决**幽灵依赖**和**依赖分身**问题。

# V2

2020 年 1 月，yarn v2 发布，也叫 yarn berry（v1 叫 yarn classic）。它是对 yarn 的一次重大升级，其中一项重要更新就是 Plug’n’Play（Plug'n'Play = Plug and Play = PnP，即插即用）。

## 抛弃  node_modules

无论是 npm 还是 yarn，都具备缓存的功能，大多数情况下安装依赖时，其实是将缓存中的相关包复制到项目目录中 node_modules 里。

而 yarn PnP 则不会进行拷贝这一步，而是在项目里维护一张静态映射表 pnp.cjs。

pnp.cjs 会记录依赖在缓存中的具体位置，所有依赖都存在全局缓存中。同时自建了一个解析器，在依赖引用时，帮助 node 从全局缓存目录中发现依赖，而不是查找 node_modules。

这样就避免了大量的 I/O 操作同时项目目录也不会有 node_modules 目录生成，同版本的依赖在全局也只会有一份，依赖的安装速度和解析速度都有较大提升。

[[pnpm]] 在 2020 年底的 v5.9 也支持了 PnP。

## 脱离 node 生态

pnp 比较明显的缺点是脱离了 node 生态。

- 因为使用 PnP 不会再有 node_modules 了，但是 Webpack，Babel 等各种前端工具都依赖 node_modules。虽然很多工具比如 pnp-webpack-plugin 已经在解决了，但难免会有兼容性风险。
- PnP 自建了依赖解析器，所有的依赖引用都必须由解析器执行，因此只能通过 yarn 命令来执行 node 脚本。
