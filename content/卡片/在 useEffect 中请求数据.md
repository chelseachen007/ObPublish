---
tags:
title: 在 useEffect 中请求数据
date created: 2023-04-04
date modified: 2023-04-26
---

# 在 useEffect 中请求数据

## 竞态问题

在 `useEffect` 中请求数据要面临的第一个问题是**「需要解决竞态问题」**。  
这里有个开发阶段很难复现的`bug` —— 如果`userID`变化足够快，会发起多个不同的用户请求。

而最终展示哪个用户的数据，取决于哪个请求先返回。这就是**「请求的竞态问题」**。

## 点击返回按钮后重新请求数据

如果用户跳转到新的页面后，又通过浏览器回退按钮回到当前页面，并不能立刻看到他跳转前的页面。

相反，看到的可能是个白屏 —— 因为还需要重新执行`useEffect`获取初始数据。

这个问题的本质原因是：没有初始数据的缓存。

## CSR 时的白屏时间

`CSR`（Client-Side Rendering，客户端渲染）时在 `useEffect`中请求数据，在数据返回前页面都是白屏状态。

## 瀑布问题

如果父子组件都依赖`useEffect`获取初始数据渲染，那么整个渲染流程如下：

1. 父组件`mount`
2. 父组件`useEffect`执行，请求数据
3. 数据返回后重新渲染父组件
4. 子组件`mount`
5. 子组件`useEffect`执行，请求数据
6. 数据返回后重新渲染子组件

可见，当父组件数据请求成功后子组件甚至还没开始首屏渲染。  
这就是渲染中的瀑布问题 —— 数据像瀑布一样一级一级向下流动，流到的组件才开始渲染，很低效。

## 解决方式

- 对于 SSR，可以使用 [[Next.js]]、[[Remix]] 接管数据请求。
- 对于 CSR，可以使用 [[React Query]]、[[useSWR]] 接管数据请求
- 如果不想使用这些方案，想自己写，可以参考 `React` 新文档中下面两篇文章：
  - [使用 effect 同步数据](https://beta.reactjs.org/learn/synchronizing-with-effects#fetching-data)
  - [你可能不需要使用 effect](https://beta.reactjs.org/learn/you-might-not-need-an-effect#fetching-data)
