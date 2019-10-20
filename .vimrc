"select powerline font for gvim
if has('gui_running')
    set guifont=Fira\ Mono\ for\ Powerline\ 10
endif

call plug#begin('~/.vim/plugged')

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-fugitive'
Plug 'HerringtonDarkholme/yats.vim'
Plug 'mhartington/nvim-typescript', {'do': './install.sh'}
" For async completion
Plug 'Shougo/deoplete.nvim', { 'do': 'UpdateRemotePlugins' }
" For Denite features
Plug 'Shougo/denite.nvim'

call plug#end()

"enable deoplete at startup
let g:deoplete#enable_at_startup = 1
"deoplete tab completion
inoremap <silent><expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
inoremap <silent><expr><s-tab> pumvisible() ? "\<c-p>" : "\<s-tab>"

"ctags configuration
let g:gutentags_exclude_filetypes = ["node_modules", "*.swp", ".git", ".vscode", ".gitignore", "*min.js", "*min.css"]

"select airline theme
let g:airline_theme='solarized'
let g:airline_solarized_bg='dark'

let g:airline_powerline_fonts = 1

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

let g:airline_symbols.space = "\ua0"

let g:airline#extensions#tabline#enabled = 1

let g:airline#extensions#tabline#show_buffers = 0

let g:airline#extensions#hunks#enabled=0

let g:airline#extensions#branch#enabled=1

let g:powerline_pycmd="py3"

set nocompatible

filetype plugin indent on
syntax on

set number relativenumber

set autoindent
set expandtab
set softtabstop=2
set shiftwidth=2
set shiftround

set laststatus=2

set showmode
set showcmd

set incsearch
set hlsearch

set ttyfast
set lazyredraw

set splitbelow
set splitright

set cursorline
set wrapscan
set report=0


set splitbelow
set splitright

tnoremap <Esc> <C-\><C-n>
map <Tab> :NERDTreeToggle<CR>

nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
