---
tags:
title: setState 是同步更新还是异步更新
date created: 2023-04-04
date modified: 2023-04-26
---

# setState 是同步更新还是异步更新

在没有合成事件之前，我们处理大量事件的方式为每一个标签添加 onclick 事件，优化的手段可以采用 [[事件委托]]

React 出于性能考虑模拟了事件冒泡，从 DOM 事件冒泡到 document，再寻找到对应组件造出了合成事件

所以这就造成了，在一个页面中，只能有一个版本的 React。如果有多个版本，事件就乱套了。值得一提的是，这个问题在 React 17 中得到了解决，事件委托不再挂在 document 上，而是挂在 DOM 容器上，也就是 ReactDom. Render 所调用的节点上。

在 17 年的时候就有人提出这样一个疑问“[为什么 setState 是异步的](https://github.com/facebook/react/issues/11527)”，这个问题得到了官方团队的回复，原因有 2 个。

- **保持内部一致性**。如果改为同步更新的方式，尽管 setState 变成了同步，但是 props 不是。
- **为后续的架构升级启用并发更新**。为了完成异步渲染，React 会在 setState 时，根据它们的数据来源分配不同的优先级，这些数据来源有：事件回调句柄、动画效果等，再根据优先级并发处理，提升渲染性能。

## 什么时候是同步的

因为 setState 并不是真正的异步函数，它实际上是通过队列延迟执行操作实现的，通过 isBatchingUpdates 来判断 setState 是先存进 state 队列还是直接更新。值为 true 则执行异步操作，false 则直接同步更新。

## 所以是异步还是同步的

setState 并非真异步，只是看上去像异步。在源码中，通过 `isBatchingUpdates` 来判断 setState 是先存进 state 队列还是直接更新，如果值为 true 则执行异步操作，为 false 则直接更新。

那么什么情况下 isBatchingUpdates 会为 true 呢？在 React 可以控制的地方，就为 true，比如在 React 生命周期事件和合成事件中，都会走合并操作，延迟更新的策略。

但在 React 无法控制的地方，比如原生事件，具体就是在 addEventListener 、setTimeout、setInterval 等事件中，就只能同步更新。

一般认为，做异步设计是为了性能优化、减少渲染次数，React 团队还补充了两点。

- 保持内部一致性。如果将 state 改为同步更新，那尽管 state 的更新是同步的，但是 props 不是。
- 启用并发更新，完成异步渲染。

可同步可异步，同步的话把 setState 放在 promises、setTimeout 或者原生事件中等。
