filetype plugin indent on
set tabstop=4 softtabstop=4 shiftwidth=4 expandtab smarttab autoindent
set incsearch ignorecase smartcase hlsearch
set wildmode=longest,list,full wildmenu
set ruler laststatus=2 showcmd showmode
set list listchars=trail:»,tab:»-
set fillchars+=vert:\
set wrap breakindent
set encoding=utf-8
set textwidth=0
set hidden
set title

" make Ctrl-s save (by calling ':w<enter>')
:nmap <c-s> :w<CR>
:imap <c-s> <Esc>:w<CR>a

" allow sudo even if we forgot to open vim with 'sudo vim'
cmap w!! w !sudo tee > /dev/null %

" stop inserting comments automatically
" https://vim.fandom.com/wiki/Disable_automatic_comment_insertion
" this must come after plugins or it gets overridden.
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
autocmd BufNewFile,BufRead * setlocal formatoptions-=cro

" tell copilot where to find node
let g:copilot_node_command = '/home/topher/micromamba/envs/memfault/.volta/tools/image/node/22.14.0/bin/node'
