" Set pathfor python =========================================================
let g:python3_host_prog='/usr/bin/python3'
"=============================================================================

" General config =============================================================
colorscheme gruvbox
filetype plugin indent on
syntax on
set background=dark
set tabstop=2
set shiftwidth=2
set expandtab
set t_Co=256
set tags=./tags;
set number
set relativenumber
set listchars=eol:⏎,tab:>· list
highlight Comment gui=bold

"=============================================================================


" Key bindings ===============================================================
let mapleader=","
" ============================================================================

nnoremap <leader>bb :buffers<cr>:b<space>
nnoremap <leader>bc :bd<cr>
nnoremap <leader><tab> :b#<cr>
imap <leader><leader> <esc>
imap <leader><leader>q <esc>:q!<CR>
imap <leader>w <esc>:w<CR>
imap <leader>wq <esc>:wq<CR>
" ============================================================================
nmap <leader>q :NERDTreeToggle<CR>
nmap \ <leader>q
nmap <silent> <leader><leader> :noh<CR>:q<CR>
" ============================================================================

" Auto-reload config on save =================================================
if has ('autocmd') " Remain compatible with earlier versions
augroup vimrc      " Source vim configuration upon save
    autocmd! BufWritePost $MYVIMRC source % | echom "Reloaded " . $MYVIMRC | redraw
    autocmd! BufWritePost $MYGVIMRC if has('gui_running') | so % | echom "Reloaded " . $MYGVIMRC | endif | redraw
    augroup END
endif " has autocmd
" ============================================================================

" AutoInstall vim-plug ================================================
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  "autocmd VimEnter * PlugInstall
  "autocmd VimEnter * PlugInstall | source $MYVIMRC
endif
"======================================================================


set backspace=2         " Backspace deletes like most programs in insert mode
set nobackup
set nowritebackup
set noswapfile          " http://robots.thoughtbot.com/post/18739402579/global-gitignore#comment-458413287
set noshowmode
set autowrite           " Automatically :write before running commands
set relativenumber      " show the numbers above your line to relative of current line
set mouse=a             " make vim clickable
set spelllang=en        " spelling in english
set pastetoggle=<F2>    " allow pasting with correct indentation
set cursorline
set smartindent
set nowrap
set hidden
set ignorecase
set smartcase
set lazyredraw
set magic
set exrc
set number
set completeopt=menuone,noinsert,noselect
set updatetime=50
set inccommand=split

set spell spelllang=en_gb
nnoremap <leader>sp :norm mm[s1z=`m<cr>

set shiftround
set expandtab

" To automatically unfold all of a file
set foldlevelstart=99

" Use one space, not two, after punctuation.
set nojoinspaces

set vb t_vb=
set undofile

" https://github.com/junegunn/fzf.vim/issues/456
" Depending where it's installed
set rtp+=~/.fzf
set rtp+=/usr/local/opt/fzf

" Use RG for grepping
set grepprg=rg\ --vimgrep\ --smart-case\ --hidden\ --follow

" Splits open to the right and below
set splitbelow splitright

set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath

autocmd BufWritePre * %s/\s\+$//e

filetype off                  " required

call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-fugitive'
Plug 'scrooloose/nerdtree'
Plug 'gruvbox-community/gruvbox'
Plug 'neoclide/coc.nvim', { 'branch': 'release' }
Plug 'mbbill/undotree'
Plug 'tpope/vim-commentary'
Plug 'pangloss/vim-javascript'
Plug 'plasticboy/vim-markdown'
Plug 'mattn/emmet-vim'
Plug 'junegunn/vim-easy-align'
Plug 'christoomey/vim-system-copy'
Plug 'vim-airline/vim-airline'
Plug 'tpope/vim-surround'
Plug 'jiangmiao/auto-pairs'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'elixir-editors/vim-elixir'
Plug 'rafi/awesome-vim-colorschemes'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install'  }
Plug 'haydenrou/tickit.vim'
Plug 'tpope/vim-dispatch'

" Use rg for FZF
if executable('rg')
  let g:rg_derive_root='true'
endif

call plug#end()

syntax on


let g:gruvbox_contrast_dark = 'hard'
if exists('+termguicolors')
        let &t_8f = "\<Esc[38;2;%lu;%lu;%lum"
        let &t_8b = "\<Esc[48;2;%lu;%lu;%lum"
endif
let g:gruvbox_invert_selection='0'
colorscheme gruvbox

hi Normal guibg=NONE ctermbg=NONE
hi NonText guibg=NONE ctermbg=NONE
hi Search cterm=NONE ctermbg=LightMagenta ctermfg=black

" Make it obvious where 80 characters is
highlight ColorColumn ctermbg=red
call matchadd('ColorColumn', '\%81v', 100)

" When editing a file, always jump to the last known cursor position.
" Don't do it for commit messages, when the position is invalid, or when
" inside an event handler (happens when dropping a file on gvim).
autocmd BufReadPost *
  \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
  \   exe "normal g`\"" |
  \ endif

autocmd FileType javascript,javascriptreact,javascript.jsx,javascript.tsx setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd BufNewFile,BufRead *.jsx set filetype=javascriptreact
autocmd BufNewFile,BufRead *.tsx set syntax=javascriptreact
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete

" When the type of shell script is /bin/sh, assume a POSIX-compatible
" shell for syntax highlighting purposes.
let g:is_posix = 1

set wildmode=list:longest,list:full

nnoremap <Leader><Enter> :noh<cr>

" Treat <li> and <p> tags like the block tags they are
let g:html_indent_tags = 'li\|p'

" Quicker window movement
nnoremap <Leader>j <C-w>j
nnoremap <Leader>k <C-w>k
nnoremap <Leader>h <C-w>h
nnoremap <Leader>l <C-w>l

nnoremap <Leader>w :w!<cr>

" Vertical and horizontal splits
nnoremap <Leader>vs <C-w>v
nnoremap <Leader>xs <C-w>S

nnoremap <silent> <Leader>+ :vertical resize +5<CR>
nnoremap <silent> <Leader>- :vertical resize -5<CR>

" for easyalign
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

autocmd FileType html,css,erb,jsx,javascript,rb,typescriptreact,javascriptreact,scss setlocal shiftwidth=2 tabstop=2 softtabstop=2
autocmd FileType go set softtabstop=0 noexpandtab
autocmd FileType html,css,erb,jsx,javascript,typescriptreact,javascriptreact EmmetInstall

" https://github.com/tpope/vim-commentary/issues/68
autocmd FileType javascript,javascriptreact,typescript,typescriptreact setlocal commentstring={/*\ %s\ */}

" PLUGIN: Coc-vim
function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
endfunction

call tickit#set_ticker("")
call tickit#set_location($HOME . "/projects/notes/TODO.md")

func GoCoC()
    :CocEnable
    inoremap <buffer> <silent><expr> <TAB>
                \ pumvisible() ? "\<C-n>" :
                \ <SID>check_back_space() ? "\<TAB>" :
                \ coc#refresh()

    inoremap <buffer> <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
    inoremap <buffer> <silent><expr> <C-space> coc#refresh()

    " GoTo code navigation.
    nmap <buffer> <leader>gd <Plug>(coc-definition)
    nmap <buffer> <leader>gy <Plug>(coc-type-definition)
    nmap <buffer> <leader>gi <Plug>(coc-implementation)
    nmap <buffer> <leader>gr <Plug>(coc-references)
    nmap <buffer> <leader>rr <Plug>(coc-rename)
    nnoremap <buffer> <leader>cr :CocRestart
endfun

autocmd BufEnter * :call GoCoC()

nnoremap \ :Rg<CR>

let g:netrw_browse_split=2
let g:netrw_banner=0
let g:netrw_winsize=25

" PLUGIN: Nerdtree
let NERDTreeMinimalUI = 1
let NERDTreeWinPos = "right"
let NERDTreeShowHidden=1
map <Leader>nf :NERDTreeFind<cr>
nnoremap <Leader>nn :NERDTreeToggle<Enter>

" PLUGIN: Fugitive
nmap <leader>gst :G<CR>
nmap <leader>gj :diffget //3<CR>
nmap <leader>gf :diffget //2<CR>
nmap <leader>gdf :Gdiff<CR>

" PLUGIN: Undotree
nnoremap <leader>u :UndotreeShow<CR>

" fzf for file searching
nnoremap <C-T> :Files<cr>
nnoremap <Leader>b :Buffers<cr>
nnoremap <Leader>s :BLines<cr>
let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.8 } }

" find word under cursor
nnoremap <leader>prr :CocSearch <C-R>=expand("<cword>")<CR><CR>
nnoremap <leader>pw :Rg <C-R>=expand("<cword>")<CR><CR>

" delete and paste register from visual mode
vnoremap <leader>p "_dP

function Loadproj(proj) abort
        let g:autoload_path = "~/projects/" . a:proj . "/autoload/" . a:proj
        let g:plugin_path = "~/projects/" . a:proj . "/plugin/" . a:proj

        execute "source" . g:autoload_path
        execute "source" . g:plugin_path
endfunction

nnoremap <C-Left> :tabprevious<CR>
nnoremap <C-Right> :tabnext<CR>
inoremap <leader>t <esc>:tabnext<CR>
nnoremap <leader>t :tabnext<CR>

inoremap <c-c> <ESC>

