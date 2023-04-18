#import "template.typ": *
#import "contributors.typ": *

#let issue(id) = link("https://github.com/lucifer1004/pkuthss-typst/issues/" + str(id), text(fill: purple)[\##id])

#set enum(indent: 0em)
#set list(indent: 0em)

#heading(level: 2, numbering: none, "2023-04-18")

+ 完整实现了盲评格式的论文（#issue(5)）
  - 现在在 `blind = true` 时可以正确生成盲评格式的封面
+ 修改了 `lengthceil` 辅助函数的逻辑
  - 现在直接使用 `math.ceil` 函数，不再需要使用循环

#heading(level: 2, numbering: none, "2023-04-16")

+ 增加了编译所需的字体文件（#contributors.TeddyHuang-00）
+ 修正了论文标题样式（#contributors.TeddyHuang-00）
  - 现在分为两行显示的论文标题样式将同样正确应用 `bold` 选项
+ 增加了更多字号设置（#contributors.TeddyHuang-00）
  - 对应 Word 中初号至小七的所有字号

#heading(level: 2, numbering: none, "2023-04-14")

+ 适配了下一版本对 `query` 函数的改动
  - 这会导致模板与 Typst `v0.2.0` 版本的不兼容。如果你使用的是 Typst `v0.2.0` 版本，请使用此前版本的模板。

#heading(level: 2, numbering: none, "2023-04-13")

+ 修正了 `alwaysstartodd` 为 `false` 时，摘要页不显示页码的错误
+ 去除了版权声明中多余的空格
+ 增加了致谢页和原创性声明页
+ 增加了 `blind` 选项，设置为 `true` 时将生成盲评格式的论文。但目前只是去除了致谢和原创性声明，还需要进一步完善。

#heading(level: 2, numbering: none, "2023-04-12")

+ 将代码块的首选字体改为 `New Computer Modern Mono`
  - Typst `v0.2.0` 版本内嵌了 `New Computer Modern` 字体，虽然并未同时提供 `New Computer Modern Mono`，这里将本模板的代码块字体相应进行了调整。`New Computer Modern Mono` 的字体文件现在在 `fonts` 目录中提供，同时删除了原来的 `CMU Typewriter Text` 字体文件

#heading(level: 2, numbering: none, "2023-04-11")

+ 将代码块的首选字体改为 `CMU Typewriter Text`
  - `CMU Typewriter Text` 的字体文件已经加入 `fonts` 目录，可以通过在运行 Typst 时使用 `--font-path` 参数指定 `fonts` 目录来使用

#heading(level: 2, numbering: none, "2023-04-10")

+ 正确设置了语言类型
  - 现在设置为 `zh`，之前错误设置为了 `cn`
+ 正确设置了首行缩进
  - 现在正文环境的首行缩进为 #2em
+ 修正了引用图、表、公式等时在前后产生的额外空白
  - 现在在 "@web" 等前后增加了 `h(0em, weak: true)`
+ 修正了公式后编号的字体
  - 现在设置为 #字体.宋体
+ 修正了图题、表题等的字号
  - 现在设置为 #字号.五号
+ 修正了目录中没有对 `outlined` 进行筛选的问题
  - 现在目录中只会显示 `outlined` 为 `true` 的条目
+ 增加了对三线表的支持
  - 现在可以通过 `booktab` 命令插入三线表
+ 增加了对含标题代码块的支持
  - 现在可以通过 `codeblock` 命令插入代码块
+ 增加了插图索引、表格索引和代码索引功能
  - 插图索引：使用 `listofimage` 选项启用或关闭
  - 表格索引：使用 `listoftable` 选项启用或关闭
  - 代码索引：使用 `listofcode` 选项启用或关闭
+ 初步支持在奇数页开始的功能
  - 使用 `alwaysstartodd` 选项启用或关闭
