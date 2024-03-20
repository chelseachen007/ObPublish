---
tags:
title: 1. Web 上的高性能计算
date created: 2023-04-04
date modified: 2023-04-26
---

[如何将 Tensorflow.js 的性能疯狂提升 100%+](https://mp.weixin.qq.com/s/jU3_Bb6-1af1h1C24dNVIw)

# 1. Web 上的高性能计算

## [R]. Web Worker

使用 Web Worker 可以将一些 CPU 密集型计算转移到子线程中去做执行，同理可以将计算进行分拆，创建多个线程进行并行计算。这里为各位大佬献上一个利用 Web Worker 做并行计算的库 [[Paralles.js]]。

## [G]. Asm.js

2012 年，Mozilla 的工程师 Alon Zakai 在研究 LLVM 编译器时突发奇想：许多 3D 游戏都是用 C / C++ 语言写的，如果能将 C / C++ 语言编译成 JavaScript 代码，它们不就能在浏览器里运行了吗？众所周知，JavaScript 的基本语法与 C 语言高度相似。

于是，他开始研究怎么才能实现这个目标，为此专门做了一个编译器项目 Emscripten。这个编译器可以将 C / C++ 代码编译成 JS 代码，但不是普通的 JS，而是一种叫做 asm.js 的 JavaScript 变体。

> C / C++ 编译成 JS 有两个最大的困难。
>
> - C / C++ 是静态类型语言，而 JS 是动态类型语言。
> - C / C++ 是手动内存管理，而 JS 依靠垃圾回收机制。

asm.js 就是为了解决这两个问题而设计的：它的变量一律都是静态类型，并且取消垃圾回收机制。除了这两点，它与 JavaScript 并无差异，也就是说，asm.js 是 JavaScript 的一个严格的子集，只能使用后者的一部分语法

一旦 JavaScript 引擎发现运行的是 asm.js，就知道这是经过优化的代码，可以**跳过语法分析**这一步，直接转成汇编语言。另外，浏览器还会调用 WebGL 通过 GPU 执行 asm.js，即 asm.js 的执行引擎与普通的 JavaScript 脚本不同。这些都是 asm.js 运行较快的原因。据称，asm.js 在浏览器里的运行速度，大约是原生代码的**50%左右**。

## [B]. WebAssembly

Wasm 相对于原生 JS 或者 asm.js 来说，速度的确很快，TensorFlow.js 官方目前也实现了基于 Wasm 的 backend。但是目前在绝大多数的机器上，Wasm 的执行速度相较于下面要说到的 WebGL 要差个 3 倍以上。

## [A]. GPU

在浏览器内利用 GPU 的能力有两种方法：

- 十分成熟的 WebGL
- 尚在草案阶段的 WebGPU。当前 WebGPU 的进展十分缓慢，我们这里先抛开不谈，谈一谈如何利用 WebGL 进行前端的高性能计算。

![](https://i.loli.net/2021/11/19/ADf4Kq2sPxXjbti.png)  
其中两个 vertex shader 和 fragment shader 为两个 GLSL 代码片段，分别处理坐标数据和颜色数据。vertex shader 和 fragment shader 的执行是以像素为单位，canvas 开始绘制的时候 vertex shader 中得到。每个需要绘制的像素的坐标，视需要可以对坐标进行各种转换，最终得到一个最终位置。这个过程中可以将数据作为输出传 fragment shader 参与下一步的计算 fragment shader 接受各种输入，最终输出一个 RGBA 颜色数据作为该像素点的颜色值。

当所有像素都绘制完成之后，画布绘制完成。

tfjs 就是利用这种方式实现了 Web 内执行模型推理的加速。

# 2.ant-tfjs 的 WebGL 的优化

## 首次执行(预热)优化

## 推理优化
