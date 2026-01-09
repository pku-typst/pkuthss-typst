#import "template.typ": *
#import "contributors.typ": *

#let issue(id) = link(
  "https://github.com/pku-typst/pkuthss-typst/issues/" + str(id),
  text(fill: purple)[\##id],
)
#let pr(id) = link(
  "https://github.com/pku-typst/pkuthss-typst/pull/" + str(id),
  text(fill: green.lighten(20%))[\##id],
)

#set enum(indent: 0em)
#set list(indent: 0em)
#set heading(numbering: none)

== 2026-01-10 #contributors.lucifer1004 #pr(30)

+ 优化了中文数字转换问题：
  - 使用 Typst 原生 `numbering` 函数替代自定义的 `chinesenumber` 函数。
  - 现在支持 Typst `int` 范围内的中文数字转换。

== 2026-01-10 #contributors.lucifer1004 #pr(29)

+ 模板已发布到 Typst Universe，现在可以通过 `typst init @preview/modern-pku-thesis:0.1.0` 创建项目。
+ 模板更名为 `modern-pku-thesis`。
+ 更新了 README 和文档，新增 Typst Universe 安装方式说明。
+ 修复了版权声明中的额外空格。

== 2026-01-03 #contributors.lucifer1004 #pr(27)

+ 重构了目录系统：
  - 使用 Typst 原生 `outline` + `show outline.entry` 替代手动 query 实现。
  - 使用 `outline.entry.page()` 获取页码，消除了对 `<__footer__>` label 的依赖。
  - 移除了 `lengthceil` 辅助函数。
  - 图表列表编号现在包含前缀（如 "图 3.1"、"表 3.1"）。
+ 新增引用记号自定义功能：
  - 新增 `supplements` 配置项，支持自定义图、表、代码、公式、节的引用前缀。
  - 支持自定义插图列表、表格列表、代码列表的页面标题。
  - 使用闭包传参方式将配置传递给 `figure-show-rule`、`ref-show-rule`、`listoffigures`。
+ 调整列表样式以匹配 Word 模板：
  - 列表 bullet 使用自绘图形（实心圆、实心方形、45° 菱形）替代 Unicode 符号。
+ 其他改进：
  - 设置 `show figure: set block(breakable: true)` 允许表格跨页显示。
  - 页脚页码字号从五号（10.5pt）改为小五（9pt）。
  - 更新了 `AGENTS.md` 和 `thesis.typ` 文档。

== 2026-01-03 #contributors.lucifer1004 #pr(26)

+ 重构了模板架构：
  - 简化了 `partcounter` 状态机（从 5 状态简化为 3 状态）。
  - 使用 `heading` 的 `supplement` 字段传递元数据，消除了对标题文本的硬编码匹配。
  - 更新了 `AGENTS.md` 文档，详细记录了内部架构设计。
+ 新增功能：
  - 新增 `degree-type` 配置项，支持选择"学术学位"或"专业学位"。
  - 新增命令行参数支持（`--input blind=true/false`、`--input preview=true/false`、`--input alwaysstartodd=true/false`）。
  - 引入 #link("https://typst.app/universe/package/codly/", `codly`) 包，支持代码块语法高亮。
  - 新增 `preview` 配置项，控制链接文本是否显示为蓝色。
  - `booktab` 组件现代化重构，支持原生 `table` 参数，新增 `outlined` 参数。
  - 新增 `bibliography-show-rule`，设置参考文献悬挂缩进和行距以匹配 Word 模板。
+ 修复问题：
  - 修复了图片后段落不自动缩进的问题（使用 `first-line-indent: (amount: 2em, all: true)`）。
  - 修复了英文摘要内容过长时与 KEY WORDS 重叠的问题。
  - 修复了目录中原创性声明页页码显示为 0 的问题。
  - 修复了子标题（如 3.1）被错误缩进的问题。
  - 修复了盲审封面中学位类型勾选框对齐问题。
  - 修复了参考文献编号与文字基线不对齐的问题。
+ 文档完善：
  - 将 `thesis.typ` 扩展为完整的项目文档，包含模板配置、Typst 基础语法、常见问题解答等。

== 2026-01-02 #contributors.lucifer1004 #contributors.TOMATOFQY #pr(26)

+ 引入 #link("https://typst.app/universe/package/itemize/", `itemize`) 包，修复了列表编号和文本内容衬线不对齐的问题。
+ 引入 #link("https://typst.app/universe/package/cuti/", `cuti`) 包，对部分需要加粗的中文文本进行了处理。
+ 对照 #link("https://grs.pku.edu.cn/docs/2024-02/20240229092001843564.doc", "北京大学博士研究生学位论文格式模板（2024）") 进行了若干调整：
  - 调整了全局的行距。
  - 调整了封面样式（#pr(19)）。
  - 调整了英文摘要的样式（#issue(20)）。
  - 调整了目录中一级标题的样式（#pr(16)）。
  - 修改了脚注数字编号的样式。
  - 调整了原创性声明和学位论文使用授权说明的样式。
  - 参考文献默认采用 `gb-7714-2015-numeric` 样式（#issue(6)）。

== 2026-01-02 #contributors.gzz2000 #pr(25)

+ 修复了#pr(24)引入的错误。

== 2025-12-22 #contributors.yefan-zhi #pr(24)

+ 修复了年份中〇的显示问题。
+ 增加了学位类型（#issue(23)）。
+ 修复了一系列页码问题（#issue(18)）。

== 2025-03-04 #contributors.wjsoj #pr(22)

+ 修复了标题与下划线重叠的问题。

== 2025-03-03 #contributors.wjsoj #pr(21)

+ 修复了与 Typst `v0.13.0` 版本不兼容的问题。

== 2023-11-22 #contributors.lucifer1004

+ 进一步优化了 `alwaysstartodd=true` 时的表现，现在插入的空白页不会显示页眉和页脚。

== 2023-11-20 #contributors.lucifer1004

+ 修正了 `blind=true` 时，使用已经删除的 `textbf` 函数导致编译失败的问题（#issue(14)）。
+ 修正了 `alwaysstartodd=true` 时的处理逻辑（#issue(4)）。
+ 修正了 `v0.9` 版本下图表标题错误的问题。

== 2023-05-30 #contributors.lucifer1004

+ 设置每一章的脚注编号从 1 开始。
  - 同时增加了脚注的示例。

== 2023-05-22 #contributors.lucifer1004

+ 修正了 `booktab` 不能被正确引用的问题（#issue(12)）。

== 2023-05-06 #contributors.lucifer1004

+ 修改了#strong[黑体]和#emph[斜体]前后空白的处理逻辑：
  - 现在如果希望前后不出现空白，应该直接使用 `#strong[粗体]` 或 `#emph[斜体]` ，而不是 `*粗体*` 或 `_斜体_`；
  - 因为语法解析的问题,使用 `_中文_` 时需要在前后加上空格才能被正确识别为 `emph`,但前后的空格也将被渲染出来。原来的解决方案是人为添加了 `h(0em, weak: true)`，但这又会导致在 `strong` 或 `emph` 块的结尾为西文字母时，手动插入的空格字符会被忽略；
  - 作者认为，目前的处理方式能够适应更多的需求。
+ 修正了#emph[斜体]对西文字母无效的问题（#issue(10)）。

== 2023-05-03 #contributors.lucifer1004

+ 使用Typst `v0.3.0` 中提供的 `array` 类型的 `zip` 方法代替原 `helpers.typ` 中的 `zip` 函数。

== 2023-04-26 #contributors.lucifer1004

+ 适配 Typst `v0.3.0`，将 `calc.mod` 改为 `calc.rem`。
+ 简化了 `show ref` 中的逻辑：
  - 现在提供了 `element`，可以少进行一次 `query`。

== 2023-04-20 #contributors.lucifer1004

+ 不再给目录和索引页中填充空隙用的 `repeat([.])` 添加链接（参见#link("https://github.com/typst/typst/issues/758", text(fill: purple)[typst/typst\#758])）。

== 2023-04-19 #contributors.lucifer1004

+ 修复了附录中没有一级标题时使用行间公式导致无法编译的错误（#issue(7)）。

== 2023-04-18 #contributors.lucifer1004

+ 完整实现了盲评格式的论文（#issue(5)）：
  - 现在在 `blind = true` 时可以正确生成盲评格式的封面。
+ 修改了 `lengthceil` 辅助函数的逻辑：
  - 现在直接使用 `math.ceil` 函数，不再需要使用循环。

== 2023-04-16 #contributors.TeddyHuang-00 #pr(2)

+ 增加了编译所需的字体文件。
+ 修正了论文标题样式：
  - 现在分为两行显示的论文标题样式将同样正确应用 `bold` 选项。
+ 增加了更多字号设置：
  - 对应 Word 中初号至小七的所有字号。

== 2023-04-14 #contributors.lucifer1004

+ 适配了下一版本对 `query` 函数的改动：
  - 这会导致模板与 Typst `v0.2.0` 版本的不兼容。如果你使用的是 Typst `v0.2.0` 版本，请使用此前版本的模板。

== 2023-04-13 #contributors.lucifer1004

+ 修正了 `alwaysstartodd` 为 `false` 时，摘要页不显示页码的错误。
+ 去除了版权声明中多余的空格。
+ 增加了致谢页和原创性声明页。
+ 增加了 `blind` 选项，设置为 `true` 时将生成盲评格式的论文。但目前只是去除了致谢和原创性声明，还需要进一步完善。

== 2023-04-12 #contributors.lucifer1004

+ 将代码块的首选字体改为 `New Computer Modern Mono`：
  - Typst `v0.2.0` 版本内嵌了 `New Computer Modern` 字体，虽然并未同时提供 `New Computer Modern Mono`，这里将本模板的代码块字体相应进行了调整。`New Computer Modern Mono` 的字体文件现在在 `fonts` 目录中提供，同时删除了原来的 `CMU Typewriter Text` 字体文件。

== 2023-04-11 #contributors.lucifer1004

+ 将代码块的首选字体改为 `CMU Typewriter Text`：
  - `CMU Typewriter Text` 的字体文件已经加入 `fonts` 目录，可以通过在运行 Typst 时使用 `--font-path` 参数指定 `fonts` 目录来使用。

== 2023-04-10 #contributors.lucifer1004

+ 正确设置了语言类型：
  - 现在设置为 `zh`，之前错误设置为了 `cn`。
+ 正确设置了首行缩进：
  - 现在正文环境的首行缩进为 #2em。
+ 修正了引用图、表、公式等时在前后产生的额外空白：
  - 现在在 `@web` 等前后增加了 `h(0em, weak: true)`。
+ 修正了公式后编号的字体：
  - 现在设置为 #字体.宋体。
+ 修正了图题、表题等的字号：
  - 现在设置为 #字号.五号。
+ 修正了目录中没有对 `outlined` 进行筛选的问题：
  - 现在目录中只会显示 `outlined` 为 `true` 的条目。
+ 增加了对三线表的支持：
  - 现在可以通过 `booktab` 命令插入三线表。
+ 增加了对含标题代码块的支持：
  - 现在可以通过 `codeblock` 命令插入代码块。
+ 增加了插图索引、表格索引和代码索引功能：
  - 插图索引：使用 `listofimage` 选项启用或关闭；
  - 表格索引：使用 `listoftable` 选项启用或关闭；
  - 代码索引：使用 `listofcode` 选项启用或关闭。
+ 初步支持在奇数页开始的功能：
  - 使用 `alwaysstartodd` 选项启用或关闭。
