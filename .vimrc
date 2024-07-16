" Install Vundle:
" git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
" then open vim and run :PluginInstall

set nocompatible " be iMproved, required
filetype off " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" Plugins:
Plugin 'scrooloose/nerdtree'
"Plugin 'tpope/vim-surround'
"Plugin 'kien/rainbow_parentheses.vim'
Plugin 'junegunn/rainbow_parentheses.vim'
"Plugin 'scrooloose/syntastic'
"Plugin 'altercation/vim-colors-solarized'
Plugin 'airblade/vim-gitgutter'
"Plugin 'valloric/youcompleteme'
Plugin 'leafgarland/typescript-vim'
"Plugin 'tpope/vim-fugitive'
Plugin 'ctrlpvim/ctrlp.vim'
"Plugin 'rizzatti/dash.vim'
"Plugin 'dkprice/vim-easygrep'
"Plugin 'mhinz/vim-grepper'
Plugin 'tomasiser/vim-code-dark'
"Plugin 'nvie/vim-flake8'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" show existing tab with 4 spaces width
set tabstop=2
" when indenting with '>', use 4 spaces width
set shiftwidth=2
" On pressing tab, insert spaces
set expandtab

" Line numbers"
set number

syntax on
set t_Co=256
set t_ut=
colorscheme codedark
" colorscheme torte
set ic " Ignore case when searching
set hlsearch " Enable highlight search results
set backspace=indent,eol,start

" Syntastic
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*
"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
"let g:syntastic_check_on_open = 1
"let g:syntastic_check_on_wq = 0
"let syntastic_mode_map = { 'passive_filetypes': ['html'] }
"autocmd BufNewFile,BufRead *.ts setlocal filetype=typescript

" vim-gitgutter
set updatetime=100

let g:OmniSharp_server_type = 'roslyn'

" vim-grepper
if executable('rg')
    "command! -nargs=+ -complete=file GrepperRg Grepper -side -noprompt -tool rg -query <args>
    nnoremap <Leader>g :Grepper -side -noprompt -tool rg -query -i<SPACE>
endif

" NERDTree
"au VimEnter * NERDTree " automatically open NERDTree on vim open
"(1/2) automatically open NERDTree if no arguments
autocmd StdinReadPre * let s:std_in=1
"(2/2) automatically open NERDTree if no arguments
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
"Easily open and close NERDTree
noremap <Leader>f :NERDTreeToggle<Enter> 
nnoremap <silent> <Leader>v :NERDTreeFind<CR>
let NERDTreeShowHidden=1

" rainbow_parentheses
" Always on:
" au VimEnter * RainbowParenthesesToggle
" au Syntax * RainbowParenthesesLoadRound
" au Syntax * RainbowParenthesesLoadSquare
" au Syntax * RainbowParenthesesLoadBraces
autocmd VimEnter * RainbowParentheses
