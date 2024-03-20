---
tags:
title: JWT
date created: 2023-04-04
date modified: 2023-04-26
---

# JWT

## session

本来 session 是一个抽象概念，开发者为了实现中断和继续等操作，将 user agent 和 server 之间一对一的交互，抽象为“会话”，进而衍生出“会话状态”，也就是 session 的概念。

而 cookie 是一个实际存在的东西，http 协议中定义在 header 中的字段。可以认为是 session 的一种后端无状态实现。

服务端执行 session 机制时候会生成 session 的 id 值，这个 id 值会发送给客户端，客户端每次请求都会把这个 id 值放到 http 请求的头部发送给服务端，而这个 id 值在客户端会保存下来，保存的容器就是 cookie，因此当我们完全禁掉浏览器的 cookie 的时候，服务端的 session 也会不能正常使用。

## Token

- session 要求**服务端存储信息**，并且根据 id 能够检索，而 token 不需要（因为信息就在 token 中，这样实现了服务端无状态化）。在大规模系统中，对每个请求都检索会话信息可能是一个复杂和耗时的过程。但另外一方面服务端要通过 token 来解析用户身份也需要定义好相应的协议（比如 JWT）。
- session 一般通过 cookie 来交互，而 token 方式更加灵活，可以是 cookie，也可以是 header，也可以放在请求的内容中。不使用 cookie 可以带来跨域上的便利性。
- token 的生成方式更加多样化，可以由第三方模块来提供。
- token 若被盗用，服务端无法感知，cookie 信息存储在用户自己电脑中，被盗用风险略小。

### 优点

- 可扩展性好 应用程序分布式部署的情况下，session 需要做多机数据共享，通常可以存在数据库或者 redis 里面。而 jwt 不需要。
- 无状态 jwt 不在服务端存储任何状态。RESTful API 的原则之一是无状态，发出请求时，总会返回带有参数的响应，不会产生附加影响。用户的认证状态引入这种附加影响，这破坏了这一原则。另外 jwt 的载荷中可以存储一些常用信息，用于交换信息，有效地使用 JWT，可以降低服务器查询数据库的次数。

### 缺点

- **安全性**：由于 jwt 的 payload 是使用 base64 编码的，并没有加密，因此 jwt 中不能存储敏感数据。而 session 的信息是存在服务端的，相对来说更安全。
- **jwt 太长**。所有的数据都被放到 JWT 里，如果还要进行一些数据交换，那载荷会更大，http 请求的 Header 可能比 Body 还要大。
- **一次性**。 状态无法修改，想要修改必须签发一个新的 jwt
  - 重新签发后，导致旧的 jwt 仍然能登录，但拿到的信息是过时的，这就**需要服务端进行额外的逻辑**，比如设置黑名单，签发新的后把旧的拉入黑名单
  - 续签。在 redis 中单独为每个 jwt 设置过期时间，每次访问时刷新 jwt 的过期时间。

**可以看出想要破解 jwt 一次性的特性，就需要在服务端存储 jwt 的状态。但是引入 redis 之后，就把无状态的 jwt 硬生生变成了有状态了，违背了 jwt 的初衷。而且这个方案和 session 都差不多了。**

## JWT(JSON WEB TOKEN) 原理解析

1. Bearer Token 包含三个组成部分：令牌头、payload、哈希

```JavaScript
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjoidGVzdCIsImV4cCI6MTU2NzY5NjEzNCwiaWF0Ij
oxNTY3NjkyNTM0fQ.OzDruSCbXFokv1zFpkv22Z_9AJGCHG5fT_WnEaf72EA
```

ey 开头表示 使用 base64 加密，可以反向解密得出临牌头和 payload

第三个 . 是使用 前两个 base64 加密算法加密得出的签名

```JavaScript
verify: key => {
            const ary = token.split('.')
            const hmac = crypto.createHmac('SHA256', key).update(ary[0] + '.' + ary[1]).digest('base64');
            return hmac === ary[2] + '='
}
```
