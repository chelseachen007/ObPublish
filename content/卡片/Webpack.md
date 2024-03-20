---
tags:
title: webpack
date created: 2023-04-04
date modified: 2023-04-26
---

# webpack

![image-20210409153220627](https://i.loli.net/2021/04/09/Ml1KsRYdg6QU8tJ.png)

## 基础概念

**webpack_require**

webpack_exports

### hash chunkhash contenthash 区别

- hash 整个文件任何代码发生改变 hash 就会改变
- contenthash 自身内容发生改变 才会改变
- chunkhash 同一个 chunk 有发生改变，都会改变

### bundle、module、chunk 的区别

- bundle：一个入口文件打包后的文件，
- 每一个文件都是一个 module
- bundle 里的 eval 都是一个 chunk，

### [[webpack_lodaer]]

### [[webpack插件]]

### sourceMap

- eval: 速度最快，使用 eval 包裹代码
- source-map：产生`.map`文件，外部产生错误代码的位置和信息
- cheap：较快，不包含列信息
- Module：第三方模块，包含 loader 的 sourceMap// 无论是 JSX 还是 vue 单文件组件，Loader 转换后差别都很大，需要调试 Loader 转换前的源代码。
- inline：将`.map`文件作为 dateURI 嵌入，不单独生成

*验证 devtool 名称时， 我们期望使用某种模式， 注意不要混淆 devtool 字符串的顺序， 模式是：* `[inline-|hidden-|eval-][nosources-][cheap-[module-]]source-map`*.*

![image-20210409153245743](https://i.loli.net/2021/04/09/YPC2FdoWUsvEBZw.png)

#### 特殊模式

- inline-source-map 模式  
  它跟普通的 source-map 效果相同，只不过这种模式下 Source Map 文件不是以物理文件存在，而是以 data URLs 的方式出现在代码中。我们前面遇到的 eval-source-map 也是这种 inline 的方式。

- hidden-source-map 模式  
  在这个模式下，我们在开发工具中看不到 Source Map 的效果，但是它也确实生成了 Source Map 文件，这就跟 jQuery 一样，虽然生成了 Source Map 文件，但是代码中并没有引用对应的 Source Map 文件，开发者可以自己选择使用。

- nosources-source-map 模式：  
  在这个模式下，我们能看到错误出现的位置（包含行列位置），但是点进去却看不到源代码。这是为了保护源代码在生产环境中不暴露。

#### 推荐配置

vuecli production 采用 source-map

个人理解 production 应该使用 none 或者 nosources-source-map

development 采用 cheap-module-eval-source-map

### 热更新

#### 开启

```JavaScript
  devServer: {
    // 开启 HMR 特性，如果资源不支持 HMR 会 fallback 到 live reloading
    hot: true
    // 只使用 HMR，不会 fallback 到 live reloading
    // hotOnly: true
  },
  plugins: [
    // ...
    // HMR 特性所需要的插件
    new webpack.HotModuleReplacementPlugin()
  ]
```

#### 原理

启动一个 websocket 监听文件 id 变化，执行除以 js，并重新执行

```JavaScript
if (module.hot) {
  module.hot.accept("./number", function() {
    document.body.removeChild(document.getElementById("number"));
    number();
  });
}
```

热更新插件也就是通过对每个文件进行监听

#### 常见问题

##### 运行时错误

如果处理热替换的代码（处理函数）中有错误，结果也会导致自动刷新。导致无法看到错误日志，

解决办法：开启 hotonly

##### 未开启 HMR

```JavaScript
if (module.hot) {
  // 确保有 HMR API 对象
  module.hot.accept("./editor", () => {
    // ...
  });
}
```

### babel

#### 预设

1.babel-loader 是 webpack 与 babel 的通信桥梁，不会做把 es6 转成 es5 的⼯作，这部分⼯作需要用到 **@babel/preset-env**来做 2.@babel/preset-env ⾥包含了 es，6，7，8 转 es5 的转换规则

#### polyfill

默认的 Babel 只⽀持 let 等⼀些基础的特性转换，Promise 等⼀些还有转换过 来，这时候需要借助@babel/polyfill，把 es 的新特性都装进来，来弥补低版本浏览器中缺失的特性

```JavaScript
//index.js 顶部
import "@babel/polyfill";
```

#### 按需加载

```JavaScript
//.babelrc
{
  "presets": [
    [
      "@babel/preset-env",
      {
        "targets": {
          //目标环境
          "edge": "17",
          "firefox": "60",
          "chrome": "67",
          "safari": "11"
        },
        "corejs": 2,//新版本需要指定核⼼库版本
        "useBuiltIns": "usage"
      }
    ],
    "@babel/preset-react"
  ]
}

```

useBuiltIns 选项是 babel 7 的新功能，这个选项告诉 babel 如何配置 @babel/polyfill 。 它有三个参数可以使用：

①entry: 需要在 webpack 的⼊⼝⽂件⾥ import "@babel/polyfill" ⼀次。 babel 会根据你的使用情况导⼊垫片，没有使用的功能不会被导⼊相应的垫片。

②usage: 不需要 import ，全⾃动检测，但是要安装 @babel/polyfill 。（试验阶段）

③false: 如果你 import "@babel/polyfill" ，它不会排除掉没有使用的垫片，程序体积会庞⼤。(不推荐)

## tree-shaking

webpack4 的 production 默认开启了 treeshaking

如果是 webpack2 ，可能会不起作用，因为 babel 会将代码转化成 commonjs 模块，而 treeshaking 不支持

```
options:{presets:[["es2015",{module:false}]]}
```

### 使用

```JavaScript
// ./webpack.config.js
module.exports = {
  // ... 其他配置项
  optimization: {
    // 模块只导出被使用的成员
    usedExports: true,
    // 尽可能合并每一个模块到一个函数中
    concatenateModules: true,
    // 压缩输出结果
    minimize: false,
  },
};
```

### 副作用 side effects

side effects 是指那些当 import 的时候会执行一些动作，但是不一定会有任何 export。比如 ployfill

tree-shaking 不能自动的识别那些代码属于 side effcets 所以，有些需要手动指定

```JavaScripton
## pagejson
{
    name:'tree-shaking',
    "sideEffects":false,
    // sideEffects:[
    // './src/common/ployfill.js'
    // ]
}
```

[[Rollup]]
