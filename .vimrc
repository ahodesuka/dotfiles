set nocompatible
filetype off

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'

Bundle 'scrooloose/syntastic'
Bundle 'scrooloose/nerdtree'
Bundle 'xolox/vim-misc'
Bundle 'xolox/vim-session'
Bundle 'bling/vim-airline'
Bundle 'tpope/vim-fugitive'
Bundle 'jiangmiao/auto-pairs'
Bundle 'Shougo/neocomplete.vim'
Bundle 'Shougo/neosnippet'
Bundle 'honza/vim-snippets'
Bundle 'OmniCppComplete'
Bundle 'vim-ruby/vim-ruby'
Bundle 'tikhomirov/vim-glsl'

filetype plugin indent on
syntax on

set hidden
set incsearch
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
set cindent expandtab smartindent autoindent tabstop=4 shiftwidth=4
set cinkeys=0{,0},:,0#
set switchbuf+=usetab,newtab
set title
set t_Co=256
set encoding=utf-8
set nolist
set formatoptions+=l
set fillchars+=vert:│
set completeopt=menuone,longest

nnoremap <C-L> :nohl<CR><C-L>
command! Make make! | copen
map <F2> :NERDTreeToggle \| :silent NERDTreeMirror<CR>
map <F5> :Make<CR><C-w>
map <F4> :ccl<CR>
map <C-F12> :!ctags -R --sort=yes --c++-kinds=+p --fields=+iaS --extra=+q .<CR>

" Move tabs with alt + left|right
nnoremap <silent> <A-Left> :execute 'silent! tabmove ' . (tabpagenr()-2)<CR>
nnoremap <silent> <A-Right> :execute 'silent! tabmove ' . tabpagenr()<CR>

map! <s-insert> <c-r>*

set tags+=~/.vim/tags/cpp
set tags+=~/.vim/tags/gl
set tags+=~/.vim/tags/sdl
set tags+=~/.vim/tags/ogre
set tags+=~/.vim/tags/cegui

let g:load_doxygen_syntax = 1
let g:DoxygenToolkit_endCommentBlock = '**/'
let g:DoxygenToolkit_endCommentTag = '**/'

" neocomplete {
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
" }

" For snippet_complete marker.
if has('conceal')
  set conceallevel=2 concealcursor=i
endif

let g:neosnippet#enable_snipmate_compatibility = 1
let g:neosnippet#snippets_directory = '~/.vim/bundle/vim-snippets/snippets'

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

