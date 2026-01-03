== 行距说明

本模板的行距已针对 Word 模板进行了校准。Word 中的"行距"指的是基线到基线的距离，而 Typst 的 `leading` 指的是行与行之间的间距（不含字符高度）。

本模板将正文行距固定为 `10.5pt`（视觉上近似对应 Word 的 20pt 行距）。如需精确匹配特定字体，可以使用 `top-edge` 和 `bottom-edge` 参数。根据 Typst 文档：

$ "基线间距" = "top-edge" - "bottom-edge" + "leading" $

不过，由于 Word 中的实际行距还会受到字体影响，即使使用这样的方式，也难以做到与 Word 的像素级对应。

== 中文粗体显示问题

中文粗体默认用黑体显示。如果需要对黑体再额外加粗，或对宋体、楷体等进行加粗，模板已集成 `cuti` 包的伪粗体功能，会自动处理。

== 字体配置

本模板的字体配置在 `lib/config.typ` 中定义。默认使用以下字体：

- *宋体*：Times New Roman, SimSun, STSong
- *黑体*：Times New Roman, SimHei, STHeiti
- *楷体*：Times New Roman, KaiTi_GB2312, STKaiti
- *仿宋*：Times New Roman, FangSong, STFangsong
- *代码*：New Computer Modern Mono, Times New Roman, SimSun

每种字体配置中，英文优先使用 Times New Roman，中文则按 Windows (SimXxx) → macOS (STXxx) 顺序回退。使用 `--font-path fonts` 参数可加载模板自带的字体文件。

如需修改字体，可以编辑 `lib/config.typ` 中的 `字体` 字典。

== 字体警告

如果编译时出现 `unknown font family` 警告，说明系统未安装对应字体。

*解决方案*：
- 下载对应字体（如思源宋体、思源黑体等），然后
  - 将字体安装到系统中
  - 或在编译时加上 `--font-path` 参数指定字体文件所在目录
- 或修改 `lib/config.typ` 中的字体配置

== 目录深度调整

默认情况下，目录只显示前三级标题。如需显示更多层级：

```typ
conf(
  outlinedepth: 4,  // 显示四级标题
  // ...
)
```

== 版本要求

本模板需要 Typst 0.14.0 或更高版本。建议使用最新稳定版本以获得最佳体验。

查看当前 Typst 版本：

```bash
typst --version
```
