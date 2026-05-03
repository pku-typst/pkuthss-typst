# Run pre-commit hooks (prefer prek, fallback to pre-commit)
[unix]
pre-commit:
  @if command -v prek > /dev/null 2>&1; then prek run --all-files; else pre-commit run --all-files; fi

[windows]
pre-commit:
  @where prek >nul 2>&1 && prek run --all-files || pre-commit run --all-files

publish:
  #!/usr/bin/env bash
  set -euo pipefail
  name=$(awk -F'"' '/^name/ {print $2; exit}' typst.toml)
  version=$(awk -F'"' '/^version/ {print $2; exit}' typst.toml)
  repo="${TYPST_PACKAGES_REPO:-}"
  if [[ -z "$repo" ]]; then
    echo "Error: set TYPST_PACKAGES_REPO to your typst-packages checkout" >&2
    exit 1
  fi
  dest="$repo/packages/preview/$name/$version"
  if [[ -d "$dest" ]]; then
    echo "Error: $dest already exists" >&2
    exit 1
  fi
  echo "Publishing $name v$version -> $dest"
  mkdir -p "$dest/lib" "$dest/template" "$dest/images" "$dest/assets"
  cp typst.toml export.typ README.md LICENSE "$dest/"
  cp assets/pkulogo.svg assets/pkuword.svg "$dest/assets/"
  cp lib/*.typ "$dest/lib/"
  cp template/main.typ template/ref.bib "$dest/template/"
  echo "Generating thumbnail..."
  typst compile --root . --font-path fonts doc/guide.typ images/cover.png --format png --pages 1
  oxipng images/cover.png
  cp images/cover.png "$dest/images/"
  echo "Done. Next:"
  echo "  cd $repo"
  echo "  git checkout -b $name-$version"
  echo "  git add packages/preview/$name/$version"
  echo "  git commit -m '$name $version'"
  echo "  gh pr create"
