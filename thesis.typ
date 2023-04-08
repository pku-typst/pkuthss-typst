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
  abstract: lorem(80),
  doc,
)

= 绪论

== 研究背景与意义

=== 研究背景

#math.equation(
  block: true,
  numbering: "(1.1)",
  $ a^b = b^c $
)

= 理论

== 理论一

== 理论二

#lorem(200)

= 方法

== 方法一

== 方法二

= 应用

== 应用一

== 应用二

= 结论与展望

@wang2010guide

@kopka2004guide

#pagebreak()
#bibliography("ref.bib",
  title: "参考文献",
  style: "ieee"
)
