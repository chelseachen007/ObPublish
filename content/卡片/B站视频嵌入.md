---
tags:
title: B 站视频嵌入
date created: 2023-04-04
date modified: 2023-04-26
---

# B 站视频嵌入

先直接看一下成品

> <div style="position: relative; padding: 30% 45%;">
>
> <iframe style="position: absolute; width: 100%; height: 100%; left: 0; top: 0;" src="[https://player.bilibili.com/player.html?aid=76053337&](https://www.bilibili.com/read/cv6775208#);bvid=[BV11J41127DF](https://www.bilibili.com/video/BV11J41127DF?from=articleDetail)&cid=130096191&page=1&as_wide=1&high_quality=1&danmaku=0" frameborder="no" scrolling="no">
>
> </iframe>
>
> </div>

稍微解释一下上面代码的含义：

- page ->  起始下标为 1 (默认值也是为 1)
- as_wide ->  是否宽屏 【1: 宽屏, 0: 小屏】
- high_quality ->  是否高清 【1: 高清(最高 1080p) / 0: 最低视频质量(默认)】
- danmaku ->  是否开启弹幕 【1: 开启(默认), 0: 关闭】
- allowfullscreen -> allowfullscreen= "ture"  允许全屏，使用该参数可以在浏览器中全屏播放
