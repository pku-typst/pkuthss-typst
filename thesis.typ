#import "template.typ": *

#show: doc => conf(
  cauthor: "张三",
  eauthor: "San Zhang",
  blindid: "L2023XXXXX",
  cthesisname: "博士研究生学位论文",
  cheader: "北京大学博士学位论文",
  // 可以用 \n 控制中英文标题在非盲审封面 (blind=false) 中的换行点
  // 在盲审封面 (blind=true) 中，手工插入的 \n 会被忽略，以确保标题连续
  ctitle: "北京大学学位论文模板\npkuthss-typst v0.1.0",
  etitle: "PKU dissertation document template\npkuthss-typst v0.1.0",
  school: "某个学院",
  cfirstmajor: "某个一级学科",
  cmajor: "某个专业",
  emajor: "Some Major",
  direction: "某个研究方向",
  csupervisor: "李四 教授",
  esupervisor: "Prof. Si Li",
  date: (year: 2026, month: 6),
  cabstract: [
    本文档是北京大学学位论文 Typst 模板（pkuthss-typst）的使用说明与示例。该模板基于 Typst 排版系统开发，旨在为北京大学研究生提供一个符合学校论文格式规范的现代化写作工具。

    Typst 是一种新兴的科技文档排版系统，具有语法简洁、编译速度快、实时预览等优点。与传统的 LaTeX 相比，Typst 的学习曲线更加平缓，同时保持了专业排版的高质量输出。本模板充分利用了 Typst 的特性，实现了封面、摘要、目录、正文、参考文献、附录等论文各部分的自动化排版。

    本文档详细介绍了模板的基本功能，包括：标题层级设置、中英文字体配置、图表插入与引用、数学公式编排、代码块展示、参考文献管理等。通过阅读本文档，用户可以快速掌握使用该模板撰写学位论文的方法。
  ],
  ckeywords: ("Typst", "学位论文", "排版模板", "北京大学"),
  eabstract: [
    This document serves as the user guide and demonstration for the Peking University dissertation Typst template (pkuthss-typst). The template is developed based on the Typst typesetting system, aiming to provide graduate students at Peking University with a modern writing tool that complies with the university's thesis formatting requirements.

    Typst is an emerging scientific document typesetting system featuring concise syntax, fast compilation, and real-time preview capabilities. Compared to traditional LaTeX, Typst has a gentler learning curve while maintaining high-quality professional typesetting output. This template fully leverages Typst's features to achieve automated formatting for various thesis components, including the cover page, abstract, table of contents, main body, references, and appendices.

    This document provides a comprehensive introduction to the template's basic functionalities, including heading hierarchy configuration, Chinese and English font settings, figure and table insertion with cross-references, mathematical formula typesetting, code block display, and bibliography management. By reading this document, users can quickly master the methods of using this template to write their dissertations.
  ],
  ekeywords: ("Typst", "Dissertation", "Template", "Peking University"),
  acknowledgements: [感谢 Typst 开发者的辛勤付出。],
  linespacing: 10pt,
  // first-line-indent: 1.77em,
  outlinedepth: 3,
  blind: false,
  listofimage: true,
  listoftable: true,
  listofcode: true,
  alwaysstartodd: true,
  cleandeclaration: true,
  doc,
)

= Typst 的基本功能 <intro>

== 标题

Typst 中的标题使用 `=` 表示，其后跟着标题的内容。`=` 的数量对应于标题的级别。

除了这一简略方式，也可以通过 `heading` 函数自定义标题的更多属性。具体可以参考#link("https://typst.app/docs/reference/meta/heading/", [文档中的有关内容])。

下面是一个示例：

#table(
  columns: (1fr, 1fr),
  [
    #set align(center)
    代码
  ],
  [
    #set align(center)
    渲染结果
  ],

  ```typ
  #heading(level: 2, numbering: none, outlined: false, "二级标题")
  #heading(level: 3, numbering: none, outlined: false, "三级标题")
  #heading(level: 4, numbering: none, outlined: false, "四级标题")
  #heading(level: 5, numbering: none, outlined: false, "五级标题")
  ```,
  [
    #heading(level: 2, numbering: none, outlined: false, "二级标题")
    #heading(level: 3, numbering: none, outlined: false, "三级标题")
    #heading(level: 4, numbering: none, outlined: false, "四级标题")
    #heading(level: 5, numbering: none, outlined: false, "五级标题")
  ],
)\

需要注意的是，这里的样式经过了本模板的一些定制，并非 Typst 的默认样式。

=== 三级标题

==== 四级标题

本模板目录的默认最大深度为 3，即只有前三级标题会出现在目录中。如果需要更深的目录，可以更改 `outlinedepth` 设置。

== 粗体与斜体

与 Markdown 类似，在 Typst 中，使用 `*...*` 表示粗体，使用 `_..._` 表示斜体。下面是一个示例：

#table(
  columns: (1fr, 1fr),
  [
    #set align(center)
    代码
  ],
  [
    #set align(center)
    渲染结果
  ],

  ```typ
  *bold* and _italic_ are very simple.
  ```,
  [
    *bold* and _italic_ are very simple.
  ],
)\

由于绝大部分中文字体只有单一字形，这里遵循 `PKUTHSS` 的惯例，使用#strong[黑体]表示粗体，#emph[楷体]表示斜体。但需要注意的是，由于语法解析的问题， `*...*` 和 `_..._` 的前后可能需要空格分隔，而这有时会导致不必要的空白。 如果不希望出现这一空白，可以直接采用 `#strong` 或 `#emph`。

#table(
  columns: (1fr, 1fr),
  [
    #set align(center)
    代码
  ],
  [
    #set align(center)
    渲染结果
  ],

  ```typ
  对于中文情形，*使用 \* 加粗* 会导致额外的空白，#strong[使用 \#strong 加粗]则不会。
  ```,
  [
    对于中文情形，*使用 \* 加粗* 会导致额外的空白，#strong[使用 \#strong 加粗]则不会。
  ],
)\

== 脚注

从 v0.4 版本开始，Typst 原生支持了脚注功能。本模板中，默认每一章节的脚注编号从 1 开始。

#table(
  columns: (1fr, 1fr),
  [
    #set align(center)
    代码
  ],
  [
    #set align(center)
    渲染结果
  ],

  ```typ
    Typst 支持添加脚注#footnote[这是一个脚注。]。
  ```,
  [
    Typst 支持添加脚注#footnote[这是一个脚注。]。
  ],
)\

== 图片

在 Typst 中插入图片的默认方式是 `image` 函数。如果需要给图片增加标题，或者在文章中引用图片，则需要将其放置在 `figure` 中，就像下面这样：

#table(
  columns: (1fr, 1fr),
  [
    #set align(center)
    代码
  ],
  [
    #set align(center)
    渲染结果
  ],

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
)\

@web 展示了 Typst 网页版的界面。更多有关内容，可以参考 @about。代码中的 `<web>` 是这一图片的标签，可以在文中通过 `@web` 来引用。

== 表格

在 Typst 中，定义表格的默认方式是 `table` 函数。但如果需要给表格增加标题，或者在文章中引用表格，则需要将其放置在 `figure` 中，就像下面这样：

#table(
  columns: (1fr, 1fr),
  [
    #set align(center)
    代码
  ],
  [
    #set align(center)
    渲染结果
  ],

  codeblock(
    ```typ
    #figure(
      table(
        columns: (auto, auto, auto, auto),
        inset: 10pt,
        align: horizon,
          [*姓名*],[*职称*],[*工作单位*],[*职责*],
          [李四],[教授],[北京大学],[主席],
          [王五],[教授],[北京大学],[成员],
          [赵六],[教授],[北京大学],[成员],
          [钱七],[教授],[北京大学],[成员],
          [孙八],[教授],[北京大学],[成员],
      ),
      caption: "答辩委员会名单",
    ) <table>
    ```,
    caption: "默认表格",
  ),
  [
    #figure(
      table(
        columns: (auto, auto, auto, auto),
        inset: 10pt,
        align: horizon,
        [*姓名*], [*职称*], [*工作单位*], [*职责*],
        [李四], [教授], [北京大学], [主席],
        [王五], [教授], [北京大学], [成员],
        [赵六], [教授], [北京大学], [成员],
        [钱七], [教授], [北京大学], [成员],
        [孙八], [教授], [北京大学], [成员],
      ),
      caption: "答辩委员会名单",
    ) <table>
  ],
)

对应的渲染结果如 @table 所示。代码中的 `<table>` 是这一表格的标签，可以在文中通过 `@table` 来引用。

默认的表格不是特别美观，本模板中提供了 `booktab` 函数用于生成三线表， @booktab 是一个示例。代码中的 `<booktab>` 是这一表格的标签，可以在文中通过 `@booktab` 来引用。

#table(
  columns: (1fr, 1fr),
  [
    #set align(center)
    代码
  ],
  [
    #set align(center)
    渲染结果
  ],

  ```typ
  #booktab(
    width: 100%,
    aligns: (left, center, right),
    columns: (1fr, 1fr, 1fr),
    caption: [`booktab` 示例],
    [左对齐], [居中], [右对齐],
    [4], [5], [6],
    [7], [8], [9],
    [10], [], [11],
  ) <booktab>
  ```,
  [
    #booktab(
      width: 100%,
      aligns: (left, center, right),
      columns: (1fr, 1fr, 1fr),
      caption: [`booktab` 示例],
      [左对齐],
      [居中],
      [右对齐],
      [4],
      [5],
      [6],
      [7],
      [8],
      [9],
      [10],
      [],
      [11],
    ) <booktab>
  ],
)

== 公式

@eq 是一个公式。代码中的 `<eq>` 是这一公式的标签，可以在文中通过 `@eq` 来引用。

#table(
  columns: (1fr, 1fr),
  [
    #set align(center)
    代码
  ],
  [
    #set align(center)
    渲染结果
  ],

  ```typ
  $ E = m c^2 $ <eq>
  ```,
  [
    $ E = m c^2 $ <eq>
  ],
)\

@eq2 是一个多行公式。

#table(
  columns: (1fr, 1fr),
  [
    #set align(center)
    代码
  ],
  [
    #set align(center)
    渲染结果
  ],

  ```typ
  $ sum_(k=0)^n k
      &= 1 + ... + n \
      &= (n(n+1)) / 2 $ <eq2>  ```,
  [
    $
      sum_(k=0)^n k & = 1 + ... + n \
                    & = (n(n+1)) / 2
    $ <eq2>
  ],
)\

@eq3 到 @eq6 中给出了更多的示例。

#table(
  columns: (1fr, 1fr),
  [
    #set align(center)
    代码
  ],
  [
    #set align(center)
    渲染结果
  ],

  ```typ
  $ frac(a^2, 2) $ <eq3>
  $ vec(1, 2, delim: "[") $
  $ mat(1, 2; 3, 4) $
  $ lim_x =
      op("lim", limits: #true)_x $ <eq6>
  ```,
  [
    $ frac(a^2, 2) $ <eq3>
    $ vec(1, 2, delim: "[") $
    $ mat(1, 2; 3, 4) $
    $
      lim_x =
      op("lim", limits: #true)_x
    $ <eq6>
  ],
)

== 代码块

像 Markdown 一样，我们可以在文档中插入代码块：

#table(
  columns: (1fr, 1fr),
  [
    #set align(center)
    代码
  ],
  [
    #set align(center)
    渲染结果
  ],

  ````typ
  ```c
  int main() {
    printf("Hello, world!");
    return 0;
  }
  ```
  ````,
  [
    ```c
      int main() {
        printf("Hello, world!");
        return 0;
      }
    ```
  ],
)\

如果想要给代码块加上标题，并在文章中引用代码块，可以使用本模板中定义的 `codeblock` 命令。其中，`caption` 参数用于指定代码块的标题，`outline` 参数用于指定代码块显示时是否使用边框。下面给出的 @code 是一个简单的 Python 程序。其中的 `<code>` 是这一代码块的标签，意味着这一代码块可以在文档中通过 `@code` 来引用。

#table(
  columns: (1fr, 1fr),
  [
    #set align(center)
    代码
  ],
  [
    #set align(center)
    渲染结果
  ],

  ````typ
  #codeblock(
    ```python
    def main():
        print("Hello, world!")
    ```,
    caption: "一个简单的 Python 程序",
    outline: true,
  ) <code>
  ````,
  [
    #codeblock(
      ```python
      def main():
          print("Hello, world!")
      ```,
      caption: "一个简单的 Python 程序",
      outline: true,
    ) <code>
  ],
)\

@codeblock_definition 中给出了本模板中定义的 `codeblock` 命令的实现。

#codeblock(
  ```typ
  #let codeblock(raw, caption: none, outline: false) = {
    figure(
      if outline {
        rect(width: 100%)[
          #set align(left)
          #raw
        ]
      } else {
        set align(left)
        raw
      },
      caption: caption, kind: "code", supplement: ""
    )
  }
  ```,
  caption: [`codeblock` 命令的实现],
) <codeblock_definition>

== 参考文献

Typst 支持 BibLaTeX 格式的 `.bib` 文件，同时也新定义了一种基于 YAML 的文献引用格式。要想在文档中引用参考文献，需要在文档中通过调用 `bibliography` 函数来引用参考文献文件。下面是一个示例：

#pagebreak()

#table(
  columns: (1fr, 1fr),
  [
    #set align(center)
    代码
  ],
  [
    #set align(center)
    渲染结果
  ],

  ```typ
  可以像这样引用参考文献@wang2010guide@kopka2004guide。
  ```,
  [
    可以像这样引用参考文献@wang2010guide@kopka2004guide。
  ],
)

#linebreak()

在论文中的合适位置（一般是论文最后），需要插入如 @bibliography-code 所示的代码块。`bibliography` 函数会在对应位置插入参考文献列表。正文中的参考文献引用将自动链接到列表中的对应条目。#link("https://grs.pku.edu.cn/docs/2024-02/20240229092001843564.doc", "北京大学博士研究生学位论文格式模板(2024)")中明确规定文献索引方式只能选择“顺序编码制”或“著者—出版年制”其中之一。本文档默认采用的 `gb-7714-2015-numeric` 样式对应于“顺序编码制”，如果需要采用“著者—出版年制”，可以将 `style` 参数改为 `gb-7714-2015-author-date`。这里代码中的 `"ref.bib"` 也可以是一个数组，比如 `("ref1.bib", "ref2.bib")`。

#codeblock(caption: "参考文献列表")[
  ```typ
  #bibliography("ref.bib",
    style: "gb-7714-2015-numeric"
  )
  ```
] <bibliography-code>

= 模板使用说明 <notes>

本模板主要参考#link("https://grs.pku.edu.cn/docs/2024-02/20240229092001843564.doc", "北京大学博士研究生学位论文格式模板（2024）")进行开发，尽可能与其保持一致，但受限于 Typst 与 Word 的本质差异，实际使用中仍有可能存在一定差异。 

Word 和 Typst 中计算行距的方式不同。Word 中计算的是相邻两行衬线之间的距离，而 Typst 中计算的是上一行底部和下一行顶部之间的距离。Word 模板中正文行距为 20pt，本模板针对中文和英文部分分别设置了 10.5pt 和 12.5pt 的 `leading`，可以达到近似的效果。理论上来说，可以通过设置 `top-edge` 和 `bottom-edge` 来达到严格对应，但实际上 Word 中的行距还会受到字体本身属性的影响；另一方面，设置这两个参数将影响列表编号和列表内容的视觉对齐，因此这里采取了近似的方法。

Word 模板中默认的首行缩进为 1.77em，本模板中设置为 2em，作者认为这样更加美观。如果要求严格对应，可以在使用模板时通过配置项 `first-line-indent` 设置为 1.77em。

#appendix()

= 关于 Typst <about>

== 在附录中插入图片和公式等

附录中也支持脚注#footnote[这是一个附录中的脚注。]。

附录中也可以插入图片，如 @web1。

#figure(
  image("images/1-writing-app.png", width: 100%),
  caption: "Typst 网页版界面",
) <web1>

附录中也可以插入公式，如 @appendix-eq。

#table(
  columns: (1fr, 1fr),
  [
    #set align(center)
    代码
  ],
  [
    #set align(center)
    渲染结果
  ],

  ```typ
  $ S = pi r^2 $ <appendix-eq>
  $ mat(
    1, 2, ..., 10;
    2, 4, ..., 20;
    3, 6, ..., 30;
    dots.v, dots.v, dots.down, dots.v;
    10, 20, ..., 100
  ) $
  $ cal(A) < bb(B) < frak(C) < mono(D) < sans(E) < serif(F) $
  $ bold(alpha < beta < gamma < delta < epsilon) $
  $ upright(zeta < eta < theta < iota < kappa) $
  $ lambda < mu < nu < xi < omicron $
  $ bold(Sigma < Tau) < italic(Upsilon < Phi) < Chi < Psi < Omega $
  ```,
  [
    $ S = pi r^2 $ <appendix-eq>
    $
      mat(
        1, 2, ..., 10;
        2, 4, ..., 20;
        3, 6, ..., 30;
        dots.v, dots.v, dots.down, dots.v;
        10, 20, ..., 100
      )
    $
    $ cal(A) < bb(B) < frak(C) < mono(D) < sans(E) < serif(F) $
    $ bold(alpha < beta < gamma < delta < epsilon) $
    $ upright(zeta < eta < theta < iota < kappa) $
    $ lambda < mu < nu < xi < omicron $
    $ bold(Sigma < Tau) < italic(Upsilon < Phi) < Chi < Psi < Omega $
  ],
)\

@complex 是一个非常复杂的公式的例子：

#table(
  columns: (1fr, 1fr),
  [
    #set align(center)
    代码
  ],
  [
    #set align(center)
    渲染结果
  ],

  ```typ
  $ vec(overline(underbracket(underline(1 + 2) + overbrace(3 + dots.c + 10, "large numbers"), underbrace(x + norm(y), y^(w^u) - root(t, z)))), dots.v, u)^(frac(x + 3, y - 2)) $ <complex>
  ```,
  [
    $
      vec(overline(underbracket(underline(1 + 2) + overbrace(3 + dots.c + 10, "large numbers"), underbrace(x + norm(y), y^(w^u) - root(t, z)))), dots.v, u)^(frac(x + 3, y - 2))
    $ <complex>
  ],
)\

附录中也可以插入代码块，如 @appendix-code。

#codeblock(
  ```rust
  fn main() {
      println!("Hello, world!");
  }
  ```,
  caption: "一个简单的 Rust 程序",
  outline: true,
) <appendix-code>

= 更新日志 <changelog>

#include "changelog.typ"

#pagebreak()

#bibliography("ref.bib", style: "gb-7714-2015-numeric")

// 著者—出版年制
// #bibliography("ref.bib", style: "gb-7714-2015-author-date")
