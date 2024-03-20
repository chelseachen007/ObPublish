---
tags:
title: Flux
date created: 2023-04-04
date modified: 2023-04-26
---

# Flux

2014 的 Facebook F8 大会上提出了一个观点，MVC 更适用于**小型应用**，但在面向大型前端项目时，MVC 会使项目**足够复杂**，即每当添加新的功能，系统复杂度就会疯狂增长。如下图所示，Model 与 View 的关联是错综复杂的，很难理解和调试，尤其是 Model 与 View 之间还存在**双向数据流动**。  
[MVC 数据流](https://s0.lgstatic.com/i/image/M00/8B/E8/CgqCHl_hvXiARE1qAAGLIgEVr84635.png)

这对于接手老代码的人来说是个令人头疼的难题，因为他们害怕承担风险，所以不敢轻易修改代码。这也正是 [[MVC]] 模式被 Facebook 抛弃的原因。

所以他们提出了一种基于** [[状态管理方案#单向数据流 |单向数据流]] **的架构。如下图所示：  
![](https://chelsechen-img.oss-cn-hangzhou.aliyuncs.com/20220705164108.png)

具体的流程是这样的，Store 存储了视图层所有的数据，当 Store 变化后会引起 View 层的更新。如果在视图层触发 Action，比如点击一个按钮，当前的页面数据值会发生变化。Action 会被 Dispatcher 进行统一的收发处理，传递给 Store 层。由于 Store 层已经注册过相关 Action 的处理逻辑，处理对应的内部状态变化后，会触发 View 层更新。
