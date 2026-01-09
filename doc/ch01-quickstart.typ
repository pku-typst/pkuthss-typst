#import "../template.typ": codeblock

== 安装与环境配置

Typst 是一个现代化的排版系统，可以通过以下方式使用：

*在线使用*：访问 #link("https://typst.app")[typst.app]，注册账号后即可在线编辑。在线版本无需安装，支持实时预览和协作编辑。

*本地安装*：
- 从 #link("https://github.com/typst/typst/releases")[GitHub Releases] 下载对应平台的可执行文件
- 使用包管理器安装：`brew install typst`（macOS）或 `cargo install --git https://github.com/typst/typst --locked typst-cli`（通用）

*编辑器支持*：
- VS Code：安装 #link("https://marketplace.visualstudio.com/items?itemName=TinyMist.typst-lsp", "TinyMist") 插件
- Neovim：使用 #link("https://github.com/kaarmu/typst.vim", "typst.vim") 或 #link("https://github.com/chomosuke/typst-preview.nvim", "typst-preview.nvim")
- 其他编辑器：大多数现代编辑器都有社区维护的 Typst 支持

== 获取模板

=== 方式一：通过 Typst Universe（推荐）

模板已发布到 Typst Universe，可以直接创建新项目：

```bash
typst init @preview/modern-pku-thesis:0.1.0 my-thesis
cd my-thesis
```

这会创建一个包含 `main.typ` 和 `ref.bib` 的干净项目，直接编辑即可开始写作。

=== 方式二：克隆仓库

如果需要完整的示例和文档，可以克隆仓库：

```bash
git clone https://github.com/pku-typst/pkuthss-typst.git
cd pkuthss-typst
```

获取模板后，可以直接编辑 `thesis.typ` 文件开始写作。

=== 编译

```bash
typst compile main.typ  # 或 thesis.typ（仓库用户）
```

或使用实时预览模式：

```bash
typst watch main.typ
```

== 基本结构

一个使用本模板的论文文件基本结构如下：

#codeblock(
  ```typ
  #import "template.typ": *

  #show: doc => conf(
    cauthor: "你的姓名",
    ctitle: "论文标题",
    // ... 其他配置项
    doc,
  )

  = 第一章 绪论

  这里是正文内容...

  = 第二章 相关工作

  这里是第二章内容...

  #appendix()

  = 附录 A 补充材料

  这里是附录内容...

  #bibliography("ref.bib", style: "gb-7714-2015-numeric")
  ```,
  caption: "论文文件基本结构",
)
