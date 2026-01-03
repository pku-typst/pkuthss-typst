#import "../template.typ": booktab

== 自定义页眉页脚

本模板的页眉页脚通过 `lib/styles.typ` 中的 `make-header` 和 `make-footer` 函数控制。如需自定义，可以修改这些函数。

页眉规则：
- 奇数页显示当前章节标题
- 偶数页显示论文标题（`cheader` 参数）
- 封面区域无页眉

页脚规则：
- 前置部分（摘要、目录等）使用罗马数字
- 正文部分使用阿拉伯数字

== 附录

使用 `#appendix()` 命令开始附录部分。附录中的章节、图表、公式编号会自动切换为字母格式（如 A.1、A.2）：

```typ
#appendix()

= 附录 A 补充材料

这里是附录内容...
```

== 盲审模式

设置 `blind: true` 启用盲审模式：

```typ
conf(
  blind: true,
  // ...
)
```

盲审模式下：
- 封面使用盲审格式，显示盲审编号
- 隐藏作者、导师等个人信息
- 隐藏致谢和原创性声明

也可以通过命令行参数临时切换盲审模式，无需修改源文件：

```bash
# 生成盲审版本
typst compile thesis.typ --input blind=true

# 生成正常版本
typst compile thesis.typ --input blind=false
```

== 预览与打印模式

`preview` 参数控制链接文本的显示方式：
- `preview: true`（默认）：链接显示为蓝色，便于电子版阅读
- `preview: false`：链接显示为正常颜色，适合打印

同样支持命令行切换：

```bash
# 生成打印版（链接不着色）
typst compile thesis.typ --input preview=false
```

== 命令行参数汇总

本模板支持以下命令行参数，通过 `--input key=value` 传递：

#booktab(
  columns: (auto, 1fr),
  align: (left, left),
  caption: "支持的命令行参数",
  [*参数*],
  [*说明*],
  [`blind`],
  [盲审模式：`true` 启用，`false` 禁用],
  [`preview`],
  [预览模式：`true` 链接显示蓝色，`false` 正常颜色],
  [`alwaysstartodd`],
  [章节从奇数页开始：`true` 启用，`false` 禁用],
)

```bash
# 组合多个参数示例
typst compile thesis.typ --input blind=true --input preview=false --input alwaysstartodd=false
```

== 自定义章节样式

如果需要创建不出现在目录中的章节（如致谢），可以使用：

```typ
#heading(numbering: none, outlined: false)[致谢]
```

如果需要章节出现在目录但无编号：

```typ
#heading(numbering: none, outlined: true)[参考文献]
```

== 使用 `include` 拆分文件

对于较长的论文，可以将各部分内容拆分到单独的文件中，使用 `include` 引入：

```typ
// 摘要拆分到单独文件
cabstract: include "doc/cabstract.typ",
eabstract: include "doc/eabstract.typ",
acknowledgements: include "doc/acknowledgements.typ",

// 正文各章也可以拆分
= 第一章 绪论
#include "chapters/01-introduction.typ"

= 第二章 相关工作
#include "chapters/02-related-work.typ"
```

== 模板提供的辅助函数

本模板导出了以下辅助函数供用户使用：

- `#appendix()`：开始附录部分，后续章节编号切换为字母格式
- `#booktab(...)`：生成三线表，支持 `outlined: false` 生成不带编号的表格
- `#codeblock(...)`：生成带标题和编号的代码块
- `#chineseoutline(...)`：生成中文目录
- `#listoffigures(...)`：生成图表列表
