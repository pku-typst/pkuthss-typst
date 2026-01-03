#import "template.typ": *

#show: doc => conf(
  cauthor: "张三",
  eauthor: "San Zhang",
  studentid: "23000xxxxx",
  blindid: "L2023XXXXX",
  cthesisname: "博士研究生学位论文",
  cheader: "北京大学博士学位论文",
  // 可以用 \n 控制中英文标题在非盲审封面 (blind=false) 中的换行点
  // 在盲审封面 (blind=true) 中，手工插入的 \n 会被忽略，以确保标题连续
  ctitle: "北京大学学位论文\nTypst 模板使用指南",
  etitle: "User Guide for PKU Dissertation\nTypst Template (pkuthss-typst)",
  school: "信息科学技术学院",
  cfirstmajor: "计算机科学与技术",
  cmajor: "计算机软件与理论",
  emajor: "Computer Software and Theory",
  direction: "程序设计语言与编译技术",
  csupervisor: "李四 教授",
  esupervisor: "Prof. Si Li",
  date: (year: 2026, month: 6),
  degree-type: "academic",
  cabstract: include "doc/cabstract.typ",
  ckeywords: ("Typst", "学位论文", "排版模板", "北京大学", "pkuthss"),
  eabstract: include "doc/eabstract.typ",
  ekeywords: (
    "Typst",
    "Dissertation",
    "Template",
    "Peking University",
    "pkuthss",
  ),
  acknowledgements: include "doc/acknowledgements.typ",
  outlinedepth: 3,
  blind: false,
  listofimage: true,
  listoftable: true,
  listofcode: true,
  alwaysstartodd: false,
  cleandeclaration: true,
  doc,
)

= 快速开始 <quickstart>

== 安装与环境配置

Typst 是一个现代化的排版系统，可以通过以下方式使用：

*在线使用*：访问 #link("https://typst.app")[typst.app]，注册账号后即可在线编辑。在线版本无需安装，支持实时预览和协作编辑。

*本地安装*：
- 从 #link("https://github.com/typst/typst/releases")[GitHub Releases] 下载对应平台的可执行文件
- 使用包管理器安装：`brew install typst`（macOS）或 `cargo install --git https://github.com/typst/typst --locked typst-cli`（通用）

*编辑器支持*：
- VS Code：安装 #link("https://marketplace.visualstudio.com/items?itemName=TinyMist.typst-lsp", "TinyMist") 插件
- Neovim：使用 #link("https://github.com/kaarmu/typst.vim", "typst.vim") 或 #link("https://github.com/chomosuke/typst-preview.nvim", "typst-preview.nvim")
- 其他编辑器：大多数现代编辑器都有社区维护的 Typst 支持

== 获取模板

本模板托管在 GitHub 上，可以通过以下方式获取：

```bash
git clone https://github.com/pku-typst/pkuthss-typst.git
cd pkuthss-typst
```

获取模板后，可以直接编辑 `thesis.typ` 文件开始写作。编译命令为：

```bash
typst compile thesis.typ
```

或使用实时预览模式：

```bash
typst watch thesis.typ
```

== 基本结构

一个使用本模板的论文文件基本结构如下：

#pagebreak()

#codeblock(
  ```typ
  #import "template.typ": *

  #show: doc => conf(
    cauthor: "你的姓名",
    ctitle: "论文标题",
    // ... 其他配置项
    doc,
  )

  = 第一章 绪论

  这里是正文内容...

  = 第二章 相关工作

  这里是第二章内容...

  #appendix()

  = 附录 A 补充材料

  这里是附录内容...

  #bibliography("ref.bib", style: "gb-7714-2015-numeric")
  ```,
  caption: "论文文件基本结构",
)

= 模板配置选项 <config>

本模板提供了丰富的配置选项，可以在 `conf` 函数中进行设置。下面详细介绍各个配置项的含义和用法。

== 作者与论文信息

#booktab(
  width: 100%,
  columns: (auto, auto, 1fr),
  align: (left, left, left),
  caption: "作者与论文信息配置项",
  [*参数名*],
  [*默认值*],
  [*说明*],
  [`cauthor`],
  [`"张三"`],
  [作者中文姓名],
  [`eauthor`],
  [`"San Zhang"`],
  [作者英文姓名],
  [`studentid`],
  [`"23000xxxxx"`],
  [学号（非盲审封面显示）],
  [`blindid`],
  [`"L2023XXXXX"`],
  [盲审编号（盲审封面显示）],
  [`cthesisname`],
  [`"博士研究生学位论文"`],
  [论文类型名称],
  [`cheader`],
  [`"北京大学博士学位论文"`],
  [页眉标题（偶数页显示）],
  [`ctitle`],
  [-],
  [论文中文标题，可用 `\n` 控制换行；盲审模式下 `\n` 会被忽略],
  [`etitle`],
  [-],
  [论文英文标题，可用 `\n` 控制换行；盲审模式下 `\n` 会被忽略],
  [`date`],
  [`(year: 2026, month: 6)`],
  [论文日期，格式为 `(year: 年, month: 月)`],
  [`degree-type`],
  [`"academic"`],
  [学位类型：`"academic"`（学术学位）或 `"professional"`（专业学位）],
) <config-author>

== 院系与专业信息

#booktab(
  width: 100%,
  columns: 3,
  align: left,
  caption: "院系与专业信息配置项",
  [*参数名*],
  [*默认值*],
  [*说明*],
  [`school`],
  [`"某个学院"`],
  [学院名称],
  [`cfirstmajor`],
  [`"某个一级学科"`],
  [一级学科名称],
  [`cmajor`],
  [`"某个专业"`],
  [专业中文名称],
  [`emajor`],
  [`"Some Major"`],
  [专业英文名称],
  [`direction`],
  [`"某个研究方向"`],
  [研究方向],
  [`csupervisor`],
  [`"李四"`],
  [导师中文姓名及职称],
  [`esupervisor`],
  [`"Si Li"`],
  [导师英文姓名],
) <config-school>

== 摘要与致谢

#booktab(
  width: 100%,
  columns: (auto, 1fr),
  align: (left, left),
  caption: "摘要与致谢配置项",
  [*参数名*],
  [*说明*],
  [`cabstract`],
  [中文摘要内容，独立 `content` 参数],
  [`ckeywords`],
  [中文关键词，使用数组格式如 `("关键词1", "关键词2")`],
  [`eabstract`],
  [英文摘要内容，独立 `content` 参数],
  [`ekeywords`],
  [英文关键词，使用数组格式如 `("Keyword1", "Keyword2")`],
  [`acknowledgements`],
  [致谢内容，独立 `content` 参数],
) <config-abstract>

== 排版选项

#booktab(
  width: 100%,
  columns: (auto, auto, 1fr),
  align: (left, left, left),
  caption: "排版选项配置项",
  [*参数名*],
  [*默认值*],
  [*说明*],
  [`first-line-indent`],
  [`2em`],
  [首行缩进，Word 模板为 `1.77em`，本模板默认 `2em`],
  [`outlinedepth`],
  [`3`],
  [目录显示的最大标题层级],
) <config-layout>

== 功能开关

#booktab(
  width: 100%,
  columns: (auto, auto, 1fr),
  align: (left, left, left),
  caption: "功能开关配置项",
  [*参数名*],
  [*默认值*],
  [*说明*],
  [`blind`],
  [`false`],
  [是否为盲审模式，盲审模式隐藏作者、导师等信息],
  [`listofimage`],
  [`true`],
  [是否生成插图列表],
  [`listoftable`],
  [`true`],
  [是否生成表格列表],
  [`listofcode`],
  [`true`],
  [是否生成代码列表],
  [`alwaysstartodd`],
  [`true`],
  [章节是否总是从奇数页开始],
  [`cleandeclaration`],
  [`false`],
  [原创性声明页是否隐藏页眉页脚],
  [`preview`],
  [`true`],
  [预览模式，链接文本显示为蓝色；生成打印版时设为 `false`],
  [`codly-args`],
  [`(:)`],
  [传递给 `codly` 包的额外参数，用于自定义代码块样式。常用选项：\
    `number-format: none` 关闭行号；\
    `display-icon: false` 关闭语言图标；\
    `zebra-fill: none` 关闭交替背景色；\
    `lang-format: none` 关闭语言名称显示],
) <config-switch>

= Typst 基本功能 <typst-basics>

本章介绍 Typst 的基本语法和功能，帮助用户快速上手。

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
    image("images/1-writing-app.png", width: 100%),
    caption: "Typst 网页版界面",
  ) <web>
  ```,
  [
    #figure(
      image("images/1-writing-app.png", width: 100%),
      caption: "Typst 网页版界面",
    ) <web>
  ],
)

@web 展示了 Typst 网页版的界面。代码中的 `<web>` 是图片的标签，可以在文中通过 `@web` 来引用。

== 表格

Typst 中定义表格使用 `table` 函数。如需标题和引用功能，同样需要将其放置在 `figure` 中。

本模板提供了 `booktab` 函数用于生成更美观的三线表。`booktab` 基于原生 `table` 实现，支持大部分 `table` 参数（`stroke` 除外），第一行自动作为表头：

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

Typst 支持 BibLaTeX 格式的 `.bib` 文件。在文档中引用文献使用 `@` 符号：

#code-preview(
  ```typ
  可以像这样引用参考文献@wang2010guide @kopka2004guide。
  ```,
  [可以像这样引用参考文献@wang2010guide @kopka2004guide。],
)

在论文末尾需要插入参考文献列表：

#codeblock(
  ```typ
  #bibliography("ref.bib", style: "gb-7714-2015-numeric")
  ```,
  caption: "插入参考文献列表",
)

根据#link("https://grs.pku.edu.cn/docs/2024-02/20240229092001843564.doc")[北京大学博士研究生学位论文格式模板(2024)]，文献索引方式可选择"顺序编码制"（`gb-7714-2015-numeric`）或"著者—出版年制"（`gb-7714-2015-author-date`）。

模板已预设参考文献的排版样式（五号字、悬挂缩进 1.66 字符、行距 16pt、段前 3pt），以匹配 Word 模板规范。

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

= 常见问题与解决方案 <faq>

== 行距说明

本模板的行距已针对 Word 模板进行了校准。Word 中的"行距"指的是基线到基线的距离，而 Typst 的 `leading` 指的是行与行之间的间距（不含字符高度）。

本模板将正文行距固定为 `10.5pt`（视觉上近似对应 Word 的 20pt 行距）。如需精确匹配特定字体，可以使用 `top-edge` 和 `bottom-edge` 参数。根据 Typst 文档：

$ "基线间距" = "top-edge" - "bottom-edge" + "leading" $

不过，由于 Word 中的实际行距还会受到字体影响，即使使用这样的方式，也难以做到与 Word 的像素级对应。

== 中文粗体显示问题

中文粗体默认用黑体显示。如果需要对黑体再额外加粗，或对宋体、楷体等进行加粗，模板已集成 `cuti` 包的伪粗体功能，会自动处理。

== 字体配置

本模板的字体配置在 `lib/config.typ` 中定义。默认使用以下字体：

- *宋体*：Times New Roman, SimSun, STSong
- *黑体*：Times New Roman, SimHei, STHeiti
- *楷体*：Times New Roman, KaiTi_GB2312, STKaiti
- *仿宋*：Times New Roman, FangSong, STFangsong
- *代码*：New Computer Modern Mono, Times New Roman, SimSun

每种字体配置中，英文优先使用 Times New Roman，中文则按 Windows (SimXxx) → macOS (STXxx) 顺序回退。使用 `--font-path fonts` 参数可加载模板自带的字体文件。

如需修改字体，可以编辑 `lib/config.typ` 中的 `字体` 字典。

== 字体警告

如果编译时出现 `unknown font family` 警告，说明系统未安装对应字体。

*解决方案*：
- 下载对应字体（如思源宋体、思源黑体等），然后
  - 将字体安装到系统中
  - 或在编译时加上 `--font-path` 参数指定字体文件所在目录
- 或修改 `lib/config.typ` 中的字体配置

== 目录深度调整

默认情况下，目录只显示前三级标题。如需显示更多层级：

```typ
conf(
  outlinedepth: 4,  // 显示四级标题
  // ...
)
```

== 版本要求

本模板需要 Typst 0.14.0 或更高版本。建议使用最新稳定版本以获得最佳体验。

查看当前 Typst 版本：

```bash
typst --version
```

= 进阶使用技巧 <advanced>

== 自定义页眉页脚

本模板的页眉页脚通过 `lib/styles.typ` 中的 `make-header` 和 `make-footer` 函数控制。如需自定义，可以修改这些函数。

页眉规则：
- 奇数页显示当前章节标题
- 偶数页显示论文标题（`cheader` 参数）
- 封面区域无页眉

页脚规则：
- 前置部分（摘要、目录等）使用罗马数字
- 正文部分使用阿拉伯数字

== 附录

使用 `#appendix()` 命令开始附录部分。附录中的章节、图表、公式编号会自动切换为字母格式（如 A.1、A.2）：

```typ
#appendix()

= 附录 A 补充材料

这里是附录内容...
```

== 盲审模式

设置 `blind: true` 启用盲审模式：

```typ
conf(
  blind: true,
  // ...
)
```

盲审模式下：
- 封面使用盲审格式，显示盲审编号
- 隐藏作者、导师等个人信息
- 隐藏致谢和原创性声明

也可以通过命令行参数临时切换盲审模式，无需修改源文件：

```bash
# 生成盲审版本
typst compile thesis.typ --input blind=true

# 生成正常版本
typst compile thesis.typ --input blind=false
```

== 预览与打印模式

`preview` 参数控制链接文本的显示方式：
- `preview: true`（默认）：链接显示为蓝色，便于电子版阅读
- `preview: false`：链接显示为正常颜色，适合打印

同样支持命令行切换：

```bash
# 生成打印版（链接不着色）
typst compile thesis.typ --input preview=false
```

== 命令行参数汇总

本模板支持以下命令行参数，通过 `--input key=value` 传递：

#booktab(
  columns: (auto, 1fr),
  align: (left, left),
  caption: "支持的命令行参数",
  [*参数*],
  [*说明*],
  [`blind`],
  [盲审模式：`true` 启用，`false` 禁用],
  [`preview`],
  [预览模式：`true` 链接显示蓝色，`false` 正常颜色],
  [`alwaysstartodd`],
  [章节从奇数页开始：`true` 启用，`false` 禁用],
)

```bash
# 组合多个参数示例
typst compile thesis.typ --input blind=true --input preview=false --input alwaysstartodd=false
```

== 自定义章节样式

如果需要创建不出现在目录中的章节（如致谢），可以使用：

```typ
#heading(numbering: none, outlined: false)[致谢]
```

如果需要章节出现在目录但无编号：

```typ
#heading(numbering: none, outlined: true)[参考文献]
```

== 使用 `include` 拆分文件

对于较长的论文，可以将各部分内容拆分到单独的文件中，使用 `include` 引入：

```typ
// 摘要拆分到单独文件
cabstract: include "doc/cabstract.typ",
eabstract: include "doc/eabstract.typ",
acknowledgements: include "doc/acknowledgements.typ",

// 正文各章也可以拆分
= 第一章 绪论
#include "chapters/01-introduction.typ"

= 第二章 相关工作
#include "chapters/02-related-work.typ"
```

== 模板提供的辅助函数

本模板导出了以下辅助函数供用户使用：

- `#appendix()`：开始附录部分，后续章节编号切换为字母格式
- `#booktab(...)`：生成三线表，支持 `outlined: false` 生成不带编号的表格
- `#codeblock(...)`：生成带标题和编号的代码块
- `#chineseoutline(...)`：生成中文目录
- `#listoffigures(...)`：生成图表列表

#appendix()

= 关于 Typst <about>

Typst 是一个现代化的排版系统，由 Martin Haug 和 Laurenz Mädje 于 2019 年开始开发。它的设计目标是成为 LaTeX 的现代替代品，同时保持简洁易学。

== 主要特点

+ *语法简洁*：Typst 的语法受到 Markdown 的启发，学习曲线平缓
+ *编译速度快*：增量编译技术使得大型文档也能快速预览
+ *实时预览*：官方编辑器支持实时渲染预览
+ *脚本能力*：内置图灵完备的脚本语言，支持复杂的排版逻辑
+ *现代设计*：原生支持 Unicode、OpenType 字体等现代排版技术

== 附录中的图表

附录中也可以插入图片，如 @appendix-fig。

#figure(
  image("images/1-writing-app.png", width: 80%),
  caption: "Typst 网页版界面（附录）",
) <appendix-fig>

附录中也可以插入公式，如 @appendix-eq。

$ nabla times arrow(E) = - (partial arrow(B)) / (partial t) $ <appendix-eq>

附录中也可以插入代码块，如 @appendix-code。

#codeblock(
  ```rust
  fn main() {
      println!("Hello from Rust!");
  }
  ```,
  caption: "Rust Hello World",
) <appendix-code>

= 更新日志 <changelog>

#include "changelog.typ"

#pagebreak()

#bibliography("ref.bib", style: "gb-7714-2015-numeric")

// 如需使用"著者—出版年制"，将上面一行改为：
// #bibliography("ref.bib", style: "gb-7714-2015-author-date")
