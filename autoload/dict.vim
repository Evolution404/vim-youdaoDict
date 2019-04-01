"===============================================================================
"File: autoload/dict.vim
"Description: 简单的翻译插件
"Last Change: 2018-06-08
"Maintainer: 615598813@qq.com
"Licence: Vim Licence
"Version: 1.0.0
"===============================================================================


if !exists('g:dict_py_version')
    if has('python')
        let g:dict_py_version = 2
        let s:py_cmd = 'py '
    elseif has('python3')
        let g:dict_py_version = 3
        let s:py_cmd = 'py3 '
    else
        echoerr 'Error: dict.vim requires vim has python/python3 features'
        finish
    endif
else
    if g:dict_py_version == 2
        let s:py_cmd = 'py '
    else
        let s:py_cmd = 'py3 '
    endif
endif

function! s:FuncNameWithSid(name)
    return '<SNR>'.matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze_FuncNameWithSid$').'_'.a:name
endfun




"有道openapi key
if !exists('g:api_key') || !exists('g:keyfrom')
    let g:api_key = '1932136763'
    let g:keyfrom = 'aioiyuuko'
endif

"有道openapi
let s:query_url = 'http://fanyi.youdao.com/openapi.do?keyfrom=%s&key=%s&type=data&doctype=json&version=1.1&q=%s'

function! dict#Search(args, searchType) abort
    let queryWord = substitute(a:args,'^ *\\| *$','','g')
    if queryWord != ''
        call s:DictSearch(queryWord, a:searchType)
    endif
endfunction

function! dict#VSearch(searchType) abort
    let vtext = s:DictGetSelctn()
    call dict#Search(vtext, a:searchType)
endfunction

function! dict#DictStatusLine(...) abort
    if bufname('%') == '__dictSearch__'
        let w:airline_section_a = 'Dict'
        let w:airline_section_b = 'Result'
        let w:airline_section_c = ''
        let w:airline_section_x = ''
        let w:airline_section_y = ''
    endif
endfunction

if exists('g:loaded_airline')
    "airline插件statusline集成
    call airline#add_statusline_func('dict#DictStatusLine')
endif

function! s:DictGetSelctn() abort
    let regTmp = @a
    exec "normal! gv\"ay"
    let vtext = @a
    let @a = regTmp
    return vtext
endfunction

function! s:WinConfig() abort
    setl filetype=dictSearch
    setl buftype=nofile
    setl bufhidden=hide
    setl noswapfile
    setl noreadonly
    setl nomodifiable
    setl nobuflisted
    setl nolist
    setl nonumber
    setl nowrap
    setl winfixwidth
    setl winfixheight
    setl textwidth=0
    setl nospell
    setl nofoldenable
    setl conceallevel=3
    setl concealcursor=icvn

    nnoremap <silent><buffer> q :close<CR>
    nnoremap <silent><buffer> j :normal! j<cr>
    nnoremap <silent><buffer> k :normal! k<cr>
    nnoremap <silent><buffer> r :call <sid>ReadWord()<cr>
endfunction

function! s:OpenWindow() abort
    let cwin = bufwinnr('__dictSearch__')
    if cwin == -1
        silent keepalt bel split __dictSearch__
        call s:WinConfig()
        return winnr()
    else
        return cwin
    endif
endfunction

function! s:DictSearch(queryWords, searchType) abort
    let s:queryWords = a:queryWords
    if has('nvim')
      let handlerName = s:FuncNameWithSid("NvimHandlerDictSearch")
      call jobstart('python3 '.g:DictPythonFilePath.' "'.a:queryWords.'"',{'on_stdout':handlerName})
    else
      let handlerName = s:FuncNameWithSid("HandlerDictSearch")
      call job_start('python3 '.g:DictPythonFilePath.' "'.a:queryWords.'"',{'callback':handlerName})
    endif
    call s:ReadWord()
endfunction

func! s:HandlerDictSearch(channel,msg)
    if len(a:msg)>0
        call s:DrawBuffer(a:msg)
    endif
endf
func! s:NvimHandlerDictSearch(job_id, data, event)
    if len(a:data)>0
      for line in a:data
        call s:DrawBuffer(line)
      endfor
    endif
endf
func! s:ReadWord()
    if match(s:queryWords,"[\u4e00-\u9fcc]")<0 && len(s:queryWords) <20
      if has('nvim')
        call jobstart("say ".s:queryWords)
      else
        call job_start("say ".s:queryWords)
      endif
    endif
endf

func! s:DrawBuffer(msg)
    let winnr = s:OpenWindow()
    exe winnr.' wincmd w'
    setl ma
    if match(a:msg,'Dictbegin') >= 0
        exe "%d _"
    elseif match(a:msg,'Dicteof') >= 0
        exe('resize '.line("$"))
    else
        call setline(strlen(getline(1))==0?line("$"):line("$")+1,a:msg)
    endif
    setl noma
endf
