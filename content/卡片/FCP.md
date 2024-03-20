---
tags:
title: FCP
date created: 2023-04-04
date modified: 2023-04-26
---

# FCP

FCP（First Contentful Paint），首次内容绘制标记浏览器渲染来自 DOM 第一位内容的时间点，该内容可能是文本、图像、SVG 甚至元素。

首屏统计的方式一直在变，起初是通过记录 window. Performance. Timing 中的 domComplete 与 domLoading 的时间差来完成，但这并不具备交互意义，现在通常是记录初次加载并绘制内容的时间。
