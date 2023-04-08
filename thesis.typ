// #import "template.typ": *

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
  #set text(font: 字体.仿宋) 
  #it
]

#let textbf(it) = [
  #set text(font: 字体.黑体)
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
  let i = 0
  let now = ""
  let ret = ()
  while i < n {
    let c = chars.at(i)
    let nxt = now + c
    let overflow = style(styles => if measure(nxt, styles).width > width { true } else { false })
    if overflow == style(styles => true) {
      ret.push(now)
      ret.push(line(length: 100%))
      now = c
    } else {
      now = nxt
    }
    i = i + 1
  }
  if now.len() > 0 {
    ret.push(now)
    ret.push(line(length: 100%))
  }

  ret
}

#let chineseoutline(title: "Contents", depth: none, indent: false) = {
  heading(title, numbering: none)
  locate(it => {
    let elements = query(heading, after: it)

    for i, el in elements {
      if depth != none and el.level > depth { continue }

      let maybe_number = if el.numbering != none {
        numbering(el.numbering, ..counter(heading).at(el.location()))
        " "
      }
      let line = {
        if indent {
          h(1em * (el.level - 1 ))
        }

        if el.level == 1 {
          v(weak: true, 0.5em)
          set text(font: 字体.黑体)
          maybe_number
          el.body
        } else {
          maybe_number
          el.body
        }

        // Filler dots
        if el.level == 1 {
          box(width: 1fr, h(3pt) + box(width: 1fr) + h(3pt))
        } else {
          box(width: 1fr, h(3pt) + box(width: 1fr, repeat[.]) + h(3pt))
        }
        
        // Page number
        let page-number = counter(page).at(el.location()).first()
        str(page-number)

        linebreak()
      }

      link(el.location(), line)
    }
  })
}

#let chapter(title, number: true) = {
  set align(center)
  set text(字号.三号, font: 字体.黑体)
  pagebreak(weak: true)
  v(1em)
  heading(level: 1, title)
  v(1em)
}

#let section(title) = {
  set text(字号.五号, font: 字体.黑体)
  heading(level: 2, title)
}

#let subsection(title) = {
  set text(字号.五号, font: 字体.黑体)
  heading(level: 3, title)
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
  set page("a4",
    header: locate(loc => {
      [
        #let elemsbefore = query(heading, before: loc)
        #let hasheader = false
        #for i, el in elemsbefore {
          if el.level == 1 {
            hasheader = true
            break
          }
        }
        #if not hasheader {
        } else {
          set text(字号.五号)
          if calc.even(loc.page()) {
            [
              #align(center, cheader)
              #v(-1em)
              #line(length: 100%)
            ]
          } else {
            let elems = query(heading, after: loc)
            if elems == () {
            } else {
              let i = 0
              while elems.at(i).level != 1 {
              i = i + 1
            }
            let el = elems.at(i)
            [
              #set align(center)
              #if el.numbering != none {
                numbering(el.numbering, ..counter(heading).at(el.location()))
              }
              #h(0.5em)
              #elems.at(i).body
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
        #str(loc.page())
      ]}),
  )

  set text(字号.一号, font: 字体.宋体, lang: "cn")
  set align(center + horizon)
  set heading(numbering: chinesenumbering)

  show heading: it => block[
    #let sizedheading(it, size) = [
      #set text(size)
      #if it.numbering != none {
        counter(heading).display()
        h(0.5em)
      }
      #it.body.text
    ]

    #set text(font: 字体.黑体)
    #if it.level == 1 {
      set align(center)
      sizedheading(it, 字号.三号)
    } else if it.level == 2 {
      sizedheading(it, 字号.四号)
    } else if it.level == 3 {
      sizedheading(it, 字号.中四)
    } else {
      sizedheading(it, 字号.小四)
    }
  ]

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
      #grid(
        rows: (auto, auto),
        row-gutter: 0.2em,
        ..chineseunderline(ctitle, width: 300pt),
      )
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

  pagebreak()

  par(justify: true)[
    *Abstract* \
    #abstract
  ]

  pagebreak()

  set align(center + top)
  set text(字号.小三)
  textbf("目录")
  set text(字号.小四)
  chineseoutline(
    title: "",
    indent: true,
  )
  pagebreak()

  set align(left + top)
  par(justify: true)[
    #doc
  ]
}

#show: doc => conf(
  abstract: lorem(80),
  doc,
)

#chapter("绪论")

#section("研究背景与意义")

#subsection("研究背景")

$ a^b = b^c $

#chapter("理论")

#section("理论一")

#section("理论二")

#chapter("方法")

#section("方法一")

#section("方法二")

#chapter("应用")

#section("应用一")

#section("应用二")

#chapter("结论与展望")

@wang2010guide

@kopka2004guide

#pagebreak()
#bibliography("ref.bib",
  title: "参考文献",
  style: "ieee"
)
