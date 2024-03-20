---
tags:
title: Redux 基础 API
date created: 2023-04-04
date modified: 2023-04-26
---

# Redux 基础 API

### Action

**Action** 是把数据从应用传到 store 的有效载荷。它是 store 数据的**唯一**来源。

```JavaScript
let nextTodoId = 0
export const addTodo = text => ({
  type: 'ADD_TODO',
  id: nextTodoId++,
  text
})
```

### Reducer

**Reducers** 指定了应用状态的变化如何响应 actions 并发送到 store 的，记住 actions 只是描述了*有事情发生了*这一事实，并没有描述应用如何更新 state。

**reducer** 就是一个**纯函数**，接收旧的 state 和 action，返回新的 state。

#### 纯函数

1. 如果**函数**的调用参数相同，则永远返回相同的结果。它不依赖于程序执行期间 **函数** 外部任何状态或数据的变化，必须只依赖于其输入参数。
2. 该 **函数** 不会产生任何可观察的副作用，例如网络请求，输入和输出设备或数据突变（mutation）

所以 **永远不要**在 reducer 里做这些操作：

1. 修改传入参数；
2. 执行有副作用的操作，如 API 请求和路由跳转；
3. 调用非纯函数，如 Date.now() 或 Math.random() 。

#### 如何使用：

```JavaScript
const todos = (state = [], action) => {
  switch (action.type) {
    case 'ADD_TODO':
      return [
        ...state,
        {
          id: action.id,
          text: action.text,
          completed: false
        }
      ]
    default:
      return state
  }
}

export default todos
```

### store

**Store** 就是把它们联系到一起的对象。Store 有以下职责：

- 维持应用的 state；
- 提供 `getState()`方法获取 state；
- 提供 `dispatch(action)`方法更新 state；
- 通过 `subscribe(listener)`注册监听器;
- 通过 `subscribe(listener)`返回的函数注销监听器。

**Redux 应用只有一个单一的 store**。当需要拆分数据处理逻辑时，你应该使用 [reducer 组合](http://cn.redux.js.org/docs/basics/Reducers.html#splitting-reducers)而不是创建多个 store。

举个例子：

```JavaScript
export default class ReduxPage extends Component {
  componentDidMount() {
    this.unsubscribe = store.subscribe(() => {
      // store state 改变
      this.forceUpdate();
    });
  }

  componentWillUnmount() {
    if (this.unsubscribe) {
      this.unsubscribe();
    }
  }

  add = () => {
    store.dispatch({ type: "ADD" });
  };

  asyAdd = () => {
    store.dispatch((dispatch, getState) => {
      setTimeout(() => {
        dispatch({ type: "ADD" });
        console.log("getState", getState());
      }, 1000);
    });
  };

  promiseMinus = () => {
    store.dispatch(
      Promise.resolve({
        type: "MINUS",
        payload: 100,
      })
    );
  };

  render() {
    return (
      <div>
        <h3>ReduxPage</h3>
        <p>{store.getState()}</p>
        {/* <p>{store.getState().home}</p> */}
        <button onClick={this.add}>add</button>
        <button onClick={this.asyAdd}>asyAdd</button>
        <button onClick={this.promiseMinus}>promise minus</button>
      </div>
    );
  }
}
```
