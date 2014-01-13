set nocompatible
filetype off

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'

Bundle 'scrooloose/syntastic'
Bundle 'scrooloose/nerdtree'
Bundle 'yegappan/grep'
Bundle 'xolox/vim-misc'
Bundle 'xolox/vim-session'
Bundle 'bling/vim-airline'
Bundle 'tpope/vim-fugitive'
Bundle 'Yggdroot/indentLine'
Bundle 'DoxygenToolkit.vim'
Bundle 'Shougo/neocomplete.vim'
Bundle 'Shougo/neosnippet'
Bundle 'honza/vim-snippets'
Bundle 'Raimondi/delimitMate'
Bundle 'OmniCppComplete'
Bundle 'a.vim'
Bundle 'drmikehenry/vim-headerguard'
Bundle 'vim-jp/cpp-vim'
Bundle 'vim-ruby/vim-ruby'
Bundle 'tikhomirov/vim-glsl'

filetype plugin indent on
syntax on

set hidden
set incsearch
set hlsearch
set ignorecase
set smartcase
set backspace=indent,eol,start
set nostartofline
set laststatus=2
set confirm
set noerrorbells
set visualbell
set t_vb=
set mouse=a
set cmdheight=1
set number
set cursorline
set notimeout
set ttimeout
set ttimeoutlen=50
set expandtab
set autoindent
set smartindent
set tabstop=4
set shiftwidth=4
set switchbuf+=usetab,newtab
set title
set t_Co=256
set encoding=utf-8
set nolist
set formatoptions+=l
set fillchars+=vert:│
set completeopt=menuone,longest
set foldcolumn=1
set showmatch

map! <S-Insert> <MiddleMouse>
map <silent> <F2> :NERDTreeToggle \| :NERDTreeMirror<CR>
map <silent> <F4> :ccl<CR>
map <silent> <F5> :make! \| :copen<CR>
map <silent> <F12> :!ctags -R --sort=yes --c++-kinds=+p --fields=+iaS --extra=+q .<CR>

" Move tabs with alt + left|right
nnoremap <silent> <A-Left> :execute 'silent! tabmove ' . (tabpagenr()-2)<CR>
nnoremap <silent> <A-Right> :execute 'silent! tabmove ' . tabpagenr()<CR>

" Switch tabs with ctrl + left|right
nnoremap <silent> <C-Left> :tabp<CR>
nnoremap <silent> <C-Right> :tabn<CR>

" Remove search highlighting with ctrl + l
noremap <silent> <C-l> :nohl<CR>
inoremap <silent> <C-l> <C-o>:nohl<CR>

" Map ctrl + s to save current buffer if its been modified
noremap <silent> <C-s> :update<CR>
inoremap <silent> <C-s> <C-o>:update<CR>

noremap <silent> <C-w> :bd<CR>

noremap <C-f> :GrepBuffer<Space>
inoremap <C-f> <C-o>:GrepBuffer<Space>

inoremap ;<CR> <End>;<CR>
inoremap ,<CR> <End>,<CR>

set tags+=~/.vim/tags/cpp
set tags+=~/.vim/tags/gl
set tags+=~/.vim/tags/sdl
set tags+=~/.vim/tags/ogre
set tags+=~/.vim/tags/cegui

let g:indentLine_char = '┆'
let g:indentLine_bufNameExclude = [ "NERD_tree_.*" ]

let g:load_doxygen_syntax = 1
let g:DoxygenToolkit_endCommentBlock = '**/'
let g:DoxygenToolkit_endCommentTag = '**/'

" neocomplete
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_smart_case = 1
let g:neocomplete#sources#syntax#min_keyword_length = 3

if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
endif

let g:neocomplete#keyword_patterns['default'] = '\h\w*'

inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
    return neosnippet#expandable_or_jumpable() ? neosnippet#mappings#expand_or_jump_impl()
                \: pumvisible() ? neocomplete#close_popup() : "\<CR>"
endfunction
inoremap <expr><TAB>   pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><Down>  pumvisible() ? "\<C-n>" : "\<Down>"
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<S-TAB>"
inoremap <expr><Up>    pumvisible() ? "\<C-p>" : "\<Up>"

if !exists('g:neocomplete#omni_patterns')
    let g:neocomplete#omni_patterns = {}
endif

let g:neocomplete#omni_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'
let g:neocomplete#omni_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
let g:neocomplete#omni_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

" For snippet_complete marker.
if has('conceal')
  set conceallevel=2 concealcursor=i
endif

let g:neosnippet#snippets_directory = '~/.vim/bundle/vim-snippets/snippets'

function! b:HeaderguardName()
    return "_" . toupper(expand('%:t:gs/[^0-9a-zA-Z_]/_/g')) . "_"
endfunction

let g:syntastic_stl_format = ''
let g:syntastic_cpp_compiler_options = ' -std=c++11'

let g:airline_theme='powerlineish'
let g:airline_powerline_fonts=1

set sessionoptions-=help
set sessionoptions-=options
set sessionoptions+=resize
set sessionoptions+=tabpages

let g:session_autosave = 'yes'
let g:session_autoload = 'yes'
let g:session_autosave_periodic = 5
let g:session_default_to_last = 1

command! -bar -bang -nargs=? -complete=customlist,xolox#session#complete_names OS call xolox#session#open_cmd(<q-args>, <q-bang>, 'OS')
command! -bar -bang -nargs=? -complete=customlist,xolox#session#complete_names SS call xolox#session#save_cmd(<q-args>, <q-bang>, 'SS')

au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif

" Retab and trim trailing white-space
au BufWritePre * :retab | :%s/\s\+$//e | :call histdel('/', -1)

au FileType coffee,python,ruby set shiftwidth=2 tabstop=2
au FileType css set omnifunc=csscomplete#CompleteCSS
au FileType html,markdown set omnifunc=htmlcomplete#CompleteTags
au FileType javascript set omnifunc=javascriptcomplete#CompleteJS
au FileType python set omnifunc=pythoncomplete#Complete
au FileType xml set omnifunc=xmlcomplete#CompleteTags
au FileType cpp set omnifunc=omni#cpp#complete#Main

au BufNewFile,BufRead *.h setfiletype cpp
au BufNewFile,BufRead *.anims,*.imageset setfiletype xml

colorscheme ahoka

set guioptions=+a
set guifont=ProFont
set guicursor=n-v-c:block-Cursor
set guicursor+=i:block-Cursor
set guicursor+=n-v-c:blinkon0
set guicursor+=i:blinkon0
