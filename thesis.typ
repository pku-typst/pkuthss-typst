#import "template.typ": *

#show: doc => conf(
  cauthor: "张三",
  eauthor: "San Zhang",
  studentid: "23000xxxxx",
  cthesisname: "博士研究生学位论文",
  cheader: "北京大学博士学位论文",
  ctitle: "北京大学学位论文 Typst 模板",
  etitle: "Typst Template for Peking University Dissertations",
  school: "某个学院",
  cmajor: "某个专业",
  emajor: "Some Major",
  direction: "某个研究方向",
  csupervisor: "李四",
  esupervisor: "Si Li",
  date: "二零二三年六月",
  cabstract: lorem(300),
  ckeywords: ("Typst", "模板"),
  eabstract: lorem(300),
  ekeywords: ("Typst", "Template"),
  acknowledgements: [感谢 Typst 开发者的辛勤付出。 #lorem(300)],
  linespacing: 1em,
  outlinedepth: 3,
  blind: false,
  listofimage: true,
  listoftable: true,
  listofcode: true,
  alwaysstartodd: true,
  doc,
)

= 基本功能 <intro>

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
  ]
)\

需要注意的是，这里的样式经过了本模板的一些定制，并非 Typst 的默认样式。

=== 三级标题

==== 四级标题

本模板目录的默认最大深度为 3，即只有前三级标题会出现在目录中。如果需要更深的目录，可以更改 `outlinedepth` 设置。

== 粗体与斜体

与 Markdown 类似，在 Typst 中，使用 `*` 表示粗体，使用 `_` 表示斜体。下面是一个示例：

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
遵循 PKUTHSS 的惯例，使用 *黑体* 表示粗体，_楷体_ 表示斜体。
  ```,
  [
遵循 PKUTHSS 的惯例，使用 *黑体* 表示粗体，_楷体_ 表示斜体。
  ]
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
  image("1-writing-app.png", width: 100%),
  caption: "Typst 网页版界面",
) <web>
```,
[
  #figure(
  image("1-writing-app.png", width: 100%),
  caption: "Typst 网页版界面",
) <web>
]
)\

@web 展示了 Typst 网页版的界面。更多有关内容，可以参考 @about。@developers 中介绍了 Typst 的主要开发者。代码中的 `<web>` 是这一图片的标签，可以在文中通过 `@web` 来引用。

== 表格

在 Typst 中，定义表格的默认方式是 `table` 函数。但如果需要给表格增加标题，或者在文章中引用表格，则需要将其放置在 `figure` 中，就像下面这样：

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
          [*姓名*],[*职称*],[*工作单位*],[*职责*],
          [李四],[教授],[北京大学],[主席],
          [王五],[教授],[北京大学],[成员],
          [赵六],[教授],[北京大学],[成员],
          [钱七],[教授],[北京大学],[成员],
          [孙八],[教授],[北京大学],[成员],
      ),
      caption: "答辩委员会名单",
    ) <table>
  ]
)

对应的渲染结果如 @table 所示。代码中的 `<table>` 是这一表格的标签，可以在文中通过 `@table` 来引用。

默认的表格不是特别美观，本模板中提供了 `booktab` 函数用于生成三线表，下面是一个示例。代码中的 `<booktab>` 是这一表格的标签，可以在文中通过 `@booktab` 来引用。

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
      [左对齐], [居中], [右对齐],
      [4], [5], [6],
      [7], [8], [9],
      [10], [], [11],
    ) <booktab>
  ]
)

== 公式

@eq 是一个公式。代码中的 `<eq>` 是这一公式的标签，可以在文中通过 `@eq` 来引用。

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
$ E = m c^2 $ <eq>
  ```,
  [
    $ E = m c^2 $ <eq>
  ]
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
$ sum_(k=0)^n k
    &= 1 + ... + n \
    &= (n(n+1)) / 2 $ <eq2>
  ]
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
$ lim_x =
    op("lim", limits: #true)_x $ <eq6>
  ]
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
  ]
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
  ]
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
可以像这样引用参考文献： @wang2010guide 和 @kopka2004guide。

#bibliography("ref.bib",
  style: "ieee"
)
  ```,
  [
    可以像这样引用参考文献： @wang2010guide 和 @kopka2004guide。
  ]
)

注意代码中的 `"ref.bib"` 也可以是一个数组，比如 `("ref1.bib", "ref2.bib")`。

= 理论

== 理论一 <theory1>

让我们首先回顾一下 @intro 中的部分公式：

$ frac(a^2, 2) $
$ vec(1, 2, delim: "[") $
$ mat(1, 2; 3, 4) $
$ lim_x =
    op("lim", limits: #true)_x $

== 理论二

在 @theory1 中，我们回顾了 @intro 中的公式。下面，我们来推导一些新的公式：

#lorem(1000)

= 展望

目前本模板还有一些不足之处，有待进一步完善：

- 参考文献格式，特别是中文参考文献的格式不完全符合学校有关规定。#link("https://discord.com/channels/1054443721975922748/1094796790559162408/1094928907880386662", "Discord 上的这个对话")显示，Typst 有关功能还在开发中。待有关接口对外开放后，本模板将会进行相应的适配。
- 暂时还不支持脚注。
- 需要完善对盲评格式的支持。
- 需要完善奇数页开始选项的效果。

#appendix()

= 关于 Typst <about>

== 在附录中插入图片和公式等

附录中也可以插入图片，如 @web1。

#figure(
  image("1-writing-app.png", width: 100%),
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
  ]
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
    $ vec(overline(underbracket(underline(1 + 2) + overbrace(3 + dots.c + 10, "large numbers"), underbrace(x + norm(y), y^(w^u) - root(t, z)))), dots.v, u)^(frac(x + 3, y - 2)) $ <complex>
  ]
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

== Typst 的开发者 <developers>

#lorem(1000)

= 关于 PKUTHSS <pkuthss>

#lorem(1000)

= 更新日志 <changelog>

#set enum(indent: 0em)
#set list(indent: 0em)

#heading(level: 2, numbering: none, "2023-04-14")

+ 适配了下一版本对 `query` 函数的改动
  - 这会导致模板与 Typst `v0.2.0` 版本的不兼容。如果你使用的是 Typst `v0.2.0` 版本，请使用此前版本的模板。

#heading(level: 2, numbering: none, "2023-04-13")

+ 修正了 `alwaysstartodd` 为 `false` 时，摘要页不显示页码的错误
+ 去除了版权声明中多余的空格
+ 增加了致谢页和原创性声明页
+ 增加了 `blind` 选项，设置为 `true` 时将生成盲评格式的论文。但目前只是去除了致谢和原创性声明，还需要进一步完善。

#heading(level: 2, numbering: none, "2023-04-12")

+ 将代码块的首选字体改为 `New Computer Modern Mono`
  - Typst `v0.2.0` 版本内嵌了 `New Computer Modern` 字体，虽然并未同时提供 `New Computer Modern Mono`，这里将本模板的代码块字体相应进行了调整。`New Computer Modern Mono` 的字体文件现在在 `fonts` 目录中提供，同时删除了原来的 `CMU Typewriter Text` 字体文件

#heading(level: 2, numbering: none, "2023-04-11")

+ 将代码块的首选字体改为 `CMU Typewriter Text`
  - `CMU Typewriter Text` 的字体文件已经加入 `fonts` 目录，可以通过在运行 Typst 时使用 `--font-path` 参数指定 `fonts` 目录来使用

#heading(level: 2, numbering: none, "2023-04-10")

+ 正确设置了语言类型
  - 现在设置为 `zh`，之前错误设置为了 `cn`
+ 正确设置了首行缩进
  - 现在正文环境的首行缩进为 #2em
+ 修正了引用图、表、公式等时在前后产生的额外空白
  - 现在在 "@web" 等前后增加了 `h(0em, weak: true)`
+ 修正了公式后编号的字体
  - 现在设置为 #字体.宋体
+ 修正了图题、表题等的字号
  - 现在设置为 #字号.五号
+ 修正了目录中没有对 `outlined` 进行筛选的问题
  - 现在目录中只会显示 `outlined` 为 `true` 的条目
+ 增加了对三线表的支持
  - 现在可以通过 `booktab` 命令插入三线表
+ 增加了对含标题代码块的支持
  - 现在可以通过 `codeblock` 命令插入代码块
+ 增加了插图索引、表格索引和代码索引功能
  - 插图索引：使用 `listofimage` 选项启用或关闭
  - 表格索引：使用 `listoftable` 选项启用或关闭
  - 代码索引：使用 `listofcode` 选项启用或关闭
+ 初步支持在奇数页开始的功能
  - 使用 `alwaysstartodd` 选项启用或关闭

#pagebreak()
#bibliography("ref.bib",
  style: "ieee"
)
