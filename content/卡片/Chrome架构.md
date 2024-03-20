---
tags:
title: Chrome 架构
date created: 2023-04-04
date modified: 2023-04-26
---

# Chrome 架构

多线程可以并行处理任务，但是线程是不能单独存在的，它是由进程来启动和管理的。那什么又是进程呢？  
**一个进程就是一个程序的运行实例。** 详细解释就是，启动一个程序的时候，操作系统会为该程序创建一块内存，用来存放代码、运行中的数据和一个执行任务的主线程，我们把这样的一个运行环境叫进程。  
![](https://chelsechen-img.oss-cn-hangzhou.aliyuncs.com/20220714140041.png)
