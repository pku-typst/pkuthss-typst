# Run pre-commit hooks (prefer prek, fallback to pre-commit)
[unix]
pre-commit:
  @if command -v prek > /dev/null 2>&1; then prek run --all-files; else pre-commit run --all-files; fi

[windows]
pre-commit:
  @if where prek >nul 2>&1 (prek run --all-files) else (pre-commit run --all-files)
