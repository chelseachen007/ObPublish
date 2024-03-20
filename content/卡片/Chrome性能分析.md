---
tags:
title: Chrome 性能分析
date created: 2023-04-04
date modified: 2023-04-26
---

# Chrome 性能分析

通常来说，前端的性能分析可以从**时间**和**空间**两个角度来进行。

- 时间：常见耗时，如页面加载耗时、渲染耗时、网络耗时、脚本执行耗时等。
- 空间：资源占用，包括 CPU 占用、内存占用、本地缓存占用等。

## Performance

首先打开无痕模式

![image-20200910153802551](https://i.loli.net/2021/03/02/FhwTLkW6NB3GHeX.png)

一般来说，我们需要分析和使用到 Performance 面板上的这些结果。

- **FPS 图表**：当在 FPS 上方看到红色条形时，表示帧速率下降得太低，以至可能损害用户体验。
- **CPU 图表**：CPU 图表的颜色对应于性能板的底部的 Summary 选项卡。
- **火焰图**：火焰图直观地表示出了内部的 CPU 分析，横轴是时间，纵轴是调用指针，调用栈最顶端的函数在最下方；启用 JS 分析器后，火焰图会显示调用的每个 JavaScript 函数，可用于分析具体函数。
- **Buttom-up**：此视图可以看到某些函数对性能影响最大，并能够检查这些函数的调用路径。

具体要怎么定位某些性能瓶颈，可以参考[官方文档系列文章](https://developers.google.com/web/tools/chrome-devtools/evaluate-performance/reference?fileGuid=xxQTRXtVcqtHK6j8) ，

除了上面标注的要学会看,还要认识几个时间节点

- **FP (First Paint) 首次绘制**: 标记浏览器渲染任何在视觉上不同于导航前屏幕内容之内容的时间点.
- **[[FCP]] (First Contentful Paint) 首次内容绘制** 标记浏览器渲染来自 DOM 第一位内容的时间点，该内容可能是文本、图像、SVG 甚至元素.
- **LCP (Largest Contentful Paint) 最大内容渲染**: 代表在 viewport 中最大的页面元素加载的时间. LCP 的数据会通过 PerformanceEntry 对象记录, 每次出现更大的内容渲染, 则会产生一个新的 PerformanceEntry 对象.(2019 年 11 月新增)
- **DCL (DomContentloaded)**: 当 HTML 文档被完全加载和解析完成之后，DOMContentLoaded 事件被触发，无需等待样式表、图像和子框架的完成加载.
- **FMP(First Meaningful Paint) 首次有效绘制**: 例如，在 YouTube 观看页面上，主视频就是主角元素. 看这个 csdn 的网站不是很明显, 这几个都成一个时间线了, 截个 weibo 的看下. 下面的示例图可以看到, 微博的博文是主要元素.
- **L (onLoad)**, 当依赖的资源, 全部加载完毕之后才会触发.

### performance 对象

![image-20200910155220279](https://i.loli.net/2021/03/02/j3AsZiBtD1VJNxK.png)

然后剩下的就要具体分析了。

我们常说的首屏绘制时间也就是**FP**，关键路径的优化主要也是在优化 FP 之前的加载 所以，学会看 Performance 尤为重要！

### [[Lighthouse]]

### 自动化

[Chrome DevTools Protocol](https://chromedevtools.github.io/devtools-protocol/?fileGuid=xxQTRXtVcqtHK6j8)允许第三方对基于 Chrome 的网站进行检测、调试、分析等操作。

也就是说，我们可以自行开发工具，通过 Chrome DevTools Protocol 来获取 Chrome 中网站运行的性能数据。

当我们打开 Chrome DevTools 的时候，浏览器内核 Chromium 本身会作为一个服务端，它会通过 WebSocket 与 Chrome DevTools 进行通信，过程如下：

1. DevTools 将作为客户端，与作为服务端的 Chromium 建立连接；
2. DevTools 通过 HTTP 获取 HTML、JavaScript 和 CSS 资源，并进行加载；
3. 资源加载后，DevTools 会建立与浏览器的 WebSocket 连接；
4. Chrome DevTools Protocol 基于 WebSocket，它利用 WebSocket 建立连接 DevTools 和浏览器内核的快速数据通道。

也就是说，DevTools 和浏览器内核的数据通信，是通过 Chrome DevTools Protocol 来完成。同样的，当我们通过 DevTools 从 Windows、Mac 或 Linux 计算机远程调试 Android 设备上的实时内容时，使用的也是该协议。

Chrome DevTools Protocol 具有与浏览器的许多不同部分（例如页面、Service Worker 和扩展程序）进行交互的 API。该协议把不同的操作划分为了不同的域（domain），每个域负责不同的功能模块，比如 `DOM`、`Debugger`、`Network`、`Console` 和 `Performance` 等，可以理解为 DevTools 中的不同功能模块。

对于如何使用该协议，其实已有针对这个协议封装出不同语言的库，包括 Node.js、Python、Java 等，可以在 [awesome-chrome-devtools](https://github.com/ChromeDevTools/awesome-chrome-devtools#chrome-devtools-protocol?fileGuid=xxQTRXtVcqtHK6j8) 这个项目中找到。
