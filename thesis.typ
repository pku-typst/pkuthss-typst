#import "template.typ": *

#show: doc => conf(
  author: "张三",
  student-id: "23000xxxxx",
  cthesisname: "博士研究生学位论文",
  cheader: "北京大学博士学位论文",
  ctitle: "北京大学学位论文Typst模板",
  school: "某个学院",
  major: "某个专业",
  direction: "某个研究方向",
  supervisor: "李四",
  date: "二零二三年六月",
  abstract: lorem(300),
  doc,
)

= 绪论 <intro>

== 图片

#figure(
  image("1-writing-app.png", width: 100%),
  caption: "Typst网页版界面",
) <web>

@web 展示了Typst网页版的界面。

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

#pagebreak()
#bibliography("ref.bib",
  title: "参考文献",
  style: "ieee"
)
