---
tags: 
title: webpack_lodaer
date created: 2023-04-04
date modified: 2023-04-26
---

# webpack_lodaer

loader 用于对模块的源代码进行转换。loader 可以使你在 `import` 或"加载"模块时预处理文件

#### 使用

举一个 less-loader 使用例子

```JavaScript
 rules: [
      {
        test: /\.less$/, //  匹配规则
        // use可对象，可以<string,object>数组
        //使用对象时，可通过options传参,通过this.query获取
        use: ["my-style-loader", "my-css-loader", {
          loader: "my-less-loader",
          options: {
            name: "scssloader",
          },
        }], //多个loader从右向左
      },
    ],
```

#### 自定义 loader

```JavaScript
// 函数 声明式函数 不可以是箭头函数
// 函数 必须有返回值
// 如何返回多值
// 如何处理异步逻辑
module.exports = function(source) {
  console.log(this.query);
  console.log(source);
  // 异步回调
  const callback = this.async();
  setTimeout(() => {
    const result = source.replace("webpack", this.query.name);
    callback(null, result);
  }, 2000);
  //  同步回调
  //   this.callback(null, result);
};
//this.callback(  err: Error | null,  content: string | Buffer,  sourceMap?: SourceMap,  meta?: any );
```

##### Markdown-loader

```js
// ./markdown-loader.js

const marked = require('marked')



module.exports = source => {

  const html = marked(source)

  // const code = `module.exports = ${JSON.stringify(html)}`

  const code = `export default ${JSON.stringify(html)}`

  return code 

}

```

#### 重命名自定义 loader

```JavaScript
 resolveLoader: {
    modules: ["./node_modules", "./myLoaders"],
  },
```

#### 常用 loader
