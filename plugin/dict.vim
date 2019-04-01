"===============================================================================
"File: plugin/dict.vim
"Description: 简单的翻译插件
"Last Change: 2015-04-25
"Maintainer: iamcco <ooiss@qq.com>
"Github: http://github.com/iamcco <年糕小豆汤>
"Licence: Vim Licence
"Version: 1.0.0
"===============================================================================
let g:DictPythonFilePath = expand('<sfile>:p:h').'/../autoload/dictpy/search.py'

if !has('python') && !has('python3')
    finish
endif

if !exists('g:debug_dict') && exists('g:loaded_dict')
    finish
endif
let g:loaded_dict= 1

let s:save_cpo = &cpo
set cpo&vim

if !hasmapto('<Plug>DictWSearch')
    nmap <silent> <Leader>w <Plug>DictWSearch
endif

if !hasmapto('<Plug>DictWVSearch')
    vmap <silent> <Leader>w <Plug>DictWVSearch
endif

nmap <silent> <Plug>DictWSearch  :call dict#Search(expand("<cword>"), "complex")<CR>
vmap <silent> <Plug>DictWVSearch :<C-U>call dict#VSearch("complex")<CR>

if !exists(':Dict')
    command! -nargs=1 Dict call dict#Search(<q-args>, 'simple')
endif

if !exists(':DictW')
    command! -nargs=1 DictW call dict#Search(<q-args>, 'complex')
endif

func! DictSearch()
  let c = input('输入查询的单词:')
  call dict#Search(c, 'complex')
endf

let &cpo = s:save_cpo
unlet s:save_cpo
