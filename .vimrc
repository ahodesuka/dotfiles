set nocp
filetype off

set rtp+=~/.vim/bundle/vundle/
call vundle#begin()

" General plugins {{{
Plugin 'gmarik/vundle'
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
Plugin 'ahodesuka/vim-snippets'
Plugin 'Raimondi/delimitMate'
Plugin 'DeleteTrailingWhitespace'
Plugin 'godlygeek/tabular'
" }}}

" Language specific plugins {{{
" C and C++
Plugin 'OmniCppComplete'
Plugin 'a.vim'
Plugin 'drmikehenry/vim-headerguard'
Plugin 'vim-jp/cpp-vim'
Plugin 'octol/vim-cpp-enhanced-highlight'

" GLSL
Plugin 'tikhomirov/vim-glsl'

" Ruby
Plugin 'vim-ruby/vim-ruby'
Plugin 'noprompt/vim-yardoc'

" Web
Plugin 'kchmck/vim-coffee-script'
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
set ttimeoutlen=50
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
set formatoptions+=l
set fillchars=vert:█,fold:█
set completeopt=menuone,longest
set showmatch
set re=1
set conceallevel=2
set nuw=6
set history=200
set foldcolumn=1
set foldmethod=marker
set foldtext=FoldText()
" }}}

function! FoldText()"{{{
    let line = getline(v:foldstart)
    let line = substitute(line, "^\s*\(#\|//\|/\*\|"\)\?\s*\|\s*\(#\|//\|/\*\|"\)\?\s*{{" . "{\d*\s*\(\*/\)\?", "", "g")
    let line = " " . line . " "
    let lines_count = v:foldend - v:foldstart + 1
    let lines_count_text = " " . lines_count . " lines "
    let foldchar = matchstr(&fillchars, "fold:\zs.")
    let foldtextstart = strpart(repeat(foldchar, max([1, indent(v:foldstart)])) . line, 0, (winwidth(0)*2)/3)
    let foldtextend = lines_count_text . repeat(foldchar, 8)
    let foldtextlength = strlen(substitute(foldtextstart . foldtextend, ".", "x", "g")) + &foldcolumn + &nuw
    return foldtextstart . repeat(foldchar, winwidth(0)-foldtextlength) . foldtextend
endfunction"}}}

" Mappings {{{
map! <S-Insert> <MiddleMouse>
map <silent> <F2> :NERDTreeToggle \| :NERDTreeMirror<CR>
map <silent> <F3> :TagbarToggle<CR>
map <silent> <F4> :ccl<CR>
map <silent> <F5> :make! \| :copen<CR>
map <silent> <F12> :!ctags -R --sort=yes --c++-kinds=+p --fields=+iaS --extra=+q .<CR>

" Move tabs with shift + h/l
nnoremap <silent> <S-h> :execute 'silent! tabmove ' . (tabpagenr()-2)<CR>
nnoremap <silent> <S-l> :execute 'silent! tabmove ' . tabpagenr()<CR>

" Switch tabs with ctrl + h/l
nnoremap <silent> <C-h> :tabp<CR>
nnoremap <silent> <C-l> :tabn<CR>

" Remove search highlighting with ctrl + n
noremap <silent> <C-n> :nohl<CR>
inoremap <silent> <C-n> <C-o>:nohl<CR>

" Map ctrl + s to save current buffer if it has been modified
noremap <silent> <C-s> :update<CR>

" Map shift + s to write all buffers
noremap <silent> <S-s> :wa<CR>

noremap <silent> <C-t> :tabnew<CR>
noremap <silent> <C-w> :tabclose<CR>

noremap <C-f> :GrepBuffer<Space>
inoremap <C-f> <C-o>:GrepBuffer<Space>

inoremap ;<CR> <End>;
inoremap ,<CR> <End>,

" space open/closes folds in normal mode
nnoremap <space> za
" space creates folds in visual mode
vnoremap <space> zf
" }}}

" Tags {{{
set tags+=~/.vim/tags/cegui
set tags+=~/.vim/tags/cpp
set tags+=~/.vim/tags/gl
set tags+=~/.vim/tags/glibmm
set tags+=~/.vim/tags/gtkmm-2.4
set tags+=~/.vim/tags/libxml2
set tags+=~/.vim/tags/ogre
set tags+=~/.vim/tags/sdl
" }}}

let NERDTreeIgnore=[ "\.o$", "\~$" ]

let g:indentLine_char = "│"
let g:indentLine_bufNameExclude = [ "NERD_tree.*" ]
let g:indentLine_noConcealCursor = 1
let g:indentLine_color_gui = "#222222"
let g:indentLine_color_term = 236
let g:indentLine_color_tty = 236

let g:localvimrc_ask = 0

let g:DeleteTrailingWhitespace = 1
let g:DeleteTrailingWhitespace_Action = "delete"

let g:load_doxygen_syntax = 1
let g:DoxygenToolkit_endCommentBlock = "**/"
let g:DoxygenToolkit_endCommentTag = "**/"

" OmniCppComplete {{{
let OmniCpp_NamespaceSearch = 1
let OmniCpp_GlobalScopeSearch = 1
let OmniCpp_ShowAccess = 1
let OmniCpp_ShowPrototypeInAbbr = 1 " show function parameters
let OmniCpp_MayCompleteDot = 1      " autocomplete after .
let OmniCpp_MayCompleteArrow = 1    " autocomplete after ->
let OmniCpp_MayCompleteScope = 1    " autocomplete after ::
let OmniCpp_DefaultNamespaces = [ "std", "_GLIBCXX_STD" ]
" }}}

" neocomplete {{{
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_smart_case = 1
let g:neocomplete#sources#syntax#min_keyword_length = 3
let g:neocomplete#lock_buffer_name_pattern = "\*ku\*"

let g:neocomplete#sources#dictionary#dictionaries = {
    \ "default" : "",
    \ }

if !exists("g:neocomplete#keyword_patterns")
    let g:neocomplete#keyword_patterns = {}
endif

let g:neocomplete#keyword_patterns["default"] = "\h\w*"

inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
    return neosnippet#expandable_or_jumpable() ? neosnippet#mappings#expand_or_jump_impl()
                \: pumvisible() ? neocomplete#close_popup() : "\<CR>"
endfunction
inoremap <expr><TAB>   pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><Down>  pumvisible() ? "\<C-n>" : "\<Down>"
inoremap <expr><C-j>   pumvisible() ? "\<C-n>" : "\<C-j>"
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<S-TAB>"
inoremap <expr><Up>    pumvisible() ? "\<C-p>" : "\<Up>"
inoremap <expr><C-k>   pumvisible() ? "\<C-p>" : "\<C-k>"

if !exists("g:neocomplete#sources#omni#input_patterns")
    let g:neocomplete#sources#omni#input_patterns = {}
endif

let g:neocomplete#sources#omni#input_patterns.ruby = "[^. *\t]\.\w*\|\h\w*::"
let g:neocomplete#sources#omni#input_patterns.c = "[^.[:digit:] *\t]\%(\.\|->\)"
let g:neocomplete#sources#omni#input_patterns.cpp = "[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::"
" }}}

let g:neosnippet#disable_runtime_snippets = { "_": 1, }
let g:neosnippet#snippets_directory = "~/.vim/bundle/vim-snippets/snippets"

function! g:HeaderguardName()
    return "_" . toupper(expand("%:t:gs/[^0-9a-zA-Z_]/_/g")) . "_"
endfunction

let g:syntastic_stl_format = ""
let g:syntastic_c_auto_refresh_includes = 1
let g:syntastic_cpp_no_include_search = 1
let g:syntastic_cpp_compiler_options = "-std=c++11"

let g:airline_theme = "powerlineish"
let g:airline_powerline_fonts = 1
let g:airline#extensions#hunks#non_zero_only = 1

let g:ruby_indent_access_modifier_style = "outdent"

set sessionoptions-=help
set sessionoptions-=options
set sessionoptions+=resize
set sessionoptions+=tabpages

let g:session_autosave = "yes"
let g:session_autoload = "yes"
let g:session_autosave_periodic = 5
let g:session_default_to_last = 1
let g:session_persist_globals = [ "&expandtab" ]

au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif

au FileType coffee,html,python,ruby,xml setl shiftwidth=2 tabstop=2
au FileType css set omnifunc=csscomplete#CompleteCSS | setlocal iskeyword+=-
au FileType html,markdown set omnifunc=htmlcomplete#CompleteTags
au FileType javascript set omnifunc=javascriptcomplete#CompleteJS
au FileType python set omnifunc=pythoncomplete#Complete
au FileType xml set omnifunc=xmlcomplete#CompleteTags
au FileType cpp set omnifunc=omni#cpp#complete#Main

colorscheme ahoka

" gVim {{{
set guioptions=+a
set guifont=ProFont
set guicursor=n-v-c:block-Cursor
set guicursor+=i:block-Cursor
set guicursor+=n-v-c:blinkon0
set guicursor+=i:blinkon0
" }}}
