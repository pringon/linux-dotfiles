runtime! debian.vim

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

let g:nvim_typescript#diagnostics_enable = 1

"ctags configuration
let g:gutentags_exclude_filetypes = ["node_modules", "*.swp", ".git", ".vscode", ".gitignore", "*min.js", "*min.css"]

"select airline theme
let g:airline_theme='solarized'
let g:airline_solarized_bg='dark'

let g:airline_powerline_fonts = 1

let g:airline#extensions#tabline#enabled = 1

filetype plugin indent on

set number relativenumber

set autoindent
set expandtab
set softtabstop=2
set shiftwidth=2
set shiftround

set showcmd

set hlsearch

set ttyfast
set lazyredraw

set splitbelow
set splitright

set cursorline
set wrapscan
set laststatus=2 
set report=0


set splitbelow
set splitright

tnoremap <Esc> <C-\><C-n>
map <Tab> :NERDTreeToggle<CR>

nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
