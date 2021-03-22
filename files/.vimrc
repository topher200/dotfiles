set autoindent
set expandtab
set smartcase
set ignorecase
set incsearch
set tabstop=2
set shiftwidth=4
set softtabstop=4
set hlsearch " highlight matches in search
syntax enable

" Use system keyboard
set clipboard=unnamed

" Set 72 column width for git commit messages
au FileType gitcommit set tw=72

" Make backspace work on previously entered text
set backspace=indent,eol,start

" enable vim to edit crontab on osx. see http://stackoverflow.com/a/21194148
autocmd FileType crontab setlocal nowritebackup

" status line always
:set laststatus=2

" make Ctrl-s save (by calling ':w<enter>')
:nmap <c-s> :w<CR>
:imap <c-s> <Esc>:w<CR>a

" allow sudo even if we forgot to open vim with 'sudo vim'
cmap w!! w !sudo tee > /dev/null %

" Keep undo history across sessions by storing it in a file
let vimDir = '$HOME/.vim'
if has('persistent_undo')
    let TheUndoDir = expand(vimDir . '/undo')
    " Create dirs
    call system('mkdir ' . vimDir)
    call system('mkdir ' . TheUndoDir)
    let &undodir = TheUndoDir
    set undofile
endif

" install vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" install plugins
call plug#begin('~/.vim/plugged')
Plug 'psf/black'
Plug 'lifepillar/vim-solarized8'
call plug#end()

" stop inserting comments automatically
" https://vim.fandom.com/wiki/Disable_automatic_comment_insertion
" this must come after plugins or it gets overridden.
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
autocmd BufNewFile,BufRead * setlocal formatoptions-=cro

" run 'black' on save
autocmd BufWritePre *.py execute ':Black'

" solarized
" may need to run this in Vim:
" :source %
" :PlugInstall
" https://vimawesome.com/plugin/solarized-8
set background=dark
colorscheme solarized8
