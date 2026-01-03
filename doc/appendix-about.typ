#import "../template.typ": codeblock

Typst 是一个现代化的排版系统，由 Martin Haug 和 Laurenz Mädje 于 2019 年开始开发。它的设计目标是成为 LaTeX 的现代替代品，同时保持简洁易学。

== 主要特点

+ *语法简洁*：Typst 的语法受到 Markdown 的启发，学习曲线平缓
+ *编译速度快*：增量编译技术使得大型文档也能快速预览
+ *实时预览*：官方编辑器支持实时渲染预览
+ *脚本能力*：内置图灵完备的脚本语言，支持复杂的排版逻辑
+ *现代设计*：原生支持 Unicode、OpenType 字体等现代排版技术

== 附录中的图表

附录中也可以插入图片，如 @appendix-fig。

#figure(
  image("../images/1-writing-app.png", width: 80%),
  caption: "Typst 网页版界面（附录）",
) <appendix-fig>

附录中也可以插入公式，如 @appendix-eq。

$ nabla times arrow(E) = - (partial arrow(B)) / (partial t) $ <appendix-eq>

附录中也可以插入代码块，如 @appendix-code。

#codeblock(
  ```rust
  fn main() {
      println!("Hello from Rust!");
  }
  ```,
  caption: "Rust Hello World",
) <appendix-code>
