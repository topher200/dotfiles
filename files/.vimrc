set autoindent
set expandtab
set smartcase
set ignorecase
set incsearch
set tabstop=2
set shiftwidth=4
set softtabstop=4
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

" run 'black' on save
autocmd BufWritePre *.py execute ':Black'

" solarized
set background=dark
colorscheme solarized8
