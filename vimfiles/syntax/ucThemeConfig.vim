"ntax highlighting for ucThemeConfig
"
syn match themeNumber "\<\d\+%\?\>"

syn match themeVerbe "\<fill\>"
syn match themeVerbe "\<img\>"
syn match themeVerbe "\<font\>"
syn match themeVerbe "\<txt\>"
syn match themeVerbe "\<rect\>"
syn match themeVerbe "\<sub\>"
syn match themeVerbe "\<reset\>"
syn match themeVerbe "\<set\>"
syn match themeVerbe "\<goto\>"
syn match themeVerbe "\<side\>"
syn match themeVerbe "\<ellips\>"
syn match themeVerbe "\<ellips_fill\>"

syn match themeEnd "\<end\>"

syn match themeKeyword "\<xcenter\>"
syn match themeKeyword "\<ycenter\>"

syn match themeKeyword "\<height\>"
syn match themeKeyword "\<width\>"

syn match themeKeyword "\<top\>"
syn match themeKeyword "\<bottom\>"
syn match themeKeyword "\<left\>"
syn match themeKeyword "\<right\>"
syn match themeKeyword "\<stretch-x\>"
syn match themeKeyword "\<stretch-y\>"
syn match themeKeyword "\<repeat-x\>"
syn match themeKeyword "\<repeat-y\>"
syn match themeKeyword "\<elipsis\>"

syn match themeKeyword "\<none\>"
syn match themeKeyword "\<null\>"

syn match themeBool "\<true\>"
syn match themeBool "\<false\>"

syn match themeCondition "\<is\>"

syn match themeStatement "\<code\>"
syn match themeLabel "\(\<code\>\s\+\)\@<=\d\+\>"
syn match themeLabel "\(\<goto\>\s\+\)\@<=\d\+\>"

syn match themeVariable "\<\d\+val\>"
syn match themeImage "\<\d\+img\>"
syn match themeString "\<\d\+str\>"

syn match themeColor '#[0-9a-fA-F]\{1,8}'
" syn match themeDrawScriptName '^\s*:ds\s\+\<[0-9a-fA-F_]\+\>'
syn match themeDrawScriptName "\(^\s\+:ds\s\+\)\@<=\<\S\+\>"
syn match themeDrawSetName "\(^\s*\.\)\@<=\<\S\+\>"

syn match themeImagePath "\S*.\(png\|jpg\|jpeg\|gif\)"

syn match themeType ":ds\>"
syn match themeType ":pen\>"
syn match themeType ":color\>"
syn match themeType ":brush\>"
syn match themeType ":img\>"
syn match themeType ":file\>"
syn match themeType ":bool\>"


" syntax region	themeBlock		start="{" end="}" fold
" syntax match themeCurlyError ""
syntax region  themeCommentL	start="//" skip="\\$" end="$" keepend

" hi DrawSetName	term=italic ctermfg=Cyan guifg=#80a0ff gui=bold
" hi DrawScriptName	term=italic ctermfg=Cyan guifg=#006161 gui=bold
" hi themeColor	term=italic ctermfg=Cyan guifg=#3E6946

hi link themeImagePath Underlined
hi link themeCommentL   Comment
hi link themeColor   Macro
hi link themeKeyword   Keyword
hi link themeSpecialKeyword   SpecialKey
hi link themeStatement   Statement
hi link themeConstant   Constant
hi link themeNumber   Number
hi link themeCurlyError Error
hi link themeType Type
hi link themeVariable Question
hi link themeString String
hi link themeImage Float
hi link themeDrawScriptName DrawScriptName
hi link themeDrawSetName DrawSetName
hi link themeBool Boolean
hi link themeVerbe Function
hi link themeLabel Label
hi link themeCondition Conditional
hi link themeEnd Label
