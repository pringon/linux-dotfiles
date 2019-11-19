call plug#begin('~/.vim/plugged')

Plug 'crusoexia/vim-monokai'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'HerringtonDarkholme/yats.vim'
Plug 'mhartington/nvim-typescript', {'do': './install.sh'}
" For async completion
Plug 'Shougo/deoplete.nvim', { 'do': 'UpdateRemotePlugins' }
" For Denite features
Plug 'Shougo/denite.nvim'
Plug 'prettier/vim-prettier', { 'do': 'npm install' }
Plug 'hashivim/vim-terraform'

call plug#end()


"enable line numbers in nerdtree
let NERDTreeShowLineNumbers = 1
autocmd FileType nerdtree setlocal number relativenumber

"enable deoplete at startup
let g:deoplete#enable_at_startup = 1

let g:nvim_typescript#diagnostics_enable = 1

"ctags configuration
let g:gutentags_exclude_filetypes = ["node_modules", "*.swp", ".git", ".vscode", ".gitignore", "*min.js", "*min.css"]

"select airline theme
let g:airline_theme='wombat'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1

"prettier settings
let g:prettier#autoformat = 0
autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.md,*.vue,*.yaml,*.html Prettier

filetype plugin indent on

syntax on
set t_Co=256
colorscheme monokai

"json highlighting
autocmd BufNewFile,BufRead *.json set ft=javascript

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

map <Tab> :NERDTreeToggle<CR>

nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

inoremap " ""<left>
inoremap ' ''<left>
inoremap ( ()<left>
inoremap [ []<left>
inoremap { {}<left>
inoremap {<CR> {<CR>}<ESC>O
inoremap {;<CR> {<CR>};<ESC>O
