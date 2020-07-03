set nocp
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'

" General plugins {{{
Plugin 'scrooloose/syntastic'
Plugin 'scrooloose/nerdtree'
Plugin 'xolox/vim-misc'
Plugin 'embear/vim-localvimrc'
Plugin 'xolox/vim-session'
Plugin 'bling/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'tpope/vim-fugitive'
Plugin 'airblade/vim-gitgutter'
Plugin 'majutsushi/tagbar'
Plugin 'yegappan/grep'
Plugin 'Yggdroot/indentLine'
Plugin 'DoxygenToolkit.vim'
Plugin 'Valloric/YouCompleteMe'
Plugin 'rdnetto/YCM-Generator'
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'
Plugin 'Raimondi/delimitMate'
"Plugin 'luochen1990/rainbow'
Plugin 'oblitum/rainbow'
Plugin 'junegunn/vim-easy-align'
" Plugin 'SyntaxAttr.vim'
" }}}

" Language specific plugins {{{
" C and C++
Plugin 'a.vim'
Plugin 'vim-jp/vim-cpp'
Plugin 'octol/vim-cpp-enhanced-highlight'
Plugin 'Conque-GDB'
Plugin 'rhysd/vim-clang-format'

" JS
Plugin 'kchmck/vim-coffee-script'
Plugin 'jelera/vim-javascript-syntax'
Plugin 'myhere/vim-nodejs-complete'

" GLSL
Plugin 'tikhomirov/vim-glsl'

" Ruby
Plugin 'vim-ruby/vim-ruby'
Plugin 'noprompt/vim-yardoc'

" Lua
Plugin 'raymond-w-ko/vim-lua-indent'

" Web
Plugin 'hail2u/vim-css3-syntax'
Plugin 'othree/html5.vim'
Plugin 'cakebaker/scss-syntax.vim'
" }}}

call vundle#end()
filetype plugin indent on
syntax on

" Settings {{{
" These really should be commented.
set autoindent
set backspace=indent,eol,start
set cindent
set cinoptions=g0
set cmdheight=1
set colorcolumn=80
set completeopt=menuone
set concealcursor=c
set conceallevel=2
set confirm
set cursorline
set encoding=utf-8
set expandtab
set ff=unix
set fileencodings=ucs-bom,utf-8,euc-jp,sjis,default,latin1
set fillchars=vert:█,fold:█
set foldcolumn=1
set foldmethod=marker
set foldtext=FoldText()
set formatoptions=croqlt
set hidden
set history=1000
set hlsearch
set ignorecase
set incsearch
set laststatus=2
set lazyredraw
set linebreak
set mouse=a
set noerrorbells
set nolist
set noshowmode
set nostartofline
set notimeout
set number
set nuw=6
set re=1
set shiftwidth=4
set showmatch
set smartcase
set softtabstop=4
set spelllang=en_us
set switchbuf+=usetab,newtab
set t_Co=256
set t_vb=
set tabstop=4
set textwidth=80
set timeoutlen=1000
set title
set ttimeout
set ttimeoutlen=0
set updatetime=500
set visualbell
set wrap
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
" Alt Key helper for urxvt
if !has('gui_running')
  set ttimeoutlen=10
  augroup FastEscape
    autocmd!
    autocmd InsertEnter * set timeoutlen=0
    autocmd InsertLeave * set timeoutlen=2000
  augroup END
endif

function! Altmap(char)
  if has('gui_running') | return ' <A-'.a:char.'> ' | else | return ' <Esc>'.a:char.' '|endif
endfunction

map <silent> <F2> :NERDTreeToggle \| :NERDTreeMirror<CR>
map <silent> <F3> :TagbarToggle<CR>
map <silent> <F4> :ccl<CR>
map <silent> <F5> :make! \| :copen<CR>

" Move tabs with shift + h/l
nnoremap <silent><S-h> :tabmove -1<CR>
nnoremap <silent><S-l> :tabmove +1<CR>

" Switch tabs with ctrl + h/l
nnoremap <silent><C-h> :tabp<CR>
nnoremap <silent><C-l> :tabn<CR>

" Switch HSplits with ctrl + j/k
nnoremap <silent><C-j> :wincmd j<CR>
nnoremap <silent><C-k> :wincmd k<CR>

" Switch splits with alt + hjkl
execute 'nnoremap <silent>'.Altmap('h').':wincmd h<CR>'
execute 'nnoremap <silent>'.Altmap('j').':wincmd j<CR>'
execute 'nnoremap <silent>'.Altmap('k').':wincmd k<CR>'
execute 'nnoremap <silent>'.Altmap('l').':wincmd l<CR>'

" Resize splits with shift + alt + hjkl
nnoremap <silent><S-A-h> :vertical resize -5<CR>
nnoremap <silent><S-A-j> :resize -5<CR>
nnoremap <silent><S-A-k> :resize +5<CR>
nnoremap <silent><S-A-l> :vertical resize +5<CR>

" Remove search highlighting with ctrl + n
noremap  <silent><C-n> :nohl<CR>
inoremap <silent><C-n> <C-o>:nohl<CR>

" Map ctrl + s to save current buffer if it has been modified
noremap  <silent><C-s> :update<CR>

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

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" autocomplete mappings
let g:ulti_expand_or_jump_res = 0
function! CRCompleteFunc()
    let snippet = UltiSnips#ExpandSnippet()
    if g:ulti_expand_res > 0
        return snippet
    endif
    return "\<CR>"
endfunction

inoremap <expr><Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr><Down>  pumvisible() ? "\<C-n>" : "\<Down>"
inoremap <expr><C-j>   pumvisible() ? "\<C-n>" : "\<C-j>"
imap     <expr><S-Tab> pumvisible() ? "\<C-p>" : "<Plug>delimitMateS-Tab"
inoremap <expr><Up>    pumvisible() ? "\<C-p>" : "\<Up>"
inoremap <expr><C-k>   pumvisible() ? "\<C-p>" : "\<C-k>"

imap     <expr><CR>    pumvisible() ? "<C-r>=CRCompleteFunc()<CR>" : "<Plug>delimitMateCR"
" }}}

map -a	:call SyntaxAttr()<CR>

if filereadable('/proc/cpuinfo')
    let &makeprg = 'make -j'.(system('grep -c ^processor /proc/cpuinfo')+1)
endif

let NERDTreeIgnore=[ '\.[ls]\?o$', '\~$' ]

let g:indentLine_char = '│'
let g:indentLine_bufNameExclude = [ 'NERD_tree.*' ]
let g:indentLine_setConceal = 0
let g:indentLine_color_gui = '#222222'
let g:indentLine_color_term = 236
let g:indentLine_color_tty = 236

let g:localvimrc_ask = 0

let g:load_doxygen_syntax = 1
let g:DoxygenToolkit_commentType = 'C++'

let g:ycm_global_ycm_extra_conf = '~/.vim/.ycm_extra_conf.py'
let g:ycm_extra_conf_globlist = ['~/Git/*']
let g:UltiSnipsUsePythonVersion = 3
let g:UltiSnipsJumpForwardTrigger = '<CR>'
let g:UltiSnipsJumpBackwardTrigger = '<S-Tab>'
let g:UltiSnipsEditSplit = 'vertical'

let delimitMate_expand_cr = 2
let delimitMate_expand_space = 1

let g:rainbow_guifgs = ['#94aad1', '#8ab4be', '#edc472', '#c98dad']
let g:rainbow_ctermfgs = ['12', '14', '11', '13']

"let g:rainbow_active = 1
"\	'operators': '_,\|=\|+\|\*\|-\|\.\|;\||\|&\|?\|:\|<\|>\|%\|/[^/]_',
let g:rainbow_conf = {
\   'guifgs': ['#94aad1', '#8ab4be', '#edc472', '#c98dad'],
\	'ctermfgs': ['12', '14', '11', '13'],
\	'operators': '_!\|=\|&\||\|?\|%\|\.\|:\|;\|,\|<\|>\|+\|-\@<!--\@!\|\/\@<!\*\|\/\(\/\|\*\)\@!_',
\	'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold'],
\	'separately': {
\		'*': {},
\       'cpp': {
\           'parentheses': [
\               'start=/(/ end=/)/ fold',
\               'start=/\[/ end=/\]/ fold',
\               'start=/{/ end=/}/ fold',
\               'start=/\(\(\<operator\>\)\@<!<\)\&[a-zA-Z0-9_]\@<=<\ze[^<]/ end=/>/']
\       },
\	}
\}

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
" Trim trailing whitespace
au FileType c,cpp,coffee,java,ruby,python,sh au BufWritePre * :%s/\s\+$//e | :call histdel('/', -1)

au FileType gitcommit,markdown setl spell

au FileType c,cpp,objc,objcpp,go,rust,python,ruby,javascript,java,vim,zsh call rainbow#load()
au FileType cpp setl cindent cino=j1,(0,ws,Ws
au FileType coffee,css,html,javascript,json,lua,perl,python,ruby,sh,xml setl shiftwidth=2 softtabstop=2 tabstop=2
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
