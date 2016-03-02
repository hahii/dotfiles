set background=dark
let g:colors_name = "custom_dark"

hi LineNr ctermfg=250			" inactive line number colour
hi CursorLineNr ctermfg=245		" active line number colour
hi CursorLine cterm=NONE ctermbg=234	" current line hi colour
hi StatusLine cterm=bold
hi StatusLineNC cterm=NONE ctermfg=250
hi ModeMsg ctermfg=9
hi Comment ctermfg=248
hi WarningMsg cterm=bold ctermfg=1

" different line/number colour when in insert mode
au InsertEnter * hi CursorLine cterm=none ctermbg=0 | hi CursorLineNr ctermfg=141 | hi StatusLine ctermfg=141
au InsertLeave * hi CursorLine cterm=none ctermbg=234 | hi CursorLineNr ctermfg=245 | hi StatusLine ctermfg=255
