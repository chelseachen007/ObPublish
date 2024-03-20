---
tags:
title: 目前的 json 串
date created: 2023-04-04
date modified: 2023-04-26
---

# 目前的 json 串

## table

```json
{
editable?: boolean | {
form?: object
element?: React.ReactNode | FormType
options?: AppOptionType[] | string
keepEditing?: boolean
forceRender?: boolean
transformDisplay?(value: any): any
},
render: (val)=> React.Node
}

```

## form

```typescript
type Element = FormType | ElementProps | React.ReactNode | ElementFunc;

interface FormItemConfig extends ZFormItemProps {
	element?: Element;

	list?: (
		fields: FormListFieldData[],

		operation: FormListOperation,

		meta: {
			errors: React.ReactNode[];

			warnings: React.ReactNode[];
		}
	) => React.ReactNode;

	chunk?: number | false | Chunk;
	group?: FormItemConfig[] | FormConfig;
}
```

## desc

```ts

{
editable?: boolean | {
form?: object
element?: React.ReactNode | FormType
options?: AppOptionType[] | string
keepEditing?: boolean
forceRender?: boolean
transformDisplay?(value: any): any
},
render: (val)=> React.Node
}
```

## searchBar

```ts
export interface SearchConfig extends SearchItemProps {
	type?: FormType;

	options?: string | DefaultOptionType[] | LoadOptions;

	itemProps?: ZFormItemProps;

	[propName: string]: any;
}

export type SearchItemsType = (SearchConfig | React.ReactNode)[];
```
