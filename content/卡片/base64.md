---
tags:
title: 加密
date created: 2023-04-04
date modified: 2023-04-26
---

# 加密

```JavaScript
function base64Encrypt(value) {
    return new Buffer(value).toString("base64");
}
```

# 解密

```JavaScript
function base64Decryption(value) {
    return new Buffer(value, "base64").toString();
}
```

# 文件

```JavaScript
const base64 = 'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABAQMAAAAl21bKAAAABlBMVEUAAP+AgIBMbL/VAAAACXBIWXMAAA7EAAAOxAGVKw4bAAAACklEQVQImWNgAAAAAgAB9HFkpgAAAABJRU5ErkJggg==';
const byteCharacters = atob(base64);
const byteNumbers = new Array(byteCharacters.length);
for (let i = 0; i < byteCharacters.length; i++) {
	byteNumbers[i] = byteCharacters.charCodeAt(i);
}
const array = Uint8Array.from(byteNumbers);
const blob = new Blob([array], {type: 'image/png'});
const form = new FormData();
form.append('file', blob, '1.png');
axios.post('http://localhost:7787/files', form);
```

base64 编解码

```JavaScript
//解码
var decodedData = window.atob(encodedData);
//编码
var encodedData = window.btoa(stringToEncode);
```
