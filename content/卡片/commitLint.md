---
tags:
title: commitLint
date created: 2023-04-04
date modified: 2023-04-26
---

# commitLint

```JavaScript
npm install -g commitizen
```

### cz-conventional-changelog

```JavaScript
commitizen init cz-conventional-changelog --save --save-exact

"devDependencies": {
 "cz-conventional-changelog": "^2.1.0"
},
"config": {
  "commitizen": {
    "path": "./node_modules/cz-conventional-changelog"
  }
}
```

### cz-customizable

```JavaScript
npm install cz-customizable --save-dev
"devDependencies": {
  "cz-customizable": "^5.3.0"
},
"config": {
  "commitizen": {
    "path": "node_modules/cz-customizable"
  }
}

```

### .cz-config.js

```JavaScript

'use strict';

module.exports = {

  types: [
    { value: 'feat', name: '特性:    一个新的特性' },
    { value: 'fix', name: '修复:    修复一个Bug' },
    { value: 'docs', name: '文档:    变更的只有文档' },
    { value: 'style', name: '格式:    空格, 分号等格式修复' },
    { value: 'refactor', name: '重构:    代码重构，注意和特性、修复区分开' },
    { value: 'perf', name: '性能:    提升性能' },
    { value: 'test', name: '测试:    添加一个测试' },
    { value: 'chore', name: '工具:    开发工具变动(构建、脚手架工具等)' },
    { value: 'revert', name: '回滚:    代码回退' },
    { value: 'WIP', name: 'WIP:     正在进行工作' }
  ],

  // scopes: [
  //   { name: 'accounts' },
  //   { name: 'admin' },
  //   { name: 'exampleScope' },
  //   { name: 'changeMe' }
  // ],

  // it needs to match the value for field type. Eg.: 'fix'
  /*
  scopeOverrides: {
    fix: [
      {name: 'merge'},
      {name: 'style'},
      {name: 'e2eTest'},
      {name: 'unitTest'}
    ]
  },
  */
  // override the messages, defaults are as follows
  messages: {
    type: 'Select the type of change that you\'re committing:',
    scope: '\nDenote the SCOPE of this change (optional):',
    // used if allowCustomScopes is true
    customScope: 'Denote the SCOPE of this change:',
    subject: 'Write a SHORT, IMPERATIVE tense description of the change:\n',
    body: 'Provide a LONGER description of the change (optional). Use "|" to break new line:\n',
    breaking: 'List any BREAKING CHANGES (optional):\n',
    footer: 'List any ISSUES CLOSED by this change (optional). E.g.: #31, #34:\n',
    confirmCommit: 'Are you sure you want to proceed with the commit above?'
  },

  allowCustomScopes: true,
  allowBreakingChanges: ['feat', 'fix'],

  // limit subject length
  subjectLimit: 100

};

```

### Commitizen 校验

```JavaScript
npm install --save-dev @commitlint/cli
npm install --save-dev @commitlint/config-conventional

// commitlint.config.js
module.exports = {
  extends: ['@commitlint/config-conventional']
};


npm install husky --save-dev


//package.json
"husky": {
  "hooks": {
    "commit-msg": "commitlint -E HUSKY_GIT_PARAMS"
  }
}
```
