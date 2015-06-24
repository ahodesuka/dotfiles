set nocp
filetype off

set rtp+=~/.vim/bundle/vundle/
call vundle#begin()
Plugin 'gmarik/vundle'

" General plugins {{{
Plugin 'scrooloose/syntastic'
Plugin 'scrooloose/nerdtree'
Plugin 'xolox/vim-misc'
Plugin 'embear/vim-localvimrc'
Plugin 'xolox/vim-session'
Plugin 'bling/vim-airline'
Plugin 'tpope/vim-fugitive'
Plugin 'airblade/vim-gitgutter'
Plugin 'majutsushi/tagbar'
Plugin 'yegappan/grep'
Plugin 'Yggdroot/indentLine'
Plugin 'DoxygenToolkit.vim'
Plugin 'Shougo/neocomplete.vim'
Plugin 'Shougo/neosnippet'
Plugin 'honza/vim-snippets'
Plugin 'Raimondi/delimitMate'
Plugin 'oblitum/rainbow'
Plugin 'DeleteTrailingWhitespace'
Plugin 'godlygeek/tabular'
Plugin 'antoyo/vim-licenses'
" }}}

" Language specific plugins {{{
" C and C++
Plugin 'OmniCppComplete'
Plugin 'a.vim'
Plugin 'drmikehenry/vim-headerguard'
Plugin 'vim-jp/cpp-vim'
Plugin 'octol/vim-cpp-enhanced-highlight'

" JS
Plugin 'kchmck/vim-coffee-script'
Plugin 'jelera/vim-javascript-syntax'
Plugin 'myhere/vim-nodejs-complete'

" GLSL
Plugin 'tikhomirov/vim-glsl'

" Ruby
Plugin 'vim-ruby/vim-ruby'
Plugin 'noprompt/vim-yardoc'

" Web
Plugin 'hail2u/vim-css3-syntax'
Plugin 'othree/html5.vim'
" }}}

call vundle#end()
filetype plugin indent on
syntax on

" Settings {{{
" These really should be sorted and commented.
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
set lazyredraw
set notimeout
set ttimeout
set timeoutlen=1000
set ttimeoutlen=0
set expandtab
set autoindent
set cindent
set cinoptions=g0
set tabstop=4
set shiftwidth=4
set switchbuf+=usetab,newtab
set title
set t_Co=256
set encoding=utf-8
set tw=120
set wrap
set linebreak
set nolist
set formatoptions+=lt
set fillchars=vert:█,fold:█
set completeopt=menuone
set showmatch
set re=1
set nuw=6
set history=1000
set foldcolumn=1
set foldmethod=marker
set foldtext=FoldText()
set updatetime=500
" }}}

function! FoldText() " {{{
    " example: █ function! FoldText() ████████ 12 lines █
    let line = getline(v:foldstart)
    let line = substitute(line, '^\s*\(#\|//\|/\*\|"\)\?\s*\|\s*\(#\|//\|/\*\|"\)\?\s*{{' . '{\d*\s*\(\*/\)\?', '', 'g')
    let line = ' ' . line . ' '
    let lines_count = v:foldend - v:foldstart + 1
    let lines_count_text = ' ' . lines_count . ' lines '
    let foldchar = matchstr(&fillchars, 'fold:\zs.')
    let foldtextstart = strpart(repeat(foldchar, max([1, indent(v:foldstart)])) . line, 0, (winwidth(0)*2)/3)
    let foldtextend = lines_count_text . repeat(foldchar, 8)
    let foldtextlength = strlen(substitute(foldtextstart . foldtextend, '.', 'x', 'g')) + &foldcolumn + &nuw
    return foldtextstart . repeat(foldchar, winwidth(0)-foldtextlength) . foldtextend
endfunction " }}}

" Mappings {{{
map <silent> <F2> :NERDTreeToggle \| :NERDTreeMirror<CR>
map <silent> <F3> :TagbarToggle<CR>
map <silent> <F4> :ccl<CR>
map <silent> <F5> :make! \| :copen<CR>
map <silent> <F12> :!ctags -R --sort=yes --c++-kinds=+p --fields=+iaS --extra=+q .<CR>

" Move tabs with shift + h/l
nnoremap <silent><S-h> :tabmove -1<CR>
nnoremap <silent><S-l> :tabmove +1<CR>

" Switch tabs with ctrl + h/l
nnoremap <silent><C-h> :tabp<CR>
nnoremap <silent><C-l> :tabn<CR>

" Switch splits with alt + hjkl
nnoremap <silent><A-h> :wincmd h<CR>
nnoremap <silent><A-j> :wincmd j<CR>
nnoremap <silent><A-k> :wincmd k<CR>
nnoremap <silent><A-l> :wincmd l<CR>

" Resize splits with shift + alt + hjkl
nnoremap <silent><S-A-h> :vertical resize -5<CR>
nnoremap <silent><S-A-j> :resize -5<CR>
nnoremap <silent><S-A-k> :resize +5<CR>
nnoremap <silent><S-A-l> :vertical resize +5<CR>

" Remove search highlighting with ctrl + n
noremap  <silent><C-n> :nohl<CR>
inoremap <silent><C-n> <C-o>:nohl<CR>

" Map ctrl + s to save current buffer if it has been modified
noremap <silent><C-s> :update<CR>

" Map shift + s to write all buffers
noremap <silent><S-s> :wa<CR>

noremap  <C-f>      :GrepBuffer<Space>
inoremap <C-f> <C-o>:GrepBuffer<Space>

" ;/, + return moves to the end of the current line and puts ;/,
inoremap ;<CR> <End>;
inoremap ,<CR> <End>,

" space open/closes folds in normal mode
nnoremap <space> za
" space creates folds in visual mode
vnoremap <space> zf

" autocomplete mappings
function! CRCompleteFunc()
    if neosnippet#expandable_or_jumpable()
        return "\<Plug>(neosnippet_expand_or_jump)"
    elseif pumvisible()
        return neocomplete#close_popup()
    elseif delimitMate#WithinEmptyPair()
        return "\<Plug>delimitMateCR"
    endif
    return "\<CR>"
endfunction

inoremap <expr><Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr><Down>  pumvisible() ? "\<C-n>" : "\<Down>"
inoremap <expr><C-j>   pumvisible() ? "\<C-n>" : "\<C-j>"
imap     <expr><S-Tab> pumvisible() ? "\<C-p>" : "<Plug>delimitMateS-Tab"
inoremap <expr><Up>    pumvisible() ? "\<C-p>" : "\<Up>"
inoremap <expr><C-k>   pumvisible() ? "\<C-p>" : "\<C-k>"

inoremap <expr><C-g>  neocomplete#undo_completion()
inoremap <expr><C-l>  neocomplete#complete_common_string()

imap <expr><CR> CRCompleteFunc()
smap <expr><CR> neosnippet#expandable_or_jumpable() ?
          \ "<Plug>(neosnippet_expand_or_jump)" :
          \ "\<CR>"
imap <expr><BS> delimitMate#WithinEmptyPair() ?
          \ "<Plug>delimitMateBS" :
          \ neocomplete#smart_close_popup() . "\<BS>"
" }}}

" Tags {{{
set tags+=~/.vim/tags/cpp
set tags+=~/.vim/tags/glibmm
set tags+=~/.vim/tags/gdkmm-2.4
set tags+=~/.vim/tags/gtkmm-2.4
set tags+=~/.vim/tags/sigc++
" }}}

let NERDTreeIgnore=[ '\.[ls]\?o$', '\~$' ]

let g:indentLine_char = '│'
let g:indentLine_bufNameExclude = [ 'NERD_tree.*' ]
let g:indentLine_noConcealCursor = 1
let g:indentLine_color_gui = '#222222'
let g:indentLine_color_term = 236
let g:indentLine_color_tty = 236

let g:localvimrc_ask = 0

let g:DeleteTrailingWhitespace = 1
let g:DeleteTrailingWhitespace_Action = 'delete'

let g:load_doxygen_syntax = 1
let g:DoxygenToolkit_endCommentBlock = '**/'
let g:DoxygenToolkit_endCommentTag = '**/'

" neocomplete {{{
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_smart_case = 1
let g:neocomplete#force_overwrite_completefunc = 1
let g:neocomplete#sources#syntax#min_keyword_length = 3
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

let g:neocomplete#sources#dictionary#dictionaries = {
    \ 'default' : '',
    \ }

if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
endif

let g:neocomplete#keyword_patterns['default'] = '\h\w*'

" Omni completion
au FileType html,markdown set omnifunc=htmlcomplete#CompleteTags
au FileType javascript set omnifunc=javascriptcomplete#CompleteJS
au FileType python set omnifunc=pythoncomplete#Complete
au FileType xml set omnifunc=xmlcomplete#CompleteTags
au FileType cpp set omnifunc=omni#cpp#complete#Main

if !exists('g:neocomplete#sources#omni#input_patterns')
    let g:neocomplete#sources#omni#input_patterns = {}
endif

let g:neocomplete#sources#omni#input_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'
let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
" }}}

let g:neosnippet#disable_runtime_snippets = { '_': 1, }
let g:neosnippet#snippets_directory = '~/.vim/bundle/vim-snippets/snippets'

" This is handled above by my own <CR> mapping
" let delimitMate_expand_cr = 2
let delimitMate_expand_space = 1

function! g:HeaderguardName()
    return '_' . toupper(expand('%:t:gs/[^0-9a-zA-Z_]/_/g')) . '_'
endfunction

let g:rainbow_guifgs = ['#94aad1', '#8ab4be', '#edc472', '#c98dad']
let g:rainbow_ctermfgs = ['12', '14', '11', '13']

let g:syntastic_stl_format = ''
let g:syntastic_c_auto_refresh_includes = 1
let g:syntastic_cpp_no_include_search = 1
let g:syntastic_cpp_compiler_options = '-std=c++11'

let g:airline_theme = 'powerlineish'
let g:airline_powerline_fonts = 1
let g:airline#extensions#hunks#non_zero_only = 1

let g:ruby_indent_access_modifier_style = 'outdent'

let g:licenses_authors_name = 'ahoka'

set sessionoptions-=help
set sessionoptions-=options
set sessionoptions+=resize
set sessionoptions+=tabpages

let g:session_autosave = 'yes'
let g:session_autoload = 'yes'
let g:session_autosave_periodic = 5
let g:session_default_to_last = 1
let g:session_persist_globals = [ '&expandtab' ]

au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif

au FileType c,cpp,html,javascript call rainbow#load()
au FileType coffee,html,python,ruby,xml setl shiftwidth=2 tabstop=2
au FileType css set omnifunc=csscomplete#CompleteCSS | setlocal iskeyword+=-

colorscheme ahoka

" GVim {{{
set guioptions=+a
set guifont=ProFont
set guicursor=n-v-c:block-Cursor
set guicursor+=i:block-Cursor
set guicursor+=n-v-c:blinkon0
set guicursor+=i:blinkon0
" }}}
