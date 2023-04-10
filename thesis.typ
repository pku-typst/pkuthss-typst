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
  linespacing: 1em,
  outlinedepth: 3,
  listofimage: true,
  listoftable: true,
  alwaysstartodd: true,
  doc,
)

= 绪论 <intro>

== 粗体与斜体

遵循 PKUTHSS 的惯例，使用 *黑体* 表示粗体，_楷体_ 表示斜体。

== 图片

#figure(
  image("1-writing-app.png", width: 100%),
  caption: "Typst 网页版界面",
) <web>

@web 展示了 Typst 网页版的界面。更多有关内容，可以参考 @about。@developers 中介绍了 Typst 的主要开发者。

=== 三级标题

==== 四级标题

目录的默认最大深度为 3，即只有前三级标题会出现在目录中。如果需要更深的目录，可以更改 `outlinedepth` 设置。

== 表格

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

@table 展示了一个示例表格。

== 公式

$ E = m c^2 $ <eq>

@eq 是一个公式。

$ sum_(k=0)^n k
    &= 1 + ... + n \
    &= (n(n+1)) / 2 $ <eq2>

@eq2 是一个多行公式。

$ frac(a^2, 2) $ <eq3>
$ vec(1, 2, delim: "[") $
$ mat(1, 2; 3, 4) $
$ lim_x =
    op("lim", limits: #true)_x $ <eq6>

@eq3 到 @eq6 中给出了更多的示例。

== 代码块

像 Markdown 一样，我们可以在文档中插入代码块：

```c
int main() {
  printf("Hello, world!");
  return 0;
}
```\

如果想要给代码块加上标题，并在文章中引用代码块，可以使用本模板中定义的 `codeblock` 命令。其中，`caption` 参数用于指定代码块的标题，`outline` 参数用于指定代码块显示时是否使用边框。

#codeblock(
  ```python
  def main():
      print("Hello, world!")
  ```,
  caption: "一个简单的 Python 程序",
  outline: true,
) <code>\

@code 是一个简单的 Python 程序。

#codeblock(
  ```typ
#let codeblock(raw, caption: none, outline: false) = {  
  [
    #figure([], caption: caption, kind: "code", supplement: "")
    #set align(center)
    #set text(字号.五号, font: 字体.宋体)
    代码
    #locate(loc => {
      chinesenumbering(
        chaptercounter.at(loc).first(), 
        ..rawcounter.at(loc), 
        location: loc)
    })
    #if caption != none {
      h(0.5em) 
      caption
    }
  ]

  if outline {
    rect(width: 100%)[
      #set align(left)
      #raw
    ]
  } else {
    set align(left)
    raw
  }
}
  ```,
  caption: [`codeblock` 命令的实现],
) <codeblock_definition>\

@codeblock_definition 中给出了本模板中定义的 `codeblock` 命令的实现。

== 参考文献

我们同样可以引用参考文献，例如 @wang2010guide 和 @kopka2004guide。

== 其他

#lorem(1000)

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

- 参考文献格式，特别是中文参考文献的格式不完全符合学校有关规定。
- 表格样式不够美观，需要提供一个默认的三线表样式。
- 暂时还不支持脚注。

#appendix()

= 关于 Typst <about>

== 在附录中插入图片和公式等

附录中也可以插入图片，如 @web1。

#figure(
  image("1-writing-app.png", width: 100%),
  caption: "Typst 网页版界面",
) <web1>

附录中也可以插入公式，如 @appendix-eq。

$ S = pi r^2 $ <appendix-eq>\

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
#heading(level: 2, numbering: none, "2023-04-10")

+ 正确设置了语言类型
  - 现在设置为 `zh`，之前错误设置为了 `cn`
+ 正确设置了首行缩进
  - 现在正文环境的首行缩进为 #2em
+ 修正了引用图、表、公式等时在前后产生的额外空白
  - 现在在 "@web" 等前后增加了 `h(0em, weak: true)`
+ 修正了公式后编号的字体
  - 现在设置为 #字体.宋体
+ 修正了图题和标题的字号
  - 现在设置为 #字号.五号
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
