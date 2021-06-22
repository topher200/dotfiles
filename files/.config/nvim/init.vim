" make Ctrl-s save (by calling ':w<enter>')
:nmap <c-s> :w<CR>
:imap <c-s> <Esc>:w<CR>a

" allow sudo even if we forgot to open vim with 'sudo vim'
cmap w!! w !sudo tee > /dev/null %
