---
tags:
title: TTI
date created: 2023-04-04
date modified: 2023-04-26
---

# TTI

TTI（Time to Interact），是页面可交互的时间。，用于标记页面已进行视觉渲染并能可靠响应用户输入的时间点。页面可能会因为多种原因而无法响应用户输入，例如页面组件运行所需的 Javascript 尚未加载，或者耗时较长的任务阻塞主线程。TTI 指标可识别页面初始 JavaScript 已加载且主线程处于空闲状态（没有耗时较长的任务）的时间点。

通常通过记录 window. Performance. Timing 中的 domInteractive 与 fetchStart 的时间差来完成。
