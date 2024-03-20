---
tags:
title: Promise
date created: 2023-04-04
date modified: 2023-04-26
---

# Promise

#### 为什么会有 promise

首先让我们来了解下,回调函数有什么缺点:

1. 多重嵌套,导致**回调地狱**
2. **代码跳跃,并非人类习惯的思维模式 ，代码逻辑不连续**
3. 信任问题,你不能把你的回调完全寄托与第三方库,因为你不知道第三方库到底会怎么执行回调（多次执行）
4. 第三方库可能没有提供错误处理
5. 不清楚回调是否都是异步调用的（可以同步调用 ajax,在收到响应前会阻塞整个线程,会陷入假死状态,非常不推荐）

为了兼容一些 promise 库,Promise 采用了一种鸭子模型（**如果它看起来像只鸭子,叫起来 像只鸭子,那它一定就是只鸭子**）来判断这个函数是不是一个 promise 函数,也就是判断.then()方法是否注册了 "`fullfillment`" 和 / 或 "`rejection`" 事件.

代码跳跃则是通过事件穿透解决的，**但是也没有那么黑魔法，只不过是 then 默认参数就是把值往后传或者抛**

```JavaScript
onResolved = typeof onResolved === 'function' ? onResolved : function(value) {return value}
onRejected = typeof onRejected === 'function' ? onRejected : function(reason) {throw reason}
```

#### promise 方法

##### 1.Promise.prototype.finally()

finally 方法用于指定不管 Promise 对象最后状态如何,都会执行的操作。该方法是 ES2018 引入标准的。

相当于

```JavaScript
Promise.prototype.finally = function (callback) {
  let P = this.constructor;
  return this.then(
    (value) => P.resolve(callback()).then(() => value),
    (reason) =>
      P.resolve(callback()).then(() => {
        throw reason;
      })
  );
};
```

##### 2.Promise.all()

Promise.all()方法用于将多个 Promise 实例,包装成一个新的 Promise 实例。

另外,Promise.all()方法的参数可以不是数组,但**必须具有 Iterator 接口,且返回的每个成员都是 Promise 实例。**

1. 只有 p1、p2、p3 的状态**都变成 fulfilled**,p 的状态才会变成 fulfilled, 此时 p1、p2、p3 的返回值组成一个数组, 传递给 p 的回调函数。
2. 只要 p1、p2、p3 之中**有一个被 rejected**,p 的状态就变成 rejected, 此时第一个被 reject 的实例的返回值, 会传递给 p 的回调函数。

##### 3.Promise.race()

```JavaScript
const p = Promise.race([p1, p2, p3]);
```

上面代码中,只要 p1、p2、p3 之中有一个实例率先改变状态,p 的状态就跟着改变。那个率先改变的 Promise 实例的返回值,就传递给 p 的回调函数。

下面是一个例子,如果指定时间内没有获得结果,就将 Promise 的状态变为 reject,否则变为 resolve。

```JavaScript
const p = Promise.race([
  fetch("/resource-that-may-take-a-while"),
  new Promise(function (resolve, reject) {
    setTimeout(() => reject(new Error("request timeout")), 5000);
  }),
]);

p.then(console.log).catch(console.error);
```

上面代码中,如果 5 秒之内 `fetch` 方法无法返回结果,变量 p 的状态就会变为 `rejected`,从而触发 `catch` 方法指定的回调函数。

这种可以使用 `axios` 的超时拦截,别的什么作用还没想到

##### 4.Promise.allSettled()

`Promise.allSettled()` 方法接受一组 `Promise` 实例作为参数,包装成一个新的 `Promise` 实例。只有等到所有这些参数实例都返回结果,不管是 `fulfilled` 还是 `rejected`,包装实例才会结束。该方法由 **ES2020** 引入。

有时候,我们**不关心异步操作的结果,只关心这些操作有没有结束**。这时,`Promise.allSettled()`方法就很有用。如果没有这个方法,想要确保所有操作都结束,就很麻烦。Promise.all()方法无法做到这一点。

##### 5.Promise.any()

与 promise.all()相反

**Promise.any()** 方法接受一组 `Promise` 实例作为参数,包装成一个新的 `Promise` 实例。只要参数实例有一个变成 `fulfilled` 状态,包装实例就会变成 fulfilled 状态；如果所有参数实例都变成 `rejected` 状态,包装实例就会变成 `rejected` 状态。该方法目前是一个第三阶段的提案 。

##### 6.Promise.resolve()

有时需要将现有对象转为 `Promise` 对象,**Promise.resolve()** 方法就起到这个作用。

```JavaScript
Promise.resolve()等价于下面的写法
Promise.resolve('foo') // 等价于 new Promise(resolve => resolve('foo'))
```

Promise.resolve 方法的参数分成四种情况:  
（1）参数是一个 Promise 实例  
如果参数是 Promise 实例,那么 Promise.resolve 将不做任何修改、原封不动地返回这个实例。  
（2）参数是一个 thenable 对象  
thenable 对象指的是具有 then 方法的对象,比如下面这个对象。

```JavaScript
let thenable = {
  then: function (resolve, reject) {
    resolve(42);
  },
};
```

（3）参数不是具有 then 方法的对象,或根本就不是对象  
（4）不带有任何参数  
相当于 new Promise()  
需要注意的是,立即 resolve()的 `Promise` 对象,是在本轮“事件循环”（event loop）的结束时执行,而不是在下一轮“事件循环”的开始时。

##### 7.Promise.reject()

##### 8Promise.try()

由于 Promise.try 为所有操作提供了统一的处理机制,所以如果想用 then 方法管理流程,最好都用 Promise.try 包装一下。这样有许多好处,其中一点就是可以更好地管理异常。

解决了 **try{}catch{}** 无法处理异步错误的问题

### 手写 promise

#### 简易实现

```JavaScript
function Promise(excutro) {
  let self = this;
  self.onResolved = [];
  self.onReject = [];
  self.stauts = "pedding";

  function resolve(value) {
    if (self.stauts === "pedding") {
      self.stauts = "resolved";
      self.value = value;
      self.onResolved.forEach((fn) => fn(value));
    }
  }

  function reject(reson) {
    if (self.stauts === "pedding") {
      self.stauts = "reject";
      self.reson = reson;
      self.onResolved.forEach((fn) => fn(value));
    }
  }
  excutro(resolve, reject);
}
```

#### then

```JavaScript
Promise.prototype.then = function (resolved, rejected) {
  let self = this;
  let promise2;
  resolved = typeof resolved === "function" ? resolved : (val) => val;
  if (self.stauts === "resolved") {
    return (promise2 = new Promise((resolve, reject) => {
      try {
        x = resolved(self.value);
        if (x instanceof Promise) {
          x = x.then;
        }
        resolve(x);
      } catch (e) {
        reject(e);
      }
    }));
  }
  if (self.stauts === "pedding") {
    return (promise2 = new Promise((resolve, reject) => {
      try {
        self.onResolved.push(function () {
          try {
            x = resolved(self.value);
            if (x instanceof Promise) x = x.then(resolve, reject);
          } catch (e) {
            reject(e);
          }
        });
      } catch (e) {
        reject(e);
      }
    }));
  }
};
```

#### all

```JavaScript
Promise.prototype.all = function (promiseArr) {
  let index = 0;
  let result = [];
  return new MyPromise((resolve, reject) => {
    promiseArr.forEach((p, i) => {
      //Promise.resolve(p)用于处理传入值不为Promise的情况
      MyPromise.resolve(p).then(
        (val) => {
          index++;
          result[i] = val; //所有then执行后, resolve结果
          if (index === promiseArr.length) {
            resolve(result);
          }
        },
        (err) => {
          reject(err);
        } //有一个Promise被reject时,MyPromise的状态变为reject
      );
    });
  });
};
```

#### race

```JavaScript
Promise.prototype.race = function (promiseArr) {
  return new MyPromise((resolve, reject) => {
    //同时执行Promise,如果有一个Promise的状态发生改变,就变更新MyPromise的状态
    for (let p of promiseArr) {
      MyPromise.resolve(p).then(
        //Promise.resolve(p)用于处理传入值不为Promise的情况
        (value) => {
          resolve(value);
        }, //注意这个resolve是上边new MyPromise的
        (err) => {
          reject(err);
        }
      );
    }
  });
};
```

#### stop

```JavaScript
Promise.cancel = Promise.stop = function () {
  return new Promise(function () {});
};
```

#### done

```JavaScript
Promise.prototype.done = function () {
  return this.catch(function (e) {
    // 此处一定要确保这个函数不能再出错
    console.error(e);
  });
};
```

#### 出错时

出错时,是用 throw new Error()还是用 return Promise.reject(new Error())呢？

性能方面,throw new Error()会使代码进入 catch 块里的逻辑

而使用 Promise.reject(new Error()),则需要构造一个新的 Promise 对象（里面包含 2 个数组,4 个函数：resolve/reject,onResolved/onRejected）,也会花费一定的时间和内存

综上,我觉得在 Promise 里发现显式的错误后,用 throw 抛出错误会比较好,而不是显式的构造一个被 reject 的 Promise 对象。
