// lib/pages/cover.typ - 标题页组件
// 提供细粒度的标题页构建模块，支持不同学位类型和院系要求

#import "@preview/cuti:0.4.0": show-cn-fakebold
#import "../config.typ": 字体, 字号
#import "../utils.typ": chinesenumber, chineseyear, split-text-by-width
#import "../styles.typ": sym-box-checked, sym-box-unchecked

#let pku-header() = {
  set text(size: 字号.一号)
  block(
    grid(
      align: center + horizon,
      columns: (auto, auto),
      gutter: 0.4em,
      image("../../assets/pkulogo.svg", height: 2.4em, fit: "contain"),
      image("../../assets/pkuword.svg", height: 1.6em, fit: "contain"),
    ),
  )
}

#let thesis-title(title) = {
  text(size: 字号.小初)[#strong(title)]
}

// 学位类型勾选框
// degree-type: "academic" | "professional"
#let degree-type-checkbox(degree-type) = {
  assert(
    degree-type == "academic" or degree-type == "professional",
    message: "degree-type 必须是 \"academic\" 或 \"professional\"，当前值: "
      + repr(degree-type),
  )
  let academic-box = if degree-type == "academic" {
    sym-box-checked(12pt)
  } else {
    sym-box-unchecked(12pt)
  }
  let professional-box = if degree-type == "professional" {
    sym-box-checked(12pt)
  } else {
    sym-box-unchecked(12pt)
  }
  set align(center + horizon)
  [#academic-box#h(0.5em)学术学位#h(4 * 0.5em)#professional-box#h(0.5em)专业学位]
}

#let date-zh(date) = {
  text(font: 字体.宋体)[
    #chineseyear(date.year()) *年* #chinesenumber(date.month()) *月*
  ]
}

#let field-grid(
  fields,
  name-width: 4em,
  value-width: 7.63cm,
  row-height: 1.5em,
  line-stroke: 0.5pt,
) = {
  let raw-data = fields
    .pairs()
    .filter(((_, v)) => v != none)
    .map(((k, v)) => (
      (stack(dir: ltr, spacing: 1fr, ..k.clusters().map(strong))),
      strong[：],
      text(font: 字体.仿宋, v),
    ))
  grid(
    align: center + horizon,
    columns: (name-width, 0.5em, value-width),
    stroke: (x, y) => if x == 2 { (bottom: line-stroke) },
    rows: row-height,
    row-gutter: 0.5em,
    column-gutter: (0cm, 8pt),
    ..raw-data.flatten(),
  )
}

#let resolve-left(margin) = {
  if margin == auto {
    2.5 / 21 * calc.min(page.width, page.height)
  } else if type(margin) == length {
    margin
  } else if type(margin) == dictionary {
    margin.left
  } else {
    margin
  }
}

#let title-block(
  zh-title: none,
  en-title: none,
  title-width: 10.16cm,
  title-block-height: 1.48cm,
  underline-offset: 0.6em,
) = {
  grid(
    columns: (2.75cm, title-width),
    rows: title-block-height,
    align: center + horizon,
    text(size: 字号.二号, weight: "regular")[题目：],
    context {
      set align(top)
      set text(size: 字号.一号, weight: "bold")
      let pos = here().position()
      set par(justify: true, leading: title-block-height - 0.8em)
      set par.line(
        numbering: (..) => {
          place(
            dx: pos.x - resolve-left(page.margin),
            dy: underline-offset,
            place(left, line(length: title-width)),
          )
        },
        number-clearance: 0pt,
        number-margin: left,
      )
      v((title-block-height - 1em) / 2)
      if zh-title != none {
        set text(lang: "zh")
        show: show-cn-fakebold
        strong(zh-title)
      }
      linebreak()
      if en-title != none {
        set text(lang: "en")
        strong(en-title)
      }
    },
  )
}

/// 封面
#let cover-page(
  school-header: pku-header(),
  thesis-name: [博士研究生学位论文],
  zh-title: [论文中文标题],
  en-title: [English Title of Your Dissertation],
  author: "张三",
  student-id: "2200010001",
  school: [请填写院系名称],
  major: [请填写专业名称],
  research-direction: [请填写研究方向],
  supervisor: [请填写导师姓名],
  extra-fields: (:),
  degree-type: "academic",
  date: datetime.today(),
  // 布局&样式控制
  title-width: 10.16cm,
  title-block-height: 1.48cm,
  title-underline-offset: 0.6em,
  after-header-v-space: 0.32cm,
  before-title-v-space: 1.25cm,
  after-fields-v-space: 2.4cm,
  before-date-v-space: 1.1cm,
) = page({
  set document(title: zh-title, author: (author,))

  set align(center + top)
  school-header
  v(after-header-v-space, weak: true)
  thesis-title(thesis-name)
  v(before-title-v-space, weak: true)
  title-block(
    zh-title: zh-title,
    en-title: en-title,
    title-width: title-width,
    title-block-height: title-block-height,
    underline-offset: title-underline-offset,
  )

  set text(size: 字号.三号)
  set align(bottom)
  field-grid((
    "姓名": author,
    "学号": student-id,
    "院系": school,
    "专业": major,
    "研究方向": research-direction,
    "导师姓名": supervisor,
    ..extra-fields,
  ))
  v(after-fields-v-space, weak: true)
  if degree-type != none {
    set text(font: 字体.仿宋)
    degree-type-checkbox(degree-type)
  }
  v(before-date-v-space, weak: true)
  if date != none {
    date-zh(date)
  }
})
