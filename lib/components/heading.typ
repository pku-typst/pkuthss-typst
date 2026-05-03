/// ========== Heading 元数据辅助函数 ==========
/// 使用 supplement 字段传递元数据，避免硬编码字符串匹配
///
/// 元数据字段定义：
///   pagebreak: bool       - 是否在此 heading 前分页（默认 true）
///   part: int | none      - 状态转换目标 (0/1/2/none)
///   reset-page: bool      - 是否重置页码为 1（默认 false）
///   show-header: bool     - 是否显示页眉（默认 true）
///   header: content | none - 自定义页眉文本

/// 创建前置部分的 heading（摘要、目录等）
/// - title: 标题文本
/// - pagebreak: 是否分页（默认 true）
/// - enter-front: 是否进入前置部分并重置页码（默认 false）
/// - extra-meta: 额外的元数据参数（如 header、spacing-before 等）
#let front-heading(
  title,
  pagebreak: true,
  enter-front: false,
  ..extra-meta,
) = {
  heading(
    numbering: none,
    outlined: false,
    supplement: [#metadata((
      pagebreak: pagebreak,
      part: if enter-front { 1 } else { none },
      reset-page: enter-front,
      show-header: true,
      ..extra-meta.named(),
    ))],
  )[#title]
}

/// 创建后置部分的 heading（致谢、声明等）
/// - title: 标题文本
/// - pagebreak: 是否分页（默认 true）
/// - show-header: 是否显示页眉（默认 true）
#let back-heading(
  title,
  pagebreak: true,
  show-header: true,
  ..extra-meta,
) = {
  heading(
    numbering: none,
    outlined: true,
    supplement: [#metadata((
      pagebreak: pagebreak,
      show-header: show-header,
      ..extra-meta.named(),
    ))],
  )[#title]
}
