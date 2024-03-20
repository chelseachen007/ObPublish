---
tags:
title: HTTP 发展史
date created: 2023-04-04
date modified: 2023-04-26
---

# HTTP 发展史

HTTP 协议在我们的生活中随处可见，打开手机或者电脑，只要你上网，不论是用 iPhone、Android、 Windows 还是 Mac，不论是用浏览器还是 App，不论是看新闻、短视频还是听音乐、玩游戏，后面总会有 HTTP 在默默为你服务。

<img src="https://i.loli.net/2021/03/02/NOPDwc5gpnGkYqJ.png" alt="HTTP分层">

## 史前时期

2020 世纪 60 年代，美国国防部高等研究计划署（ARPA）建立了 ARPA 网，它有四个分布在各地的节点，被认为 是如今互联网的“始祖”。  
然后在 70 年代，基于对 ARPA 网的实践和思考，研究人员发明出了著名的 TCP/IP 协议。由于具有良好的分层 结构和稳定的性能，TCP/IP 协议迅速战胜其他竞争对手流行起来，并在 80 年代中期进入了 UNIX 系统内核， 促使更多的计算机接入了互联网。

## 创世纪

**蒂姆·伯纳斯-李（Tim Berners-Lee）** 在 1989 年发表了一个论文,确立了三项关键技术。

- URI：即统一资源标识符，作为互联网上资源的唯一身份；
- HTML：即超文本标记语言，描述超文本文档；
- HTTP：即超文本传输协议，用来传输超文本。

基于他们，就可以把 `超文本` 系统完美的运行在互联网上,这个系统被称之为 **“万维网”（World Wide Web）**

## HTTP/0.9

只有 `GET` 请求获取 HTML 文档，并且在响应请求之后立即关闭连接。

HTTP/0.9 虽然很简单，但它作为一个“原型”，充分验证了 Web 服务的可行性，而“简单”也正是它的优点，蕴含了进化和扩展的可能性，因为：  
**“把简单的系统变复杂”，要比“把复杂的系统变简单”容易得多。**

## HTTP/1.0

因为多媒体技术( `JPEG`、 `MP3` 等相继发明)的发展,网名推动 HTTP 快速发展，并在 1996 年正式发布了 `HTTP/1.0` 。

- 增加了 HEAD、POST 等新方法；
- 增加了响应状态码，标记可能的错误原因；
- 引入了协议版本号概念；
- 引入了 HTTP Header（头部）的概念，让 HTTP 处理请求和响应更加灵活；
- 传输的数据不再仅限于文本。

但 **HTTP/1.0 并不是一个“标准”**，只是记录已有实践和模式的一份参考文档，不具有实际的约束力，相当于 一个“备忘录”。

## HTTP/1.1

浏览器大战之后，HTTP 协议成为一个“正式的标准”，而不是一份可有可无的“参考文档”,少了很多学术气息，更加接地气了。

HTTP/1.1 主要的变更点有：

- 增加了 `PUT`、 `DELETE` 等方法
- 允许数据分块（chunked）,支持大文件的上传
- 强制要求 HOST 头，让互联网主机托管成为了可能
- 增加了缓存管理
- 明确了连接管理，支持长连接(connection:keep-alive)
- 引入了客户端 Cookie、安全机制

这次标准的确定，成为了我们日常使用的 HTTP。

### 主要问题

HTTP/1.1**对带宽的利用率却并不理想**

#### TCP 的慢启动

一旦一个 TCP 连接建立之后，就进入了发送数据状态，刚开始 TCP 协议会采用一个非常慢的速度去发送数据，然后慢慢加快发送数据的速度，直到发送数据的速度达到一个理想状态，我们把这个过程称为慢启动。

#### **同时开启了多条 TCP 连接，那么这些连接会竞争固定的带宽。**

在下载过程中，当发现带宽不足的时候，各个 TCP 连接就需要动态减慢接收数据的速度。这样就会阻塞关键资源的下载

#### **队头阻塞的问题。**

HTTP/1.1 中使用持久连接时，虽然能**公用一个 TCP 管道**，但是在一个管道中同一时刻只能处理一个请求，在当前的请求没有结束之前，其他的请求只能处于阻塞状态。这意味着我们不能随意在一个管道中发送请求和接收内容。

## [[HTTPS]]

HTTPS 是为了解决 HTTP 安全问题的一个新协议，由“**HTTP over HTTP** ”变成了“ **HTTP over SSL/TLS**”，让 HTTP 运行在了安全的 SSL/TLS 协议上， 收发报文不再使用 Socket API，而是调用专门的安全接口。

## [[HTTP 2]]

## [[HTTP 3]]

---

参考资料

[《透视 HTTP 协议》](https://time.geekbang.org/column/intro/100029001)

[《HTTP 世界观》](https://mp.weixin.qq.com/s?__biz=MzAxOTAzNjUwMg==&mid=2448541703&idx=1&sn=164f1fb3e503f2e50ca6f5a97a7f119c&chksm=8fc8483eb8bfc1288b14aed0739425c2b31ce8e679a81ab0ffd8f1690c35c3032e0ecea73ab6&scene=126&sessionid=1589430279&key=ad1327b1c72241bf0ec91b57b52b52d6ead79c4dec3bb5ea1b9cf66dca50c9c27f5ddbfa2322fa04e2d68709954e2bb3e18c1af617ff2ac527a5ef9ebd9cac0d5ef977ef159d3959fa5954a561640d1c&ascene=1&uin=MTIwOTc2NTAyMQ%3D%3D&devicetype=Windows+10+x64&version=62090070&lang=zh_CN&exportkey=ATCMwpFbvaf56KD%2BcqI7xHA%3D&pass_ticket=DXKQiIl5eK%2BQt%2FmJHshlzwb8%2FTplkfJw6KRjxgfWB401dxQScVrscRWHXWr5DgV2)
