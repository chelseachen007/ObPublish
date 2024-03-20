---
tags:
title: Redux API 分解实现
date created: 2023-04-04
date modified: 2023-04-26
---

# Redux API 分解实现

### createStore

```JavaScript
const store = createStore(
  countReducer,
  applyMiddleware(thunk, logger, promise)
);
```

从使用实例可以搭出函数框架

```JavaScript
export default function createStore(reducer, enhancer) {
  let currentState; // 选中的状态值，记录下方便获取
  let currentListeners = []; // 选中的监听器,方便订阅和取消订阅
  function getState() {}
  function dispatch() {}
  function subscribe() {}
  return {
    getState,
    dispatch,
    subscribe,
  };
}
```

然后依次实现

getState 比较简单 直接返回选中值即可

```JavaScript
  function getState() {
    return currentState;
  }
```

dispatch 函数只是在 reducer 中找到对应的函数执行以后，进行对视图的通知更新

```JavaScript
  // add = () => {
  //     store.dispatch({ type: "ADD" });
  //   };
  function dispatch(actions) {
    //将reducer执行一遍，获取变化后的值
    currentState = reducer(currentState, actions);
    // 发布订阅模式 都是通过一个数组进行遍历通知视图进行更新
    currentListeners.forEach((listener) => listener());
  }
```

订阅函数 subscribe 则是标准的发布订阅函数，记得返回一个取消订阅的函数

```JavaScript
  //订阅函数
  function subscribe(fn) {
    currentListeners.push(fn);
    // 返回一个取消订阅函数
    return () => (currentListeners = []);
  }
```

最后执行一次 dispatch 进行默认值的设定

```JavaScript
  dispatch({ type: "随机生成一段Type进行初始值设置" });
```

### applyMiddleware

顾名思义中间件，把 createStore 通过一轮 Middleware 增强一遍

```JavaScript
  if (enhancer) {
    enhancer(createStore)(reducer);
  }
```

这样我们就可以搭出如下框架

```JavaScript
export default function applyMiddleware(...middlewares) {
  return (createStore) => (reducer) => {
    let store = createStore(reducer);
    // 这是原版的dispatch，这个dispatch只能接受plain object，不能处理异步、promise
    let dispatch = store.dispatch;

    return {
      ...store,
      // 加强版的dispatch
      dispatch,
    };
  };
}
```

这里需要注意 ，我们传入了多个增强函数，需要一次执行增强同一个参数,like this

将参数向下传递，进行加强后，继续向下传递

```JavaScript
function f1(arg) {
  console.log("f1", arg);
  return arg;
}
function f2(arg) {
  console.log("f2", arg);
  return arg;
}
function f3(arg) {
  console.log("f3", arg);
  return arg;
}

const res = f1(f2(f3("omg")));
console.log("res", res); //sy-log
// f3 omg
// f2 omg
// f1 omg
// res omg
```

但是这么写不免繁琐，所以就有了

### compose

![[高阶函数#compose#redux 版本 同步函数]]  
也叫函数合成，执行顺序是越后面越内层，也就是越早执行

这样我们就可以开始使用中间件进行函数增强了

```JavaScript
export default function applyMiddleware(...middlewares) {
  return (createStore) => (reducer) => {
    .....
    const API = {
      state: store.getState(),
      dispatch: (actions, ...args) => store.dispatch(actions, ...args),
    };
    //将middlewares转化成 参数为 API 的函数数组
    const middlewaresChain = middlewares.map((middleware) => middleware(API));
    // 对 dispatch 进行增强
    dispatch = compose(...middlewaresChain)(store.dispatch);

    .....
  };
}
```

### combineReducers

#### 用法改变

```html
<p>{store.getState()}</p>
=>
<p>{store.getState().home}</p>
```

```JavaScript
const store = createStore(
  // combineReducers用法
  combineReducers({home: countReducer}),
  applyMiddleware(thunk, logger, promise)
);
```

**combineReducers** 辅助函数的作用是

1. 把一个由多个不同 reducer 函数作为 value 的 object，
2. *合并成一个最终的 reducer 函数，然后就可以对这个 reducer 调用 createStore。*

#### 使用规则：

- 每个传入 combineReducers 的 reducer 都需满足以下规则：
- 所有未匹配到的 action，必须把它接收到的第一个参数也就是那个 state 原封不动返回。
- 永远不能返回 undefined。当过早 return 时非常容易犯这个错误，为了避免错误扩散，遇到这种情况时 combineReducers 会抛异常。
- 如果传入的 state 就是 undefined，一定要返回对应 reducer 的初始 state。根据上一条规则，初始 state 禁止使用 undefined。

  使用 ES6 的默认参数值语法来设置初始 state 很容易，但你也可以手动检查第一个参数是否为 undefined。

#### 实现：

```JavaScript
export default function combineReducers(reducers) {
  return function combination(state = {}, action) {
    var hasChanged = false; // 做缓存的标记
    var nextState = {};
    // 循环reducer，如果是函数就进行执行
    // 将执行完成的值，赋值给对象保存
    for (let key in reducers) {
      let reducer = reducers[key];
      if (typeof reducer !== "function") {
        break;
      }
      var previousStateForKey = state[key];
      var nextStateForKey = reducer(previousStateForKey, action);
      nextState[key] = nextStateForKey;
     //判断值有没变化
      hasChanged = hasChanged || nextStateForKey !== previousStateForKey;
    }
     //判断有没新增state
    hasChanged =
      hasChanged || Object.keys(nextState).length !== Object.keys(state).length;
    return hasChanged ? nextState : state;
  };
}
```

redux 内部的 API 我们已经全部实现了。
