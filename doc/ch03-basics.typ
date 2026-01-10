#import "../template.typ": booktab, codeblock

#let code-preview(code, result) = {
  booktab(
    columns: (1fr, 1fr),
    outlined: false,
    align(center)[*代码*],
    align(center)[*渲染结果*],
    code,
    result,
  )
}

== 内容模式与代码模式

理解 Typst 的两种基本模式是掌握其语法的关键：

*内容模式* `[...]`：用于书写文档内容，类似于 Markdown。在内容模式中，文本会直接渲染，可以使用 `*粗体*`、`_斜体_` 等标记语法。

*代码模式* `{...}`：用于编写逻辑代码，如变量定义、条件判断、循环等。代码模式中的内容不会直接渲染，而是作为程序执行。

两种模式可以相互嵌套：
- 在内容模式中使用 `#` 前缀进入代码模式：`这是文本 #calc.pow(2, 10) 继续文本`
- 在代码模式中使用 `[...]` 进入内容模式：`#let x = [这是内容]`

#code-preview(
  ```typ
  // 内容模式
  这是普通文本，*粗体*，_斜体_。

  // 在内容中嵌入代码
  计算结果：#(1 + 2 + 3)

  // 代码模式定义变量
  #let name = "张三"
  你好，#name！
  ```,
  [
    这是普通文本，*粗体*，_斜体_。

    计算结果：#(1 + 2 + 3)

    #let name = "张三"
    你好，#name！
  ],
)

== 标题与章节

Typst 中的标题使用 `=` 表示，其后跟着标题的内容。`=` 的数量对应于标题的级别。如果需要更加细致的控制标题的样式和行为，可以直接使用 `heading` 函数：

#code-preview(
  ```typ
  == 二级标题
  === 三级标题
  ==== 四级标题

  #heading(level: 2, numbering: none, outlined: false)[无编号二级标题]
  ```,
  [
    == 二级标题
    === 三级标题
    ==== 四级标题
    #heading(level: 2, numbering: none, outlined: false)[无编号二级标题]
  ],
)

#par(first-line-indent: 2em)[
  需要注意的是，本模板对标题样式进行了定制，包括：
]

+ 一级标题使用"第X章"格式编号；
+ 各级标题使用不同字号；
+ 章节前后的间距参照 Word 模板中的设置：
  - 一级标题：17pt 段前间距，16.5pt 段后间距
  - 二级标题：24pt 段前间距，6pt 段后间距
  - 三级标题：12pt 段前间距，6pt 段后间距
  - 更低级标题：6pt 段前间距，6pt 段后间距（Word 模板中本身没有更低级标题）

=== 三级标题示例

==== 四级标题示例

本模板目录的默认最大深度为 3，即只有前三级标题会出现在目录中。如需更深的目录层级，可以通过 `outlinedepth` 配置项调整。

== 文本样式

=== 粗体与斜体

与 Markdown 类似，在 Typst 中使用 `*...*` 表示粗体，使用 `_..._` 表示斜体：

#code-preview(
  ```typ
  *bold* and _italic_ are simple.
  ```,
  [*bold* and _italic_ are simple.],
)

本模板遵循 `PKUTHSS` 的惯例：使用#strong[黑体]表示粗体，#emph[楷体]表示斜体。

需要注意的是，由于语法解析的特性，`*...*` 和 `_..._` 的前后可能需要空格分隔，这有时会导致不必要的空白。如果不希望出现空白，可以使用 `#strong[...]` 或 `#emph[...]`：

#code-preview(
  ```typ
  这是*粗体*文字，有额外空白。
  这是#strong[粗体]文字，无额外空白。
  ```,
  [
    这是 *粗体* 文字，有额外空白。
    这是#strong[粗体]文字，无额外空白。
  ],
)

=== 脚注

Typst 原生支持脚注功能。本模板中，每一章节的脚注编号从 ① 开始重新计数：

#code-preview(
  ```typ
  Typst 支持添加脚注#footnote[这是一个脚注。]。
  ```,
  [Typst 支持添加脚注#footnote[这是一个脚注。]。],
)

=== 列表

Typst 支持无序列表和有序列表：

#code-preview(
  ```typ
  无序列表：
  - 第一项
  - 第二项
    - 嵌套项

  有序列表：
  + 第一步
  + 第二步
  + 第三步
  ```,
  [
    无序列表：
    - 第一项
    - 第二项
      - 嵌套项

    有序列表：
    + 第一步
    + 第二步
    + 第三步
  ],
)

== 图片

在 Typst 中插入图片使用 `image` 函数。如果需要给图片增加标题或在文章中引用，需要将其放置在 `figure` 中：

#code-preview(
  ```typ
  #figure(
    image("../images/1-writing-app.png", width: 100%),
    caption: "Typst 网页版界面",
  ) <web>
  ```,
  [
    #figure(
      image("../images/1-writing-app.png", width: 100%),
      caption: "Typst 网页版界面",
    ) <web>
  ],
)

@web 展示了 Typst 网页版的界面。代码中的 `<web>` 是图片的标签，可以在文中通过 `@web` 来引用。

== 表格

Typst 中定义表格使用 `table` 函数。如需标题和引用功能，同样需要将其放置在 `figure` 中。

本模板提供了 `booktab` 函数用于生成更美观的三线表。`booktab` 基于原生 `table` 实现，支持大部分 `table` 参数（`stroke` 除外），第一行自动作为表头。

*注意*：本模板默认允许表格跨页显示（`show figure: set block(breakable: true)`）。如果不希望某个表格被分割，可以在表格前手动插入 `#pagebreak()` 进行调整。

三线表示例：

#code-preview(
  ```typ
  #booktab(
    columns: (1fr, 1fr, 1fr),
    align: (left, center, right),
    caption: [三线表示例],
    [左对齐], [居中], [右对齐],
    [4], [5], [6],
    [7], [8], [9],
  ) <booktab-example>
  ```,
  [
    #booktab(
      columns: (1fr, 1fr, 1fr),
      align: (left, center, right),
      caption: [三线表示例],
      [左对齐],
      [居中],
      [右对齐],
      [4],
      [5],
      [6],
      [7],
      [8],
      [9],
    ) <booktab-example>
  ],
)

== 公式

Typst 使用 `$...$` 包裹数学公式。行内公式前后需要有空格，行间公式会自动编号：

#code-preview(
  ```typ
  行内公式：$E = m c^2$

  行间公式：
  $ integral_0^infinity e^(-x^2) dif x = sqrt(pi) / 2 $ <integral>
  ```,
  [
    行内公式：$E = m c^2$

    行间公式：
    $ integral_0^infinity e^(-x^2) dif x = sqrt(pi) / 2 $ <integral>
  ],
)

@integral 展示了一个积分公式。更多数学公式语法可以参考 #link("https://typst.app/docs/reference/math/")[Typst 数学公式文档]。

=== 多行公式

多行公式使用 `\` 换行，使用 `&` 对齐：

#code-preview(
  ```typ
  $ sum_(k=0)^n k
      &= 1 + 2 + ... + n \
      &= (n(n+1)) / 2 $ <sum>
  ```,
  [
    $
      sum_(k=0)^n k & = 1 + 2 + ... + n \
                    & = (n(n+1)) / 2
    $ <sum>
  ],
)

=== 常用数学符号

#code-preview(
  ```typ
  $ frac(a^2, 2) $
  $ vec(1, 2, delim: "[") $
  $ mat(1, 2; 3, 4) $
  $ lim_(x -> 0) sin(x) / x = 1 $
  ```,
  [
    $ frac(a^2, 2) $
    $ vec(1, 2, delim: "[") $
    $ mat(1, 2; 3, 4) $
    $ lim_(x -> 0) sin(x) / x = 1 $
  ],
)

== 代码块

像 Markdown 一样，可以使用三个反引号插入代码块：

#code-preview(
  ````typ
  ```python
  def hello():
      print("Hello, world!")
  ```
  ````,
  [
    ```python
    def hello():
        print("Hello, world!")
    ```
  ],
)

本模板使用 #link("https://typst.app/universe/package/codly/")[codly] 包提供代码块的语法高亮和样式增强。默认启用行号、语言图标和交替背景色。可以通过 `codly-args` 配置项自定义样式，例如：

```typ
#show: doc => conf(
  // 关闭行号和语言图标
  codly-args: (number-format: none, display-icon: false),
  doc,
)
```

如果需要给代码块加标题并在文章中引用，可以使用本模板提供的 `codeblock` 命令：

#codeblock(
  ```python
  def fibonacci(n):
      if n <= 1:
          return n
      return fibonacci(n-1) + fibonacci(n-2)
  ```,
  caption: "斐波那契数列递归实现",
) <fib>

@fib 展示了斐波那契数列的递归实现。

== 参考文献

本模板集成了 #link("https://github.com/pku-typst/gb7714-bilingual")[gb7714-bilingual] 包，提供符合 GB/T 7714 标准的参考文献格式。该包会自动根据文献语言切换中英文术语（如英文文献使用 "et al."，中文文献使用 "等"）。

=== 基本用法

Typst 支持 BibLaTeX 格式的 `.bib` 文件。在文档中引用文献使用 `@` 符号：

#code-preview(
  ```typ
  可以像这样引用参考文献@wang2010guide @kopka2004guide。
  ```,
  [可以像这样引用参考文献@wang2010guide @kopka2004guide。],
)

使用本模板时，只需在 `conf` 函数中配置 `bibfiles` 参数即可，无需手动调用 `bibliography` 函数：

#codeblock(
  ```typ
  #show: doc => conf(
    bibfiles: "ref.bib",        // 单个文件
    // bibfiles: ("ref.bib", "extra.bib"),  // 多个文件
    bibstyle: "numeric",        // 顺序编码制（默认）
    // bibstyle: "author-date", // 著者—出版年制
    bibversion: "2015",         // GB/T 7714-2015（默认）
    // bibversion: "2025",      // GB/T 7714-2025（2026年7月1日起实施）
    doc,
  )
  ```,
  caption: "配置参考文献",
)

根据#link("https://grs.pku.edu.cn/docs/2024-02/20240229092001843564.doc")[北京大学博士研究生学位论文格式模板(2024)]，文献索引方式可选择"顺序编码制"（`bibstyle: "numeric"`）或"著者—出版年制"（`bibstyle: "author-date"`）。

=== 语言检测

gb7714-bilingual 会自动检测文献语言。如果自动检测不准确，可以在 `.bib` 文件中显式指定 `language` 字段：

#codeblock(
  ```bib
  @book{kopka2004guide,
    title     = {Guide to LATEX},
    author    = {Kopka, Helmut and Daly, Patrick W},
    year      = {2004},
    publisher = {Addison-Wesley},
    language  = {english}  // 显式指定为英文
  }
  ```,
  caption: "在 .bib 文件中指定语言",
)

=== 高级用法

如果需要使用其他引用样式（如 APA、IEEE 等），可以设置 `override-bib: true`，然后自行调用 `bibliography()` 函数：

#codeblock(
  ```typ
  #show: doc => conf(
    override-bib: true,  // 禁用 gb7714-bilingual
    doc,
  )

  // ... 正文内容 ...

  #bibliography("ref.bib", style: "ieee")
  ```,
  caption: "使用其他引用样式",
)

模板已预设参考文献的排版样式（五号字、悬挂缩进 1.66 字符、行距 16pt、段前 3pt），以匹配 Word 模板规范。设置 `override-bib: true` 时，模板仍会应用这些默认格式。如需进一步自定义排版，可以添加自己的 `show bibliography` 规则来覆盖模板设置。

== 交叉引用

Typst 使用标签 `<label>`（或`label(...)`）和引用 `@label`（或`link(dst, src)`）实现交叉引用。当原始标签引用的对象是章节、图表等时，`@label` 会自动转换为链接文本。对于一般的引用，则需要通过 `link` 函数手动创建链接文本。

#code-preview(
  ```typ
  这是一个本地标签 <local-label>。

  引用这个本地标签：@local-label。

  如 @web 所示...
  根据 @integral...
  详见 @config...
  ```,
  [
    这是一个本地标签 <local-label>。

    引用这个#link(<local-label>)[本地标签]。

    如 @web 所示...
    根据 @integral...
    详见 @config...
  ],
)
