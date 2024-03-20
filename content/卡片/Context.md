---
tags:
title: Context
date created: 2023-04-04
date modified: 2023-04-26
---

# Context

## 使用

```javascript
const AppContext = React.createContext()
const { Provider, Consumer } = AppContext


//Provider
<Provider value={title: this.state.title, content: this.state.content}>
  <Title />
  <Content />
 </Provider>

//Consumer
<Consumer>
  {value => <div>{value.title}</div>}
</Consumer>
```

#### 过时的 Context

- **代码不够优雅**
- 如果组件提供的一个 Context 发生了变化，而中间父组件的 shouldComponentUpdate 返回 false，**那么使用到该值的后代组件不会进行更新**。使用了 Context 的组件则完全失控，所以基本上没有办法能够可靠的更新 Context。[这篇博客文章](https://medium.com/@mweststrate/how-to-safely-use-react-context-b7e343eff076)很好地解释了为何会出现此类问题，以及你该如何规避它。 ——React 官方
