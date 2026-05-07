#import "../utils.typ": 字号
#import "../components/heading.typ": front-heading

/// 中文摘要页
#let abstract-page-zh(
  keywords: (),
  first-line-indent: 2em,
  zh-abstract,
) = {
  // Word 模板中默认为 20pt 行距
  // 调整 text(top-edge:, bottom-edge:) 的方式可以更完美地匹配行距
  // 但是会导致列表编号和列表内容无法对齐
  // 这里选择基于经验的配置
  set par(leading: 10.5pt, spacing: 10.5pt, justify: true)
  front-heading("摘要", enter-front: true, header: "摘要")
  set par(first-line-indent: first-line-indent)
  zh-abstract
  // 如果发现关键词和内容挤到一起，或者关键词在下一页顶部
  // 可以插入 pagebreak() 手动分页
  v(1fr)
  [关键词：]
  keywords.join("，")
  v(1em)
}

/// 英文摘要页
#let abstract-page-en(
  keywords: (),
  en-abstract,
  title: none,
  author: none,
  major: none,
  supervisor: none,
  blind: false,
) = {
  // 英文摘要标题，页眉为 ABSTRACT
  heading(
    numbering: none,
    outlined: false,
    supplement: [#metadata((
      pagebreak: true,
      show-header: true,
      header: "ABSTRACT",
      spacing-before: 24pt,
      spacing-after: 8pt,
      linespacing: 2em,
      font: (size: 字号.三号, font: "Arial", weight: "bold"),
    ))],
  )[ABSTRACT]

  // Word 模板中正文仍然是 20pt 行距
  // 对于纯英文字体，测试下来 12.5pt 的匹配效果较好
  set par(spacing: 12.5pt, leading: 12.5pt, justify: true)
  // if not blind {
  //   [
  //     #set align(center)
  //     #author \(#major\) \
  //     Supervised by #supervisor
  //   ]
  // }
  // Word 模板中英文摘要的首行缩进固定为 0.74cm
  set par(first-line-indent: 0.74cm, justify: true)
  en-abstract
  v(1fr)
  let keyword-prefix = if keywords.len() == 1 {
    "KEY WORD: "
  } else {
    "KEY WORDS: "
  }
  [#keyword-prefix]
  keywords.join(", ")
  v(1em)
}
