# 字体说明

本目录仅包含开源字体：

- **New Computer Modern Mono**（代码字体）：来自 CTAN 的 [newcomputermodern](https://ctan.org/pkg/newcomputermodern) 包，采用 [GUST Font License (GFL)](https://tug.org/fonts/licenses/GUST-FONT-LICENSE.txt)，允许自由再分发。

模板所需的其他字体（宋体、黑体、楷体、仿宋、Times New Roman 等）为商业字体，本仓库不再随附，请使用系统已安装的字体：

- **Windows / macOS**：系统已预装，直接编译即可。
- **Linux**：安装开源替代字体，如 `fonts-noto-cjk`（思源宋体/黑体的 Noto 打包版）或从 [adobe-fonts](https://github.com/adobe-fonts) 下载思源宋体、思源黑体。模板的宋体、黑体字体链已内置这些开源字体作为回退。西文可安装 `fonts-liberation`（Times New Roman / Arial 的度量兼容替代）；仿宋可用 [FandolFang](https://ctan.org/pkg/fandol)（GPL 字体例外许可），楷体可用 [LXGW 文楷](https://github.com/lxgw/LxgwWenKai)（OFL）。缺失的字体编译时会有警告，不影响其他部分。

如需使用自备字体，编译时添加 `--font-path <目录>` 参数。
