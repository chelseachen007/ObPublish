---
tags:
title: React 发展
date created: 2023-04-04
date modified: 2023-04-26
---

# React 发展

## react16 的重大更新

1. 采用了新的内核架构 Fiber
2. 引入了 `getDerivedStateFromProps` 、 `getSnapshotBeforeUpdate` 及 `componentDidCatch` 等三个生命周期函数
3. 将 `componentWillUpdate`、`componentWillReceiveProps` 和 `componentWillUpdate` 标记为不安全的方法。
4. 全新的 Context API

为什么要删除这三个生命周期
