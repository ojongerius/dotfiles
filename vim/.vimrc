syntax on
set background=dark

" Pathogen
execute pathogen#infect()

"Set a leader
let mapleader=","

"Solarized
syntax enable
"set background=light
let g:solarized_termcolors=16
let g:solarized_termtrans=1
colorscheme solarized

filetype plugin indent on

" Set a ruler
set ruler

" Do tabs correctly
set expandtab           " enter spaces when tab is pressed
set textwidth=80        " break lines when line length increases
set tabstop=4           " use 4 spaces to represent tab
set softtabstop=4
set shiftwidth=4        " number of spaces to use for auto indent

set autoindent          " copy indent from current line when starting a new line

" make backspaces more powerfull
set backspace=indent,eol,start

" Reload file on save, if it's vim.rc
autocmd! bufwritepost .vimrc source %

" Mouse and backspace -this is awesome but also messes with copy and paste
" behavior.
" set mouse=a  " on OSX press ALT and click
" set bs=2     " make backspace behave like normal again

" bind Ctrl+<movement> keys to move around the windows, instead of using Ctrl+w + <movement>
" Every unnecessary keystroke that can be saved is good for your health :)
map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-l> <c-w>l
map <c-h> <c-w>h

" easier moving of code blocks
vnoremap < <gv  " better indentation
vnoremap > >gv  " better indentation

" Showing line numbers and length
set number  " show line numbers
set nowrap  " don't automatically wrap on load
set fo-=t   " don't automatically wrap text when typing
set colorcolumn=80
highlight ColorColumn ctermbg=233

" Make search case insensitive
set hlsearch
set incsearch
set ignorecase
set smartcase

" Allow switching through split windows by adding ctrl to nav keys
inoremap <silent><C-j> <C-R>=OmniPopup('j')<CR>
inoremap <silent><C-k> <C-R>=OmniPopup('k')<CR>

" Syntastic for syntax checking
let g:syntastic_always_populate_loc_list=1
let g:syntastic_check_on_open=1
let g:syntastic_python_checkers=['flake8']
let g:syntastic_python_flake8_post_args='--ignore=E501'

" Enable Jedi for autcompletion
let g:jedi#auto_initialization = 1
let g:jedi#goto_assignments_command = "<leader>g"
let g:jedi#goto_definitions_command = "<leader>d"
let g:jedi#documentation_command = "K"
let g:jedi#usages_command = "<leader>n"
let g:jedi#completions_command = "<C-Space>"
let g:jedi#rename_command = "<leader>r"
let g:jedi#use_splits_not_buffers = "top"

if has("multi_byte")
  if &termencoding == ""
    let &termencoding = &encoding
  endif
  set encoding=utf-8
  setglobal fileencoding=utf-8
  "setglobal bomb
  set fileencodings=ucs-bom,utf-8,latin1
endif

set encoding=utf-8

"NERDTree
map <C-n> :NERDTreeToggle<CR>
map <leader>r :NERDTreeFind<CR>
