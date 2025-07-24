" An example for a gvimrc file.
" The commands in this are executed when the GUI is started.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	1999 Feb 02
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.gvimrc
"             for Amiga:  s:.gvimrc
"  for MS-DOS and Win32:  $VIM\_gvimrc

" Make external commands work through a pipe instead of a pseudo-tty
"set noguipty

" set the X11 font to use
" set guifont=-misc-fixed-medium-r-normal--14-130-75-75-c-70-iso8859-1
autocmd BufReadPost *
	\ if line("'\"") > 0 && line("'\"") <= line("$") |
		\   exe "normal g`\"" |
			\ endif

set tags=./

" Make command line two lines high
set ch=2

" Make tab keys to 4 spaces
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set formatoptions=roctq
set foldmethod=indent
set nu
" for cpplint
set efm+=%f\ \ %l\ \ %m


set tags=./tags
let Tlist_Show_One_File = 1            "不同时显示多个文件的tag，只显示当前文件的
let Tlist_Exit_OnlyWindow = 1          "如果taglist窗口是最后一个窗口，则退出vim


syntax enable
au Syntax php   source /home/jiangh/backup/source/php.vim
au Syntax tpl   source /usr/share/vim/vim61/syntax/html.vim
set smartindent
" set number
set hlsearch
set incsearch
"set encoding=gbk
set encoding=UTF-8
set langmenu=zh_CN.UTF-8
set fileencoding=utf-8
set fileencodings=utf-8,gb18030,gb2312,gbk,ucs-bom,latin-18,cp936
let php_sql_query = 1
let php_baselib = 1
let php_oldStyle = 1

"set LANG=zh_CN.GBK
"set LANGUAGE=en_US:en
"set LC_CTYPE=zh_CN.GBK
"set LC_NUMERIC="zh_CN.GBK"
"set LC_TIME="zh_CN.GBK"
"set LC_COLLATE="zh_CN.GBK"
"set LC_MONETARY="zh_CN.GBK"
"set LC_MESSAGES="zh_CN.GBK"
"set LC_PAPER="zh_CN.GBK"
"set LC_NAME="zh_CN.GBK"
"set LC_ADDRESS="zh_CN.GBK"
"set LC_TELEPHONE="zh_CN.GBK"
"set LC_MEASUREMENT="zh_CN.GBK"
"set LC_IDENTIFICATION="zh_CN.GBK"
"set encoding=euc-cn

" Make shift-insert work like in Xterm
map <S-Insert> <MiddleMouse>
map! <S-Insert> <MiddleMouse>

" Only do this for Vim version 5.0 and later.
if version >= 500

  " I like highlighting strings inside C comments
  let c_comment_strings=1

  " Switch on syntax highlighting.
  syntax on
  "Type the number of Line
  " set nu

  " Switch on search pattern highlighting.
  "set hlsearch

  " For Win32 version, have "K" lookup the keyword in a help file
  "if has("win32")
  "  let winhelpfile='windows.hlp'
  "  map K :execute "!start winhlp32 -k <cword> " . winhelpfile <CR>
  "endif
set nocompatible	" Use Vim defaults (much better!)
set bs=2		" allow backspacing over everything in insert mode
"set noai			" always set autoindenting on
"set backup		" keep a backup file
set viminfo='20,\"10000	" read/write a .viminfo file, don't store more
			" than 50 lines of registers
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time

" jh
syntax on
set hlsearch
if has("gui_running")
	set background=light
else
	set background=dark
endif
" jh

" Hide the mouse pointer while typing
  set mousehide

  " Set nice colors
  " background for normal text is light grey
  " Text below the last line is darker grey
  " Cursor is green
  " Constants are not underlined but have a slightly lighter background
  highlight Normal guibg=grey90
  highlight Cursor guibg=Green guifg=NONE
  highlight NonText guibg=grey80
  highlight Constant gui=NONE guibg=grey95
  highlight Special gui=NONE guibg=grey95
  highlight Comment term=bold ctermfg=6
  highlight Search NONE
  highlight Search term=reverse cterm=reverse
endif

set mouse=v
"set mouse=a
nnoremap <silent> <F8> :TlistToggle<CR>

" for color of tabs empty space
hi TabLineFill term=bold cterm=bold ctermbg=0
nnoremap gb gT

" for c++ file, set tab to 2 space
autocmd FileType c,cc,cpp,h setlocal tabstop=2 shiftwidth=2 softtabstop=2

" 保存时自动删除行尾空格
autocmd BufWritePre * %s/\s\+$//e
