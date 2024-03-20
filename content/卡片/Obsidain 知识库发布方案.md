---
tags: 
修改时间: 2023-04-04 20:34:15
创建时间: 2023-04-04 17:33:50
title: Obsidain 知识库发布方案
date created: 2023-04-04
date modified: 2023-06-19
---

# Obsidain 知识库发布方案

不详细的写了，详细参考这位网友： [001_部署Obsidian静态知识库网站](https://ob.tianzhongs.ml/001_%e9%83%a8%e7%bd%b2Obsidian%e9%9d%99%e6%80%81%e7%9f%a5%e8%af%86%e5%ba%93%e7%bd%91%e7%ab%99)

# 记录一下重要的信息

## 父仓库 workflow

```yaml
name: Deploy to GitHub Pages

on:
  push:
    branches:
      - hugo

  workflow_dispatch:

jobs:
  deploy:
    runs-on: ubuntu-22.04
    steps:
      - uses: actions/checkout@v2
        with: 
          token: ${{ secrets.TOKEN }}  #这里是添加的token，不用设置，需要在仓库中添加TOKEN，$代表的是调用刚才添加的环境变量，所以不需要设置
          submodules: 'true'
      - name: Checkout submodules
        run: git submodule update --init --recursive

      - name: config1 
        run: rm -rf content/.obsidian content/cedict_ts.u8 content/Extras/Templates  && mv content/*.md content/Atlas && find content/ -name "*.md" | xargs -I file  mv -f file content &&  mv content/AboutTheGarden.md content/_index.md 

      - name: config2
        run: "ls content/ && grep -lr --null 'title' content/* | xargs -0 sed -i -E -r 's/title: "(.*)/title: \"\\1\"/g'""

      - name: config3 
        run: rm -rf content/*.md-E


      - name: Build Link Index
        uses: jackyzha0/hugo-obsidian@v2.18
        with:
          index: true
          input: content
          output: assets/indices
          root: .


      - name: Setup Hugo
        uses: peaceiris/actions-hugo@v2
        with:
          hugo-version: '0.96.0'
          extended: true

      - name: Build
        run: hugo --minify --debug

      - name: Deploy
        uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./public
          publish_branch: master  # deploying branch
          cname: www.baidu.com   #修改成你的域名

```

## 子仓库提交更新父仓库

```yaml
name: Send submodule updates to parent repo

on:
  push:
    branches:
      - main

jobs:
  update:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v2
        with:
          repository: zhangsan/dg3 # 设置你用户名/发布仓库的仓库名,作用是将子模块更新到父仓库dg3
          token: ${{ secrets.TOKEN }}
          # 把子模块打开
          submodules: 'true'

      - name: Pull & update submodules recursively
        run: |
          git submodule update --init --recursive
          git submodule update --recursive --remote          
      - name: Commit
        run: |
          git config user.email "提交的邮箱，一般是你github的邮箱" #修改
          git config user.name "你的名称" #修改
          git add --all
          git commit -m "Update submodules" || echo "No changes to commit"
          git push          

```

[[ 本库自动同步到 github]]

# 踩的一些坑

- 第一行如果是 `-` 会导致构建失败
- 目前不支持 iframe
- [gittalk的坑](https://blog.misec.top/archives/2018810gitalk-error#:~:text=Error%3A-Validation-Failed-%E8%BF%99%E4%B8%AA%E9%97%AE%E9%A2%98%E5%B0%B1%E6%AF%94%E8%BE%83%E5%A4%8D%E6%9D%82%E4%BA%86%EF%BC%8C%E9%83%A8%E5%88%86%E6%96%87%E7%AB%A0%E7%9A%84%E8%AF%84%E8%AE%BA%E5%8C%BA%E4%BC%9A%E6%8A%A5Error%3A-Validation-Failed%2C%E5%85%B7%E4%BD%93%E5%8E%9F%E5%9B%A0%E6%98%AF%E7%94%B1%E4%BA%8E,Github-%E9%99%90%E5%88%B6-labal-%E9%95%BF%E5%BA%A6%E4%B8%8D%E8%83%BD%E8%B6%85%E8%BF%87-50%E5%BC%95%E8%B5%B7%E7%9A%84%EF%BC%8C%E8%AF%A5%E9%97%AE%E9%A2%98%E8%A7%A3%E5%86%B3%E6%96%B9%E6%A1%88%E6%9D%A5%E8%87%AAGitalk%E9%A1%B9%E7%9B%AE%E4%BB%93-Issues115%EF%BC%8C%E9%80%9A%E8%BF%87MD5%E5%8A%A0%E5%AF%86ID%E6%9D%A5%E7%BC%A9%E7%9F%ADlabal%E9%95%BF%E5%BA%A6%E3%80%82)
