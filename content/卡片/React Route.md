---
tags:
title: React Route
date created: 2023-04-04
date modified: 2023-04-26
---

# React Route

React Router 路由的基础实现原理分为两种，如果是切换 Hash 的方式，那么依靠浏览器 Hash 变化即可；如果是切换网址中的 Path，就要用到 HTML5 History API 中的 pushState、replaceState 等。在使用这个方式时，还需要在服务端完成 historyApiFallback 配置。

在 React Router 内部主要依靠 history 库完成，这是由 React Router 自己封装的库，为了实现跨平台运行的特性，内部提供两套基础 history，一套是直接使用浏览器的 History API，用于支持 react-router-dom；另一套是基于内存实现的版本，这是自己做的一个数组，用于支持 react-router-native。

React Router 的工作方式可以分为设计模式与关键模块两个部分。从设计模式的角度出发，在架构上通过 Monorepo 进行库的管理。Monorepo 具有团队间透明、迭代便利的优点。其次在整体的数据通信上使用了 Context API 完成上下文传递。

在关键模块上，主要分为三类组件：第一类是  Context 容器，比如 Router 与 MemoryRouter；第二类是消费者组件，用以匹配路由，主要有 Route、Redirect、Switch 等；第三类是与平台关联的功能组件，比如 Link、NavLink、DeepLinking 等。
