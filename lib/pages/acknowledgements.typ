#import "../config.typ": back-heading

#let acknowledgements-page(first-line-indent: 2em, acknowledgements) = {
  back-heading("致谢")
  set par(
    first-line-indent: first-line-indent,
    leading: 10.5pt,
    spacing: 10.5pt,
  )
  acknowledgements
}
