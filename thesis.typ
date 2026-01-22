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
  etitle: "User Guide for PKU Dissertation\nTypst Template (modern-pku-thesis)",
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
  ckeywords: ("Typst", "学位论文", "排版模板", "北京大学"),
  eabstract: include "doc/eabstract.typ",
  ekeywords: (
    "Typst",
    "Dissertation",
    "Template",
    "Peking University",
  ),
  acknowledgements: include "doc/acknowledgements.typ",
  outlinedepth: 3,
  blind: false,
  listofimage: true,
  listoftable: true,
  listofcode: true,
  alwaysstartodd: false,
  cleandeclaration: true,
  bibcontent: read("ref.bib"),
  bibstyle: "numeric",
  bibversion: "2015",
  doc,
)

= 快速开始 <quickstart>

#include "doc/ch01-quickstart.typ"

= 模板配置选项 <config>

#include "doc/ch02-config.typ"

= Typst 基本功能 <typst-basics>

本章介绍 Typst 的基本语法和功能，帮助用户快速上手。

#include "doc/ch03-basics.typ"

= 常见问题与解决方案 <faq>

#include "doc/ch04-faq.typ"

= 进阶使用技巧 <advanced>

#include "doc/ch05-advanced.typ"

#appendix()

= 关于 Typst <about>

#include "doc/appendix-about.typ"

= 更新日志 <changelog>

#include "changelog.typ"

#pagebreak()
