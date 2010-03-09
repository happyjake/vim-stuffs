" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

function! JakeCopyFile()
python << EOF
import vim
from os import startfile,makedirs
from shutil import move
from os.path import exists,dirname
fpath = vim.eval('expand("<cfile>")')
if exists(fpath):
	startfile(fpath)
else:
	src = "../" + fpath
	pdir = dirname(fpath)
	if not exists(pdir):makedirs(pdir)
	move(src,fpath)
EOF
endfunction

function! JakeStartFile()
python << EOF
import vim
from os import startfile
from os.path import exists
fpath = vim.eval('expand("<cfile>")')
if exists(fpath):
	startfile(fpath)
else:
	print "%s not exists!" % fpath
	vim.command("normal bve")
EOF
endfunction

function! Eatchar(pat)
    let c = nr2char(getchar())
	" no matter what.just eat it
	return ''
	return (c =~ a:pat) ? '' : c
endfunction
" command! -nargs=+ Iabbr execute "iabbr" <q-args> . "<C-R>=Eatchar('')<CR>"
command! -nargs=+ Inoreabbr execute "inoreabbr" <q-args> . "<C-R>=Eatchar('')<CR>"

" 执行python语句
function! JakeEvalPython() range
	" let pycmd = join(getline(a:firstline,a:lastline),"\n")
	" echo "python << EOF\n".pycmd."\nEOF\n"
	" exec "echo 'asdf'"
python << EOF
import vim
lines = vim.eval('join(getline(a:firstline,a:lastline),"\n")')
print lines
#eval(lines)
EOF
endfunction

" 插入当天日期
function! JakeGetDate()
python << EOF
import vim
from datetime import datetime, date, time
vim.command('let l:datestr = "' + datetime.now().strftime("%Y-%m-%d") + '"')
EOF
exe "normal a".l:datestr
endfunction

function! JakeToPasteBin()
python << EOF
import os
import urllib
import vim

url = "http://paste-bin.appspot.com"
f = urllib.urlopen(url)
content = f.read()
f.close()
lines=content.split("\n")
for line in lines:
  vim.current.buffer.append(line)
EOF
endfunction

function! JakeInsertText()
python << EOF
import os
import vim

EOF
endfunction

function! JakeComTest()
python << EOF
import win32com.client
import time
ie6=win32com.client.Dispatch("InternetExplorer.Application")
ie6.Navigate("http://192.168.2.10/c6")
ie6.Visible=1
while ie6.Busy:
	time.sleep(1)

document=ie6.Document
document.getElementById("username").value="admin"
document.getElementById("password").value="lala"
document.forms[0].submit()
EOF
endfunction

function! JakeHtmlPure()
python << EOF
import vim, BeautifulSoup
soup = BeautifulSoup.BeautifulSoup(vim.current.buffer[:])
vim.current.buffer[:] = soup.prettify().split('\n').encode("utf-8")
EOF
endfunction

function! DoLineComment()
	let cs = &commentstring
	if cs =~ "%s$"
		return substitute(cs, "%s", "", "")
	else
		let ft = &filetype
		return "//"
	endif

endfunction

function! JakeGetHTML()
python << EOF
import vim, BeautifulSoup, urllib
handle = urllib.urlopen(vim.current.line)
soup = BeautifulSoup.BeautifulSoup(handle.read())
vim.current.buffer[:] = soup.prettify().split('\n').encode("utf-8")
EOF
endfunction

function! JakeRSS()
python << EOF
import urllib
import urllib2
import vim
from xml.sax.saxutils import unescape
from BeautifulSoup import BeautifulSoup          # For processing HTML
count = 0
page=1
url = "http://www.qiushibaike.com/groups/2/latest/page/%d" % page
data = urllib.urlopen(url).readlines()
soup = BeautifulSoup("".join(data))
contents = soup.findAll('div', "content")
stories = [str(text) for text in contents]
for story in stories[6:7]:
	count += 1
	minisoup = BeautifulSoup(story)
	text = ''.join([e for e in minisoup.recursiveChildGenerator() if isinstance(e, unicode)])
	text = urllib.unquote(unescape(text, {'&quot;':'"'}))
	text = text.encode("gb18030")
	vim.command(':echo "%s"' % text)
EOF
endfunction

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

set nobackup		"不作备份
set history=2000    "超长历史记录
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")
if has('win32') || has('win64')
	set guifont=courier_new:h9:w5:b:cDEFAULT
endif

" Don't use Ex mode, use Q for formatting
map Q gq

" In many terminal emulators the mouse works just fine, thus enable it.
set mouse=a

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
  set guioptions-=T "不显示工具栏
endif


" colorscheme hhazure
set nocompatible ruler confirm hidden mousehide title
set showmatch showmode incsearch autoindent noautowrite splitbelow
set ignorecase smartcase nowrapscan wildmenu hlsearch
set sessionoptions=buffers,winpos,blank,winsize,globals
" use > to indicate line break
set showbreak=>

set titlelen=100
" set titlestring=%<%F%m%r%=\ [\ %{getcwd()}\ ]\ -on-\ %{hostname()}

set backupcopy=yes
set sessionoptions+=curdir

set browsedir=current

" colorscheme morning
" colorscheme calmar256-light
colorscheme zenburn

set tabstop=2
set shiftwidth=2
set noexpandtab
" set statusline=%<%F%m%=#%n\ %([%R]%)\ %([%Y]%)\ %P\ <%l,%c%V>
set rulerformat=%25(#%n\ %m%r%y\ %P\ <%l,%c%V>%)
set textwidth=0
" auto marker
set foldmethod=marker
" always show status line
set laststatus=2
set statusline=%F%m%r%h%w[%L][%{&ff},%{&encoding},%{&fileencoding}]%y[%p%%][%04l,%04v]
set number
set nowrap
set scrolloff=3
set go+=b
set autochdir
set matchpairs+=<:>
set complete+=k " scan the files given with the 'dictionary' option
set smartindent " smart autoindenting when starting a new line

" Only do this part when compiled with support for autocommands.
if has("autocmd")
  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  " Put these in an autocmd group, so that we can delete them easily.
	augroup vimrcEx
		" 删除本组au,防止重复定义
		au!
		" 保存_vimrc时自动source
		autocmd BufWritePost $VIM/_vimrc   silent! so $VIM/_vimrc
		" autocmd BufWritePost *.ini  silent! TlistUpdate
		" 不再显示^M字符
		autocmd BufRead * silent! %s/[\r \t]\+$//
		filetype plugin indent on
		autocmd BufEnter * :lcd %:p:h "切换到当前文件路径
		" For all text files set 'textwidth' to 78 characters.
		autocmd FileType text setlocal textwidth=78

		" 打开vim时自动最大化窗口
		" 相当于按下系统菜单的最大化项.同样的:simalt ~r相当于按下了还原项
		" 设置最大的显示行数及列数使开启的窗口一开始就比较大
		set lines=999
		set columns=999
		autocmd VimEnter * :simalt ~x

		autocmd FileType python nnoremap <F5> <ESC>:exe "!".expand("%")<CR>

		autocmd FileType c,cpp set cindent
		" autocmd FileType c,cpp inoreabbr " ""<Left><C-R>=Eatchar('')<CR>
		" autocmd FileType c,cpp inoreabbr ' ''<Left><C-R>=Eatchar('')<CR>
		" autocmd FileType c,cpp inoreabbr [ []<Left><C-R>=Eatchar('')<CR>
		" autocmd FileType c,cpp inoreabbr ( ()<Left><C-R>=Eatchar('')<CR>
		" autocmd FileType c,cpp inoreabbr { {<CR>}<Up><Esc>o<C-R>=Eatchar('')<CR>
		" autocmd FileType c,cpp inoreabbr _T <C-R>='_T("")'<CR><Left><Left><C-R>=Eatchar('')<CR>

		" autocmd FileType c,cpp inoreabbr if( if()<Left><C-R>=Eatchar('')<CR>
		" autocmd FileType c,cpp inoreabbr elif else if()<Left><C-R>=Eatchar('')<CR>
		" autocmd FileType c,cpp inoreabbr else else<CR>{<CR>}<Up><CR><C-R>=Eatchar('')<CR>
		" autocmd FileType c,cpp inoreabbr for( for(;;)<Left><Left><Left><C-R>=Eatchar('')<CR>
		" autocmd FileType c,cpp inoreabbr switch( switch()<CR>{<CR>case :<CR>break;<CR>default:<CR>}<C-o>%<C-R>=Eatchar('')<CR>

"-------------------------------------------------------------------------------
" autocomplete parenthesis, brackets and braces
"-------------------------------------------------------------------------------
" inoremap ( ()<Left>
" inoremap [ []<Left>
" inoremap { {}<Left>
"
vnoremap ( s()<Esc>P<Right>%
vnoremap [ s[]<Esc>P<Right>%
vnoremap { s{}<Esc>P<Right>%
"
"-------------------------------------------------------------------------------
" autocomplete quotes (visual and select mode)
"-------------------------------------------------------------------------------
xnoremap  '  s''<Esc>P<Right>
xnoremap  "  s""<Esc>P<Right>
xnoremap  `  s``<Esc>P<Right>
"

		" When editing a file, always jump to the last known cursor position.
		" Don't do it when the position is invalid or when inside an event handler
		" (happens when dropping a file on gvim).
		autocmd BufReadPost *
		\ if line("'\"") > 0 && line("'\"") <= line("$") |
		\   exe "normal! g`\"" |
		\ endif
	augroup END

  " 加入在插入模式的自动补全 - Word_Complete插件
  " autocmd BufEnter * call DoWordComplete()

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
	 	\ | wincmd p | diffthis

source $VIMRUNTIME/mswin.vim
behave mswin

" set diffexpr=MyDiff()
" function! MyDiff()
	" let opt = '-a --binary '
	" if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
	" if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
	" let arg1 = v:fname_in
	" if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
	" let arg2 = v:fname_new
	" if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
	" let arg3 = v:fname_out
	" if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
	" let eq = ''
	" if $VIMRUNTIME =~ ' '
		" if &sh =~ '\<cmd'
			" let cmd = '""' . $VIMRUNTIME . '\diff"'
			" let eq = '"'
		" else
			" let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
		" endif
	" else
		" let cmd = $VIMRUNTIME . '\diff'
	" endif
	" silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
" endfunction


" abbreviation
" see http://vimdoc.sourceforge.net/htmldoc/vimfaq.html
" 吃掉abbr最后加上的空格
" function! Eatchar(pat)
	" let c = nr2char(getchar())
	" return (c =~ a:pat) ? '' : c
" endfunction
" command! -nargs=+ Iabbr execute "iabbr" <q-args> . "<C-R>=Eatchar('\\s')<CR>"


" 这个用来开始写一段的comment
" iabbr /b /****************************************<CR>
" 这个用来结束comment
" iabbr b/ <Esc>Xi****************************************/<CR>
" 单行的comment
" iabbr /c /*  */<Left><Left><Left>
" 行尾加comment
" nnoremap <M-;> <Esc>A /*  */<Left><Left><Left>
nnoremap <M-;> <Esc>A <C-R>=DoLineComment()." "<CR>
" nnoremap <C-X><C-X> :call JakeStartFile()<CR>
" nnoremap <MiddleMouse> :call JakeStartFile()<CR>
nnoremap <2-LeftMouse> :call JakeStartFile()<CR>
nnoremap <MiddleMouse> :call JakeCopyFile()<CR>
" 华丽的分界线
" Iabbr /l /****************************************/
" ucweb里面要求要用这个来注释改过的代码
" 这些全被snipyMate代替了
" Iabbr //r // rongkf edit <ESC>:call JakeGetDate()<CR><ESC>a {<CR>}<ESC>kfta
" Iabbr //r // rongkf edit <C-R>=strftime("%Y-%m-%d")<CR>
" Iabbr //r // rongkf edit <C-R>=strftime("%Y-%m-%d")<CR><C-R><C-R>=" {// }"<CR>
" Iabbr //re // rongkf edit <C-R>=strftime("%Y-%m-%d")<CR>
" Iabbr //ra // rongkf add <C-R>=strftime("%Y-%m-%d")<CR>
" Iabbr //rd // rongkf delete <C-R>=strftime("%Y-%m-%d")<CR>
" Iabbr --r -- rongkf <C-R>=strftime("%Y-%m-%d")<CR>
" 指针->
" Iabbr ., ->
" 注释
" EnhancedCommentify在这里下载:
" http://www.vim.org/scripts/script.php?script_id=23
let g:EnhCommentifyUserBindings = 'yes'
let g:EnhCommentifyPretty = 'Yes'
let	g:EnhCommentifyRespectIndent = 'Yes'
nnoremap <C-_><C-_> :call EnhancedCommentify('', 'guess')<CR>
vnoremap <C-_><C-_> :call EnhancedCommentify('', 'first')<CR>

" 以下模式下按;a回到normal
" inoremap ;; <Esc>
" cmap ;; <Esc>
" vnoremap ;; <Esc>

" 正常模式插入空行
" 在上面插入
nnoremap <M-S-o> ma:put!=''<CR>`a
" 在下面插入
nnoremap <M-o> ma:put=''<CR>`a

" 显示光标下的颜色 eg #445588
" :nnoremap <leader>c :hi Normal guibg=#<c-r>=expand("<cword>")<cr><cr>

" 抄回来的，感觉好用，但是有bug.
" type table,,, to get <table></table>       ### Cool ###
" inoremap ,,, <Esc>bdwa<<Esc>pa><CR></<Esc>pa><Esc>kA

" MAKE IT EASY TO UPDATE/RELOAD _vimrc
nnoremap ,v :e $VIM/_vimrc<CR>
" MAKE IT EASY TO EDIT snippis
" 按;w保存，少按一下shift
" nnoremap ;w :w<CR>
" 同理
" nnoremap ;q :q<CR>

" 按;r替换本行，多了个indent的效果
" nnoremap ;r ddO

" 命令模式下移动
cnoremap <C-A> <Home>
cnoremap <C-E> <End>
" cnoremap <C-F> <Right>
cnoremap <C-B> <Left>

" 插入模式下移动
inoremap <C-A> <Home>
inoremap <C-E> <End>
inoremap <C-F> <Right>
inoremap <C-B> <Left>

" 画图
map <F12> :call ToggleSketch()<CR>

" set path+="C:\Program Files\Microsoft Visual Studio\VC98\MFC\Include"
let Tlist_Show_Menu = 1
" let Tlist_Auto_Open = 1
let Tlist_Show_One_File = 1
let Tlist_Auto_Update = 1
let Tlist_Exit_OnlyWindow = 1
let Tlist_Use_SingleClick = 1
let Tlist_Process_File_Always = 1
let Tlist_Use_Right_Window = 1
nnoremap <silent> T :TlistToggle<CR>
" let g:winManagerWindowLayout = 'FileExplorer,TagsExplorer|BufExplorer'
let NERDChristmasTree = 1
let NERDTreeMouseMode = 2
let NERDTreeMapToggleFiles = "T"
nnoremap <silent> <F3> :NERDTreeToggle<CR>

" winmang
let g:winManagerWindowLayout = 'FileExplorer,TagsExplorer|BufExplorer'

" set cursorcolumn " highlight the current column
set cursorline " highlight current line

nnoremap <C-M-End> :call DTEPutFile()<CR>
inoremap <C-M-End> <Esc>

"Locate and return character "above" current cursor position...
function! LookUpwards()
   "Locate current column and preceding line from which to copy...
   let column_num      = virtcol('.')
   let target_pattern  = '\%' . column_num . 'v.'
   let target_line_num = search(target_pattern . '*\S', 'bnW')

   "If target line found, return vertically copied character...

   if !target_line_num
      return ""
   else
      return matchstr(getline(target_line_num), target_pattern)
   endif
endfunction

"Reimplement CTRL-Y within insert mode...

" imap <silent>  <C-Y>  <C-R><C-R>=LookUpwards()<CR>
" nmap <F6> :call ResetSnippets()<CR>:call GetSnippets(snippets_dir, &ft)<CR>
" imap <F6> <ESC>:call ResetSnippets()<CR>:call GetSnippets(snippets_dir, &ft)<CR>a
" Taglist
nmap <F5> :TlistUpdate<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                           UltiSnips Settings                            "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" load UltiSnips
set runtimepath+=$VIM/vimfiles/ultisnips_rep

" reload snippets
" nmap <F6> :py UltiSnips_Manager.reset()<CR>
" imap <F6> <ESC>:py UltiSnips_Manager.reset()<CR>a

" quick edit snippets
nnoremap ,s :sp <C-R>=GetUltiSnipsFilePath()<CR><CR>

function UpdateSnippet()
	exe "py UltiSnips_Manager.reset()"
endfunction
com -nargs=0 UpdateSnippet call UpdateSnippet()

function EditSnippet(ft)
	let myft = a:ft
	if empty(myft)
		if empty(&ft)
			let myft = "all"
		else
			let myft = &ft
		endif
	endif
	let path = GetUltiSnipsFilePath(myft)
	exe "sp ".path
endfunction
com -nargs=? EditSnippet call EditSnippet(<q-args>)

function GetUltiSnipsFilePath(ft)
	let myft = a:ft
	if empty(myft)
		let myft = "all"
	endif
	return $VIM.'\vimfiles\UltiSnips\'.myft.'.snippets'
endfunction

