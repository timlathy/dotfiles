syntax enable

" Use spaces instead of tabs
set tabstop=2 softtabstop=0 expandtab shiftwidth=2

set number " Show line numbers
set cursorline " Highlight current line
set incsearch " Search when typing
set title " Update terminal title
set ttimeoutlen=0 " Remove delay on <Esc>
set splitbelow " Open new windows below the current one
set termwinsize=10x0 " Default terminal size = 10 rows x current width

filetype plugin indent on

autocmd BufNewFile,BufReadPost *.md set filetype=markdown

" Use tabs instead of spaces in Makefiles
autocmd FileType make set noexpandtab

" When in Normal mode, translate Russian characters into corresponding
" English keys on a standard QWERTY/ЙЦУКЕН layout.
set langmap=ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz

"
" Plugins
"

" https://github.com/slim-template/vim-slim/issues/19
let g:polyglot_disabled = ['slim']

source $HOME/.vim/plugins.vim

" onedark.vim
let g:onedark_color_overrides = {
\ "red": {"gui": "#d75faf", "cterm": "169", "cterm16": "5" },
\}
set background=dark
colorscheme onedark
set termguicolors

" Display a vertical line at 80 characters
set colorcolumn=80

" lightline.vim
let g:lightline = {
  \ 'colorscheme': 'onedark',
  \ }
set laststatus=2
set noshowmode

" https://github.com/posva/vim-vue/issues/95
let g:vue_disable_pre_processors = 1

let ruby_operators = 1

" Markdown
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_no_default_key_mappings = 1

"
" Commands
"

" Clear the search pattern
command C let @/=""

"
" Keyboard mappings
"

let mapleader=" "

" Consistent undo-redo bindings
nnoremap <Leader>u :u<CR>
nnoremap <Leader>r <C-r> 

" Alternative for block visual mode
nnoremap <Leader>v <C-v>

" Clipboard integration
vmap <Leader>y "+y
nmap <Leader>p "+p
nmap <Leader>P "+P

" File navigation
nnoremap <Leader>n :NERDTreeToggle<CR>
nnoremap <Leader>j :GFiles<CR>
nnoremap <Leader>J :Files<CR>
nnoremap <Leader>g :Ag<CR>

" Tabs
nnoremap <silent> <A-Right> :tabnext<CR>
nnoremap <silent> <A-Left> :tabprevious<CR>
nnoremap <silent> <C-t> :tabnew<CR>

" Terminal
nnoremap <Leader>t :term<CR>

" Center search results on the matching line
map N Nzz
map n nzz

" Breaking bad habits...
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

" ...
nnoremap <Leader>A :BasmJumpToAddr 
nnoremap <silent> <Leader>a :call BasmPrintAddr()<CR>
nnoremap <silent> <Leader>w :call BasmJumpToLabel()<CR>
