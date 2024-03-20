---
tags:
title: 使用
date created: 2023-04-04
date modified: 2023-04-26
---

`Blob 对象` 是一个前端的一个专门用于支持 `文件操作` 的 `二进制对象`，表示一个 `二进制文件` 的 `数据内容`，表示一个 `不可变`、`原始数据` 的类文件对象。通常用来读写文件，比如一个图片文件的内容就可以通过 Blob 对象读写。Blob 对象。Blob 表示的不一定是 JavaScript 原生格式的数据。

# 使用

```JavaScript
const json = { hello: "world" };
const blob = new Blob([JSON.stringify(json, null, 2)], { type: 'application/json' });

const form = new FormData();
form.append('file', blob, '1.json');
axios.post('http://localhost:7787/files', form);
```
