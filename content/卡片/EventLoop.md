---
tags:
title: 浏览器 EventLoop
date created: 2023-04-04
date modified: 2023-04-26
---

# 浏览器 EventLoop

## 宏任务

我们都知道 JS 是单线程的,我们按照代码顺序写入主线程,然后主线程再依次执行。但是浏览器是多个线程合作运行的,并不是执行之前统一安排好的。所以浏览器的主线程通过一个事件循环机制,**可以接受并执行新的任务**。我们可以通过一个 for 循环语句来监听是否有新的任务,可以在线程运行过程中,等待用户输入的数字,等待过程中线程处于暂停状态,一旦接收到用户输入的信息,那么线程会被激活,然后执行相加运算,最后输出结果。然后一直循环执行。

那么我们如何实现按序的将任务添加到 for 循环中呢,那么答案就是**消息队列**

**消息队列是一种数据结构,可以存放要执行的任务**。它符合队列“**先进先出**”的特点,也就是说**要添加任务的话,添加到队列的尾部；要取出任务的话,从队列头部去取**。

### 页面使用单线程的缺点

**第一个问题是如何处理高优先级的任务。**

因为 DOM 变化非常频繁,如果每次发生变化的时候,都直接调用相应的 JavaScript 接口,那么这个当前的任务执行时间会被拉长,从而导致**执行效率的下降**。

如果将这些 DOM 变化做成异步的消息事件,添加到消息队列的尾部,那么又会影响到监控的实时性,因为在添加到消息队列的过程中,可能前面就有很多任务在排队了。

这也就是说,如果 DOM 发生变化,采用同步通知的方式,会影响当前任务的**执行效率**；如果采用异步方式,又会影响到**监控的实时性**

#### 第二个是如何解决单个任务执行时长过久的问题

因为所有的任务都是在单线程中执行的,所以每次只能执行一个任务,而其他任务就都处于等待状态。如果其中一个任务执行时间过久,那么下一个任务就要等待很长时间。

### 宏任务列表

- 渲染事件（如解析 DOM、计算布局、绘制）；
- 用户交互事件（如鼠标点击、滚动页面、放大缩小等）；
- JavaScript 脚本执行事件；
- 网络请求完成、文件读写完成事件。

### setTimeout

setTimeout 返回一个 id，而**clearTimeout 函数** 接受需要取消的定时器的 ID

#### 注意事项

1. 如果当前任务执行时间过久,会影延迟到期定时器任务的执行
2. 如果 setTimeout 存在嵌套调用,那么系统会设置最短时间间隔为 4 毫秒
3. 未激活的页面,setTimeout 执行最小间隔是 1000 毫秒
4. 延时执行时间有最大值

`Chrome`、`Safari`、`Firefox`都是以 32 个 bit 来存储延时值的,32bit 最大只能存放的数字是 2147483647 毫秒,这就意味着,如果 setTimeout 设置的延迟值大于 2147483647 毫秒（大约 24.8 天）时就会溢出,这导致定时器会被立即执行.

5. 如果被 setTimeout 推迟执行的回调函数是某个对象的方法,那么该方法中的 this 关键字将指向全局环境,而不是定义时所在的那个对象。

### requestAnimationFrame

requestAnimationFrame 提供一个原生的 API 去执行动画的效果,它会在一帧（一般是 16ms）间隔内根据选择浏览器情况去执行相关动作。

## 微任务

为了解决消息队列的种种问题,浏览器引入了微任务。**微任务可以在实时性和效率之间做一个有效的权衡**。

每个宏任务都有一个微任务列表,在宏任务的执行过程中产生微任务会被添加到该列表中。**执行时机是在主函数执行结束之后、当前宏任务结束之前。**

在现代浏览器里面,产生微任务有两种方式:

第一种方式是使用 MutationObserver 监控某个 DOM 节点,然后再通过 JavaScript 来修改这个节点,或者为这个节点添加、删除部分子节点,当 DOM 节点发生变化时,就会产生 DOM 变化记录的微任务。

第二种方式是使用 Promise,当调用 Promise.resolve() 或者 Promise.reject() 的时候,也会产生微任务。

### MutationObserver

#### Mutation Event

2000 年的时候引入了 Mutation Event, Mutation Event 采用了**观察者的设计模式**,当 DOM 有变动时就会立刻触发相应的事件,这种方式属于同步回调。

采用 Mutation Event 解决了实时性的问题,因为 DOM 一旦发生变化,就会立即调用 JavaScript 接口。但也正是这种实时性造成了严重的性能问题,因为每次 DOM 变动,渲染引擎都会去调用 JavaScript,这样会产生较大的性能开销。

#### MutationObserverAPI

MutationObserver 的作用是监控某个 DOM 节点

MutationObserver 将响应函数改成异步调用,可以不用在每次 DOM 变化都触发异步调用,而是等多次 DOM 变化后,**一次触发异步调用**,并且还会使用一个数据结构来记录这期间所有的 DOM 变化。这样即使频繁地操纵 DOM,也不会对性能造成太大的影响。

如果采用 setTimeout 创建宏任务来触发回调的话,那么实时性就会大打折扣,因为上面我们分析过,在两个任务之间,可能会被渲染进程插入其他的事件,从而影响到**响应的实时性**。

MutationObserver 采用了“**异步 + 微任务**”的策略。

- 通过**异步**操作解决了同步操作的**性能问题**；
- 通过**微任务**解决了**实时性的问题**。

### [[Promise]]

### await

async 函数是什么？一句话,它就是 Generator 函数的语法糖。

Generator 函数,依次读取两个文件。

```JavaScript
const fs = require("fs");

const readFile = function (fileName) {
  return new Promise(function (resolve, reject) {
    fs.readFile(fileName, function (error, data) {
      if (error) return reject(error);
      resolve(data);
    });
  });
};

const gen = function* () {
  const f1 = yield readFile("/etc/fstab");
  const f2 = yield readFile("/etc/shells");
  console.log(f1.toString());
  console.log(f2.toString());
};
```

async 函数

```JavaScript
const asyncReadFile = async function () {
  const f1 = await readFile("/etc/fstab");
  const f2 = await readFile("/etc/shells");
  console.log(f1.toString());
  console.log(f2.toString());
};
```

async 函数对 Generator 函数的改进,体现在以下四点  
（1）**内置执行器。**  
（2）**更好的语义**。  
（3）**更广的适用性。**  
（4）**返回值是`Promise`。**

`async` 函数返回的 `Promise` 对象,必须等到内部所有 `await` 命令后面的 `Promise` 对象执行完,才会发生状态改变,除非遇到 `return` 语句或者抛出错误。也就是说,只有 `async` 函数内部的异步操作执行完,才会执行 `then` 方法指定的回调函数。

#### 实现原理

async 函数的实现原理,就是将 Generator 函数和自动执行器,包装在一个函数里。

```JavaScript
async function fn(args) {
  // ...
}

// 等同于

function fn(args) {
  return spawn(function* () {
    // ...
  });
}
```

spawn

```JavaScript
function spawn(genF) {
  return new Promise(function (resolve, reject) {
    const gen = genF();
    function step(nextF) {
      let next;
      try {
        next = nextF();
      } catch (e) {
        return reject(e);
      }
      if (next.done) {
        return resolve(next.value);
      }
      Promise.resolve(next.value).then(
        function (v) {
          step(function () {
            return gen.next(v);
          });
        },
        function (e) {
          step(function () {
            return gen.throw(e);
          });
        }
      );
    }
    step(function () {
      return gen.next(undefined);
    });
  });
}
```

## 与 Node 环境的 EventLoop 区别

> *在 node 11 版本中，node 下 Event Loop 已经与浏览器趋于相同*

### 循环阶段

1. timers：执行满足条件的 setTimeout、setInterval 回调。
2. I/O callbacks：是否有已完成的 I/O 操作的回调函数，来自上一轮的 poll 残留。
3. idle，prepare：可忽略
4. poll：等待还没完成的 I/O 事件，会因 timers 和超时时间等结束等待。
5. check：执行 setImmediate 的回调。
6. close callbacks：关闭所有的 closing handles，一些 onclose 事件。

```ruby
   ┌───────────────────────┐
┌─>│        timers         │<————— 执行 setTimeout()、setInterval() 的回调
│  └──────────┬────────────┘
|             |<-- 执行所有 Next Tick Queue 以及 MicroTask Queue 的回调
│  ┌──────────┴────────────┐
│  │     pending callbacks │<————— 执行由上一个 Tick 延迟下来的 I/O 回调（待完善，可忽略）
│  └──────────┬────────────┘
|             |<-- 执行所有 Next Tick Queue 以及 MicroTask Queue 的回调
│  ┌──────────┴────────────┐
│  │     idle, prepare     │<————— 内部调用（可忽略）
│  └──────────┬────────────┘
|             |<-- 执行所有 Next Tick Queue 以及 MicroTask Queue 的回调
|             |                   ┌───────────────┐
│  ┌──────────┴────────────┐      │   incoming:   │ - (执行几乎所有的回调，除了 close callbacks 以及 timers 调度的                                                    回调和 setImmediate() 调度的回调，在恰当的时机将会阻塞在此阶段)
│  │         poll          │<─────┤  connections, │
│  └──────────┬────────────┘      │   data, etc.  │
│             |                   |               |
|             |                   └───────────────┘
|             |<-- 执行所有 Next Tick Queue 以及 MicroTask Queue 的回调
|  ┌──────────┴────────────┐
│  │        check          │<————— setImmediate() 的回调将会在这个阶段执行
│  └──────────┬────────────┘
|             |<-- 执行所有 Next Tick Queue 以及 MicroTask Queue 的回调
│  ┌──────────┴────────────┐
└──┤    close callbacks    │<————— socket.on('close', ...)
   └───────────────────────┘
```

### setTimeout 与 setImmediate 的顺序

Node 并不能保证 timers 在预设时间到了就会立即执行，因为 Node 对 timers 的过期检查不一定靠谱，它会受机器上其它运行程序影响，或者那个时间点主线程不空闲。比如下面的代码，setTimeout() 和 setImmediate() 都写在 Main 进程中，但它们的执行顺序是不确定的：
