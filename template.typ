#let 字号 = (
  初号: 42pt,
  小初: 36pt,
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
  六号: 7.5pt,
  小六: 6.5pt,
  七号: 5.5pt,
  小七: 5pt,
)

#let 字体 = (
  仿宋: ("Times New Roman", "FangSong"),
  宋体: ("Times New Roman", "SimSun"),
  黑体: ("Times New Roman", "SimHei"),
  楷体: ("Times New Roman", "KaiTi"),
  代码: ("New Computer Modern Mono", "Times New Roman", "SimSun"),
)

#let lengthceil(len, unit: 字号.小四) = calc.ceil(len / unit) * unit
#let partcounter = counter("part")
#let chaptercounter = counter("chapter")
#let appendixcounter = counter("appendix")
#let footnotecounter = counter(footnote)
#let rawcounter = counter(figure.where(kind: "code"))
#let imagecounter = counter(figure.where(kind: image))
#let tablecounter = counter(figure.where(kind: table))
#let equationcounter = counter(math.equation)
#let appendix() = {
  appendixcounter.update(10)
  chaptercounter.update(0)
  counter(heading).update(0)
}
#let skippedstate = state("skipped", false)

#let chinesenumber(num, standalone: false) = if num < 11 {
  ("零", "一", "二", "三", "四", "五", "六", "七", "八", "九", "十").at(num)
} else if num < 100 {
  if calc.rem(num, 10) == 0 {
    chinesenumber(calc.floor(num / 10)) + "十"
  } else if num < 20 and standalone {
    "十" + chinesenumber(calc.rem(num, 10))
  } else {
    chinesenumber(calc.floor(num / 10)) + "十" + chinesenumber(calc.rem(num, 10))
  }
} else if num < 1000 {
  let left = chinesenumber(calc.floor(num / 100)) + "百"
  if calc.rem(num, 100) == 0 {
    left
  } else if calc.rem(num, 100) < 10 {
    left + "零" + chinesenumber(calc.rem(num, 100))
  } else {
    left + chinesenumber(calc.rem(num, 100))
  }
} else {
  let left = chinesenumber(calc.floor(num / 1000)) + "千"
  if calc.rem(num, 1000) == 0 {
    left
  } else if calc.rem(num, 1000) < 10 {
    left + "零" + chinesenumber(calc.rem(num, 1000))
  } else if calc.rem(num, 1000) < 100 {
    left + "零" + chinesenumber(calc.rem(num, 1000))
  } else {
    left + chinesenumber(calc.rem(num, 1000))
  }
}

#let chinesenumbering(..nums, location: none, brackets: false) = locate(loc => {
  let actual_loc = if location == none { loc } else { location }
  if appendixcounter.at(actual_loc).first() < 10 {
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
  let chars = s.clusters()
  let n = chars.len()
  style(styles => {
    let i = 0
    let now = ""
    let ret = ()

    while i < n {
      let c = chars.at(i)
      let nxt = now + c

      if measure(nxt, styles).width > width or c == "\n" {
        if bold {
          ret.push(strong(now))
        } else {
          ret.push(now)
        }
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
        ret.push(strong(now))
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
  heading(title, numbering: none, outlined: false)
  locate(it => {
    let elements = query(heading.where(outlined: true).after(it), it)

    for el in elements {
      // Skip list of images and list of tables
      if partcounter.at(el.location()).first() < 20 and el.numbering == none { continue }

      // Skip headings that are too deep
      if depth != none and el.level > depth { continue }

      let maybe_number = if el.numbering != none {
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
          v(0.5em, weak: true)
        }

        if maybe_number != none {
          style(styles => {
            let width = measure(maybe_number, styles).width
            box(
              width: lengthceil(width),
              link(el.location(), if el.level == 1 {
                strong(maybe_number)
              } else {
                maybe_number
              })
            )
          })
        }

        link(el.location(), if el.level == 1 {
          strong(el.body)
        } else {
          el.body
        })

        // Filler dots
        if el.level == 1 {
          box(width: 1fr, h(10pt) + box(width: 1fr) + h(10pt))
        } else {
          box(width: 1fr, h(10pt) + box(width: 1fr, repeat[.]) + h(10pt))
        }

        // Page number
        let footer = query(selector(<__footer__>).after(el.location()), el.location())
        let page_number = if footer == () {
          0
        } else {
          counter(page).at(footer.first().location()).first()
        }
        
        link(el.location(), if el.level == 1 {
          strong(str(page_number))
        } else {
          str(page_number)
        })

        linebreak()
        v(-0.2em)
      }

      line
    }
  })
}

#let listoffigures(title: "插图", kind: image) = {
  heading(title, numbering: none, outlined: false)
  locate(it => {
    let elements = query(figure.where(kind: kind).after(it), it)

    for el in elements {
      let maybe_number = {
        let el_loc = el.location()
        chinesenumbering(chaptercounter.at(el_loc).first(), counter(figure.where(kind: kind)).at(el_loc).first(), location: el_loc)
        h(0.5em)
      }
      let line = {
        style(styles => {
          let width = measure(maybe_number, styles).width
          box(
            width: lengthceil(width),
            link(el.location(), maybe_number)
          )
        })

        link(el.location(), el.caption.body)

        // Filler dots
        box(width: 1fr, h(10pt) + box(width: 1fr, repeat[.]) + h(10pt))

        // Page number
        let footers = query(selector(<__footer__>).after(el.location()), el.location())
        let page_number = if footers == () {
          0
        } else {
          counter(page).at(footers.first().location()).first()
        }
        link(el.location(), str(page_number))
        linebreak()
        v(-0.2em)
      }

      line
    }
  })
}

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

#let booktab(columns: (), aligns: (), width: auto, caption: none, ..cells) = {
  let headers = cells.pos().slice(0, columns.len())
  let contents = cells.pos().slice(columns.len(), cells.pos().len())
  set align(center)

  if aligns == () {
    for i in range(0, columns.len()) {
      aligns.push(center)
    }
  }

  let content_aligns = ()
  for i in range(0, contents.len()) {
    content_aligns.push(aligns.at(calc.rem(i, aligns.len())))
  }

  return figure(
    block(
      width: width,
      grid(
        columns: (auto),
        row-gutter: 1em,
        line(length: 100%),
        [
          #set align(center)
          #box(
            width: 100% - 1em,
            grid(
              columns: columns,
              ..headers.zip(aligns).map(it => [
                #set align(it.last())
                #strong(it.first())
              ])
            )
          )
        ],
        line(length: 100%),
        [
          #set align(center)
          #box(
            width: 100% - 1em,
            grid(
              columns: columns,
              row-gutter: 1em,
              ..contents.zip(content_aligns).map(it => [
                #set align(it.last())
                #it.first()
              ])
            )
          )
        ],
        line(length: 100%),
      ),
    ),
    caption: caption,
    kind: table
  )
}

#let conf(
  cauthor: "张三",
  eauthor: "San Zhang",
  studentid: "23000xxxxx",
  blindid: "L2023XXXXX",
  cthesisname: "博士研究生学位论文",
  cheader: "北京大学博士学位论文",
  ctitle: "北京大学学位论文 Typst 模板",
  etitle: "Typst Template for Peking University Dissertations",
  school: "某个学院",
  cfirstmajor: "某个一级学科",
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
  acknowledgements: [],
  linespacing: 1em,
  outlinedepth: 3,
  blind: false,
  listofimage: true,
  listoftable: true,
  listofcode: true,
  alwaysstartodd: true,
  doc,
) = {
  let smartpagebreak = () => {
    if alwaysstartodd {
      skippedstate.update(true)
      pagebreak(to: "odd", weak: true)
      skippedstate.update(false)
    } else {
      pagebreak(weak: true)
    }
  }

  set page("a4",
    header: locate(loc => {
      if skippedstate.at(loc) and calc.even(loc.page()) { return }
      [
        #set text(字号.五号)
        #set align(center)
        #if partcounter.at(loc).at(0) < 10 {
          let headings = query(selector(heading).after(loc), loc)
          let next_heading = if headings == () {
            ()
          } else {
            headings.first().body.text
          }

          // [HARDCODED] Handle the first page of Chinese abstract specailly
          if next_heading == "摘要" and calc.odd(loc.page()) {
            [
              #next_heading
              #v(-1em)
              #line(length: 100%)
            ]
          }
        } else if partcounter.at(loc).at(0) <= 20 {
          if calc.even(loc.page()) {
            [
              #align(center, cheader)
              #v(-1em)
              #line(length: 100%)
            ]
          } else {
            let footers = query(selector(<__footer__>).after(loc), loc)
            if footers != () {
              let elems = query(
                heading.where(level: 1).before(footers.first().location()), footers.first().location()
              )

              // [HARDCODED] Handle the last page of Chinese abstract specailly
              let el = if elems.last().body.text == "摘要" or not skippedstate.at(footers.first().location()) {
                elems.last()
              } else {
                elems.at(-2)
              }
              [
                #let numbering = if el.numbering == chinesenumbering {
                  chinesenumbering(..counter(heading).at(el.location()), location: el.location())
                } else if el.numbering != none {
                  numbering(el.numbering, ..counter(heading).at(el.location()))
                }
                #if numbering != none {
                  numbering
                  h(0.5em)
                }
                #el.body
                #v(-1em)
                #line(length: 100%)
              ]
            }
          }
      }]}),
    footer: locate(loc => {
      if skippedstate.at(loc) and calc.even(loc.page()) { return }
      [
        #set text(字号.五号)
        #set align(center)
        #if query(selector(heading).before(loc), loc).len() < 2 or query(selector(heading).after(loc), loc).len() == 0 {
          // Skip cover, copyright and origin pages
        } else {
          let headers = query(selector(heading).before(loc), loc)
          let part = partcounter.at(headers.last().location()).first()
          [
            #if part < 20 {
              numbering("I", counter(page).at(loc).first())
            } else {
              str(counter(page).at(loc).first())
            }
          ]
        }
        #label("__footer__")
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
      set text(font: 字体.宋体)
      if appendixcounter.at(loc).first() < 10 {
        numbering("(1.1)", chaptercounter.at(loc).first(), ..nums)
      } else {
        numbering("(A.1)", chaptercounter.at(loc).first(), ..nums)
      }
    })
  )
  set list(indent: 2em)
  set enum(indent: 2em)

  show strong: it => text(font: 字体.黑体, weight: "semibold", it.body)
  show emph: it => text(font: 字体.楷体, style: "italic", it.body)
  show par: set block(spacing: linespacing)
  show raw: set text(font: 字体.代码)

  show heading: it => [
    // Cancel indentation for headings
    #set par(first-line-indent: 0em)

    #let sizedheading(it, size) = [
      #set text(size)
      #v(2em)
      #if it.numbering != none {
        strong(counter(heading).display())
        h(0.5em)
      }
      #strong(it.body)
      #v(1em)
    ]

    #if it.level == 1 {
      if not it.body.text in ("Abstract", "学位论文使用授权说明", "版权声明")  {
        smartpagebreak()
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
      footnotecounter.update(())
      imagecounter.update(())
      tablecounter.update(())
      rawcounter.update(())
      equationcounter.update(())

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
      it
    } else if it.kind == image {
      it.body
      [
        #set text(字号.五号)
        #it.caption
      ]
    } else if it.kind == table {
      [
        #set text(字号.五号)
        #it.caption
      ]
      it.body
    } else if it.kind == "code" {
      [
        #set text(字号.五号)
        代码#it.caption
      ]
      it.body
    }
  ]

  show ref: it => {
    if it.element == none {
      // Keep citations as is
      it
    } else {
      // Remove prefix spacing
      h(0em, weak: true)

      let el = it.element
      let el_loc = el.location()
      if el.func() == math.equation {
        // Handle equations
        link(el_loc, [
          式
          #chinesenumbering(chaptercounter.at(el_loc).first(), equationcounter.at(el_loc).first(), location: el_loc, brackets: true)
        ])
      } else if el.func() == figure {
        // Handle figures
        if el.kind == image {
          link(el_loc, [
            图
            #chinesenumbering(chaptercounter.at(el_loc).first(), imagecounter.at(el_loc).first(), location: el_loc)
          ])
        } else if el.kind == table {
          link(el_loc, [
            表
            #chinesenumbering(chaptercounter.at(el_loc).first(), tablecounter.at(el_loc).first(), location: el_loc)
          ])
        } else if el.kind == "code" {
          link(el_loc, [
            代码
            #chinesenumbering(chaptercounter.at(el_loc).first(), rawcounter.at(el_loc).first(), location: el_loc)
          ])
        }
      } else if el.func() == heading {
        // Handle headings
        if el.level == 1 {
          link(el_loc, chinesenumbering(..counter(heading).at(el_loc), location: el_loc))
        } else {
          link(el_loc, [
            节
            #chinesenumbering(..counter(heading).at(el_loc), location: el_loc)
          ])
        }
      }

      // Remove suffix spacing
      h(0em, weak: true)
    }
  }

  let fieldname(name) = [
    #set align(right + top)
    #strong(name)
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

  // Cover page

  if blind {
    set align(center + top)
    text(字号.初号)[#strong(cheader)]
    linebreak()
    set text(字号.三号, font: 字体.仿宋)
    set par(justify: true, leading: 1em)
    [（匿名评阅论文封面）]
    v(2fr)
    grid(
      columns: (80pt, 320pt),
      row-gutter: 1.5em,
      align(left + top)[中文题目：],
      align(left + top)[#ctitle],
      align(left + top)[英文题目：],
      align(left + top)[#etitle],
    )
    v(2em)
    grid(
      columns: (80pt, 320pt),
      row-gutter: 1.5em,
      align(left + top)[一级学科：],
      align(left + top)[#cfirstmajor],
      align(left + top)[二级学科：],
      align(left + top)[#cmajor],
      align(left + top)[论文编号：],
      align(left + top)[#blindid],
    )

    v(4fr)
    text(字号.小二, font: 字体.仿宋)[#date]
    v(1fr)
  } else {
    box(
      grid(
        columns: (auto, auto),
        gutter: 0.4em,
        image("pkulogo.svg", height: 2.4em, fit: "contain"),
        image("pkuword.svg", height: 1.6em, fit: "contain")
      )
    )
    linebreak()
    strong(cthesisname)

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

    grid(
      columns: (80pt, 280pt),
      row-gutter: 1em,
      fieldname(text("姓") + h(2em) + text("名：")),
      fieldvalue(cauthor),
      fieldname(text("学") + h(2em) + text("号：")),
      fieldvalue(studentid),
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
    text(字号.小二)[#date]
  }

  smartpagebreak()

  // Copyright
  set align(left + top)
  set text(字号.小四)
  heading(numbering: none, outlined: false, "版权声明")
  par(justify: true, first-line-indent: 2em, leading: linespacing)[
    任何收存和保管本论文各种版本的单位和个人，未经本论文作者同意，不得将本论文转借他人，亦不得随意复制、抄录、拍照或以任何方式传播。否则，引起有碍作者著作权之问题，将可能承担法律责任。
  ]

  smartpagebreak()

  // Chinese abstract
  par(justify: true, first-line-indent: 2em, leading: linespacing)[
    #heading(numbering: none, outlined: false, "摘要")
    #cabstract
    #v(1fr)
    #set par(first-line-indent: 0em)
    *关键词：*
    #ckeywords.join("，")
    #v(2em)
  ]

  smartpagebreak()

  // English abstract
  par(justify: true, first-line-indent: 2em, leading: linespacing)[
    #[
      #set text(字号.小二)
      #set align(center)
      #strong(etitle)
    ]
    #if not blind {
      [
        #set align(center)
        #eauthor \(#emajor\) \
        Directed by #esupervisor
      ]
    }
    #heading(numbering: none, outlined: false, "Abstract")
    #eabstract
    #v(1fr)
    #set par(first-line-indent: 0em)
    *KEYWORDS:*
    #h(0.5em, weak: true)
    #ekeywords.join(", ")
    #v(2em)
  ]
  
  // Table of contents
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

  if listofcode {
    listoffigures(title: "代码", kind: "code")
  }

  set align(left + top)
  par(justify: true, first-line-indent: 2em, leading: linespacing)[
    #doc
  ]

  if not blind {
    par(justify: true, first-line-indent: 2em, leading: linespacing)[
      #heading(numbering: none, "致谢")
      #acknowledgements
    ]

    partcounter.update(30)
    heading(numbering: none, "北京大学学位论文原创性声明和使用授权说明")
    align(center)[#heading(level: 2, numbering: none, outlined: false, "原创性声明")]
    par(justify: true, first-line-indent: 2em, leading: linespacing)[
      本人郑重声明：
      所呈交的学位论文，是本人在导师的指导下，独立进行研究工作所取得的成果。
      除文中已经注明引用的内容外，
      本论文不含任何其他个人或集体已经发表或撰写过的作品或成果。
      对本文的研究做出重要贡献的个人和集体，均已在文中以明确方式标明。
      本声明的法律结果由本人承担。

      #v(1em)

      #align(right)[
        论文作者签名
        #h(5em)
        日期：
        #h(2em)
        年
        #h(2em)
        月
        #h(2em)
        日
      ]

      #align(center)[#heading(level: 2, numbering: none, outlined: false, "学位论文使用授权说明")]
      #v(-0.33em, weak: true)
      #align(center)[#text(字号.五号)[（必须装订在提交学校图书馆的印刷本）]]
      #v(字号.小三)

      本人完全了解北京大学关于收集、保存、使用学位论文的规定，即：

      - 按照学校要求提交学位论文的印刷本和电子版本；
      - 学校有权保存学位论文的印刷本和电子版，并提供目录检索与阅览服务，在校园网上提供服务；
      - 学校可以采用影印、缩印、数字化或其它复制手段保存论文；
      - 因某种特殊原因须要延迟发布学位论文电子版，授权学校 #box[#rect(width: 9pt, height: 9pt)] 一年 /	 #box[#rect(width: 9pt, height: 9pt)] 两年 / #box[#rect(width: 9pt, height: 9pt)] 三年以后，在校园网上全文发布。

      #align(center)[（保密论文在解密后遵守此规定）]

      #v(1em)
      #align(right)[
        论文作者签名
        #h(5em)
        导师签名
        #h(5em)
        日期：
        #h(2em)
        年
        #h(2em)
        月
        #h(2em)
        日
      ]
    ]
  }
}
