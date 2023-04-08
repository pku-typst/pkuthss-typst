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
  #it
]

#let textbf(it) = [
  #set text(font: 字体.黑体, weight: "semibold")
  #it
]

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

#let chinesenumbering(..nums) = if nums.pos().len() == 1 {
  "第" + chinesenumber(nums.pos().at(0), standalone: true) + "章"
} else {
  numbering("1.1", ..nums)
}

#let chineseunderline(s, width: 300pt) = {
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
      ret.push(now)
      ret.push(v(-1em))
      ret.push(line(length: 100%))
    }

    ret.join()
  })
}

#let chineseoutline(title: "Contents", depth: none, indent: false) = {
  heading(title, numbering: none)
  locate(it => {
    let elements = query(heading, after: it)

    for el in elements {
      if depth != none and el.level > depth { continue }

      let maybe_number = if el.numbering != none {
        numbering(el.numbering, ..counter(heading).at(el.location()))
        h(0.5em)
      }
      let line = {
        if indent {
          h(1em * (el.level - 1 ))
        }

        if el.level == 1 {
          v(weak: true, 0.5em)
          textbf(maybe_number)
          textbf(el.body)
        } else {
          maybe_number
          h(0.5em)
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
          counter(page).at(footer.at(0).location()).at(0)
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

#let conf(
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
  abstract: [],
  doc,
) = {
  let partcounter = counter("part")
  let chaptercounter = counter("chapter")

  set page("a4",
    header: locate(loc => {
      [
        #if partcounter.at(loc).at(0) < 10 {
        } else {
          set text(字号.五号)
          if calc.even(loc.page()) {
            [
              #align(center, cheader)
              #v(-1em)
              #line(length: 100%)
            ]
          } else {
            let elems = query(heading.where(level: 1), after: loc)
            if elems == () {
            } else {
              let el = elems.first()
              [
                #set align(center)
                #if el.numbering != none {
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
        #let headers = query(heading, before: loc)
        #if headers == () {
        } else {
          let part = partcounter.at(headers.last().location()).at(0)
          
          [
            #if part < 20 {
              numbering("I", counter(page).at(loc).at(0))
            } else {
              str(counter(page).at(loc).at(0))
            }

            #label("footer")
          ]
        }
      ]
    }),
  )

  set text(字号.一号, font: 字体.宋体, lang: "cn")
  set align(center + horizon)
  set heading(numbering: chinesenumbering)
  set figure(
    numbering: (..nums) => locate(loc => numbering("1.1", chaptercounter.at(loc).at(0), ..nums))
  )
  set math.equation(
    numbering: (..nums) => locate(loc => numbering("(1.1)", chaptercounter.at(loc).at(0), ..nums))
  )

  show heading: it => [
    #let sizedheading(it, size) = [
      #set text(size)
      #if it.numbering != none {
        textbf(counter(heading).display())
        h(0.5em)
      }
      #textbf(it.body)
    ]

    #if it.level == 1 {
      pagebreak(weak: true)
      locate(loc => {
        if it.body.text == "摘要" {
          partcounter.update(10)
          counter(page).update(1)
        } else if it.numbering != none and partcounter.at(loc).at(0) < 20 {
          partcounter.update(20)
          counter(page).update(1)
        }
      })
      if it.numbering != none {
        chaptercounter.step()
      }
      counter(figure).update(())
      counter(math.equation).update(())

      set align(center)
      v(字号.三号)
      sizedheading(it, 字号.三号)  
      v(字号.三号)
    } else if it.level == 2 {
      sizedheading(it, 字号.四号)
      v(字号.四号)
    } else if it.level == 3 {
      sizedheading(it, 字号.中四)
      v(字号.中四)
    } else {
      sizedheading(it, 字号.小四)
    }
  ]

  show figure: it => [
    #set align(center)
    #it.body
    图 #locate(loc => {
      numbering("1.1", chaptercounter.at(loc).at(0), counter(figure).at(loc).at(0))
    }) #it.caption
  ]

  show ref: it => {
    locate(loc => {
      let elems = query(it.target, loc)
      if elems.len() == 0 {
        it
      } else {
        let el = elems.first()
        let el-loc = el.location()
        if el.has("block") {
          // Assume to be an equation
          link(el-loc, "式 " + numbering("(1.1)", chaptercounter.at(el-loc).at(0), counter(math.equation).at(el-loc).at(0)))
        } else if el.has("kind") and el.kind == image {
          // Assume to be a figure
          link(el-loc, "图 " + numbering("1.1", chaptercounter.at(el-loc).at(0), counter(figure).at(el-loc).at(0)))
        } else if el.has("level") {
          // Assume to be a heading
          if el.level == 1 {
            link(el-loc, chinesenumbering(..counter(heading).at(el-loc)))
          } else {
            link(el-loc, "节 " + numbering("1.1", ..counter(heading).at(el-loc)))
          }
        }
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
      #chineseunderline(ctitle, width: 300pt)
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
    fieldname("姓        名："),
    fieldvalue(author),
    fieldname("学        号："),
    fieldvalue(student-id),
    fieldname("学        院："),
    fieldvalue(school),
    fieldname("专        业："),
    fieldvalue(major),
    fieldname("研究方向："),
    fieldvalue(direction),
    fieldname("导        师："),
    fieldvalue(supervisor),
  )

  v(60pt)
  set text(字号.小二)
  text(date)
  
  // 封面后的空白页
  pagebreak()
  pagebreak()

  set align(left + top)
  set text(字号.小四)
  par(justify: true)[
    #heading(numbering: none, "摘要")
    #abstract
  ]

  chineseoutline(
    title: "目录",
    indent: true,
  )

  set align(left + top)
  par(justify: true)[
    #doc
  ]
}
