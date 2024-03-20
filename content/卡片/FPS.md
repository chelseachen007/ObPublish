---
tags:
title: 计算方式
date created: 2023-04-04
date modified: 2023-04-26
---

# 计算方式

```js
let lastTime = performance.now();
let frame = 0;
let lastFameTime = performance.now();
const loop = (time) => {
	const now = performance.now();
	lastFameTime = now;
	frame++;
	if (now > 1000 + lastTime) {
		let fps = Math.round(frame / ((now - lastTime) / 1000));
		frame = 0;
		lastTime = now;
		console.log(fps);
	}
	window.requestAnimationFrame(loop);
};
```
