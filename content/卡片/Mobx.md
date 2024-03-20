---
tags:
title: Mobx
date created: 2023-04-04
date modified: 2023-04-26
---

# Mobx

Mobx 是通过监听数据的属性变化，直接在数据上更改来触发 UI 的渲染。是不是一听就非常“Vue”。那 Mobx 的监听方式是什么呢？

- 在 Mobx 5 之前，实现监听的方式是采用 Object.defineProperty；
- 而在 Mobx 5 以后采用了 Proxy 方案。

action, makeObservable, observable, runInAction, toJS

## makeAutoObservable 详解

`makeAutoObservable(target, overrides?, options?)`

- `target`：将目标对象中的属性和方法设置为 Observable State 和 Action
- `overrides`：覆盖默认设置，将  `target`  对象中的某些属性或方法设置为普通属性
  - 因为并不是所有的属性或方法都需要转化
  - `overrides`  对象中的  `key`  是需要覆盖的属性或方法的名称，`value`  为  `false`  的会被设置成普通属性
- `options`：配置对象
