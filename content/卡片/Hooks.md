---
tags:
title: Hooks
date created: 2023-04-04
date modified: 2023-04-26
---

# Hooks

### hooks 简介

### Hook 使用规则

Hook 就是 JavaScript 函数，但是使用它们会有两个额外的规则：

- 只能在**函数最外层**调用 Hook。不要在循环、条件判断或者子函数中调用。
- 只能在 **React 的函数组件**中调用 Hook。不要在其他 JavaScript 函数中调用。（还有一个地方可以调用 Hook —— 就是自定义的 Hook 中，我们稍后会学习到。）

#### useSatate

### useEffect

#### 副作用

你之前可能已经在 React 组件中执行过数据获取、订阅或者手动修改过 DOM。我们统一把这些操作称为“副作用”，或者简称为“作用”。

`useEffect` 就是一个 Effect Hook，给函数组件增加了操作副作用的能力。它跟 [[类组件]] 中的 `componentDidMount`、`componentDidUpdate` 和 `componentWillUnmount` 具有相同的用途，只不过被合并成了一个 API。

[[在 useEffect 中请求数据]]

### useMemo

把“创建”函数和依赖项数组作为参数传入 `useMemo`，它仅会在某个依赖项改变时才重新计算 memoized 值。这种优化有助于避免在每次渲染时都进行高开销的计算。

```JavaScript
const memoizedValue = useMemo(() => computeExpensiveValue(a, b), [a, b]);
```

### useCallback

useCallback 跟 useMemo 比较类似，但它返回的是缓存的函数。

```JavaScript
const memoizedCallback = useCallback(
  () => {
    doSomething(a, b);
  },
  [a, b],
);
```

使用场景是：有一个父组件，其中包含子组件，子组件接收一个函数作为 props；通常而言，如果父组件更新了，子组件也会执行更新；但是大多数场景下，更新是没有必要的，我们可以借助 useCallback 来返回函数，然后把这个函数作为 props 传递给子组件；这样，子组件就能避免不必要的更新。

useEffect、useMemo、useCallback 都是自带闭包的。也就是说，每一次组件的渲染，其都会捕获当前组件函数上下文中的状态 (state, props)，所以每一次这三种 hooks 的执行，反映的也都是当前的状态，你无法使用它们来捕获上一次的状态。对于这种情况，我们应该使用 ref 来访问。

### UseLayoutEffect

useLayoutEffect 的函数签名与 useEffect 相同。  
在源码中，它们调用的是同一个函数。

- useEffect 先调用 mountEffect，再调用 mountEffectImpl；
- useLayoutEffect 会先调用 mountLayoutEffect，再调用 mountEffectImpl。

#### 运用效果

从运用效果上而言，useEffect 与 useLayoutEffect 两者都是**用于处理副作用**，这些副作用包括改变 DOM、设置订阅、操作定时器等。在函数组件内部操作副作用是不被允许的，所以需要使用这两个函数去处理。

#### 不同点

在 React 社区中最佳的实践是这样推荐的，大多数场景下可以直接使用**useEffect**，但是如果你的代码引起了页面闪烁，也就是引起了组件突然改变位置、颜色及其他效果等的情况下，就推荐使用**useLayoutEffect**来处理。那么总结起来就是如果有直接操作 DOM 样式或者引起 DOM 样式更新的场景更推荐使用 useLayoutEffect。

标记为 HookLayout 的 effect 会在所有 的 DOM 变更之后同步调用，所以可以使用它来读取 DOM 布局并同步触发重渲染。但既然是同步，就有一个问题，计算量较大的耗时任务必然会造成阻塞，所以这就需要根据实际情况酌情考虑了。

## [[高阶组件]]

# [[Vue 和 react 的 hooks 区别]]

# 参考链接

[useHooks - Easy to understand React Hook recipes](https://usehooks.com/)
