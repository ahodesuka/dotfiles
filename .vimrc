filetype plugin indent on
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
set noerrorbells visualbell t_vb=
set t_vb=
set mouse=a
set cmdheight=1
set number
set notimeout ttimeout ttimeoutlen=50
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
set encoding=utf-8
set wrap
set wrapmargin=0
set linebreak
set nolist
set formatoptions+=l

map Y y$
nnoremap <C-L> :nohl<CR><C-L>
command! Make make! | copen
map <F2> :NERDTreeToggle \| :silent NERDTreeMirror<CR>
map <F5> :Make<CR><C-w>
map <F4> :ccl<CR>
map <C-F12> :!ctags -R --sort=yes --c++-kinds=+p --fields=+iaS --extra=+q .<CR>
" Move tabs with alt + left|right
nnoremap <silent> <A-Left> :execute 'silent! tabmove ' . (tabpagenr()-2)<CR>
nnoremap <silent> <A-Right> :execute 'silent! tabmove ' . tabpagenr()<CR>

set tags+=~/.vim/tags/cpp
set tags+=~/.vim/tags/gl
set tags+=~/.vim/tags/openal
set tags+=~/.vim/tags/sdl
set tags+=~/.vim/tags/ogre
set tags+=~/.vim/tags/cegui
set tags+=~/.vim/tags/wx

let g:neocomplcache_enable_at_startup = 1
let g:neocomplcache_enable_smart_case = 1
let g:neocomplcache_min_syntax_length = 2
let g:neocomplcache_enable_auto_select = 1
let g:neocomplcache_enable_auto_delimiter = 1
let g:neocomplcache_dictionary_filetype_lists = { 'default' : '' }

let g:airline_powerline_fonts=1

set sessionoptions-=help
set sessionoptions-=options
set sessionoptions+=resize
set sessionoptions+=tabpages

let g:session_autosave = "yes"
let g:session_autoload = "yes"
let g:session_default_to_last = 1

command! -bar -bang -nargs=? -complete=customlist,xolox#session#complete_names OS call xolox#session#open_cmd(<q-args>, <q-bang>, 'OS')
command! -bar -bang -nargs=? -complete=customlist,xolox#session#complete_names SS call xolox#session#save_cmd(<q-args>, <q-bang>, 'SS')

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

au BufNewFile,BufRead *.h setfiletype cpp

if !exists('g:neocomplcache_omni_patterns')
    let g:neocomplcache_omni_patterns = {}
endif
let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'
let g:neocomplcache_omni_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
let g:neocomplcache_omni_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

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

colorscheme jellybeans

hi TabLineFill  ctermfg=242 ctermbg=235 guifg=#666 guibg=#111
hi TabLineSel   ctermfg=255 ctermbg=234 guifg=#eee guibg=#1b1b1b
hi TabLine      ctermfg=242 ctermbg=235 guifg=#666 guibg=#111
hi Title        ctermfg=251 guifg=#c48181
set guifont=ProFont

set guicursor=n-v-c:block-Cursor
set guicursor+=i:block-Cursor
set guicursor+=n-v-c:blinkon0
set guicursor+=i:blinkon0
