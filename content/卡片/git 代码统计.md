---
tags:
title: git 代码统计
date created: 2023-04-04
date modified: 2023-04-26
---

# git 代码统计

一、git 命令统计

1、统计某人代码提交量

```shell
git log --author="mengfanxiao" --pretty=tformat: --numstat | awk '{ add += $1; subs += $2; loc += $1 - $2 } END { printf "added lines: %s, removed lines: %s, total lines: %s\n", add, subs, loc }' -
```

2、统计所有人代码提交量（指定统计提交文件类型）

```shell
git log --format='%aN' | sort -u | while read name; do echo -en "$name\t"; git log --author="$name" --pretty=tformat: --numstat | grep "\(.html\|.java\|.xml\|.properties\|.css\|.js\|.txt\)$" | awk '{ add += $1; subs += $2; loc += $1 - $2 } END { printf "added lines: %s, removed lines: %s, total lines: %s\n", add, subs, loc }' -; done
```

3、统计某时间范围内的代码提交量

```shell
git log --author=mengfanxiao --since=2019-01-01 --until=2021-02-01 --format='%aN' | sort -u | while read name; do echo -en "$name\t"; git log --author="$name" --pretty=tformat: --numstat | grep "\(.html\|.java\|.xml\|.properties\)$" | awk '{ add += $1; subs += $2; loc += $1 - $2 } END { printf "added lines: %s, removed lines: %s, total lines: %s\n", add, subs, loc }' -; done
```

结果：added lines: 106243, removed lines: 14088, total lines: 92155
