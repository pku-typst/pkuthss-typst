// lib/styles.typ - 样式规则
// 页眉页脚、heading、figure、ref 等 show/set 规则

#import "config.typ": (
  appendixcounter, chaptercounter, equationcounter, footnotecounter,
  imagecounter, partcounter, rawcounter, skippedstate, tablecounter, 字体, 字号,
)
#import "utils.typ": chinesenumbering

// 从 heading 提取元数据（从 supplement 中的 metadata 获取）
#let get-heading-meta(it) = {
  if it.supplement != none and it.supplement.func() == metadata {
    it.supplement.value
  } else {
    (:)
  }
}

// 生成页眉内容
#let make-header(cheader: none) = context {
  let part = partcounter.at(here()).first()

  // 使用逻辑页码进行奇偶判断
  let logical-page = counter(page).at(here()).first()

  // 查找当前页面之后的第一个 heading（用于处理页眉在 heading 之前渲染的情况）
  let headings-after = query(selector(heading.where(level: 1)).after(here()))
  let headings-before = query(selector(heading.where(level: 1)).before(here()))
  let current-physical-page = here().page()

  // 检查当前页面是否有 heading
  let current-page-heading = if headings-after.len() > 0 {
    let next-heading = headings-after.first()
    if next-heading.location().page() == current-physical-page {
      next-heading
    } else {
      none
    }
  } else {
    none
  }

  // 检查当前页面是否是前置部分第一页（摘要页，会将 part 更新为 1）
  let is-front-first-page = if current-page-heading != none {
    let meta = get-heading-meta(current-page-heading)
    meta.at("part", default: none) == 1
  } else {
    false
  }

  // 检查当前页面是否是正文第一页（包含第一个带编号的一级标题）
  let is-body-first-page = (
    current-page-heading != none
      and current-page-heading.numbering != none
      and part < 2
  )

  // 封面区域无页眉（但如果当前页是前置部分第一页则显示）
  if part == 0 and not is-front-first-page { return }

  // 如果是正文第一页，强制视为奇数页（页码将被重置为1）
  // 如果是前置部分第一页，也强制视为奇数页
  let is-odd = if is-body-first-page or is-front-first-page { true } else {
    calc.odd(logical-page)
  }
  let is-even = if is-body-first-page or is-front-first-page { false } else {
    calc.even(logical-page)
  }

  // 跳过的空白页不显示页眉
  if skippedstate.at(here()) and is-even { return }

  // 确定使用哪个 heading
  let el = if current-page-heading != none {
    current-page-heading
  } else if headings-before.len() > 0 {
    headings-before.last()
  } else {
    return
  }

  // 检查是否显示页眉
  let meta = get-heading-meta(el)
  if not meta.at("show-header", default: true) { return }

  let header-gap = -0.6em

  set text(字号.五号)
  set align(center)

  if is-even {
    // 偶数页：论文标题
    cheader
    v(header-gap)
    line(length: 100%)
  } else {
    // 奇数页：章节标题
    let header-text = meta.at("header", default: none)
    if header-text == none { header-text = el.body }

    // 编号（如果有）
    if el.numbering != none {
      chinesenumbering(
        ..counter(heading).at(el.location()),
        location: el.location(),
      )
      h(0.5em)
    }
    header-text
    v(header-gap)
    line(length: 100%)
  }
}

// 生成页脚内容
#let make-footer() = context {
  let part = partcounter.at(here()).first()

  // 封面区域无页脚
  if part == 0 { return }

  // 使用逻辑页码进行奇偶判断
  let logical-page = counter(page).at(here()).first()
  if skippedstate.at(here()) and calc.even(logical-page) { return }

  // 检查是否有足够的 heading
  if (
    query(selector(heading).before(here())).len() < 2
      or query(selector(heading).after(here())).len() == 0
  ) { return }

  set text(字号.五号)
  set align(center)

  let page-num = counter(page).at(here()).first()

  [
    #if part == 1 {
      numbering("I", page-num)
    } else {
      str(page-num)
    }
    #label("__footer__")
  ]
}

// heading 尺寸计算
#let get-heading-size(level) = {
  if level == 2 { 字号.四号 } else if level == 3 { 字号.中四 } else {
    字号.小四
  }
}

// heading 渲染（只渲染标题内容，不重新渲染整个 heading 元素）
#let sizedheading(it, size) = {
  set text(size)
  v(2em)
  if it.numbering != none {
    strong(counter(heading).display())
    h(0.5em)
  }
  strong(it.body)
  v(1em)
}

// heading 样式规则
#let heading-show-rule(it, smartpagebreak) = {
  // Cancel indentation for headings
  set par(first-line-indent: 0em)

  if it.level != 1 {
    return sizedheading(it, get-heading-size(it.level))
  }

  // 提取元数据
  let meta = get-heading-meta(it)
  let should-pagebreak = meta.at("pagebreak", default: true)
  let target-part = meta.at("part", default: none)
  let should-reset-page = meta.at("reset-page", default: false)

  // 1. 分页
  if should-pagebreak {
    smartpagebreak()
  }

  // 2. 状态更新
  context {
    let current-part = partcounter.at(here()).first()

    if target-part != none {
      // 显式指定 part
      partcounter.update(target-part)
    } else if it.numbering != none and current-part < 2 {
      // 第一个带编号章节自动进入正文
      partcounter.update(2)
    }

    // 重置页码
    if should-reset-page or (it.numbering != none and current-part < 2) {
      counter(page).update(1)
    }
  }

  // 3. 计数器重置（仅正文章节）
  if it.numbering != none {
    chaptercounter.step()
    footnotecounter.update(())
    imagecounter.update(())
    tablecounter.update(())
    rawcounter.update(())
    equationcounter.update(())
  }

  // 4. 渲染
  set align(center)
  sizedheading(it, 字号.三号)
}

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
