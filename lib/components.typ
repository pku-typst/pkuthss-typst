// lib/components.typ - UI 组件
// 目录、图表列表、代码块、三线表等可复用组件

#import "config.typ": 字号, partcounter, chaptercounter
#import "utils.typ": lengthceil, chinesenumbering, bodytotextwithtrim

// 中文目录
#let chineseoutline(title: "目录", depth: none, indent: false) = {
  heading(title, numbering: none, outlined: false)
  context {
    let it = here()
    let elements = query(heading.where(outlined: true).after(it))

    for el in elements {
      // Skip list of images and list of tables
      if partcounter.at(el.location()).first() < 20 and el.numbering == none {
        continue
      }

      // Skip headings that are too deep
      if depth != none and el.level > depth { continue }

      let maybe_number = if el.numbering != none {
        if el.numbering == chinesenumbering {
          chinesenumbering(
            ..counter(heading).at(el.location()),
            location: el.location(),
          )
        } else {
          numbering(el.numbering, ..counter(heading).at(el.location()))
        }
        h(0.5em)
      }

      let line = {
        if indent {
          h(1em * (el.level - 1))
        }

        if el.level == 1 {
          v(0.5em, weak: true)
        }

        if maybe_number != none {
          context {
            let width = measure(maybe_number).width
            box(
              width: lengthceil(width),
              link(el.location(), if el.level == 1 {
                strong(maybe_number)
              } else {
                maybe_number
              }),
            )
          }
        }

        link(el.location(), if el.level == 1 {
          strong(el.body)
        } else {
          el.body
        })

        // Filler dots
        box(width: 1fr, h(10pt) + box(width: 1fr, repeat[.]) + h(10pt))

        // Page number
        let footer = query(selector(<__footer__>).after(el.location()))
        let page_number = if footer == () {
          0
        } else {
          counter(page).at(footer.first().location()).first()
        }

        str(page_number)

        linebreak()
        v(-0.2em)
      }

      line
    }
  }
}

// 图表列表（插图、表格、代码）
#let listoffigures(title: "插图", kind: image) = {
  heading(title, numbering: none, outlined: false)
  context {
    let it = here()
    let elements = query(figure.where(kind: kind).after(it))

    for el in elements {
      let maybe_number = {
        let el_loc = el.location()
        chinesenumbering(
          chaptercounter.at(el_loc).first(),
          counter(figure.where(kind: kind)).at(el_loc).first(),
          location: el_loc,
        )
        h(0.5em)
      }
      let line = {
        context {
          let width = measure(maybe_number).width
          box(
            width: lengthceil(width),
            link(el.location(), maybe_number),
          )
        }

        link(el.location(), bodytotextwithtrim(el.caption.body))

        // Filler dots
        box(width: 1fr, h(10pt) + box(width: 1fr, repeat[.]) + h(10pt))

        // Page number
        let footers = query(selector(<__footer__>).after(el.location()))
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
  }
}

// 代码块组件
#let codeblock(raw, caption: none, outline: false) = {
  figure(
    if outline {
      block(width: 100%)[
        #set align(left)
        #raw
      ]
    } else {
      set align(left)
      raw
    },
    caption: caption,
    kind: "code",
    supplement: "",
  )
}

// 三线表组件
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

  figure(
    block(
      width: width,
      grid(
        columns: auto,
        row-gutter: 1em,
        line(length: 100%),
        [
          #set align(center)
          #box(
            width: 100% - 1em,
            grid(
              columns: columns,
              ..headers
                .zip(aligns)
                .map(it => [
                  #set align(it.last())
                  #strong(it.first())
                ])
            ),
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
              ..contents
                .zip(content_aligns)
                .map(it => [
                  #set align(it.last())
                  #it.first()
                ])
            ),
          )
        ],
        line(length: 100%),
      ),
    ),
    caption: caption,
    kind: table,
  )
}
