---
tags:
title: muji迁移vite
date created: 2023-04-04
date modified: 2023-05-19
---

#状态/未完成

# muji迁移vite

# 准备工作

## 创建一个 muji 模板

```js
   yarn create @souche-f2e/muji
```

## 创建一个 vite 模板

```

```

将 index.ejs 移到最外层改成 index.html 并引入 main.js

```html
<!DOCTYPE html>

<html lang="en">
	<head>
		<meta charset="UTF-8" />

		<link rel="icon" type="image/svg+xml" href="/src/favicon.svg" />

		<meta name="viewport" content="width=device-width, initial-scale=1.0" />

		<title>Vite App</title>
	</head>

	<body>
		<div id="root"></div>

		<script type="module" src="./src/.muji/entry.tsx"></script>
	</body>
</html>
```

另外变量引入

# 问题修复

### require is not defined

https://learnku.com/vuejs/t/54771  
store 文件 require 改成 import

### antd icon

```js
Uncaught (in promise) TypeError: Unknown theme type: undefined, name: undefined

```

升级到 4.0

### 批量修改后缀

可以看下这个 issue:[https://github.com/vitejs/vite/issues/1552](https://github.com/vitejs/vite/issues/1552) ，最后作者发出`批量改个后缀有这么难`的吐槽，算了，还是改吧，如果觉得手动改麻烦，写个脚本也不是啥难事。

https://qdmana.com/2021/04/20210419144833849u.html

### 输出文件

```error
Failed to load module script: The server responded with a non-JavaScript MIME type of "text/html". Strict MIME type checking is enforced for module scripts per HTML spec.
```

### alias 和包名冲突

### 无法解析 less 中的~antd/语法

```js
alias: [

{ find: /^~/, replacement: '' },

{ find: '@', replacement: pathResolve('src') },

{ find: '@@', replacement: pathResolve('src/.muji') },

],
```

### 引入 antd 中有 js

```
[vite] Internal server error: Inline JavaScript is not enabled. Is it set in your options?
```

```js
// vite2.x
css: {
  preprocessorOptions: {
    less: {
      javascriptEnabled: true,
    }
  },
},
```

### babel 解析 store

```
[plugin:vite:react-babel] /Volumes/work/数据中心/muji-template/src/pages/link/index.tsx: Identifier 'dispatch' has already been declared. (9:9)
```

### process 未找到

https://cn.vitejs.dev/guide/env-and-mode.html

process.env 替换成 **`import.meta.env`**

### 环境变量定义

为了防止意外地将一些环境变量泄漏到客户端，只有以 `VITE_` 为前缀的变量才会暴露给经过 vite 处理的代码。例如下面这个文件中：

```js
DB_PASSWORD = foobar;
VITE_SOME_KEY = 123;
```

只有 `VITE_SOME_KEY` 会被暴露为 `import.meta.env.VITE_SOME_KEY` 提供给客户端源码，而 `DB_PASSWORD` 则不会。

如果你想自定义 env 变量的前缀，请参阅 [envPrefix](https://cn.vitejs.dev/config/index.html#envprefix)。

### 引入包不支持

```node
Error: Build failed with 1 error:
node_modules/react-virtualized/dist/es/WindowScroller/utils/onScroll.js:74:9: error: No matching export in "node_modules/react-virtualized/dist/es/WindowScroller/WindowScroller.js" for import "bpfrpt_proptype_WindowScroller"
```

修复

```json
"react-virtualized": "patch:react-virtualized@9.22.3#./path/to/react-virtualized-9.22.3.patch",
```

### 修复之后也没找到 style

```
Error: The following dependencies are imported but could not be resolved:

  react-virtualized/styles.css
```

#状态/todo

### 动态路由

查找正则  
import\((.+?)\)

### dispatch 已声明

```
import { dispatch } from '@@/store';
```

删除即可\

### antd 主题色

muji

```json
[

'@souche-f2e/muji-plugin-antd-vars',

{

theme: {

'@primary-color': '#456CF6',

'@link-color': '#4A96FF',

// '@height-base': '36px',

// '@height-lg': '44px',

// '@height-sm': '28px',

'@text-color': '#1B1C33',

'@table-padding-vertical': '10px',

'@table-padding-horizontal': '10px',

'@table-header-bg': '#EAEDF2',

'@table-selected-row-bg': 'rgba(67, 97, 216, 0.1)',

'@pagination-item-size': '30px',

'@border-radius-base': '4px',

},

},

],
```

vite.config.js

```js
css: {

preprocessorOptions: {

less: {

modifyVars: {

'@primary-color': '#456CF6',

},

javascriptEnabled: true,

},

},

},
```

### store 更新页面没渲染

将 store.ts 中的 moudle 都替换成 import.meta

```js
if (import.meta.hot) {
}
```

### 引入 antd.less

```js
import "antd/dist/antd.less";
```

### 引入 luban 出错

缺少 module 模块对应的 es5.js

```json
"main": "dist/luban-js-v2.umd.js",

"module": "dist/luban-js-v2.es5.js",

"typings": "dist/types/luban-js-v2.d.ts",
```

### 循环引用

```
error during build:
RangeError: /Volumes/work/dataCenter/user-portrait-v2/node_modules/react-redux/es/components/Provider.js: Maximum call stack size exceeded
```

在 vite.config.js，只在开发环境中使用

```javascript
export default defineConfig(({ mode }) => {
  const isDevEnv = mode === 'development';

  return {
    plugins: [
       isDevEnv && react(),
    ]
  }
}
```

### 部署线上路径不对

```json
baseUrl:'./'
```

### 无法按需引入 echarts

```js
import * as echarts from "echarts";
```

### antd 国际化的包要 es 的

```js
import zhCN from 'antd/es/locale/zh_CN.js';`
```

# 对比

对比维度

1. 初次构建速度
2. 热更新速度
3. 构建包体积

## muji

### 初次构建速度

![](https://chelsechen-img.oss-cn-hangzhou.aliyuncs.com/20211207162404.png)

### 第二次以后构建

![](https://chelsechen-img.oss-cn-hangzhou.aliyuncs.com/20211207195924.png)

### 热更新速度

![](https://chelsechen-img.oss-cn-hangzhou.aliyuncs.com/20211207162426.png)

### 页面加载速度

![](https://chelsechen-img.oss-cn-hangzhou.aliyuncs.com/20211207162602.png)

### 打包大小

![](https://chelsechen-img.oss-cn-hangzhou.aliyuncs.com/20211207163355.png)

大概 23.1MB

### 兼容性

## vite

### 初次构建速度

![](https://chelsechen-img.oss-cn-hangzhou.aliyuncs.com/20211207154949.png)

### 第二次以后构建

![](https://chelsechen-img.oss-cn-hangzhou.aliyuncs.com/20211207155136.png)

### 热更新速度

瞬间 毫秒级

### 页面加载速度

![](https://chelsechen-img.oss-cn-hangzhou.aliyuncs.com/20211207155916.png)

#### 懒加载以后

![](https://chelsechen-img.oss-cn-hangzhou.aliyuncs.com/20211208154222.png)

### 兼容性

### 打包大小

大概 5.7M  
![](https://chelsechen-img.oss-cn-hangzhou.aliyuncs.com/20211207161228.png)

# Vite 打包优化

[[Vite优化]]
