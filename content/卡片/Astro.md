---
tags:
title: 定位
date created: 2023-04-04
date modified: 2023-04-26
---

# 定位

这一点其实挺困扰初学者的，因为 Astro 既自创了类似于`.vue`、`.jsx`文件的  `.astro`  语法，又提供了像 Next.js 里面各种运行时的能力，比如约定式路由、构建优化、SSR 等等。

但实际上它给自己的定位非常清晰，即  `content-focused`  应用开发框架，换句话说，就是重内容、轻交互场景下的上层研发框架，比如大多数电商网站、文档站、博客站、证券网站等等。

你可以将 Astro 理解为一个垂直场景下的`Next.js`，但它可以在它适用的领域里面可以胜过其它所有竞品(如`Next.js`、`Remix`、`Vuepress`  等)，这是它能够做起来的重要原因。

# 优势

Astro 的主要优势包括如下几点:

- [[Islands 架构]]，解决传统 SSR/SSG 框架的全量 hydration 问题，做到尽可能少的 Client 端 JS 的开销，甚至是 0 JS。
- 学习成本低。`.astro`  语法和传统的  `.jsx`  和  `.vue`  非常相似，对于新手前端来说也比较容易掌握。
- 使用灵活。对于页面的开发，你既可以使用官方的`.astro`  语法，也同样可以使用  `.md`、`.vue`、`.jsx`  语法，也就是说，你可以自由选择其它前端框架的语法来开发，甚至可以在一个项目中同时写 Vue 组件和 React 组件！
- 构建迅速。底层构建体系基于 Vite 以及 Esbuild 实现，项目启动速度非常快。

# 相比 [[SSR]]

相比于传统 SSR 中的全量 hydration，Islands 模式可以实现局部(partial) hydration，从而优化 JS 的体积，减少网络传输的成本和 JS 运行时的开销。

在 Astro 中，默认所有的组件都是静态组件

优势：

1. Astro 相比 [[Next.js]]可以大幅度减少 JS 代码的体积(90% 以上)，同时页面的运行时性能也提升了 30% 以上。
2. 除了 React，也支持其它的众多前端框架；
3. 同时支持 SSR 和 SSG，而 Remix 不支持 [[SSG]]

# 对比 React 18 的 Selection Hydration 特性

React 18 提供了  `renderToPipeableStream` API，真正实现了 SSR 场景下的  `Selection Hydration`，主要有如下的几个特点:

- 在完整的 HTML 渲染之前就可以进行组件的 hydrate，而不用等待 HTML 的内容发送完毕
- hydration 可中断。比如页面中有两个组件: Sidebar 和 Comment，当这个部分的 HTML 发送至浏览器时，React 打算开始对 Sidebar 组件进行 hydrate:

两者存在着非常大的区别:

- 从渲染框架上来看， `Selection Hydration`  依附于具体框架的实现，而  `Partial Hydration`  可以做到框架无关，即使是 Vue、Solid 的项目也可以做到  `Partial Hydration`。
- 从客户端执行的 JS 总量来看， `Partial Hydration`  可以做到加载部分组件的 JS 代码，而  `Selection Hydration`  仍然需要加载和执行全量的 JS 代码。
- 从服务端和客户端的交互来看，  `Selection Hydration`  严重依赖于流式(Streaming)渲染，服务端需要加上  `transfer-encoding: chunked`  的响应头，而  `Partial Hydration`  没有这个限制。
