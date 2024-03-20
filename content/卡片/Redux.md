---
tags:
title: Redux
date created: 2023-04-04
date modified: 2023-04-26
---

# Redux

Redux 是 JavaScript 状态容器，提供可预测化的状态管理。

## Redux 三大原则

### 单一数据源

整个应用的 state 被储存在一棵 **object tree** 中，并且这个 object tree 只存在于唯一一个 **store** 中。

这让同构应用开发变得非常容易

### State 是只读的

唯一改变 state 的方法就是触发 **action**，**action** 是一个用于描述已发生事件的普通对象。

### 使用纯函数来执行修改

为了描述 action 如何改变 state tree ，你需要编写 **reducers**。

这三大原则使 Redux 的调试工具实现了**时间回溯**功能，通过录制回放 Action，完整重现了整个应用路径，这在当时引发了不小的轰动。

## 副作用

真正可以解决副作用的方案主要分为两类：

- 在 Dispatch 的时候有一个**middleware 中间件层**，拦截分发的**Action**并添加额外的复杂行为，还可以添加副作用；
- 允许 Reducer 层直接处理副作用。

## [[Redux 基础 API]]

## [[Redux API分解实现]]

接下来我们再通过实现几个中间件，加强下对 redux 中间件的理解。

## Middleware

首先我们从上面 applyMiddleware 实现中可以获得一些参数

```JavaScript
function xxx( store ) {
  return (next) => (action) => {
    console.log(next);
    /*     dispatch(actions) {
      currentState = reducer(currentState, actions);
      currentListeners.forEach(listener => listener());
    } */
    console.log(action);
    //  {type: "MINUS", payload: 100}

    return  next(action);
  };
}
```

那么就可以开始写功能了

#### thunk

thunk 支持传入一个函数，只是把`dispatch` , `getState` 向下传递

```JavaScript
function thunk({ dispatch, getState }) {
  return (next) => (action) => {
    if (typeof action === "function") {
      return action(dispatch, getState);
    }
    return next(action);
  };
}
```

#### Promise

支持 `dispatch`传入一个 Promise

```JavaScript
function promise({ dispatch }) {
  return (next) => (action) => {
    return isPromise(action) ? action.then(dispatch) : next(action);
  };
}
```

#### logger

每次值改变的时候进行一次控制台输出

```JavaScript
function logger({ getState }) {
  return (next) => (action) => {
    console.log(next);
    console.log("*******************************");

    console.log(action.type + "执行了！");

    let prevState = getState();
    console.log("prev state", prevState);

    const returnValue = next(action);
    let nextState = getState();
    console.log("next state", nextState);

    console.log("*******************************");
    return returnValue;
  };
}
```

## [[React Redux]]
