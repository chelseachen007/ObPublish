---
tags:
title: monorepo 的优劣势
date created: 2023-04-04
date modified: 2023-04-26
---

单仓库模块管理，可使用 lerna 进行包管理  
monorepo 是一种**将多个项目代码存储在一个仓库里的软件开发策略**（"mono" 来源于希腊语 μόνος 意味**单个的**，而 "repo"，显而易见地，是 repository 的缩写）

# monorepo 的优劣势

通过 monorepo 策略组织代码，您代码仓库的目录结构看起来会是这样：

```
.
├── lerna.json
├── package.json
└── packages/ # 这里将存放所有子 repo 目录
    ├── project_1/
    │   ├── index.js
    │   ├── node_modules/
    │   └── package.json
    ├── project_2/
    │   ├── index.js
    │   ├── node_module/
    │   └── package.json
    ...
```

乍看起来，所谓的 monorepo 策略就只是将不同项目的目录汇集到一个目录之下，但实际上操作起来所要考虑的事情则远比看起来要复杂得多。通过分析使用 monorepo 策略的优劣，我们可以更直观的感受到这里面所隐晦涉及的知识点。

## 优点

- 项目代码可集中进行管理，使用统一的构建工具。  
  代码重用将变得非常容易：由于所有的项目代码都集中于一个代码仓库，我们将很容易抽离出各个项目共用的业务组件或工具，并通过 [[TypeScript]]，[[Lerna]] 或其他工具进行代码内引用；
- 依赖管理将变得非常简单：同理，由于项目之间的引用路径内化在同一个仓库之中，我们很容易追踪当某个项目的代码修改后，会影响到其他哪些项目。通过使用一些工具，我们将很容易地做到版本依赖管理和版本号自动升级；
- 代码重构将变得非常便捷：想想究竟是什么在阻止您进行代码重构，很多时候，原因来自于「不确定性」，您不确定对某个项目的修改是否对于其他项目而言是「致命的」，出于对未知的恐惧，您会倾向于不重构代码，这将导致整个项目代码的腐烂度会以惊人的速度增长。而在 monorepo 策略的指导下，您能够明确知道您的代码的影响范围，并且能够对被影响的项目可以进行统一的测试，这会鼓励您不断优化代码；
- 它倡导了一种开放，透明，共享的组织文化，这有利于开发者成长，代码质量的提升：在 monorepo 策略下，每个开发者都被鼓励去查看，修改他人的代码（只要有必要），同时，也会激起开发者维护代码，和编写单元测试的责任心（毕竟朋友来访之前，我们从不介意自己的房子究竟有多乱），这将会形成一种良性的技术氛围，从而保障整个组织的代码质量。
- 模块间调试方便、问题定位和修复相对容易

## 缺点

- 仓库体积大，对构建工具要求较高  
  **对于公司级别的 monorepo 策略而言，需要专门的 VFS 系统，自动重构工具的支持**：设想一下 Google 这样的企业是如何将十亿行的代码存储在一个仓库之中的？开发人员每次拉取代码需要等待多久？各个项目代码之间又如何实现权限管理，敏捷发布？
- **项目粒度的权限管理变得非常复杂**：无论是 Git 还是其他 VCS 系统，在支持 monorepo 策略中项目粒度的权限管理上都没有令人满意的方案，这意味着 A 部门的 a 项目若是不想被 B 部门的开发者看到就很难了。（好在我们可以将 monorepo 策略实践在「项目级」这个层次上，这才是我们这篇文章的主题，我们后面会再次明确它）；
- 为了保证代码质量，对版本控制和 Git 工作流要求更高
- 新员工的学习成本变高：不同于一个项目一个代码仓库这种模式下，组织新人只要熟悉特定代码仓库下的代码逻辑，在 monorepo 策略下，新人可能不得不花更多精力来理清各个代码仓库之间的相互逻辑，当然这个成本可以通过新人文档的方式来解决，但维护文档的新鲜又需要消耗额外的人力；

和[[单页应用]]类似

# 实践

## 使用环境：[[Volta]]

## 复用 packages：workspace

使用 monorepo 策略后，收益最大的两点是：

1. **避免重复安装包，因此减少了磁盘空间的占用，并降低了构建时间**；
2. **内部代码可以彼此相互引用**；  
    为了实现前面提到的两点收益，您需要在代码中做三件事：

3. 调整目录结构，将相互关联的项目放置在同一个目录，推荐命名为  `packages`；
4. 在项目根目录里的  `package.json`  文件中，设置  `workspaces`  属性，属性值为之前创建的目录；
5. 同样，在  `package.json`  文件中，设置  `private`  属性为  `true`（为了避免我们误操作将仓库发布）；

经过修改，您的项目目录看起来应该是这样：

```
.
├── package.json
└── packages/
    ├── @mono/project_1/ # 推荐使用 `@<项目名>/<子项目名>` 的方式命名
    │   ├── index.js
    │   └── package.json
    └── @mono/project_2/
        ├── index.js
        └── package.json
```

而当您在项目根目录中执行  `npm install`  或  `yarn install`后，您会发现在项目根目录中出现了  `node_modules`  目录，并且该目录不仅拥有所有子项目共用的 npm 包，还包含了我们的子项目。因此，我们可以在子项目中通过各种模块引入机制，像引入一般的 npm 模块一样引入其他子项目的代码。

## 统一配置

您一定同意，编写代码要遵循 [[DRY 原则]]（Don't Repeat Yourself 的缩写）。那么，理所当然地，我们应该尽量避免在多个子项目中放置重复的 eslintrc，tsconfig 等配置文件。幸运的是，Babel，Eslint 和 Typescript 都提供了相应的功能让我们减少自我重复。

### TypeScript

我们可以在  `packages`  目录中放置  `tsconfig.settting.json`  文件，并在文件中定义通用的 ts 配置，然后，在每个子项目中，我们可以通过  `extends`  属性，引入通用配置，并设置  `compilerOptions.composite`  的值为  `true`，理想情况下，子项目中的  `tsconfig`  文件应该仅包含下述内容：

```
{
  "extends": "../tsconfig.setting.json", // 继承 packages 目录下通用配置
  "compilerOptions": {
    "composite": true, // 用于帮助 TypeScript 快速确定引用工程的输出文件位置
    "outDir": "dist",
    "rootDir": "src"
  },
  "include": ["src"]
}
```

### [[Eslint]]

对于 Eslint 配置文件，我们也可以如法炮制，这样定义子项目的  `.eslintrc`  文件内容：

```
{
  "extends": "../../.eslintrc", // 注意这里的不同
  "parserOptions": {
    "project": "tsconfig.json"
  }
}
```

### Babel

Babel 配置文件合并的方式与 TypeScript 如出一辙，甚至更加简单，我们只需在子项目中的  `.babelrc`  文件中这样声明即可：

```
{
  "extends": "../.babelrc"
}
```

当一切准备就绪后，我们的项目目录应该大致呈如下所示的结构：

```
.
├── package.json
├── .eslintrc
└── packages/
    │   ├── tsconfig.settings.json
    │   ├── .babelrc
    ├── @mono/project_1/
    │   ├── index.js
    │   ├── .eslintrc
    │   ├── .babelrc
    │   ├── tsconfig.json
    │   └── package.json
    └───@mono/project_2/
        ├── index.js
        ├── .eslintrc
        ├── .babelrc
        ├── tsconfig.json
        └── package.json
```

### 统一命令脚本：scripty

scripty 允许您将脚本命令定义在文件中，并在  `package.json`  文件中直接通过文件名来引用。这使我们可以实现如下目的：

1. **子项目间复用脚本命令**；
2. **像写代码一样编写脚本命令，无论它有多复杂，而在调用时，像调用函数一样调用**；

注意，我们脚本分为两类「package 级别」与「workspace 级别」，并且分别放在两个文件夹内。这样做的好处在于，我们既可以在项目根目录执行全局脚本，也可以针对单个项目执行特定的脚本。

通过使用 scripty，子项目的  `package.json`  文件中的  `scripts`  属性将变得非常精简：

```
{
  ...
  "scripts": {
    "test": "scripty",
    "lint": "scripty",
    "build": "scripty"
  },
  "scripty": {
    "path": "../../scripts/packages" // 注意这里我们指定了 scripty 的路径
  },
  ...
}
```

### 统一包管理：[[Lerna]]

### 格式化 commit 信息

[[commitLint]] 和[[husky]]

## 如何迁移

Lerna 为我们提供了  `lerna import`  命令，用来将我们已有的包导入到 monorepo 仓库，并且还会保留该仓库的所有 commit 信息。然而实际上，该命令仅支持**导入本地项目**，并且**不支持**导入项目的分支和标签

那么如果我们想要导入远程仓库，或是要获取某个分支或标签该怎么做呢？答案是使用  [tomono](https://github.com/hraban/tomono)，其内容是一个 shell 脚本。

使用 tomono 导入远程仓库，您所需要做的只有两件事：

1. 创建一个包含所有需要导入 repo 地址的文本文件；
2. 执行 shell 命令：`cat repos.txt | ~/tomono/tomono.sh`（这里我们假定您的文本文件名为  `repos.txt`，且您将 tomono 下载在用户根目录；

repo 文件内容示例如下：

```
// 1. Git仓库地址  2. 子项目名称  3. 迁移后的路径
git@github.com/backend.git @mono/backend packages/backend
git@github.com/frontend.git @mono/frontend packages/frontend
git@github.com/mobile.git @mono/mobile packages/mobile
```
