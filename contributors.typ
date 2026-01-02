#let contributor-link(name, url) = link(url, text(fill: blue)[#name])

#let contributors-names = (
  "lucifer1004",
  "TeddyHuang-00",
  "wjsoj",
  "gzz2000",
  "yefan-zhi",
  "TOMATOFQY",
)

#let contributors = (:)
#for name in contributors-names {
  contributors.insert(name, contributor-link(
    "@" + name,
    "https://github.com/" + name,
  ))
}
