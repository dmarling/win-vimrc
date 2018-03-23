filetype plugin indent on
syntax enable

"colorscheme
set background=dark
colorscheme solarized

"general settings
set nocompatible
set nu
set relativenumber
set laststatus=2
set showcmd
set ruler
set splitright
set splitbelow
set autochdir
set autoindent
set nowrap  "prevents visual line wrapping
set textwidth=0 "prevents literal line wrapping
set so=3
set gdefault
set completeopt=longest,menuone
set shiftwidth=4
set softtabstop=4
set cursorline
set foldmethod=manual
"search settings
set nohlsearch
set incsearch
set ignorecase
set smartcase
"navigate away from open/unsaved buffers without warnings
set noswapfile
set nobackup
set hidden
"skip over folded blocks with nav '{' cmds
set foldopen-=block
"hide tabnames at top of doc
set showtabline=0

"build status line
set statusline=\ %{fugitive#statusline()}   "git info
set statusline+=\ [%{&fileformat}\]         "filetype -effectively a DOS/UNIX flag
set statusline+=\ %.60F                     "filename truncated to 60 characters
set statusline+=\%m\ %r                     "modified/read-only flags
set statusline+=\%=%c                       "column number aligned to the right


"fix backspace key to act conventionally
set backspace=indent,eol,start
"convert tabs to spaces automatically
set expandtab
"font
set guifont=Lucida\ Console:h10
"gui options
set guioptions-=m  "remove menu bar
set guioptions-=T  "remove toolbar
set guioptions-=r  "remove right-hand scroll bar
set guioptions-=L  "remove left-hand scroll bar
set mouse=c        "disable mouse

"maps
inoremap jk <Esc>
nnoremap <Tab> :bn<CR>
nnoremap <S-Tab> :bp<CR>
nnoremap <F1> :NERDTreeToggle<CR>
nnoremap <F2> :Listbufs<CR>:buffer<Space>
nnoremap <F3> :set lines=999 columns=999<CR>
nnoremap <F4> :set paste!<CR>
nnoremap <leader>bd :bd!<CR>             
nnoremap <leader>br :bn\|bd! #<CR>      
nnoremap <leader>w :w!<CR>
nnoremap <leader>so :w\|source %<CR>
nnoremap <leader>do :diffo<CR>
nnoremap <leader>dt :difft<CR>
nnoremap <leader>hl :set hlsearch!<CR>
nnoremap <leader>lw :set wrap!<CR>
nnoremap j gj
nnoremap k gk
vnoremap // y/\V<C-R>"<CR>

"instead of using unnamed clipboard as a catchall
nnoremap <leader>y "*y<CR>    

"filetype extensions
autocmd BufNewFile,BufRead *.ddl,*.sql set filetype=sql
autocmd BufNewFile,BufRead *.py set filetype=python
autocmd BufNewFile,BufRead *.xml set filetype=xml 
autocmd BufNewFile,BufRead *.json set filetype=json

"xml file settings
autocmd FileType xml setlocal sw=8 sts=8 fdm=syntax norelativenumber
let g:xml_syntax_folding=1
"sql file settings
autocmd FileType sql setlocal sw=8 sts=8 noexpandtab

"plugins have been manually installed and are accessible with the 'help [name of plugin]'
"documentation has been generated by 1) navigate to doc parent directory. Run inside editor 'helptags doc' 
"
"	Tabular            - For formatting data into columns based on a flexible delimiter
"	Surround           - Extended vim motions for parenthese,quotes,brackets etc...
"	SuperTab           - Binds tab key to use complete 
"       Bufferline         - Puts buffer names below status bar
"       NERDTree           - Replaces netrw as file explorer
"       Fugitive           - Git integration


" Settings Unique to Plugins
let g:bufferline_show_bufnr = 0
let g:bufferline_active_buffer_left ='   ==[ '
let g:bufferline_active_buffer_right =']==   '
autocmd VimEnter * NERDTree
autocmd VimEnter * set winfixwidth  "tbd should prevent the nerdtree window from resizing
let NERDTreeIgnore=['\.pol$','\.regtrans-ms$','\.blf$'] "prevent certain files from showing up in NerdTree file explorer
let NERDTreeQuitOnOpen=1
":AddTabularPattern first_comma /^[^,]*\zs,/r0c0l0  --figure this out later

"Commands
command! -nargs=* Vgrep execute 'normal c' | execute 'vimgrep <args>' | :vert cw | :vertical resize 70
command! -nargs=* READSTDOUT execute 'vnew | r! <args>'
command! -nargs=* PrdHiveMetaStore execute 'vnew | r! python C:\Users\dmarling\Desktop\scripts\vim_call_prd_hive_metastore.py <args>' | execute '%s/[()]//' 
command! -nargs=* DevHiveMetaStore execute 'vnew | r! python C:\Users\dmarling\Desktop\scripts\vim_call_dev_hive_metastore.py <args>' | execute '%s/[()]//' 
command! -nargs=* StgHiveMetaStore execute 'vnew | r! python C:\Users\dmarling\Desktop\scripts\vim_call_stg_hive_metastore.py <args>' | execute '%s/[()]//'
command! Listbufs call CleanBufferNav()
command! -nargs=1 SearchBuffers call setqflist([]) | execute 'bufdo vimgrepadd' . (<f-args>) . ' %' | copen
command! -nargs=1 Vres execute 'vertical resize <args>' | set winfixwidth
command! PrdHiveRun execute 'w C:\Users\dmarling\Desktop\scripts\prdquery.sql' | execute '!python C:\Users\dmarling\Desktop\scripts\execute_arbitrary_hive_script.py C:\Users\dmarling\Desktop\scripts\prdquery.sql'
command! DevHiveRun execute 'w! C:\Users\dmarling\Desktop\scripts\devquery.sql' | execute 'vnew | r! python C:\Users\dmarling\Desktop\scripts\devquery.py C:\Users\dmarling\Desktop\scripts\devquery.sql'
command! StgHiveRun execute 'w C:\Users\dmarling\Desktop\scripts\stgquery.sql' | execute '!python C:\Users\dmarling\Desktop\scripts\ C:\Users\dmarling\Desktop\scripts\stgquery.sql'
command! BigFileSettings execute set nocursorline | :set norelativenumber | :syntax off

"Commands with dependencies on settings or external programs
" XMLPrettyPrint 1)fdm=syntax 2) let g:xml_syntax_folding=1 3)filetype plugin indent on 4) sw=8 5) sts=8 
command! XMLPrettyPrint set filetype=xml | %s/></>\r</ | execute 'normal gg=G' 
command! JSONPrettyPrint set filetype=json | %!python -m json.tool 
command! XMLPrettyPrintCollapse execute ':%s/^\s\+//' | execute ':%s/\n//'

" matchit can match xml angle brackets with % and I'm sure other things
" **relies on filetype detection for xml
packadd! matchit

"functions
function! CleanBufferNav()
    redir => ls_output
    silent exec 'ls'
    redir END
    let list = substitute(ls_output, '"\([a-zA-Z0-9:\\_" .-]*\\\)\([a-zA-Z0-9:\\_" .-]*\)"' , '\=submatch(2)',  'g')
    let list = substitute(list, '\(\s\+line\s\+\d\+\)',  '', 'g')
    let list = substitute(list, '\(\d\+\s\+\)\(\S*\)', '\=submatch(1)."     "','g')
    echo list 
endfunction

