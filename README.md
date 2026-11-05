# vim-jasmin

Syntax highlighting, filetype detection and a filetype plugin for
[Jasmin](https://github.com/jasmin-lang/jasmin) source files (`*.jazz`) and
include files (`*.jinc`).

Jasmin is a low-level language for writing high-assurance cryptographic
implementations: essentially assembly with variables and structured control
flow.

## Installation

### Vim 8+ / Neovim packages

```bash
# Vim
git clone https://github.com/<you>/vim-jasmin \
  ~/.vim/pack/plugins/start/vim-jasmin

# Neovim
git clone https://github.com/<you>/vim-jasmin \
  ~/.local/share/nvim/site/pack/plugins/start/vim-jasmin
```

### Plugin managers

```vim
" vim-plug
Plug '<you>/vim-jasmin'

" lazy.nvim
{ '<you>/vim-jasmin', ft = { 'jasmin' } }
```

### Manual

```bash
cp syntax/jasmin.vim   ~/.vim/syntax/
cp ftdetect/jasmin.vim ~/.vim/ftdetect/
cp ftplugin/jasmin.vim ~/.vim/ftplugin/
```

Ensure `syntax on` and `filetype plugin on` are set in your `vimrc`.

## What is highlighted

| Group | Covers |
| --- | --- |
| `jasminStructure` | `fn` `export` `namespace` `type` `require` `from` `exec` |
| `jasminStorage` | `reg` `stack` `inline` `global` `param` `ptr` `const` `mut` |
| `jasminType` | `bool` `int` `sint` `uint`, `u8`…`u256`, `ui8`…`ui256`, `si8`…`si256` |
| `jasminCast` | size/sign suffixes such as `(32u)`, `(16u8)`, `+8u16` |
| `jasminConditional` | `if` `else` |
| `jasminRepeat` | `for` `while` `to` `downto` |
| `jasminStatement` | `return` `assert` `ArrayInit` |
| `jasminBoolean` | `true` `false` |
| `jasminNumber` | decimal, `0x`, `0b` and `0o` literals, including `_` separators |
| `jasminIntrinsic` | `#ROL`, `#spill`, `#copy`, … |
| `jasminAlign` | `#aligned` `#unaligned` |
| `jasminAnnotation` | `#[returnaddress=stack]`, `#[sct=...]`, … |
| `jasminFunction` | the name in a `fn <name>` definition |
| `jasminOperator` | including sign-suffixed forms `>>s` `<<r` `<=u` `/s` `%u` |
| `jasminComment` | `//` and `/* */`, **nested** as the compiler allows |
| `jasminString` | `"..."` with escapes |

All groups link to standard highlight groups, so they follow your colourscheme.
Override any of them in your `vimrc`, for example:

```vim
highlight link jasminIntrinsic Macro
```

The filetype plugin sets `commentstring` to `// %s`, keeps comment leaders on
new lines without hard-wrapping code, and teaches `gf` to follow
`require "file.jinc"` by adding `.jinc`/`.jazz` to `suffixesadd`.

## Notes on accuracy

Keywords, literal formats and operators follow
[`compiler/src/lexer.mll`](https://github.com/jasmin-lang/jasmin/blob/main/compiler/src/lexer.mll)
rather than being inferred from examples, so the highlighted token set matches
what the compiler accepts. Two consequences worth knowing:

- Block comments **nest**. The Jasmin lexer tracks a depth counter, so
  `/* a /* b */ c */` is a single comment, and the syntax region recurses to
  match.
- Comments and strings are defined *last* in `syntax/jasmin.vim`. Where two
  items match at one position Vim keeps the one defined last, and `/` is also
  in the operator character class, so defining them earlier would leave `//`
  and `/*` highlighted as operators.

Likewise the function-name rule uses a lookbehind rather than `\zs`, because
`fn` is a `syn-keyword`, keywords take priority, and a match anchored at `fn`
would never be attempted.

## Credit

The initial token categories were taken from
[1uckyPh4nt0m/jasmin-syntax-highlighting](https://github.com/1uckyPh4nt0m/jasmin-syntax-highlighting),
a VS Code TextMate grammar. This Vim port extends it with the keywords that
grammar omits (`global`, `namespace`, `type`, `from`, `exec`, `else`, `downto`,
`const`, `mut`, `assert`, `ArrayInit`, `true`/`false`, the `ui`/`si` and
128/256-bit types), nested block comments, binary/octal/underscore literals,
annotations, intrinsics, sign-suffixed operators and the size/sign cast
suffixes.
