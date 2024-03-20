---
tags:
title: WebAssembly
date created: 2023-04-04
date modified: 2023-04-26
---

# WebAssembly

WebAssembly （WASM）是一种可移植的低级语言，Rust 可以编译成它。它在浏览器中运行，可与 JavaScript 互操作，并被所有主要的现代浏览器所支持。

> WASM 肯定比 JS 快很多，但还没有达到原生速度。在我们的测试中，Parcel 编译成 WASM 后的运行速度比使用本地二进制文件慢 10 - 20 倍。
>
> —— Devon Govett

虽然 WASM 还不是完美的解决方案，但它可以帮助开发者创建极快的 Web 体验。[[Rust]] 团队 致力于实现高质量和先进（cutting edge）的 WASM 实现。对于开发者来说，这意味着你可以拥有 Rust 的性能优势（相对于 Go ），同时还可以为 Web 服务（使用 WASM ）。
