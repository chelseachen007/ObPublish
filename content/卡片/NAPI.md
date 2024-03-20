---
tags:
title: NAPI
date created: 2023-04-04
date modified: 2023-04-26
---

# NAPI

Rust 与 Node.js 的整合比其他低级语言更好。

napi-rs 允许你用 Rust 构建预编译的 Node.js add-ons 。它为交叉编译（cross-compilation）和向 NPM 发布本地二进制文件提供了一个开箱即用的解决方案，不需要 `node-gyp` 或使用 `postinstall` 。

相应的，你也能轻松构建一个被 Node.js 侧直接调用的 [[Rust]] 模块，而不需要像 [[esbuild]] 那样创建一个子进程。
