#import "../components/heading.typ": front-heading

/// 版权声明页
#let copyright-page(linespacing: 10pt) = {
  set align(left + top)
  set text(字号.小四)

  // Word 模板中，版权声明页标题为 2 倍行距，段落前后无额外间距
  // 在黑体三号字情况下，对应行距为 16pt * 1.3 * 2
  front-heading(
    [版权声明],
    pagebreak: false,
    linespacing: 字号.三号 * 1.3 * 2,
    spacing-before: 0pt,
    spacing-after: 0pt,
  )
  linebreak()

  // 版权声明页的首行缩进固定为 2em，Word 行距为 2 倍行距
  // 在宋体小四号字情况下，对应行距 31.2 pt
  set par(
    first-line-indent: 2em,
    leading: 字号.小四 * 1.3,
    spacing: 字号.小四 * 1.3,
  )
  set text(top-edge: 0.8 * 字号.小四 * 1.3, bottom-edge: -0.2 * 字号.小四 * 1.3)
  [
    任何收存和保管本论文各种版本的单位和个人未经本论文作者同意，不得将本论文转借他人，亦不得随意复制、抄录、拍照或以任何方式传播。否则，引起有碍作者著作权之问题，将可能承担法律责任。
  ]
}
