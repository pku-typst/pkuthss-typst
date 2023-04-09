#import "template.typ": *

#show: doc => conf(
  cauthor: "张三",
  eauthor: "San Zhang",
  student-id: "23000xxxxx",
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

#appendix()

= 关于 Typst <about>

== 在附录中插入图片和公式等

附录中也可以插入图片，如 @web1。

#figure(
  image("1-writing-app.png", width: 100%),
  caption: "Typst 网页版界面",
) <web1>

附录中也可以插入公式，如 @appendix-eq。

$ S = pi r^2 $ <appendix-eq>

== Typst 的开发者 <developers>

#lorem(1000)

= 关于 PKUTHSS <pkuthss>

#lorem(1000)

= 关于 PKUTHSS-Typst <pkuthss-typst>

#lorem(1000)

#pagebreak()
#bibliography("ref.bib",
  title: "参考文献",
  style: "ieee"
)
