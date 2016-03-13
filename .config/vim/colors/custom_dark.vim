set background=dark
let g:colors_name = "custom_dark"

hi LineNr ctermfg=250					" inactive line number
hi CursorLineNr ctermfg=255				" active line number
hi CursorLine cterm=NONE ctermbg=234			" current line highlight
hi StatusLine cterm=bold ctermfg=255 ctermbg=235	" status line of active window
hi StatusLineNC cterm=NONE ctermfg=250 ctermbg=235	" status line of inactive window
hi ModeMsg ctermfg=9					" mode name in bottom left
hi Comment ctermfg=248					" comment lines in code
hi WarningMsg cterm=bold ctermfg=1			" warning messages

" change colours when entering/leaving insert mode
au InsertEnter * hi CursorLine cterm=none ctermbg=0 | hi CursorLineNr ctermfg=141 | hi StatusLine ctermfg=141
au InsertLeave * hi CursorLine cterm=none ctermbg=234 | hi CursorLineNr ctermfg=255 | hi StatusLine ctermfg=255
