---
title: 吴恩达 chatGPT 提示语教程
date created: 2023-05-05
date modified: 2023-06-20
---

## 什么是 LLM

### 基础 LLM

### 指令学习 LLM

## 原则性技巧

### 编写清晰明了的指令

- 清晰不等于简短
- 将文本和prompt 用符号分割开 可以是``` ```
    - 可以是 ` ``` `
    - 也可以是`"""`
    - `---`
    - `<Tag></Tag>`
- 要求结构化输出
- 要求模型检查是否符合要求  
  ![](https://chelsechen-img.oss-cn-hangzhou.aliyuncs.com/20230505203046.png)
- 少样本提示，即在要求模型执行实际任务之前提供成功执行的案例
- ![](https://chelsechen-img.oss-cn-hangzhou.aliyuncs.com/20230505203334.png)

### 给 AI 思考的时间

- 指定完成任务的步骤  
  ![](https://chelsechen-img.oss-cn-hangzhou.aliyuncs.com/20230505203552.png)
- 指导模型自己解决问题，然后比较它的解决方案和学生的解决方案  
  ![](https://chelsechen-img.oss-cn-hangzhou.aliyuncs.com/20230505204017.png)  
 ![](https://chelsechen-img.oss-cn-hangzhou.aliyuncs.com/20230505204107.png)

### 记住模型的限制

- 模型会编造一些很真实的错误
  - 避免方法：让他找到引用文章，再追溯到源文件

```
Reducing hallucinations:
First find relevant information,
then answer the question
based on the relevant information.
```

## 如何迭代你的 prompt

 ![](https://chelsechen-img.oss-cn-hangzhou.aliyuncs.com/20230505204721.png)

- 准备好结构化的 prompt
- 给 AI 足够的思考时间
- 思考为什么没有很好的回答，增加你需要的 prompt
- 如此重复迭代

## 对文本进行总结

![](https://chelsechen-img.oss-cn-hangzhou.aliyuncs.com/20230505210116.png)

1. 要有一个明确的目的

## 可以用来做什么

## 最佳实践是什么
