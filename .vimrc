filetype on
filetype plugin on
syntax on

set hidden
set wildmenu
set showcmd
set hlsearch
set nocompatible
set ignorecase
set smartcase
set backspace=indent,eol,start
set nostartofline
set ruler
set laststatus=2
set confirm
set visualbell
set t_vb=
set mouse=a
set cmdheight=1
set number
set notimeout ttimeout ttimeoutlen=200
set pastetoggle=<F11>
set cindent
set smartindent
set autoindent
set expandtab
set tabstop=4
set shiftwidth=4
set cinkeys=0{,0},:,0#
set switchbuf+=usetab,newtab
set nocp
set textwidth=120
set cursorline
set title
set t_Co=256

map Y y$
nnoremap <C-L> :nohl<CR><C-L>
command! Make make! | copen
map <F2> :NERDTreeToggle \| :silent NERDTreeMirror<CR>
map <F5> :Make<CR><C-w>
map <F4> :ccl<CR>
map <C-F12> :!ctags -R --sort=yes --c++-kinds=+p --fields=+iaS --extra=+q .<CR>

set tags+=~/.vim/tags/cpp
set tags+=~/.vim/tags/gl
set tags+=~/.vim/tags/sdl

let g:neocomplcache_enable_at_startup = 1
let g:neocomplcache_enable_smart_case = 1
let g:neocomplcache_enable_camel_case_completion = 1
let g:neocomplcache_enable_underbar_completion = 1
let g:neocomplcache_enable_auto_select = 1

let g:Powerline_symbols = "fancy"

let g:session_autoload = 1
let g:session_autosave = 1
let g:session_default_to_last = 1

ca SS SaveSession
ca OS OpenSession

au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
set completeopt=menuone,menu,longest,preview

au BufWritePre * :%s/\s\+$//e

au FileType coffee,python,ruby set shiftwidth=2 tabstop=2
au FileType css set omnifunc=csscomplete#CompleteCSS
au FileType html,markdown set omnifunc=htmlcomplete#CompleteTags
au FileType javascript set omnifunc=javascriptcomplete#CompleteJS
au FileType python set omnifunc=pythoncomplete#Complete
au FileType ruby set omnifunc=rubycomplete#Complete
au FileType xml set omnifunc=xmlcomplete#CompleteTags
au FileType cpp set omnifunc=omni#cpp#complete#Main

au VimEnter * NERDTree

let g:neocomplcache_dictionary_filetype_lists = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme' : $HOME.'/.gosh_completions'
    \ }

if !exists('g:neocomplcache_omni_patterns')
  let g:neocomplcache_omni_patterns = {}
endif
let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'
let g:neocomplcache_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
let g:neocomplcache_omni_patterns.c = '\%(\.\|->\)\h\w*'
let g:neocomplcache_omni_patterns.cpp = '\h\w*\%(\.\|->\)\h\w*\|\h\w*::'

" gVim
set guioptions-=m
set guioptions-=T
set guioptions-=r
set guioptions-=L

hi LineNr       term=underline ctermfg=8 guifg=Brown
hi Search       term=standout ctermfg=0 ctermbg=12 guifg=Black guibg=Blue
hi Pmenu        ctermfg=7 ctermbg=0 guibg=grey30
hi PmenuSel     ctermfg=0 ctermbg=7 guibg=Grey
hi PmenuSbar    ctermfg=7 ctermbg=0 guibg=Grey
hi PmenuThumb   cterm=reverse gui=reverse
hi CursorLine   term=NONE cterm=NONE ctermbg=black

colorscheme jellybeans
set guifont=Profont\ 8

set guicursor=n-v-c:block-Cursor
set guicursor+=i:block-Cursor
set guicursor+=n-v-c:blinkon0
set guicursor+=i:blinkon0

set noerrorbells visualbell t_vb=

