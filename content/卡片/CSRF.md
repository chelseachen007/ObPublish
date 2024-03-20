---
tags:
title: CSRF
date created: 2023-04-04
date modified: 2023-04-26
---

# CSRF

CSRF 攻击：陌生链接不要随便点

CSRF 英文全称是**Cross-site request forgery**,所以又称为“ **跨站请求伪造** ”，是指黑客引  
诱用户打开黑客的网站，在黑客的网站中，利用用户的登录状态发起的跨站请求。简单来讲，  
**CSRF 攻击就是黑客利用了用户的登录状态，并通过第三方的站点来做一些坏事。**

### 自动发起 GET 请求

当页面被加载时，浏览器会自动发起资源请求

```html
<img src="https://xxxx.com/session?user=xxx&psw=xxx" />
```

### 自动发起 POST 请求

```html
<form id="hacker-form"></form>
<script>
	document.getElementById("hacker-form").submit();
</script>
```

通过表单自动提交 POST 请求

### 引诱客户点击链接

### 如何防止 CSRF 攻击

发起 `CSRF` 攻击的三个必要条件：

- 第一个，目标站点一定要有 `CSRF` 漏洞；
- 第二个，用户要登录过目标站点，并且在浏览器上保持有该站点的登录状态；
- 第三个，需要用户打开一个第三方站点，可以是黑客的站点，也可以是一些论坛。

要避免发生 `CSRF 攻击`，通常有以下几种途径：

1. **充分利用好 `Cookie` 的 `SameSite` 属性**

- **Strict** 最为严格。如果 SameSite 的值是 Strict, 那么浏览器会完全禁止第三方 Cookie。
- **Lax** 相对宽松一点。在跨站点的情况下，从第三方站点的链接打开和从第三方站点提交 Get  
  方式的表单这两种方式都会携带 Cookie。但如果在第三方站点中使用 Post 方法，或者通  
  过 img、iframe 等标签加载的 URL,这些场景都不会携带 Cookie。
- 而如果使用 **None** 的话，在任何情况下都会发送 Cookie 数据。

2. **验证请求的来源站点**

服务器的策略是优先判断 **Origin**,如果请求头中没有包含 `Origin` 属性，再根据实际情况判断是否使用 **Referer** 值。  
Origin 属性只包含了域名信息，并没有包含具体的 URL 路径，这是 Origin 和 Referer 的一个主要区别。  
在这里需要补充一点，Origin 的值之所以不包含详细路径信息，是有些站点因为安全考虑，不想把源站点的详细路径暴露给服务器。

3. **CSRF Toekn**  
   服务器生成一个随机字符串，在之后的请求都携带上
