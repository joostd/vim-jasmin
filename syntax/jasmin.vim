" Vim syntax file
" Language:     Jasmin (https://github.com/jasmin-lang/jasmin)
" Filenames:    *.jazz, *.jinc
"
" Keywords, literal formats and operators follow compiler/src/lexer.mll in the
" Jasmin repository, so that what is highlighted matches what the compiler
" actually accepts.

if exists("b:current_syntax")
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

syn case match

" ---------------------------------------------------------------- keywords
syn keyword jasminStorage     reg stack inline global param ptr const mut
syn keyword jasminStructure   fn export namespace type require from exec
syn keyword jasminConditional if else
syn keyword jasminRepeat      for while to downto
syn keyword jasminStatement   return assert ArrayInit
syn keyword jasminBoolean     true false

" ---------------------------------------------------------------- types
syn keyword jasminType bool int sint uint
syn keyword jasminType u8 u16 u32 u64 u128 u256
syn keyword jasminType ui8 ui16 ui32 ui64 ui128 ui256
syn keyword jasminType si8 si16 si32 si64 si128 si256

" Size/sign suffixes used by casts, packing and sized operators:
"   SWSIZE  <size><wsign>              e.g. (32u)x, x +64s y
"   SVSIZE  <vsize><sign><gensize>     e.g. (16u8)[...], x +8u16 y
syn match jasminCast "\<\%(8\|16\|32\|64\|128\|256\)\%(si\|ui\|[su]\)\>"
syn match jasminCast "\<\%(2\|4\|8\|16\|32\)[su]\%(1\|2\|4\|8\|16\|32\|64\|128\)\>"

" ---------------------------------------------------------------- numbers
" Digit groups may be separated by underscores, e.g. 0xdead_beef.
syn match jasminNumber "\<\d\+\%(_\+\d\+\)*\>"
syn match jasminNumber "\<0[xX]\x\+\%(_\+\x\+\)*\>"
syn match jasminNumber "\<0[bB][01]\+\%(_\+[01]\+\)*\>"
syn match jasminNumber "\<0[oO]\o\+\%(_\+\o\+\)*\>"

" ---------------------------------------------------------------- operators
" Defined shortest-first: when several items match at one position Vim keeps
" the one defined last, so the longer forms below must come after.
syn match jasminOperator "[-+*/%&|^!?:;,.=<>]"
syn match jasminOperator "->\|::\|==\|!=\|&&\|||\|<<\|>>"
syn match jasminOperator "[<>]=\|[/%][su]\|[<>][su]"
syn match jasminOperator "<<r\|>>r\|>>[su]\|[<>]=[su]"

" ---------------------------------------------------------------- functions
" Lookbehind rather than \zs: 'fn' is a syn-keyword, which takes priority and
" consumes that text, so a match anchored at 'fn' would never be attempted.
syn match jasminFunction "\%(\<fn\s\+\)\@<=\h\w*"

" ------------------------------------------------------- intrinsics, annotations
" #NAME is an architecture-specific instruction, #[...] an annotation.
syn match  jasminIntrinsic  "#\h\w*"
syn match  jasminAlign      "#\%(un\)\?aligned\>"
syn region jasminAnnotation start="#\[" end="\]" contains=jasminString,jasminNumber,jasminType,jasminCast

" ------------------------------------------------------- comments and strings
" These come last on purpose. Where two items match at the same position Vim
" keeps the one defined last, and '/' is also in the operator class above, so
" defining comments any earlier would leave // and /* highlighted as operators.
"
" Block comments nest: the lexer tracks a depth counter, so /* /* */ */ is one
" comment. The region therefore contains itself.
syn keyword jasminTodo    contained TODO FIXME XXX NOTE
syn region  jasminComment start="/\*" end="\*/" contains=jasminComment,jasminTodo,@Spell
syn match   jasminComment "//.*$"               contains=jasminTodo,@Spell

syn match  jasminEscape contained "\\."
syn region jasminString start=+"+ skip=+\\.+ end=+"+ contains=jasminEscape

" ---------------------------------------------------------------- highlight
hi def link jasminTodo        Todo
hi def link jasminComment     Comment
hi def link jasminString      String
hi def link jasminEscape      SpecialChar
hi def link jasminNumber      Number
hi def link jasminBoolean     Boolean
hi def link jasminType        Type
hi def link jasminCast        Type
hi def link jasminStorage     StorageClass
hi def link jasminStructure   Structure
hi def link jasminConditional Conditional
hi def link jasminRepeat      Repeat
hi def link jasminStatement   Statement
hi def link jasminFunction    Function
hi def link jasminIntrinsic   Special
hi def link jasminAlign       PreProc
hi def link jasminAnnotation  PreProc
hi def link jasminOperator    Operator

let b:current_syntax = "jasmin"

let &cpo = s:cpo_save
unlet s:cpo_save
