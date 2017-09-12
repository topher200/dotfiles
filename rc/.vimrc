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