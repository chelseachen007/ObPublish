---
tags:
title: 带着问题
date created: 2023-04-04
date modified: 2023-04-26
---

# 带着问题

- 我为什么要用 Formily
  - 用响应式处理数据，性能好
  - 可以准确的更新联动数据
  - 动态渲染能力
  - 可以跨端 （vue，react）
- 用 Formily 有什么优缺点
  - 缺点：有一定上手成本
- 如何避免缺点
- 有遇到什么坑吗？

# Formily 原理

![基础架构图](https://chelsechen-img.oss-cn-hangzhou.aliyuncs.com/20220704200051.png)  
![数据流向](https://chelsechen-img.oss-cn-hangzhou.aliyuncs.com/20220704200455.png)

## Observe

是一个[[高阶组件]], 接受一个组件，返回一个组件

```js
const obj = observable({
count:1
})

const Page = observer(()=>{
return  ()
})
```

```js

```
