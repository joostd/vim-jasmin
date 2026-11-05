" Vim filetype plugin
" Language: Jasmin

if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

let s:cpo_save = &cpo
set cpo&vim

setlocal commentstring=//\ %s
setlocal comments=s1:/*,mb:*,ex:*/,://

" Continue comments when pressing Enter, but do not wrap code at textwidth.
setlocal formatoptions-=t formatoptions+=croql

" `require "foo.jinc"` under the cursor: let gf find the file.
setlocal suffixesadd=.jinc,.jazz
setlocal include=^\\s*\\%(from\\s\\+\\h\\w*\\s\\+\\)\\=require

setlocal matchpairs=(:),{:},[:]

let b:undo_ftplugin = "setlocal commentstring< comments< formatoptions<"
      \ . " suffixesadd< include< matchpairs<"

let &cpo = s:cpo_save
unlet s:cpo_save
