---
tags:
title: Rollup
date created: 2023-04-04
date modified: 2023-04-26
---

# Rollup

Rollup 诞生的目的并不是要与 Webpack 这样的工具全面竞争。它的初衷只是希望能够**提供一个高效的 ES Modules 打包器，充分利用 ES Modules 的各项特性，构建出结构扁平，性能出众的类库**。

Rollup 打包结果惊人的简洁，基本上就跟我们手写的代码一样。相比于 Webpack 大量的引导代码和一堆的模块函数，这里的输出结果没有任何多余代码，就是把打包过程中的各个模块按照依赖顺序，先后拼接到了一起。

### 输出格式

```JavaScript
// ./rollup.config.js
// 所有 Rollup 支持的格式
const formats = ["es", "amd", "cjs", "iife", "umd", "system"];
export default formats.map((format) => ({
  input: "src/index.js",
  output: {
    file: `dist/bundle.${format}.js`,
    format,
  },
}));
```

### 使用插件

```JavaScript
// ./rollup.config.js
import json from "@rollup/plugin-json";
export default {
  input: "src/index.js",
  output: {
    file: "dist/bundle.js",
    format: "es",
  },
  plugins: [json()],
};
```

### 加载 NPM 模块

Rollup 默认只能够按照文件路径的方式加载本地的模块文件，对于 node_modules 目录中的第三方模块，并不能像 Webpack 一样，直接通过模块名称直接导入。

```JavaScript
import resolve from '@rollup/plugin-node-resolve'
export default {
  ...
  plugins: [
    resolve()
  ]
}
```

### 加载 CommonJS 模块

由于 Rollup 设计的是只处理 ES Modules 模块的打包，所以如果在代码中导入 CommonJS 模块，默认是不被支持的

```JavaScript
import commonjs from '@rollup/plugin-commonjs'
export default {
  ...
  plugins: [
    commonjs()
  ]
}
```

### 优缺点

优点

- 输出结果更加扁平，执行效率更高；
- 自动移除未引用代码；
- 打包结果依然完全可读。

但是它的缺点也同样明显：

- 加载非 ESM 的第三方模块比较复杂；
- 因为模块最终都被打包到全局中，所以无法实现 HMR；
- 浏览器环境中，代码拆分功能必须使用 Require.js 这样的 AMD 库。

总结一下：Webpack 大而全，Rollup 小而美。
