#import "../template.typ": booktab

本模板提供了丰富的配置选项，可以在 `conf` 函数中进行设置。下面详细介绍各个配置项的含义和用法。

== 作者与论文信息

#booktab(
  width: 100%,
  columns: (auto, auto, 1fr),
  align: (left, left, left),
  caption: "作者与论文信息配置项",
  [*参数名*],
  [*默认值*],
  [*说明*],
  [`cauthor`],
  [`"张三"`],
  [作者中文姓名],
  [`eauthor`],
  [`"San Zhang"`],
  [作者英文姓名],
  [`studentid`],
  [`"23000xxxxx"`],
  [学号（非盲审封面显示）],
  [`blindid`],
  [`"L2023XXXXX"`],
  [盲审编号（盲审封面显示）],
  [`cthesisname`],
  [`"博士研究生学位论文"`],
  [论文类型名称],
  [`cheader`],
  [`"北京大学博士学位论文"`],
  [页眉标题（偶数页显示）],
  [`ctitle`],
  [-],
  [论文中文标题，可用 `\n` 控制换行；盲审模式下 `\n` 会被忽略],
  [`etitle`],
  [-],
  [论文英文标题，可用 `\n` 控制换行；盲审模式下 `\n` 会被忽略],
  [`date`],
  [`(year: 2026, month: 6)`],
  [论文日期，格式为 `(year: 年, month: 月)`],
  [`degree-type`],
  [`"academic"`],
  [学位类型：`"academic"`（学术学位）或 `"professional"`（专业学位）],
) <config-author>

== 院系与专业信息

#booktab(
  width: 100%,
  columns: 3,
  align: left,
  caption: "院系与专业信息配置项",
  [*参数名*],
  [*默认值*],
  [*说明*],
  [`school`],
  [`"某个学院"`],
  [学院名称],
  [`cfirstmajor`],
  [`"某个一级学科"`],
  [一级学科名称],
  [`cmajor`],
  [`"某个专业"`],
  [专业中文名称],
  [`emajor`],
  [`"Some Major"`],
  [专业英文名称],
  [`direction`],
  [`"某个研究方向"`],
  [研究方向],
  [`csupervisor`],
  [`"李四"`],
  [导师中文姓名及职称],
  [`esupervisor`],
  [`"Si Li"`],
  [导师英文姓名],
) <config-school>

== 摘要与致谢

#booktab(
  width: 100%,
  columns: (auto, 1fr),
  align: (left, left),
  caption: "摘要与致谢配置项",
  [*参数名*],
  [*说明*],
  [`cabstract`],
  [中文摘要内容，独立 `content` 参数],
  [`ckeywords`],
  [中文关键词，使用数组格式如 `("关键词1", "关键词2")`],
  [`eabstract`],
  [英文摘要内容，独立 `content` 参数],
  [`ekeywords`],
  [英文关键词，使用数组格式如 `("Keyword1", "Keyword2")`],
  [`acknowledgements`],
  [致谢内容，独立 `content` 参数],
) <config-abstract>

== 排版选项

#booktab(
  width: 100%,
  columns: (auto, auto, 1fr),
  align: (left, left, left),
  caption: "排版选项配置项",
  [*参数名*],
  [*默认值*],
  [*说明*],
  [`first-line-indent`],
  [`2em`],
  [首行缩进，Word 模板为 `1.77em`，本模板默认 `2em`],
  [`outlinedepth`],
  [`3`],
  [目录显示的最大标题层级],
) <config-layout>

== 其他配置项

#booktab(
  width: 100%,
  columns: (auto, auto, 1fr),
  align: (left, left, left),
  caption: "其他配置项",
  [*参数名*],
  [*默认值*],
  [*说明*],
  [`blind`],
  [`false`],
  [是否为盲审模式，盲审模式隐藏作者、导师等信息],
  [`listofimage`],
  [`true`],
  [是否生成插图列表],
  [`listoftable`],
  [`true`],
  [是否生成表格列表],
  [`listofcode`],
  [`true`],
  [是否生成代码列表],
  [`alwaysstartodd`],
  [`true`],
  [章节是否总是从奇数页开始],
  [`cleandeclaration`],
  [`false`],
  [原创性声明页是否隐藏页眉页脚],
  [`preview`],
  [`true`],
  [预览模式，链接文本显示为蓝色；生成打印版时设为 `false`],
  [`codly-args`],
  [`(:)`],
  [传递给 `codly` 包的额外参数，用于自定义代码块样式。常用选项：\
    `number-format: none` 关闭行号；\
    `display-icon: false` 关闭语言图标；\
    `zebra-fill: none` 关闭交替背景色；\
    `lang-format: none` 关闭语言名称显示],
  [`supplements`],
  [`(:)`],
  [自定义引用记号和列表标题。可用字段及默认值：\
    引用前缀：`图`（"图"）、`表`（"表"）、`代码`（"代码"）、`公式`（"式"）、`节`（"节"）；\
    `图表`（"图表"，未知 figure kind 的 fallback）；\
    列表页标题：`插图列表`（"插图"）、`表格列表`（"表格"）、`代码列表`（"代码"）。\
    示例：`supplements: (图: "Figure", 插图列表: "List of Figures")`],
) <config-switch>

== 参考文献配置

本模板集成了 #link("https://github.com/pku-typst/gb7714-bilingual")[gb7714-bilingual] 包，提供符合 GB/T 7714 标准的参考文献格式，并自动根据文献语言切换中英文术语。

#booktab(
  width: 100%,
  columns: (auto, auto, 1fr),
  align: (left, left, left),
  caption: "参考文献配置项",
  [*参数名*],
  [*默认值*],
  [*说明*],
  [`bibfiles`],
  [`()`],
  [参考文献文件路径，可以是单个文件名（如 `"ref.bib"`）或文件名数组（如 `("ref.bib", "extra.bib")`）],
  [`bibstyle`],
  [`"numeric"`],
  [引用风格：`"numeric"`（顺序编码制）或 `"author-date"`（著者—出版年制）],
  [`bibversion`],
  [`"2015"`],
  [GB/T 7714 标准版本：`"2015"` 或 `"2025"`。注意 GB/T 7714-2025 标准从 2026 年 7 月 1 日开始实施],
  [`override-bib`],
  [`false`],
  [是否自定义参考文献引用样式。设为 `true` 时忽略上述三个参数，用户需自行调用 `bibliography()`。模板仍会应用默认排版格式（五号字、悬挂缩进等），如需覆盖可添加自己的 `show bibliography` 规则],
) <config-bib>
