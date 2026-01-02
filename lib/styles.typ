// lib/styles.typ - 样式规则
// 页眉页脚、heading、figure、ref 等 show/set 规则

#import "config.typ": (
  字号,
  字体,
  partcounter,
  chaptercounter,
  appendixcounter,
  footnotecounter,
  imagecounter,
  tablecounter,
  rawcounter,
  equationcounter,
  skippedstate,
)
#import "utils.typ": chinesenumbering

// 生成页眉内容
#let make-header(cheader: none) = context {
  // 使用逻辑页码（显示的页码）而非物理页码进行奇偶判断
  let logical-page = counter(page).at(here()).first()
  
  // 检查当前页面是否是正文第一页（包含第一个带编号的一级标题）
  // 在这种情况下，页眉渲染时页码还未重置，需要特殊处理
  let headings-after = query(selector(heading.where(level: 1)).after(here()))
  let is-body-first-page = headings-after.len() > 0 and headings-after.first().numbering != none and partcounter.at(here()).first() < 21
  
  // 如果是正文第一页，强制视为奇数页（页码将被重置为1）
  let is-odd = if is-body-first-page { true } else { calc.odd(logical-page) }
  let is-even = if is-body-first-page { false } else { calc.even(logical-page) }
  
  if skippedstate.at(here()) and is-even { return }
  [
    #set text(字号.五号)
    #set align(center)
    #let header-gap = -0.6em
    #if partcounter.at(here()).at(0) < 10 {
      let headings = query(selector(heading).after(here()))
      let next_heading = if headings == () {
        ()
      } else {
        headings.first().body.text
      }

      // [HARDCODED] Handle the first page of Chinese abstract specailly
      if next_heading == "摘要" and is-odd {
        [
          #next_heading
          #v(header-gap)
          #line(length: 100%)
        ]
      }
    } else if partcounter.at(here()).at(0) <= 21 or is-body-first-page {
      if is-even {
        [
          #align(center, cheader)
          #v(header-gap)
          #line(length: 100%)
        ]
      } else {
        let footers = query(selector(<__footer__>).after(here()))
        if footers != () {
          let elems = query(
            heading.where(level: 1).before(footers.first().location()),
          )

          // [HARDCODED] Handle the last page of Chinese abstract specailly
          let el = elems.last()
          [
            #let numbering = if el.numbering == chinesenumbering {
              chinesenumbering(
                ..counter(heading).at(el.location()),
                location: el.location(),
              )
            } else if el.numbering != none {
              numbering(el.numbering, ..counter(heading).at(el.location()))
            }
            #if numbering != none {
              numbering
              h(0.5em)
            }
            #el.body
            #v(header-gap)
            #line(length: 100%)
          ]
        }
      }
    }
  ]
}

// 生成页脚内容
#let make-footer() = context {
  // 使用逻辑页码（显示的页码）而非物理页码进行奇偶判断
  let logical-page = counter(page).at(here()).first()
  if skippedstate.at(here()) and calc.even(logical-page) { return }
  [
    #set text(字号.五号)
    #set align(center)
    #if (
      query(selector(heading).before(here())).len() < 2
        or query(selector(heading).after(here())).len() == 0
    ) {
      // Skip cover, copyright and origin pages
    } else {
      let headers = query(selector(heading).before(here()))
      let part = partcounter.at(headers.last().location()).first()
      [
        #if part < 20 {
          numbering("I", counter(page).at(here()).first())
        } else {
          str(counter(page).at(here()).first())
        }
      ]
    }
    #label("__footer__")
  ]
}

// heading 样式规则
#let heading-show-rule(it, smartpagebreak, lastchapterbeforebody) = [
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
    if not it.body.text in ("学位论文使用授权说明", "版权声明") {
      smartpagebreak()
    }
    context {
      if it.body.text == "摘要" {
        partcounter.update(10)
        counter(page).update(1)
      } else {
        if it.body.text == lastchapterbeforebody {
          partcounter.update(20)
        }
        if it.numbering != none and partcounter.at(here()).first() < 21 {
          counter(page).update(1)
          partcounter.update(21)
        }
      }
    }
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

// figure 样式规则
#let figure-show-rule(it) = [
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
      #context { [代码] + it.counter.display(it.numbering) + "   " }
      #it.caption.body
    ]
    it.body
  }
]

// ref 样式规则
#let ref-show-rule(it) = {
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
        #chinesenumbering(
          chaptercounter.at(el_loc).first(),
          equationcounter.at(el_loc).first(),
          location: el_loc,
          brackets: true,
        )
      ])
      h(0.25em, weak: true)
    } else if el.func() == figure {
      // Handle figures
      if el.kind == image {
        link(el_loc, [
          图
          #chinesenumbering(
            chaptercounter.at(el_loc).first(),
            imagecounter.at(el_loc).first(),
            location: el_loc,
          )
        ])
      } else if el.kind == table {
        link(el_loc, [
          表
          #chinesenumbering(
            chaptercounter.at(el_loc).first(),
            tablecounter.at(el_loc).first(),
            location: el_loc,
          )
        ])
      } else if el.kind == "code" {
        link(el_loc, [
          代码
          #chinesenumbering(
            chaptercounter.at(el_loc).first(),
            rawcounter.at(el_loc).first(),
            location: el_loc,
          )
        ])
      }
    } else if el.func() == heading {
      // Handle headings
      if el.level == 1 {
        link(el_loc, chinesenumbering(
          ..counter(heading).at(el_loc),
          location: el_loc,
        ))
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

