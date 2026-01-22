# PKU Thesis 模板内部架构文档

本文档描述模板中的状态机、计数器系统及其依赖关系，供维护和重构参考。

## 1. 核心状态机

| 名称              | 类型                      | 作用                                 |
| ----------------- | ------------------------- | ------------------------------------ |
| `partcounter`     | `counter("part")`         | 标识文档区域（0=封面/1=前置/2=正文） |
| `chaptercounter`  | `counter("chapter")`      | 正文章节计数（用于图表公式编号）     |
| `appendixcounter` | `counter("appendix")`     | 附录状态标识（≥10 表示附录）         |
| `skippedstate`    | `state("skipped", false)` | 标记被跳过的空白页                   |

## 2. partcounter 状态流转

```
初始值: 0
   │
   ▼
┌──────────────────┐
│  封面区域 (0)     │  封面、版权声明
│  无页眉页脚       │
└────────┬─────────┘
         │ 触发: heading 元数据 part == 1
         ▼
┌──────────────────┐
│  前置部分 (1)     │  摘要、Abstract、目录、列表
│  罗马数字页码     │
└────────┬─────────┘
         │ 触发: heading.numbering != none && partcounter < 2
         ▼
┌──────────────────┐
│  正文部分 (2)     │  正文章节、附录、致谢、声明
│  阿拉伯数字页码   │
└──────────────────┘
```

## 3. Heading 元数据系统

使用 `heading.supplement` 传递 `metadata` content：

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

### 元数据字段

| 字段          | 类型              | 默认值  | 作用                    |
| ------------- | ----------------- | ------- | ----------------------- |
| `pagebreak`   | `bool`            | `true`  | 是否在 heading 前分页   |
| `part`        | `int \| none`     | `none`  | 状态转换目标 (1/2/none) |
| `reset-page`  | `bool`            | `false` | 是否重置页码为 1        |
| `show-header` | `bool`            | `true`  | 是否显示页眉            |
| `header`      | `content \| none` | `none`  | 自定义页眉文本          |

### 辅助函数

- `front-heading(title, pagebreak, enter-front, header)` - 前置部分 heading（摘要、目录等）
- `back-heading(title, pagebreak, show-header)` - 后置部分 heading（致谢、声明等）

## 4. 引用记号系统

通过 `conf()` 的 `supplements` 参数自定义图、表、代码、公式等的引用前缀：

```typst
#show: doc => conf(
  supplements: (
    图: "Figure",
    表: "Table",
    代码: "Code",
    公式: "Eq.",
    节: "Section",
  ),
  doc,
)
```

### 默认值（定义在 `lib/config.typ`）

| 字段       | 默认值   | 用途                         |
| ---------- | -------- | ---------------------------- |
| `图`       | `"图"`   | 图片引用和插图列表编号前缀   |
| `表`       | `"表"`   | 表格引用和表格列表编号前缀   |
| `代码`     | `"代码"` | 代码引用和代码列表编号前缀   |
| `公式`     | `"式"`   | 公式引用                     |
| `节`       | `"节"`   | 章节引用（二级及以下）       |
| `图表`     | `"图表"` | 未知 figure kind 的 fallback |
| `插图列表` | `"插图"` | 插图列表页标题               |
| `表格列表` | `"表格"` | 表格列表页标题               |
| `代码列表` | `"代码"` | 代码列表页标题               |

### 传递方式

使用闭包传参，在 `template.typ` 中合并用户配置与默认值后传递给：

- `styles.figure-show-rule(it, supplements: ...)`
- `styles.ref-show-rule(it, supplements: ...)`
- `listoffigures(..., supplements: ...)`

## 5. 参考文献系统

模板集成了 `gb7714-bilingual` 包，提供符合 GB/T 7714 标准的参考文献格式。

### 配置参数

| 参数           | 类型   | 默认值      | 说明                                       |
| -------------- | ------ | ----------- | ------------------------------------------ |
| `bibcontent`   | `str`  | `none`      | 参考文献文件内容（需使用 `read()` 读取）   |
| `bibstyle`     | `str`  | `"numeric"` | 引用风格：`"numeric"` 或 `"author-date"`   |
| `bibversion`   | `str`  | `"2015"`    | GB/T 7714 版本：`"2015"` 或 `"2025"`       |
| `override-bib` | `bool` | `false`     | 是否自定义引用样式（用户自行处理参考文献） |

### override-bib 行为

当 `override-bib: true` 时：

- 用户自行调用 `bibliography()` 选择任意 CSL 样式
- 模板的 `show bibliography` 规则仍会应用默认排版格式
- 用户可添加自己的 `show bibliography` 规则覆盖模板格式

### 内部实现

```typst
// template.typ 中的处理流程
let use-gb7714 = not override-bib and bibcontent != none
if use-gb7714 {
  init-gb7714.with(
    bibcontent,
    style: bibstyle,
    version: bibversion,
  )(doc)
  gb7714-bibliography(
    title: heading(numbering: none)[参考文献],
    full-control: entries => { ... },
  )
}
```

### 关键点

1. **show rule 包装**：`init-gb7714.with(...)` 必须作为 show rule 使用
2. **隐藏 bibliography**：需要一个隐藏的 `bibliography` 调用让 `@key` 语法生效
3. **full-control 模式**：使用 `gb7714-bibliography` 的 `full-control` 参数完全控制渲染样式
4. **语言检测**：gb7714-bilingual 自动检测文献语言，可通过 `.bib` 文件的 `language` 字段覆盖

## 6. 命令行参数

通过 `--input key=value` 传递，覆盖 `conf()` 配置：

| 参数             | 说明                     |
| ---------------- | ------------------------ |
| `blind`          | 盲审模式                 |
| `preview`        | 预览模式（链接显示蓝色） |
| `alwaysstartodd` | 章节是否总是从奇数页开始 |

```bash
typst compile thesis.typ --input blind=true --input preview=false
```

## 7. 模块依赖关系

```
template.typ (入口)
    ├── lib/config.typ (常量、计数器、辅助函数)
    │       ├── 字号、字体、引用记号
    │       ├── partcounter, chaptercounter, appendixcounter
    │       ├── appendix(), front-heading(), back-heading()
    │
    ├── lib/utils.typ (工具函数)
    │       ├── chinesenumber(), chineseyear()
    │       ├── chinesenumbering(), split-text-by-width()
    │
    ├── lib/components.typ (UI组件)
    │       ├── chineseoutline(), listoffigures()
    │       ├── codeblock(), booktab()
    │
    ├── lib/pages.typ (页面生成器)
    │       ├── cover-page-blind(), cover-page-normal()
    │       ├── abstract-page-zh(), abstract-page-en()
    │       ├── acknowledgements-page(), declaration-page()
    │
    └── lib/styles.typ (样式规则)
            ├── get-heading-meta()
            ├── make-header(), make-footer()
            ├── heading-show-rule(), figure-show-rule(), ref-show-rule()
```

## 8. 设计原则

1. **策略与机制分离**：`front-heading()` / `back-heading()` 声明意图，`heading-show-rule()` 执行操作
2. **零字符串匹配**：所有状态转换通过 `supplement` 元数据控制
3. **状态机极简化**：只有 3 个状态（0/1/2），转换逻辑清晰
4. **可扩展性**：添加新功能只需在元数据中添加字段并在 show rule 中处理
