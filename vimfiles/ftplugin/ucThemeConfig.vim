if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

setlocal comments=:// commentstring=//%s formatoptions-=t formatoptions+=croql

" place those line in $HOME/.ctas
" --------------------------------------------------------------------------
" --langdef=ucThemeConfig
" --langmap=ucThemeConfig:.ini
" --regex-ucThemeConfig=/^[ \t]*:ds[ \t]*([a-zA-Z0-9_]+)/\1/d,DrawScripts/
"
let Tlist_Ctags_Cmd="xxxxctags.exe"
let tlist_ucThemeConfig_settings = 'ucThemeConfig;d:DrawScripts;s:DrawSets'

function EnhCommentifyCallback(ft)
	if a:ft == 'ucThemeConfig'
		let b:ECcommentOpen = '//'
		let b:ECcommentMiddle = ''
		let b:ECcommentClose = ''
	endif
endfunction
let g:EnhCommentifyCallbackExists = 'Yes'
