---
tags:
title: SSR
date created: 2023-04-04
date modified: 2023-04-26
---

# SSR

在传统`SSR`中，首屏渲染时，服务端会向浏览器输出`HTML`结构。

当浏览器渲染`HTML`后，再执行前端框架的初始化逻辑，为`HTML`结构绑定事件，这一步叫`hydrate`（注水）。

当`hydrate`完成后，页面才能响应用户交互。

也就是说，只有当整个页面所有组件`hydrate`完成后，页面中任一组件才能响应用户交互。

`Chrome LightHouse`跑分中的[TTI](https://link.juejin.cn/?target=https%3A%2F%2Fweb.dev%2Finteractive%2F "https://web.dev/interactive/")（Time to Interactive，可交互时间）指标用于衡量**页面变得完全可交互所需的时间**。

传统`SSR`架构的页面随着应用体积变大，`TTI`指标会持续走高。

`孤岛架构`的目的就是为了优化`SSR`架构下`TTI`指标的问题。
