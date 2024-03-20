---
tags:
title: 使用
date created: 2023-04-04
date modified: 2023-04-26
---

# 使用

```JavaScript
const bufferArrary = [137,80,78,71,13,10,26,10,0,0,0,13,73,72,68,82,0,0,0,1,0,0,0,1,1,3,0,0,0,37,219,86,202,0,0,0,6,80,76,84,69,0,0,255,128,128,128,76,108,191,213,0,0,0,9,112,72,89,115,0,0,14,196,0,0,14,196,1,149,43,14,27,0,0,0,10,73,68,65,84,8,153,99,96,0,0,0,2,0,1,244,113,100,166,0,0,0,0,73,69,78,68,174,66,96,130];
const array = Uint8Array.from(bufferArrary);
const blob = new Blob([array], {type: 'image/png'});
const form = new FormData();
form.append('file', blob, '1.png');
axios.post('http://localhost:7787/files', form)
```
