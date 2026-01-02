# PKU Thesis 模板内部架构文档

本文档详细描述模板中的状态机、计数器系统及其依赖关系，供后续维护和重构参考。

## 1. 状态机与计数器概览

### 1.1 核心状态机

| 名称              | 类型                      | 定义位置            | 作用                             |
| ----------------- | ------------------------- | ------------------- | -------------------------------- |
| `partcounter`     | `counter("part")`         | `lib/config.typ:37` | 标识文档区域（封面/前置/正文）   |
| `chaptercounter`  | `counter("chapter")`      | `lib/config.typ:38` | 正文章节计数（用于图表公式编号） |
| `appendixcounter` | `counter("appendix")`     | `lib/config.typ:39` | 附录状态标识                     |
| `skippedstate`    | `state("skipped", false)` | `lib/config.typ:47` | 标记被跳过的空白页               |

### 1.2 内容计数器

| 名称              | 类型                                  | 作用                 |
| ----------------- | ------------------------------------- | -------------------- |
| `footnotecounter` | `counter(footnote)`                   | 脚注编号（每章重置） |
| `imagecounter`    | `counter(figure.where(kind: image))`  | 图片编号             |
| `tablecounter`    | `counter(figure.where(kind: table))`  | 表格编号             |
| `rawcounter`      | `counter(figure.where(kind: "code"))` | 代码块编号           |
| `equationcounter` | `counter(math.equation)`              | 公式编号             |

## 2. partcounter 状态流转

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                              partcounter 状态图                              │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   初始值: 0                                                                  │
│      │                                                                      │
│      ▼                                                                      │
│   ┌──────────────────┐                                                      │
│   │  封面区域 (0)     │  封面、版权声明                                       │
│   │  无页眉页脚       │                                                      │
│   └────────┬─────────┘                                                      │
│            │ 触发: heading 元数据 part == 1                                 │
│            │ 动作: partcounter.update(1), counter(page).update(1)          │
│            ▼                                                                │
│   ┌──────────────────┐                                                      │
│   │  前置部分 (1)     │  摘要、Abstract、目录、插图列表、表格列表、代码列表    │
│   │  罗马数字页码     │                                                      │
│   │  有页眉          │                                                      │
│   └────────┬─────────┘                                                      │
│            │ 触发: heading.numbering != none && partcounter < 2            │
│            │ 动作: partcounter.update(2), counter(page).update(1)          │
│            ▼                                                                │
│   ┌──────────────────┐                                                      │
│   │  正文部分 (2)     │  正文章节、附录、致谢、声明                           │
│   │  阿拉伯数字页码   │                                                      │
│   │  页眉由元数据控制 │                                                      │
│   └──────────────────┘                                                      │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 2.1 状态转换触发点

| 转换   | 触发位置            | 触发条件                           | 代码位置                 |
| ------ | ------------------- | ---------------------------------- | ------------------------ |
| 0 → 1  | `heading-show-rule` | `meta.part == 1`（摘要页）         | `lib/styles.typ:192-194` |
| <2 → 2 | `heading-show-rule` | `it.numbering != none && part < 2` | `lib/styles.typ:195-198` |

## 3. Heading 元数据系统

### 3.1 元数据传递机制

使用 `heading` 的 `supplement` 字段传递 `metadata` content：

```typst
heading(
  supplement: [#metadata((
    pagebreak: true,
    part: 1,
    reset-page: true,
    show-header: true,
    header: "摘要",
  ))],
)[标题]
```

**技术细节**：Typst 的 `heading.supplement` 不能直接接受函数类型用于渲染，但可以包含 `metadata` content。在 show rule 中通过 `it.supplement.func() == metadata` 判断并提取 `it.supplement.value`。

### 3.2 元数据字段定义

| 字段          | 类型              | 默认值  | 作用                                |
| ------------- | ----------------- | ------- | ----------------------------------- |
| `pagebreak`   | `bool`            | `true`  | 是否在此 heading 前分页             |
| `part`        | `int \| none`     | `none`  | 状态转换目标 (0/1/2/none)           |
| `reset-page`  | `bool`            | `false` | 是否重置页码为 1                    |
| `show-header` | `bool`            | `true`  | 是否显示页眉                        |
| `header`      | `content \| none` | `none`  | 自定义页眉文本（覆盖 heading.body） |

### 3.3 辅助函数

#### `front-heading(title, pagebreak, enter-front, header)`

创建前置部分的 heading（摘要、目录等）：

- `numbering: none`
- `outlined: false`
- 如果 `enter-front: true`，设置 `part: 1` 和 `reset-page: true`

#### `back-heading(title, pagebreak, show-header)`

创建后置部分的 heading（致谢、声明等）：

- `numbering: none`
- `outlined: true`（出现在目录中）

## 4. 页码系统

### 4.1 页码重置时机

| 时机         | 触发条件                           | 新值 | 代码位置                 |
| ------------ | ---------------------------------- | ---- | ------------------------ |
| 前置部分开始 | `meta.reset-page == true`          | 1    | `lib/styles.typ:201-203` |
| 正文开始     | `it.numbering != none && part < 2` | 1    | `lib/styles.typ:201-203` |

### 4.2 页码格式

| partcounter 值 | 页码格式                 | 判断位置                 |
| -------------- | ------------------------ | ------------------------ |
| 1              | 罗马数字 (I, II, III...) | `lib/styles.typ:140-141` |
| 2              | 阿拉伯数字 (1, 2, 3...)  | `lib/styles.typ:142-143` |

## 5. 页眉系统

### 5.1 页眉渲染流程

```
页眉渲染流程 (make-header):
┌─────────────────────────────────────────────────────────────────┐
│  1. 获取当前 partcounter 值                                      │
│  2. 查找当前物理页面的 heading（处理页眉在 heading 之前渲染）      │
│  3. 检测是否为前置/正文第一页（预判状态转换）                      │
│  4. 确定奇偶性（第一页强制为奇数页）                              │
│  5. 从 heading 元数据获取 show-header 和 header 字段             │
│  6. 根据奇偶性渲染页眉内容                                       │
└─────────────────────────────────────────────────────────────────┘
```

### 5.2 页眉内容规则

| partcounter           | 奇偶性 | 页眉内容                   |
| --------------------- | ------ | -------------------------- |
| 0                     | -      | 无页眉（除非是前置第一页） |
| 1                     | 偶数   | 论文标题 (cheader)         |
| 1                     | 奇数   | 章节标题（或 meta.header） |
| 2                     | 偶数   | 论文标题 (cheader)         |
| 2                     | 奇数   | 章节标题（或 meta.header） |
| 2 + show-header=false | -      | 无页眉                     |

### 5.3 页眉时序问题及解决方案

**问题**：页眉在页面顶部渲染时，该页的 heading 尚未被处理，导致：

1. `partcounter` 还未更新
2. `query(heading.before(here()))` 找不到该页的 heading

**解决方案** (`lib/styles.typ:40-85`):

1. 使用 `query(heading.after(here()))` 查找当前页之后的 heading
2. 检查 heading 的物理页码是否与当前页相同
3. 如果相同，使用该 heading；否则使用 `headings-before.last()`
4. 对于前置第一页，检测 `meta.part == 1` 来预判状态转换

## 6. 分页系统

### 6.1 smartpagebreak 函数

定义于 `template.typ:55-65`，根据 `alwaysstartodd` 参数决定分页行为：

| alwaysstartodd | 行为                                                   |
| -------------- | ------------------------------------------------------ |
| true           | 分页到下一奇数页，中间空白页标记 `skippedstate = true` |
| false          | 普通分页                                               |

### 6.2 分页触发规则

分页由 heading 元数据的 `pagebreak` 字段控制：

| 页面       | pagebreak | 说明             |
| ---------- | --------- | ---------------- |
| 版权声明   | `false`   | 紧跟封面，不分页 |
| 摘要       | `true`    | 分页             |
| ABSTRACT   | `true`    | 分页             |
| 目录/列表  | `true`    | 分页             |
| 正文章节   | `true`    | 默认分页         |
| 致谢       | `true`    | 分页             |
| 原创性声明 | `true`    | 分页             |

## 7. 目录过滤逻辑

定义于 `lib/components.typ:15-17`:

```typst
if partcounter.at(el.location()).first() < 2 and el.numbering == none {
  continue
}
```

**语义**: 前置部分（part < 2）的无编号章节不出现在目录中。

**出现在目录中的章节**:

- 致谢 (part = 2, numbering = none, outlined = true)
- 正文各章 (numbering = chinesenumbering)
- 附录各章 (numbering = chinesenumbering)

**不出现在目录中的章节**:

- 摘要、ABSTRACT、目录、列表 (outlined = false)

## 8. 各页面的元数据配置

| 页面           | 辅助函数        | pagebreak | part      | reset-page   | show-header | header       |
| -------------- | --------------- | --------- | --------- | ------------ | ----------- | ------------ |
| 版权声明       | `front-heading` | `false`   | -         | -            | `true`      | -            |
| 摘要           | `front-heading` | `true`    | `1`       | `true`       | `true`      | `"摘要"`     |
| ABSTRACT       | 直接 `heading`  | `true`    | -         | -            | `true`      | `"ABSTRACT"` |
| 目录           | `front-heading` | `true`    | -         | -            | `true`      | -            |
| 插图/表格/代码 | `front-heading` | `true`    | -         | -            | `true`      | -            |
| 正文章节       | 默认 `heading`  | `true`    | `2`(自动) | `true`(首个) | `true`      | -            |
| 致谢           | `back-heading`  | `true`    | -         | -            | `true`      | -            |
| 原创性声明     | `back-heading`  | `true`    | -         | -            | `false`     | -            |

## 9. 时序图：文档渲染流程

```
时间轴 ──────────────────────────────────────────────────────────────────►

封面页
  │ partcounter = 0
  │ 无页眉页脚
  ▼
版权声明页
  │ front-heading("版权声明", pagebreak: false)
  │ partcounter = 0
  │ 无页眉页脚
  ▼
中文摘要页
  │ front-heading("摘要", enter-front: true, header: "摘要")
  │ partcounter: 0 → 1
  │ counter(page): ? → 1
  │ 页眉: "摘要"（通过预判 is-front-first-page 显示）
  │ 页脚: I
  ▼
英文摘要页
  │ heading(supplement: metadata((header: "ABSTRACT")))[]
  │ partcounter = 1
  │ 页眉: "ABSTRACT"
  │ 页脚: II, III...
  ▼
目录页
  │ front-heading("目录")
  │ partcounter = 1
  │ 页眉: "目录"
  │ 页脚: III, IV...
  ▼
插图/表格/代码列表页（如果启用）
  │ front-heading("插图"/"表格"/"代码")
  │ partcounter = 1
  ▼
正文第一章
  │ heading(numbering: chinesenumbering)[第一章 XXX]
  │ partcounter: 1 → 2（自动，因为 numbering != none && part < 2）
  │ counter(page): ? → 1
  │ chaptercounter: 0 → 1
  │ 页眉: 偶数页=论文标题, 奇数页=章节标题
  │ 页脚: 1, 2, 3...
  ▼
后续章节...
  │ heading[第N章 XXX]
  │ chaptercounter: N-1 → N
  │ 各内容计数器重置
  ▼
附录（如果有）
  │ appendix() 调用:
  │   appendixcounter: 0 → 10
  │   chaptercounter: ? → 0
  │   counter(heading): ? → 0
  │ heading[附录 A] → 编号变为 A.1 格式
  ▼
致谢
  │ back-heading("致谢")
  │ partcounter = 2
  │ 有页眉
  ▼
原创性声明
  │ back-heading("...", pagebreak: true, show-header: false)
  │ partcounter = 2
  │ 无页眉（meta.show-header = false）
```

## 10. 模块依赖关系

```
template.typ (入口)
    │
    ├── lib/config.typ (常量、计数器、状态、辅助函数)
    │       ├── 字号、字体
    │       ├── partcounter, chaptercounter, appendixcounter, ...
    │       ├── skippedstate
    │       ├── appendix()
    │       ├── front-heading()
    │       └── back-heading()
    │
    ├── lib/utils.typ (工具函数)
    │       ├── chinesenumber(), chineseyear()
    │       ├── chinesenumbering()
    │       ├── split-text-by-width()
    │       └── 依赖 config.typ
    │
    ├── lib/components.typ (UI组件)
    │       ├── chineseoutline()
    │       ├── listoffigures()
    │       ├── codeblock(), booktab()
    │       ├── 依赖 config.typ
    │       └── 依赖 utils.typ
    │
    ├── lib/pages.typ (页面生成器)
    │       ├── cover-page-blind(), cover-page-normal()
    │       ├── copyright-page()
    │       ├── abstract-page-zh(), abstract-page-en()
    │       ├── acknowledgements-page(), declaration-page()
    │       ├── 依赖 config.typ (front-heading, back-heading)
    │       └── 依赖 utils.typ
    │
    └── lib/styles.typ (样式规则)
            ├── get-heading-meta()
            ├── make-header(), make-footer()
            ├── heading-show-rule()
            ├── figure-show-rule(), ref-show-rule()
            ├── 依赖 config.typ
            └── 依赖 utils.typ
```

## 11. 设计原则

### 11.1 策略与机制分离

- **策略层**：`front-heading()` 和 `back-heading()` 声明每个章节的行为意图
- **机制层**：`heading-show-rule()` 和 `make-header()` 执行实际操作

### 11.2 零字符串匹配

所有状态转换通过 heading 的 `supplement` 元数据控制，不依赖标题文本匹配。

### 11.3 状态机极简化

只有 3 个状态（0/1/2），状态转换逻辑清晰：

- `part: 1` 显式进入前置部分
- `numbering != none` 自动进入正文部分

### 11.4 可扩展性

添加新功能只需：

1. 在元数据中添加新字段
2. 在 `heading-show-rule` 或 `make-header` 中处理该字段
