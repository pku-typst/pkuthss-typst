// template.typ - PKU Thesis 模板入口
// 这是一个 facade，将所有模块功能组合并导出给用户

// ========== 命令行参数支持 ==========
// 通过 typst compile --input key=value 传递参数
// 支持的参数：
//   blind=true|false          - 盲审模式
//   preview=true|false        - 预览模式（链接显示蓝色）
//   alwaysstartodd=true|false - 章节是否总是从奇数页开始
//
// 示例：
//   typst compile thesis.typ --input blind=true
//   typst compile thesis.typ --input preview=false
//   typst compile thesis.typ --input alwaysstartodd=false

#let _parse-bool(value, default) = {
  if value == none { default } else if value == "true" or value == "1" {
    true
  } else if value == "false" or value == "0" { false } else { default }
}

#let _cli-blind = _parse-bool(sys.inputs.at("blind", default: none), none)
#let _cli-preview = _parse-bool(sys.inputs.at("preview", default: none), none)
#let _cli-alwaysstartodd = _parse-bool(
  sys.inputs.at("alwaysstartodd", default: none),
  none,
)

#import "@preview/itemize:0.2.0" as itemize
#import "@preview/cuti:0.4.0": show-cn-fakebold
#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.10": *
#import "@preview/gb7714-bilingual:0.2.3": *

// 导入并重导出所有公共符号
#import "lib/config.typ": appendix, 字体, 字号, 引用记号
#import "lib/utils.typ": chinesenumbering
#import "lib/components.typ": as-booktab, booktab, chineseoutline, codeblock, listoffigures
#import "lib/styles.typ": style-config, sym-bullet, sym-square-filled, sym-square-filled-rotated
#import "lib/pages.typ": *

// 高级用户 API：导出内部计数器和状态，用于自定义章节编号等场景
// 注意：这些是内部实现细节，未来版本可能会有变化
#import "lib/config.typ": appendixcounter, chaptercounter, partcounter, skippedstate

// 内部使用的模块
#import "lib/pages.typ"
#import "lib/styles.typ"

// 主配置函数
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
  date: (year: 2026, month: 6),
  // 学位类型："academic"（学术学位）或 "professional"（专业学位）
  degree-type: "academic",
  cabstract: [],
  ckeywords: (),
  eabstract: [],
  ekeywords: (),
  acknowledgements: [],
  // Word 模板中中文正文的首行缩进固定为 1.77em
  // 如果要求严格对应，请将 first-line-indent 设置为 1.77em
  // 这里设置为 2em 是为了更加美观
  first-line-indent: 2em,
  outlinedepth: 3,
  blind: false,
  listofimage: true,
  listoftable: true,
  listofcode: true,
  alwaysstartodd: true,
  // 是否清除原创性声明页的页眉和页码
  // 如果想要去除原创性声明页的页眉和页码，可以设置为 true
  // Word 模板中包含原创性声明页的页眉和页码，所以这里默认为 false
  cleandeclaration: false,
  // 预览模式下会将链接文本显示为蓝色
  // 在生成打印版时，可以设置为 false
  // 可通过命令行 --input preview=false 覆盖
  preview: true,
  // 代码块的额外参数
  codly-args: (:),
  // 引用记号自定义（图、表、代码、公式、节）
  // 示例：supplements: (图: "Figure", 表: "Table")
  supplements: (:),
  // 完全自定义参考文献样式，忽略以下参数
  override-bib: false,
  // 参考文献文件内容（需使用 read() 读取）
  // 示例：bibcontent: read("ref.bib")
  bibcontent: none,
  // 引用风格（默认为 "numeric"，可选 "author-date"）
  bibstyle: "numeric",
  // 引用版本（默认为 "2015"，可选 "2025"。注意 GB/T 7714-2025 标准从 2026 年 7 月 1 日开始实施）
  bibversion: "2015",
  // 仅 bibstyle: "author-date"。true（默认）时中文条目排在外文之前；false 时外文在前（传给 gb7714-bilingual 的 cn-first）
  bib-cn-first: true,
  // 仅 author-date 且中文作者：多音字校正，传给 auto-pinyin 的 to-pinyin(..., override: ...)
  // 键为汉字（字符串），值为 tone-num-end 音节串，如 ("重": "chong2")
  bib-pinyin-override: (:),
  doc,
) = {
  // 命令行参数覆盖配置文件中的值
  let blind = if _cli-blind != none { _cli-blind } else { blind }
  let preview = if _cli-preview != none { _cli-preview } else { preview }
  let alwaysstartodd = if _cli-alwaysstartodd != none {
    _cli-alwaysstartodd
  } else { alwaysstartodd }

  // 合并用户自定义引用记号与默认值
  let merged-supplements = 引用记号
  for (key, value) in supplements {
    merged-supplements.insert(key, value)
  }

  // 智能分页函数
  let smartpagebreak = () => {
    if alwaysstartodd {
      skippedstate.update(false)
      pagebreak(weak: true)
      skippedstate.update(true)
      pagebreak(to: "odd", weak: true)
      skippedstate.update(false)
    } else {
      pagebreak(weak: true)
    }
  }

  // ========== 页面设置 ==========
  set page(
    "a4",
    margin: (top: 3cm, bottom: 2.5cm, left: 2.6cm, right: 2.6cm),
    header: styles.make-header(cheader: cheader),
    footer: styles.make-footer(),
  )

  // ========== 全局样式 ==========
  set text(字号.正文, font: 字体.宋体, lang: "zh")
  set align(center + horizon)
  set heading(numbering: chinesenumbering)
  set figure(
    numbering: (..nums) => context {
      if appendixcounter.at(here()).first() < 10 {
        numbering("1.1", chaptercounter.at(here()).first(), ..nums)
      } else {
        numbering("A.1", chaptercounter.at(here()).first(), ..nums)
      }
    },
  )
  set math.equation(
    numbering: (..nums) => context {
      set text(font: 字体.宋体)
      if appendixcounter.at(here()).first() < 10 {
        numbering("(1.1)", chaptercounter.at(here()).first(), ..nums)
      } else {
        numbering("(A.1)", chaptercounter.at(here()).first(), ..nums)
      }
    },
  )
  set footnote(numbering: "①")
  show footnote.entry: it => {
    let loc = it.note.location()
    numbering(it.note.numbering, ..counter(footnote).at(loc))
    h(0.5em)
    it.note.body
  }

  show: itemize.default-enum-list.with(
    indent: (first-line-indent, 0.5em),
    label-baseline: "center", // 让 itemize 处理 marker 与文本的对齐
    list-config: (
      label-format: it => [#(
        sym-bullet(6pt),
        sym-square-filled(6pt),
        sym-square-filled-rotated(6pt),
      ).at(calc.rem(it.level - 1, 3))],
    ),
  )
  show strong: it => text(font: 字体.黑体, weight: "bold", it.body)
  show emph: it => text(font: 字体.楷体, style: "italic", it.body)
  show raw: set text(font: 字体.代码, size: 字号.五号, top-edge: "ascender")
  show: codly-init.with()
  codly(languages: codly-languages, ..codly-args)
  show link: it => if type(it.dest) == str and preview {
    text(fill: blue)[#it]
  } else { it }

  // 应用 show 规则
  show heading: it => styles.heading-show-rule(it, smartpagebreak)
  show figure: set block(breakable: true)
  show figure: it => styles.figure-show-rule(
    it,
    supplements: merged-supplements,
  )
  show ref: it => styles.ref-show-rule(it, supplements: merged-supplements)

  // ========== 封面页 ==========
  if blind {
    pages.cover-page-blind(
      cheader: cheader,
      ctitle: ctitle,
      etitle: etitle,
      cfirstmajor: cfirstmajor,
      cmajor: cmajor,
      blindid: blindid,
      date: date,
      degree-type: degree-type,
    )
  } else {
    pages.cover-page-normal(
      cthesisname: cthesisname,
      ctitle: ctitle,
      cauthor: cauthor,
      studentid: studentid,
      school: school,
      cmajor: cmajor,
      direction: direction,
      csupervisor: csupervisor,
      date: date,
      degree-type: degree-type,
    )
  }

  smartpagebreak()

  // ========== 版权声明页 ==========
  pages.copyright-page()

  smartpagebreak()

  // ========== 中文摘要 ==========
  set align(left + top)
  pages.abstract-page-zh(
    keywords: ckeywords,
    first-line-indent: first-line-indent,
  )[#cabstract]

  smartpagebreak()

  // ========== 英文摘要 ==========
  pages.abstract-page-en(
    etitle: etitle,
    eauthor: eauthor,
    emajor: emajor,
    esupervisor: esupervisor,
    ekeywords: ekeywords,
    blind: blind,
  )[#eabstract]

  // ========== 目录和列表 ==========
  chineseoutline(
    title: "目录",
    depth: outlinedepth,
    indent: true,
  )

  if listofimage {
    listoffigures(
      title: merged-supplements.插图列表,
      supplements: merged-supplements,
    )
  }

  if listoftable {
    listoffigures(
      title: merged-supplements.表格列表,
      kind: table,
      supplements: merged-supplements,
    )
  }

  if listofcode {
    listoffigures(
      title: merged-supplements.代码列表,
      kind: "code",
      supplements: merged-supplements,
    )
  }

  // ========== 正文 ==========
  set align(left + top)
  set par(
    justify: true,
    first-line-indent: (amount: first-line-indent, all: true),
    leading: 10.5pt,
    spacing: 10.5pt,
  )

  let use-gb7714 = not override-bib and bibcontent != none
  if use-gb7714 {
    let make-bib = () => gb7714-bibliography(
      title: heading(numbering: none)[参考文献],
      full-control: entries => {
        set text(字号.五号)
        let extra-spacing = if bibversion == "2015" { 1pt } else { 0pt }
        set par(
          leading: 6.5pt + extra-spacing,
          spacing: 6.5pt + 3pt + extra-spacing,
          hanging-indent: 1.66em,
          first-line-indent: 0em,
          justify: true,
        )
        if bibstyle == "author-date" {
          for e in entries [
            #e.labeled-rendered
            #parbreak()
          ]
        } else if bibstyle == "numeric" {
          for e in entries [
            [#e.order]
            #e.labeled-rendered
            #parbreak()
          ]
        }
      },
    )
    show metadata.where(value: "pkuthss-appendix"): _ => make-bib()
    init-gb7714.with(
      bibcontent,
      style: bibstyle,
      version: bibversion,
      cn-first: bib-cn-first,
      pinyin-override: bib-pinyin-override,
    )(doc)
    context {
      if query(metadata.where(value: "pkuthss-appendix")).len() == 0 {
        make-bib()
      }
    }
  } else {
    show bibliography: it => styles.bibliography-show-rule(it)
    doc
  }

  // ========== 致谢和声明（非盲审） ==========
  if not blind {
    pages.acknowledgements-page(
      first-line-indent: first-line-indent,
    )[#acknowledgements]
    pages.declaration-page(cleandeclaration: cleandeclaration)
  }
}



// 致谢页
#let acknowledgements-page(first-line-indent: 2em, acknowledgements) = {
  back-heading("致谢")
  set par(
    first-line-indent: first-line-indent,
    leading: 10.5pt,
    spacing: 10.5pt,
  )
  acknowledgements
}

// 原创性声明和授权说明页
#let declaration-page(cleandeclaration: false) = {
  // Word 模板中首行缩进固定为 2em
  set par(first-line-indent: 2em)
  back-heading(
    "北京大学学位论文原创性声明和使用授权说明",
    pagebreak: true,
    // Word 模板中原创性声明页有页眉，如果不想要，可以在这里手动关闭
    show-header: not cleandeclaration,
  )

  // 放置一个占位元素，用于清除页码
  if cleandeclaration {
    [#[]<__clean_declaration__>]
  }

  align(center)[#text(
    字号.四号,
    weight: "bold",
    show-cn-fakebold[原创性声明],
  )]
  v(1fr)
  [
    #set par(leading: 0.95em, spacing: 0.95em)
    本人郑重声明：所呈交的学位论文，是本人在导师的指导下，独立进行研究工作所取得的成果。除文中已经注明引用的内容外，本论文不含任何其他个人或集体已经发表或撰写过的作品或成果。对本文的研究做出重要贡献的个人和集体，均已在文中以明确方式标明。本声明的法律结果由本人承担。

    #v(1fr)

    #align(right)[
      论文作者签名：#h(10em)
      #v(1em)
      #h(5em)
      日期：
      #h(2em)
      年
      #h(2em)
      月
      #h(2em)
      日
    ]

    #v(1fr)
    #align(center)[#text(
      字号.四号,
      weight: "bold",
      show-cn-fakebold[学位论文使用授权说明],
    )]
    // #align(center)[#text(字号.五号)[（必须装订在提交学校图书馆的印刷本）]]
    #v(1fr)

    #set par(leading: 0.95em, spacing: 0.95em)
    本人完全了解北京大学关于收集、保存、使用学位论文的规定，即：
    #[
      #set list(
        marker: [#grid(
          columns: (auto, 1em),
          circle(radius: 0.3em, fill: black, stroke: none), [],
        )],
        indent: 1.5em,
      )
      - 按照学校要求提交学位论文的印刷本和电子版本；
      - 学校有权保存学位论文的印刷本和电子版，并提供目录检索与阅览服务，在校园网上提供服务；
      - 学校可以采用影印、缩印、数字化或其它复制手段保存论文；
      // - 因某种特殊原因须要延迟发布学位论文电子版，授权学校#box(width: 12pt, align(center, square(size: 9pt)))一年/#box(width: 12pt, align(center, square(size: 9pt)))两年/#box(width: 12pt, align(center, square(size: 9pt)))三年以后，在校园网上全文发布。
    ]
    // #v(4em)
    // #align(center)[（保密论文在解密后遵守此规定）]
    #v(2fr)
    #align(right)[
      论文作者签名：
      #h(5em)
      导师签名：
      #h(5em)
      #v(1em)
      日期：
      #h(2em)
      年
      #h(2em)
      月
      #h(2em)
      日
      #h(5em)
    ]
    #v(2fr)
  ]
}
