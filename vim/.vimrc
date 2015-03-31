" Presentation
"
syntax on
set background=dark
highlight ColorColumn ctermbg=233
set colorcolumn=80                    " try to behave
" set nonumber                        " show line numbers -no need with statusbar
set ruler                             " Set a ruler
" set nowrap                          " don't automatically wrap on load
set fo-=t                             " don't automatically wrap text when typing

" Misc
"
autocmd! bufwritepost .vimrc source % " Reload .vim.rc on save

" Formatting
"
" Do tabs correctly
set expandtab                         " enter spaces when tab is pressed
set textwidth=80                      " break lines when line length increases
set tabstop=4                         " use 4 spaces to represent tab
set softtabstop=4
set shiftwidth=4                      " number of spaces to use for auto indent

set autoindent                        " copy indent from current line
set backspace=indent,eol,start        " make backspaces more powerfull
set laststatus=2                      " Always show status line
filetype plugin indent on             " Sane indentation

" Navigation
"
let mapleader=","                     " set this to be the leader key
" Navigate between panes (Ctrl+<movement>)
map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-l> <c-w>l
map <c-h> <c-w>h

" Resizing of panes (Shift+<movement>-)
nnoremap <C-S-j> :resize +5<cr>
nnoremap <C-S-k> :resize -5<cr>
nnoremap <C-S-h> :vertical resize -5<cr>
nnoremap <C-S-l> :vertical resize +5<cr>

" easier moving of code blocks
vnoremap < <gv  " better indentation
vnoremap > >gv  " better indentation

" Allow switching through split windows by adding ctrl to nav keys
inoremap <silent><C-j> <C-R>=OmniPopup('j')<CR>
inoremap <silent><C-k> <C-R>=OmniPopup('k')<CR>

" Make search case insensitive
set hlsearch
set incsearch
set ignorecase
set smartcase

" Mouse and backspace -this is awesome but also messes with copy and paste
" behavior.
" set mouse=a                         " on OSX press ALT and click
" set bs=2                            " make backspace behave like normal again

" Plugins
"
" Pathogen
execute pathogen#infect()

" Solarized
let g:solarized_termcolors=16
let g:solarized_termtrans=1
colorscheme solarized                 " needs to be set after configuration above

" Syntastic for syntax checking
let g:syntastic_always_populate_loc_list=1
let g:syntastic_check_on_open=1
let g:syntastic_python_checkers=['flake8']
let g:syntastic_python_flake8_post_args='--ignore=E501'

" Enable Jedi for completion and code navigation
let g:jedi#auto_initialization = 1
let g:jedi#goto_assignments_command = "<leader>g"
let g:jedi#goto_definitions_command = "<leader>d"
let g:jedi#documentation_command = "K"
let g:jedi#usages_command = "<leader>n"
let g:jedi#completions_command = "<C-Space>"
let g:jedi#rename_command = "<leader>r"
let g:jedi#use_splits_not_buffers = "top"

" NERDTree
map <C-n> :NERDTreeToggle<CR>
map <leader>r :NERDTreeFind<CR>
let NERDTreeShowHidden=1              " Show dotfiles
let NERDTreeShowBookmarks=1           " Show bookmarks on startup

" Airline config, enable powerline fonts
let g:airline#extensions#tabline#enabled = 0
let g:airline_powerline_fonts = 2

" Tagbar
nmap <F8> :TagbarToggle<CR>

" Run py.test's
nmap <silent><Leader>tf <Esc>:Pytest file<CR>
nmap <silent><Leader>tc <Esc>:Pytest class<CR>
nmap <silent><Leader>tm <Esc>:Pytest method<CR>
nmap <silent><Leader>tn <Esc>:Pytest next<CR>
nmap <silent><Leader>tp <Esc>:Pytest previous<CR>
nmap <silent><Leader>te <Esc>:Pytest error<CR>

" Add the virtualenv's site-packages to vim path
if has('python')
py << EOF
import os.path
import sys
import vim
if 'VIRTUAL_ENV' in os.environ:
    project_base_dir = os.environ['VIRTUAL_ENV']
    sys.path.insert(0, project_base_dir)
    activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
    execfile(activate_this, dict(__file__=activate_this))
EOF
endif

" Gundo
nnoremap <F5> :GundoToggle<CR>


" Neocomplete
if has('lua')
    "Note: This option must set it in .vimrc(_vimrc).  NOT IN .gvimrc(_gvimrc)!
    " Disable AutoComplPop.
    let g:acp_enableAtStartup = 0
    " Use neocomplete.
    let g:neocomplete#enable_at_startup = 1
    " Use smartcase.
    let g:neocomplete#enable_smart_case = 1
    " Set minimum syntax keyword length.
    let g:neocomplete#sources#syntax#min_keyword_length = 3
    let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

    " Define dictionary.
    let g:neocomplete#sources#dictionary#dictionaries = {
        \ 'default' : '',
        \ 'vimshell' : $HOME.'/.vimshell_hist',
        \ 'scheme' : $HOME.'/.gosh_completions'
            \ }

    " Define keyword.
    if !exists('g:neocomplete#keyword_patterns')
        let g:neocomplete#keyword_patterns = {}
    endif
    let g:neocomplete#keyword_patterns['default'] = '\h\w*'

    " Plugin key-mappings.
    inoremap <expr><C-g>     neocomplete#undo_completion()
    inoremap <expr><C-l>     neocomplete#complete_common_string()

    " Recommended key-mappings.
    " <CR>: close popup and save indent.
    inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
    function! s:my_cr_function()
      return neocomplete#close_popup() . "\<CR>"
      " For no inserting <CR> key.
      "return pumvisible() ? neocomplete#close_popup() : "\<CR>"
    endfunction
    " <TAB>: completion.
    inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
    " <C-h>, <BS>: close popup and delete backword char.
    inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
    inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
    inoremap <expr><C-y>  neocomplete#close_popup()
    inoremap <expr><C-e>  neocomplete#cancel_popup()
    " Close popup by <Space>.
    "inoremap <expr><Space> pumvisible() ? neocomplete#close_popup() : "\<Space>"

    " For cursor moving in insert mode(Not recommended)
    "inoremap <expr><Left>  neocomplete#close_popup() . "\<Left>"
    "inoremap <expr><Right> neocomplete#close_popup() . "\<Right>"
    "inoremap <expr><Up>    neocomplete#close_popup() . "\<Up>"
    "inoremap <expr><Down>  neocomplete#close_popup() . "\<Down>"
    " Or set this.
    "let g:neocomplete#enable_cursor_hold_i = 1
    " Or set this.
    "let g:neocomplete#enable_insert_char_pre = 1

    " AutoComplPop like behavior.
    "let g:neocomplete#enable_auto_select = 1

    " Shell like behavior(not recommended).
    "set completeopt+=longest
    "let g:neocomplete#enable_auto_select = 1
    "let g:neocomplete#disable_auto_complete = 1
    "inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"

    " Enable omni completion.
    autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
    autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
    autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
    autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
    autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

    " Enable heavy omni completion.
    if !exists('g:neocomplete#sources#omni#input_patterns')
      let g:neocomplete#sources#omni#input_patterns = {}
    endif
    "let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
    "let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
    "let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

    " For perlomni.vim setting.
    " https://github.com/c9s/perlomni.vim
    let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'

    " Neoshippet
    imap <C-k>     <Plug>(neosnippet_expand_or_jump)
    smap <C-k>     <Plug>(neosnippet_expand_or_jump)
    xmap <C-k>     <Plug>(neosnippet_expand_target)
end
