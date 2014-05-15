" Script modified from vim.wikia.com/wiki/VimTip1202
" Note that this requires you to make the initial session.vim manually
" using :mksession ~/.local/share/vim/session/session.vim ONLY the first time

" the functions must start with the exact filename and a #, and be called the same way
" if argc() == 0 means only run if vim is called without arguments

" function to update a session, BUT ONLY IF IT ALREADY EXISTS
function! session#UpdateSession()
  if argc() == 0
    let b:sessiondir = $HOME . "/.local/share/vim/session"
    let b:sessionfile = b:sessiondir . "/session.vim"
    if (filereadable(b:sessionfile))
      exe "mksession! " . b:sessionfile
      echo "updating session"
    endif
  endif
endfunction


" function to load session on exit
function! session#LoadSession()
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
