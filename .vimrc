filetype plugin indent on
syntax on

set hidden
set hlsearch
set ignorecase smartcase
set backspace=indent,eol,start
set nostartofline
set laststatus=2
set confirm
set noerrorbells visualbell t_vb=
set mouse=a
set cmdheight=1
set number cursorline
set notimeout ttimeout ttimeoutlen=50
set pastetoggle=<F11>
set cindent expandtab smartindent autoindent tabstop=4 shiftwidth=4
set cinkeys=0{,0},:,0#
set switchbuf+=usetab,newtab
set title
set t_Co=256
set encoding=utf-8
set nolist
set formatoptions+=l
set fillchars+=vert:█

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
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"

map! <s-insert> <c-r>*

set tags+=~/.vim/tags/cpp
set tags+=~/.vim/tags/gl
set tags+=~/.vim/tags/openal
set tags+=~/.vim/tags/sdl
set tags+=~/.vim/tags/ogre
set tags+=~/.vim/tags/cegui
set tags+=~/.vim/tags/wx

let g:load_doxygen_syntax = 1
let g:DoxygenToolkit_endCommentBlock = "**/"
let g:DoxygenToolkit_endCommentTag = "**/"

let g:neocomplcache_enable_at_startup = 1
let g:neocomplcache_enable_smart_case = 1
let g:neocomplcache_min_syntax_length = 3
let g:neocomplcache_enable_auto_delimiter = 1

if !exists('g:neocomplcache_keyword_patterns')
    let g:neocomplcache_keyword_patterns = {}
endif

let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

if !exists('g:neocomplcache_omni_patterns')
    let g:neocomplcache_omni_patterns = {}
endif

let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'
let g:neocomplcache_omni_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
let g:neocomplcache_omni_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

let g:syntastic_stl_format = ""
let g:syntastic_cpp_compiler_options = " -std=c++11"

let g:airline_theme="powerlineish"
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
set completeopt=menuone,longest

au BufWritePre * :retab | :%s/\s\+$//e | :call histdel("/", -1)

au FileType coffee,python,ruby set shiftwidth=2 tabstop=2
au FileType css set omnifunc=csscomplete#CompleteCSS
au FileType html,markdown set omnifunc=htmlcomplete#CompleteTags
au FileType javascript set omnifunc=javascriptcomplete#CompleteJS
au FileType python set omnifunc=pythoncomplete#Complete
au FileType ruby set omnifunc=rubycomplete#Complete
au FileType xml set omnifunc=xmlcomplete#CompleteTags
au FileType cpp set omnifunc=omni#cpp#complete#Main

au BufNewFile,BufRead *.h setfiletype cpp
au BufNewFile,BufRead *.anims,*.imageset setfiletype xml

colorscheme ahoka

set guioptions=

set guifont=ProFont
set guicursor=n-v-c:block-Cursor
set guicursor+=i:block-Cursor
set guicursor+=n-v-c:blinkon0
set guicursor+=i:blinkon0

