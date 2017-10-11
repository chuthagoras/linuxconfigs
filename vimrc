function! SyntasticSetupf(info)
  autocmd! User syntastic set statusline+=%#warningmsg#
  autocmd! User syntastic set statusline+=%{SyntasticStatuslineFlag()}
  autocmd! User syntastic set statusline+=%*
  autocmd! User syntastic let g:syntastic_always_populate_loc_list = 1
  autocmd! User syntastic let g:syntastic_auto_loc_list = 1
  autocmd! User syntastic let g:syntastic_check_on_open = 1
  autocmd! User syntastic let g:syntastic_check_on_wq = 0
endfunction



call plug#begin('~/.vim/vplugindir')
" Compile source files on the fly
Plug 'xuhdev/SingleCompile'
nmap <F9> :SCCompile<cr>
nmap <F10> :SCCompileRun<cr>

" Syntax checker
Plug 'vim-syntastic/syntastic', { 'on': 'LoadSyntastic', 'do': function('SyntasticSetupf') }

call plug#end()
" May need to
"   filetype off
"   syntax off

try
    source ~/linuxconfigs/svimrc
catch
endtry

autocmd FileType c,cpp,h,hpp,py,java call SetMostOptions()
autocmd FileType c,cpp,h,hpp call SetCppOptions()

function SetCppOptions()
    "-if/while/for for c++
    noremap rif iif ()<Enter>{<Enter>}<Esc>2k=2j$i
    noremap rwhile iwhile ()<Enter>{<Enter>}<Esc>2k=2j$i
    "- this guy makes for templates from a to z
    for i in split('abcdefghijklmnopqrstuvwxyz', '\zs')
        execute printf("noremap rfor%s i for (int %s = 0; %s < ; %s++)<Enter>{<Enter>}<Esc>2k=2j$5hi", i, i, i, i)
    endfor
    nnoremap rFor i for ()<Enter>{<Enter>}<Esc>2k=2j$i
    nnoremap ; A;<Esc>
    nnoremap #i< i#include <><Esc>hi
    nnoremap #i" i#include ""<Esc>hi
endfunction

function SetMostOptions()
    "-auto closing for most languages (not <> because << and >> )
    inoremap ( ()<Left>
    inoremap { {<Enter>}<Esc>k$i<Right>
    inoremap " ""<Left>
    inoremap ' ''<Left>
    inoremap [ []<Left>


    "-wrap selection in quotes, parenthesis, or {} brackets w/ indent
    vnoremap ( <ESC>`>a)<ESC>`<i(<ESC>
    vnoremap " <ESC>`>a"<ESC>`<i"<ESC>
    vnoremap { <ESC>`>a<Enter>}<ESC>`<i{<Enter><ESC>`<=i{
endfunction


" Make the dot command work as expected in visual mode
vnoremap . :norm.<CR>")"

filetype indent plugin on

syntax on

set mouse=n
set title

"-Indent
set shiftwidth=4
set smartindent
set expandtab

"-Key changes
set backspace=indent,eol,start


"-Search
set ignorecase
set smartcase
set hlsearch
nnoremap <C-L> :nohl<CR><C-L>

"-Paste mode (doesn't mess with indentation and mappings within copy paste)
set pastetoggle=<F2>

"-Center screen
nnoremap <Leader>zz :let &scrolloff=999-&scrolloff<CR>

"- gc - swap char with next
nnoremap <silent> gc xph
"- gw - swap word with next
nnoremap <silent> gw "_yiw:s/\(\%#\w\+\)\(\W\+\)\(\w\+\)/\3\2\1/<CR><c-o><c-l>:nohlsearch<CR>
"- gh, gl swap word left/right and move cursor to new location
nnoremap <silent> gh "_yiw?\w\+\_W\+\%#<CR>:s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<CR><c-o><c-l>:nohlsearch<CR>
nnoremap <silent> gl "_yiw:s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<CR><c-o>/\w\+\_W\+<CR><c-l>:nohlsearch<CR>
"- g{ - swap paragraph with next
nnoremap g{ {dap}p{
"- alt + j, move current line down 1, alt + k, move current line up 1 (also works with visal mode)
nnoremap gj :m .+1<CR>==
nnoremap gk :m .-2<CR>==
vnoremap gj :m '>+1<CR>gv=gv
vnoremap gk :m '<-2<CR>gv=gv

function! s:DiffWithSaved()
    let filetype=&ft
    diffthis
    vnew | r # | normal! 1Gdd
    diffthis
    exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
endfunction
com! Diff call s:DiffWithSaved()

