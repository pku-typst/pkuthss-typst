#let 字号 = (
  一号: 26pt,
  小一: 24pt,
  二号: 22pt,
  小二: 18pt,
  三号: 16pt,
  小三: 15pt,
  四号: 14pt,
  中四: 13pt,
  小四: 12pt,
  五号: 10.5pt,
  小五: 9pt,
)

#let 字体 = (
  仿宋: ("Times New Roman", "FangSong"),
  宋体: ("Times New Roman", "SimSun"),
  黑体: ("Times New Roman", "SimHei"),
  楷体: ("Times New Roman", "KaiTi"),
)

#let textit(it) = [
  #set text(font: 字体.楷体, style: "italic")
  #h(0em, weak: true)
  #it
  #h(0em, weak: true)
]

#let textbf(it) = [
  #set text(font: 字体.黑体, weight: "semibold")
  #h(0em, weak: true)
  #it
  #h(0em, weak: true)
]

#let lengthceil(len, unit: 字号.小四) = {
  let start = unit
  while start < len {
    start = start + unit
  }
  start
}

#let partcounter = counter("part")
#let chaptercounter = counter("chapter")
#let appendixcounter = counter("appendix")
#let appendix() = {
  appendixcounter.update(10)
  chaptercounter.update(())
  counter(heading).update(())
}

#let chinesenumber(num, standalone: false) = if num < 11 {
  ("零", "一", "二", "三", "四", "五", "六", "七", "八", "九", "十").at(num)
} else if num < 100 {
  if calc.mod(num, 10) == 0 {
    chinesenumber(calc.floor(num / 10)) + "十"
  } else if num < 20 and standalone {
    "十" + chinesenumber(calc.mod(num, 10))
  } else {
    chinesenumber(calc.floor(num / 10)) + "十" + chinesenumber(calc.mod(num, 10))
  }
} else if num < 1000 {
  let left = chinesenumber(calc.floor(num / 100)) + "百"
  if calc.mod(num, 100) == 0 {
    left
  } else if calc.mod(num, 100) < 10 {
    left + "零" + chinesenumber(calc.mod(num, 100))
  } else {
    left + chinesenumber(calc.mod(num, 100))
  }
} else {
  let left = chinesenumber(calc.floor(num / 1000)) + "千"
  if calc.mod(num, 1000) == 0 {
    left
  } else if calc.mod(num, 1000) < 10 {
    left + "零" + chinesenumber(calc.mod(num, 1000))
  } else if calc.mod(num, 1000) < 100 {
    left + "零" + chinesenumber(calc.mod(num, 1000))
  } else {
    left + chinesenumber(calc.mod(num, 1000))
  }
}

#let chinesenumbering(..nums, location: none, brackets: false) = locate(loc => {
  let actual-loc = if location == none { loc } else { location }
  if appendixcounter.at(actual-loc).first() < 10 {
    if nums.pos().len() == 1 {
      "第" + chinesenumber(nums.pos().first(), standalone: true) + "章"
    } else {
      numbering(if brackets { "(1.1)" } else { "1.1" }, ..nums)
    }
  } else {
    if nums.pos().len() == 1 {
      "附录 " + numbering("A.1", ..nums)
    } else {
      numbering(if brackets { "(A.1)" } else { "A.1" }, ..nums)
    }
  }
}) 

#let chineseunderline(s, width: 300pt, bold: false) = {
  let chars = s.split("")
  let n = chars.len()
  style(styles => {
    let i = 0
    let now = ""
    let ret = ()

    while i < n {
      let c = chars.at(i)
      let nxt = now + c

      if measure(nxt, styles).width > width or c == "\n" {
        ret.push(now)
        ret.push(v(-1em))
        ret.push(line(length: 100%))
        if c == "\n" {
          now = ""
        } else {
          now = c
        }
      } else {
        now = nxt
      }

      i = i + 1
    }

    if now.len() > 0 {
      if bold {
        ret.push(textbf(now))
      } else {
        ret.push(now)
      }
      ret.push(v(-0.9em))
      ret.push(line(length: 100%))
    }

    ret.join()
  })
}

#let chineseoutline(title: "目录", depth: none, indent: false) = {
  heading(title, numbering: none)
  locate(it => {
    let elements = query(heading, after: it)

    for el in elements {
      // Skip list of images and list of tables
      if partcounter.at(el.location()).first() < 20 and el.numbering == none { continue }

      // Skip headings that are too deep
      if depth != none and el.level > depth { continue }

      let maybe-number = if el.numbering != none {
        if el.numbering == chinesenumbering {
          chinesenumbering(..counter(heading).at(el.location()), location: el.location())
        } else {
          numbering(el.numbering, ..counter(heading).at(el.location()))
        }
        h(0.5em)
      }
      let line = {
        if indent {
          h(1em * (el.level - 1 ))
        }

        if el.level == 1 {
          v(weak: true, 0.5em)
          if maybe-number != none {
            style(styles => {
              let width = measure(maybe-number, styles).width
              box(
                width: lengthceil(width),
                textbf(maybe-number)
              )
            })
          }
          textbf(el.body)
        } else {
          style(styles => {
            let width = measure(maybe-number, styles).width
            box(
              width: lengthceil(width),
              maybe-number
            )
          })
          el.body
        }

        // Filler dots
        if el.level == 1 {
          box(width: 1fr, h(10pt) + box(width: 1fr) + h(10pt))
        } else {
          box(width: 1fr, h(10pt) + box(width: 1fr, repeat[.]) + h(10pt))
        }
        
        // Page number
        let footer = query(<footer>, after: el.location())
        let page-number = if footer == () {
          0
        } else {
          counter(page).at(footer.first().location()).first()
        }
        if el.level == 1 {
          textbf(str(page-number))
        } else {
          str(page-number)
        }

        linebreak()
        v(-0.2em)
      }

      link(el.location(), line)
    }
  })
}

#let listoffigures(title: "插图", kind: image) = {
  heading(title, numbering: none)
  locate(it => {
    let elements = query(figure.where(kind: kind), after: it)

    for el in elements {
      let maybe-number = {
        let el-loc = el.location()
        chinesenumbering(chaptercounter.at(el-loc).first(), counter(figure.where(kind: kind)).at(el.location()).first(), location: el.location())
        h(0.5em)
      }
      let line = {
        style(styles => {
          let width = measure(maybe-number, styles).width
          box(
            width: lengthceil(width),
            maybe-number
          )
        })
        el.caption

        // Filler dots
        box(width: 1fr, h(10pt) + box(width: 1fr, repeat[.]) + h(10pt))
        
        // Page number
        let footer = query(<footer>, after: el.location())
        let page-number = if footer == () {
          0
        } else {
          counter(page).at(footer.first().location()).first()
        }
        str(page-number)
        linebreak()
        v(-0.2em)
      }

      link(el.location(), line)
    }
  })
}


#let conf(
  cauthor: "张三",
  eauthor: "San Zhang",
  student-id: "23000xxxxx",
  cthesisname: "博士研究生学位论文",
  cheader: "北京大学博士学位论文",
  ctitle: "北京大学学位论文Typst模板",
  etitle: "Typst Template for Peking University Dissertations",
  school: "某个学院",
  cmajor: "某个专业",
  emajor: "Some Major",
  direction: "某个研究方向",
  csupervisor: "李四",
  esupervisor: "Si Li",
  date: "二零二三年六月",
  cabstract: [],
  ckeywords: (),
  eabstract: [],
  ekeywords: (),
  linespacing: 1em,
  outlinedepth: 3,
  listofimage: true,
  listoftable: true,
  doc,
) = {
  set page("a4",
    header: locate(loc => {
      [
        #set text(字号.五号)
        #set align(center)
        #if partcounter.at(loc).first() < 10 {
          // FIXME: Handle the first page of Chinese abstract specailly
          if loc.page() == 5 {
            [
              摘要
              #v(-1em)
              #line(length: 100%)
            ]
          }
        } else {
          if calc.even(loc.page()) {
            [
              #align(center, cheader)
              #v(-1em)
              #line(length: 100%)
            ]
          } else {
            let elems = query(heading.where(level: 1), before: query(<footer>, after: loc).first().location())
            if elems == () {
            } else {
              let el = elems.last()
              [
                #if el.numbering == chinesenumbering {
                  chinesenumbering(..counter(heading).at(el.location()), location: el.location())
                } else if el.numbering != none {
                  numbering(el.numbering, ..counter(heading).at(el.location()))
                }
                #h(0.5em)
                #el.body
                #v(-1em)
                #line(length: 100%)
              ]
          }
        }
      }]}),
    footer: locate(loc => {
      [
        #set text(字号.五号)
        #set align(center)
        #if loc.page() <= 4 {
          // FIXME: Skip cover and copyright page
        } else {
          let headers = query(heading, before: loc)
          let part = partcounter.at(headers.last().location()).first()
          [
            #if part < 20 {
              numbering("I", counter(page).at(loc).first())
            } else {
              str(counter(page).at(loc).first())
            }

            #label("footer")
          ]
        }
      ]
    }),
  )

  set text(字号.一号, font: 字体.宋体, lang: "zh")
  set align(center + horizon)
  set heading(numbering: chinesenumbering)
  set figure(
    numbering: (..nums) => locate(loc => {
      if appendixcounter.at(loc).first() < 10 { 
        numbering("1.1", chaptercounter.at(loc).first(), ..nums)
      } else {
        numbering("A.1", chaptercounter.at(loc).first(), ..nums)
      }
    })
  )
  set math.equation(
    numbering: (..nums) => locate(loc => {
      if appendixcounter.at(loc).first() < 10 { 
        numbering("(1.1)", chaptercounter.at(loc).first(), ..nums)
      } else {
        numbering("(A.1)", chaptercounter.at(loc).first(), ..nums)
      }
    })
  )

  show strong: it => textbf(it)
  show emph: it => textit(it)
  show par: set block(spacing: linespacing)

  show heading: it => [
    // Cancel indentation for headings of level 2 or above
    #set par(first-line-indent: 0em)

    #let sizedheading(it, size) = [
      #set text(size)
      #v(2em)
      #if it.numbering != none {
        textbf(counter(heading).display())
        h(0.5em)
      }
      #textbf(it.body)
      #v(1em)
    ]

    #if it.level == 1 {
      if it.body.text != "Abstract" {
        pagebreak(weak: true)
      }
      locate(loc => {
        if it.body.text == "摘要" {
          partcounter.update(10)
          counter(page).update(1)
        } else if it.numbering != none and partcounter.at(loc).first() < 20 {
          partcounter.update(20)
          counter(page).update(1)
        }
      })
      if it.numbering != none {
        chaptercounter.step()
      }
      counter(figure.where(kind: image)).update(())
      counter(figure.where(kind: table)).update(())
      counter(math.equation).update(())

      set align(center)
      sizedheading(it, 字号.三号)
    } else {
      if it.level == 2 {
        sizedheading(it, 字号.四号)
      } else if it.level == 3 {
        sizedheading(it, 字号.中四)
      } else {
        sizedheading(it, 字号.小四)
      }
    }
  ]

  show figure: it => [
    #set align(center)
    #if not it.has("kind") {
    } else if it.kind == image {
      it.body
      text("图 ")
      locate(loc => {
        chinesenumbering(chaptercounter.at(loc).first(), counter(figure.where(kind: image)).at(loc).first(), location: loc)
      })
      text("  ")
      it.caption
    } else if it.kind == table {
      text("表 ")
      locate(loc => {
        chinesenumbering(chaptercounter.at(loc).first(), counter(figure.where(kind: table)).at(loc).first(), location: loc)
      })
      text("  ")
      it.caption
      it.body
    }
  ]

 show ref: it => {
    locate(loc => {
      let elems = query(it.target, loc)

      if elems == () {
        // Keep citations as is
        it
      } else {
        // Remove prefix spacing
        h(0em, weak: true)

        let el = elems.first()
        let el-loc = el.location()
        if el.func() == math.equation {
          // Handle equations
          link(el-loc, [
            式
            #chinesenumbering(chaptercounter.at(el-loc).first(), counter(math.equation).at(el-loc).first(), location: el-loc, brackets: true)
          ])
        } else if el.func() == figure {
          // Handle figures
          if el.kind == image {
            link(el-loc, [
              图
              #chinesenumbering(chaptercounter.at(el-loc).first(), counter(figure.where(kind: image)).at(el-loc).first(), location: el-loc)
            ])
          } else if el.kind == table {
            link(el-loc, [
              表
              #chinesenumbering(chaptercounter.at(el-loc).first(), counter(figure.where(kind: table)).at(el-loc).first(), location: el-loc)
            ])
          }
        } else if el.func() == heading {
          // Handle headings
          if el.level == 1 {
            link(el-loc, chinesenumbering(..counter(heading).at(el-loc), location: el-loc))
            if appendixcounter.at(el-loc).first() < 10 {
              // Remove suffix spacing for "第一章"
            }
          } else {
            link(el-loc, [
              节
              #chinesenumbering(..counter(heading).at(el-loc), location: el-loc)
            ])
          }
        }

        // Remove suffix spacing
        h(0em, weak: true)
      }
    })
  }

  box(
    grid(
      columns: (auto, auto),
      gutter: 0.4em,
      image("pkulogo.svg", height: 2.4em, fit: "contain"),
      image("pkuword.svg", height: 1.6em, fit: "contain")
    )
  )
  linebreak()
  textbf(cthesisname)

  set text(字号.二号)
  v(60pt)
  grid(
    columns: (80pt, 300pt),
    [
      #set align(right + top)
      题目：
    ],
    [
      #set align(center + horizon)
      #chineseunderline(ctitle, width: 300pt, bold: true)
    ]
  )

  v(60pt)
  set text(字号.三号)

  let fieldname(name) = [
    #set align(right + top)
    #textbf(name)
  ]

  let fieldvalue(value) = [
    #set align(center + horizon)
    #set text(font: 字体.仿宋)
    #grid(
      rows: (auto, auto),
      row-gutter: 0.2em,
      value,
      line(length: 100%)
    )
  ]

  grid(
    columns: (80pt, 280pt),
    row-gutter: 1em,
    fieldname(text("姓") + h(2em) + text("名：")),
    fieldvalue(cauthor),
    fieldname(text("学") + h(2em) + text("号：")),
    fieldvalue(student-id),
    fieldname(text("学") + h(2em) + text("院：")),
    fieldvalue(school),
    fieldname(text("专") + h(2em) + text("业：")),
    fieldvalue(cmajor),
    fieldname("研究方向："),
    fieldvalue(direction),
    fieldname(text("导") + h(2em) + text("师：")),
    fieldvalue(csupervisor),
  )

  v(60pt)
  set text(字号.小二)
  text(date)
  
  // Blank page after cover
  pagebreak()
  pagebreak()

  set align(left + top)
  set text(字号.小四)
  heading(numbering: none, "版权声明")
  par(justify: true, first-line-indent: 2em, leading: linespacing)[
    任何收存和保管本论文各种版本的单位和个人，
    未经本论文作者同意，不得将本论文转借他人，
    亦不得随意复制、抄录、拍照或以任何方式传播。
    否则，引起有碍作者著作权之问题，将可能承担法律责任。
  ]

  // Blank page after copyright
  pagebreak()
  pagebreak()

  par(justify: true, first-line-indent: 2em, leading: linespacing)[
    #heading(numbering: none, "摘要")
    #cabstract
    #v(1fr)
    #set par(first-line-indent: 0em)
    *关键词：*
    #ckeywords.join("，")
    #v(2em)
  ]
  pagebreak(weak: true)

  par(justify: true, first-line-indent: 2em, leading: linespacing)[
    #[
      #set text(字号.小二)
      #set align(center)
      #textbf(etitle)
    ]
    #[
      #set align(center)
      #eauthor \(#emajor\) \
      Directed by #esupervisor
    ]
    #heading(numbering: none, "Abstract")
    #eabstract
    #v(1fr)
    #set par(first-line-indent: 0em)
    *KEYWORDS:*
    #h(0.5em, weak: true)
    #ekeywords.join(", ")
    #v(2em)
  ]
  pagebreak(weak: true)

  chineseoutline(
    title: "目录",
    depth: outlinedepth,
    indent: true,
  )

  if listofimage {
    listoffigures()
  }

  if listoftable {
    listoffigures(title: "表格", kind: table)
  }

  set align(left + top)
  par(justify: true, first-line-indent: 2em, leading: linespacing)[
    #doc
  ]
}
