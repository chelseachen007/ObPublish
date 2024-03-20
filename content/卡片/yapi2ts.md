---
tags:
title: 开始目的
date created: 2023-04-04
date modified: 2023-04-26
---

# 开始目的

一次任务要接几十个接口复制黏贴比较慢

调研使用了 yapi2ts

但是生成的接口文件不太满意，所以只用了自动生成 interface 的功能

然后自己写了一套模板生成的功能

出现了几个问题

1. 自动生成的一些规则不完善，现在是全量覆盖的，如果你手动改了 ，下次生成会覆盖掉文件，导致手动改的失效，可以在 config 里排除掉这个生成的 catid
2. 生成的类型也不满意，准备 yapi2ts 借鉴一下，自己写一套完整的
3. 现在是根据接口最后一个路径判断 import 和 export ，生成 type :' download' 或者 'uoload'
4. 生成的路径 目前的规则是 最后两个路径的驼峰
5. 目前一个是使用的 catid 和 name 查找的。
6. 现在需要先从 yapi 导出 json，复制到文件中读取使用，准备做成 api 请求

# 用到的库学习

[[change-case]]  
[[enquirer]]  
[[ora]]  
[[json-schema-to-typescript]]  
[[commander]]
