" Script modified from vim.wikia.com/wiki/VimTip1202

" Note that this requires you to make the initial session.vim manually
" using :mksession ~/.local/share/vim/session/session.vim ONLY the first time

" the functions must start with the exact filename and a #, and be called the same way from vimrc


" update session ONLY IF IT ALREADY EXISTS
function! sessionpersist#UpdateSession()
  if argc() == 0
    let b:sessiondir = $HOME . "/.local/share/vim/session"
    let b:sessionfile = b:sessiondir . "/session.vim"
    if (filereadable(b:sessionfile))
      exe "mksession! " . b:sessionfile
      echo "updating session"
    endif
  endif
endfunction


" load session if vim is called without arguments (argc() == 0)
function! sessionpersist#LoadSession()
  if argc() == 0
    let b:sessiondir = $HOME . "/.local/share/vim/session"
    let b:sessionfile = b:sessiondir . "/session.vim"
    if (filereadable(b:sessionfile))
      exe 'source ' b:sessionfile
    else
      echo "No session loaded."
    endif
  else
    let b:sessionfile = ""
    let b:sessiondir = ""
  endif
endfunction
