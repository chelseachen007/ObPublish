---
tags:
title: React Redux
date created: 2023-04-04
date modified: 2023-04-26
---

# React Redux

[Redux](https://github.com/reactjs/redux) 官方提供的 React 绑定库。具有高效且灵活的特性。

### 如何使用

```JavaScript
@connect(
  // mapStateToProps
  ({count}) => ({count}),
  // mapDispatchToProps object | function
  {
    add: () => ({type: "ADD"})
  }
  // dispatch => {
  //   let creators = {
  //     add: () => ({type: "ADD"}),
  //     minus: () => ({type: "MINUS"})
  //   };
  //   creators = bindActionCreators(creators, dispatch);

  //   return {
  //     dispatch,
  //     ...creators
  //   };
  // }
)
class ReactReduxPage extends Component {
  render() {
    const {count, dispatch, add} = this.props;
    console.log("pr", this.props);
    return (
      <div>
        <h3>ReactReduxPage</h3>
        <p>{count}</p>
        <button onClick={() => dispatch({type: "ADD"})}>dispatch add</button>
        <button onClick={add}>add</button>
      </div>
    );
  }
}
```

@connect 接受两个参数 `mapStateToProps`和 `mapDispatchToProps` 分别是 `state`和 `dispatch`的映射
