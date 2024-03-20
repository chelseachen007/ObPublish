---
tags:
title: React 18
date created: 2023-04-04
date modified: 2023-04-26
---

# React 18

## Suspense

可以“等待”目标 UI 加载，并且可以直接指定一个加载的界面（像是个 spinner），让它在用户等待的时候显示。

```js
<Suspense fallback={<Spinner />}>
	<Comments />
</Suspense>
```
