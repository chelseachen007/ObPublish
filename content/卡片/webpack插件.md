---
tags:
title: webpack 插件
date created: 2023-04-04
date modified: 2023-04-26
---

# webpack 插件

插件是 webpack 的[支柱](https://github.com/webpack/tapable)功能。webpack 自身也是构建于，你在 webpack 配置中用到的**相同的插件系统**之上！

插件目的在于解决 [loader](https://www.webpackjs.com/concepts/loaders) 无法实现的**其他事**。

#### 使用

使用相当简单，具体传入参数看文档就好

```JavaScript
const HtmlWebpakcPlugin = require("html-webpack-plugin");

plugins: [new HtmlWebpakcPlugin(), new CleanWebpackPlugin(), new fileWebpackPlugin()],
```

#### 自定义 Plugins

```JavaScript
class fileWebpackPlugin {
  //   constructor(options) {
  //     console.log(options);
  //   }
  //如何钩入hooks
  apply(compiler) {
    compiler.hooks.emit.tapAsync("fileWebpackPlugin", (compilation, cb) => {
      const len = Object.keys(compilation.assets).length;
      let content = `文件的数量：${len}`;
      for (let filename in compilation.assets) {
        content += `\n ${filename}`;
      }
      compilation.assets[`file.txt`] = {
        source: function() {
          return content;
        },
        size: function() {
          return 1024;
        },
      };
      cb();
    });
  }
}
module.exports = fileWebpackPlugin;
```

在插件开发中最重要的两个资源就是 `compiler` 和 `compilation` 对象。理解它们的角色是扩展 webpack 引擎重要的第一步。

- `compiler` 对象代表了**完整的 webpack 环境配置**。这个对象在启动 webpack 时被一次性建立，并配置好所有可操作的设置，包括 options，loader 和 plugin。当在 webpack 环境中应用一个插件时，插件将收到此 compiler 对象的引用。可以使用它来访问 webpack 的主环境。
- `compilation` 对象代表了一次资源版本构建。当运行 webpack 开发环境中间件时，每当检测到一个文件变化，就会创建一个新的 compilation，从而生成一组**新的编译资源**。一个 compilation 对象表现了当前的模块资源、编译生成资源、变化的文件、以及被跟踪依赖的状态信息。compilation 对象也提供了很多关键时机的回调，以供插件做自定义处理时选择使用。

#### 查看配置的 webpack 周期

```JavaScript
const compiler = webpack(config);
Object.keys(compiler.hooks).forEach((hookName) => {
  compiler.hooks[hookName].tap("xxxx", () => {
    console.log(`run====> ${hookName}`);
  });
});

compiler.run();
```
