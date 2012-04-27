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
set autoindent
set nostartofline
set ruler
set laststatus=2
set confirm
set visualbell
set t_vb=
set mouse=a
set cmdheight=2
set number
set notimeout ttimeout ttimeoutlen=200
set pastetoggle=<F11>
set smartindent
set tabstop=4
set shiftwidth=4
set expandtab
set switchbuf+=usetab,newtab
set nocp
set textwidth=120
set cursorline
set title
set t_Co=256

map Y y$
nnoremap <C-L> :nohl<CR><C-L>
command! Make make! | copen
map <F5> :Make<CR><C-w>
map <F4> :ccl<CR>
map <F2> :NERDTreeToggle \| :silent NERDTreeMirror<CR>

set tags+=~/.vim/tags/cpp
set tags+=~/.vim/tags/gl
set tags+=~/.vim/tags/sdl

map <C-F12> :!ctags -R --sort=yes --c++-kinds=+p --fields=+iaS --extra=+q .<CR>

let OmniCpp_NamespaceSearch = 1
let OmniCpp_GlobalScopeSearch = 1
let OmniCpp_ShowAccess = 1
let OmniCpp_ShowPrototypeInAbbr = 1 " show function parameters
let OmniCpp_MayCompleteDot = 1 " autocomplete after .
let OmniCpp_MayCompleteArrow = 1 " autocomplete after ->
let OmniCpp_MayCompleteScope = 1 " autocomplete after ::
let OmniCpp_DefaultNamespaces = ["std", "_GLIBCXX_STD"]

let g:neocomplcache_enable_at_startup = 1

au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
set completeopt=menuone,menu,longest,preview

au FileType ruby,coffee,ruby setlocal shiftwidth=2 tabstop=2
au FileType css setlocal omnifunc=csscomplete#CompleteCSS
au FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
au FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
au FileType python setlocal omnifunc=pythoncomplete#Complete
au FileType ruby setlocal omnifunc=rubycomplete#Complete
au FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
au FileType cpp setlocal omnifunc=omni#cpp#complete#Main
au VimEnter *  NERDTree

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

