set nocompatible              " be iMproved, required
set clipboard=unnamedplus
set mouse=a
set nu
set smartindent
set tabstop=4
set shiftwidth=4
set expandtab
set noswapfile
set list
set listchars=trail:.,tab:>>
set hls
syntax on
filetype indent plugin on

"-----------------------------------------------------------------------
"=====================================================
" Vundle settings
"=====================================================
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim' " let Vundle manage Vundle, required
Plugin 'scrooloose/nerdtree'     " Project and file navigation
Plugin 'majutsushi/tagbar'          " Class/module browser
Plugin 'https://github.com/sheerun/vim-polyglot'
Plugin 'https://github.com/vim-syntastic/syntastic'
Plugin 'https://github.com/SirVer/ultisnips'
Plugin 'https://github.com/Valloric/YouCompleteMe'
Plugin 'bling/vim-airline'       " Lean & mean status/tabline for vim
Plugin 'tpope/vim-surround' "Parentheses, brackets, quotes, XML tags, and more
Plugin 'flazz/vim-colorschemes'
Plugin 'https://github.com/rakr/vim-one'

call vundle#end()            		" required
" ---------------------------------- "
" Configure NERDTree
" ---------------------------------- "

" Open NERDTree when Vim startsup and no files were specified
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" Open NERDTree with Ctrl-n 
map <C-n> :NERDTreeToggle<CR>

" Close Vim if the only window left open is NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
" ---------------------------------- "
" Configure Ultisnip and YouCompleteMe
" ---------------------------------- "
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
" ---------------------------------- "
" Configure YouCompleteMe
" ---------------------------------- "
let g:ycm_collect_identifiers_from_tags_files = 1 " Let YCM read tags from Ctags file
let g:ycm_use_ultisnips_completer = 1 " Default 1, just ensure
let g:ycm_seed_identifiers_with_syntax = 1 " Completion for programming language's keyword
let g:ycm_complete_in_comments = 1 " Completion in comments
let g:ycm_complete_in_strings = 1 " Completion in string

let g:ycm_key_list_select_completion = ['<C-j>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-k>', '<Up>']
" Goto definition with F3
map <F3> :YcmCompleter GoTo<CR>

set tags+=./.tags
set colorcolumn=80
filetype on
filetype plugin on
filetype plugin indent on
" virtual tabstops using spaces
set shiftwidth=4
set softtabstop=4
set expandtab
" allow toggling between local and default mode
function TabToggle()
   if &expandtab
       set shiftwidth=4
       set softtabstop=0
       set noexpandtab
   else
       set shiftwidth=4
       set softtabstop=4
       set expandtab
   endif
endfunction
set pastetoggle=<F10>
map <F9> mz:execute TabToggle()<CR>'z
nmap <F8> :TagbarToggle<CR>
source ~/.config/nvim/init.vim.local
nmap <silent> <A-Up> :wincmd k<CR>
nmap <silent> <A-Down> :wincmd j<CR>
nmap <silent> <A-Left> :wincmd h<CR>
nmap <silent> <A-Right> :wincmd l<CR>
 " Find file in current directory and edit it.
function! Find(name)
  let l:list=system("find . -name '".a:name."' | perl -ne 'print \"$.\\t$_\"' ")
  let l:num=strlen(substitute(l:list, "[^\n]", "", "g"))
  if l:num < 1
    echo "'".a:name."' not found"
    return
  endif
  if l:num != 1
    echo l:list
    let l:input=input("Which ? (CR=nothing)\n")
    if strlen(l:input)==0
      return
    endif
    if strlen(substitute(l:input, "[0-9]", "", "g"))>0
      echo "Not a number"
      return
    endif
    if l:input<1 || l:input>l:num
      echo "Out of range"
      return
    endif
    let l:line=matchstr("\n".l:list, "\n".l:input."\t[^\n]*")
  else
    let l:line=l:list
  endif
  let l:line=substitute(l:line, "^[^\t]*\t./", "", "")
  execute ":e ".l:line
endfunction
command! -nargs=1 Find :call Find("<args>")

function! DoPrettyXML()
  " save the filetype so we can restore it later
  let l:origft = &ft
  set ft=
  " delete the xml header if it exists. This will
  " permit us to surround the document with fake tags
  " without creating invalid xml.
  1s/<?xml .*?>//e
  " insert fake tags around the entire document.
  " This will permit us to pretty-format excerpts of
  " XML that may contain multiple top-level elements.
  0put ='<PrettyXML>'
  $put ='</PrettyXML>'
  silent %!xmllint --format -
  " xmllint will insert an <?xml?> header. it's easy enough to delete
  " if you don't want it.
  " delete the fake tags
  2d
  $d
  " restore the 'normal' indentation, which is one extra level
  " too deep due to the extra tags we wrapped around the document.
  silent %<
  " back to home
  1
  " restore the filetype
  exe "set ft=" . l:origft
endfunction

command! PrettyXML call DoPrettyXML()
  if (has("nvim"))
  "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif
"For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
"Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
" < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
if (has("termguicolors"))
  set termguicolors
endif
colorscheme one
let g:airline_theme='one'
set background=dark
