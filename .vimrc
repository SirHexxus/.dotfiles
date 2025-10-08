" ---------------------------------------------
" James Stacy's .vimrc
" jamesmichaelstacy@gmail.com
" License MIT
"
" Credits
"   https://github.com/bahamas10/
" ---------------------------------------------
set nocompatible		" Disable VI Compatibility

" ---------------------------------------------
" Init - plugins
" A good resource for plugins: https://vimawesome.com/
" ---------------------------------------------
" Automatically install vim-plug
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()

Plug 'embark-theme/vim', { 'as': 'embark', 'branch': 'main' }
Plug 'preservim/vim-markdown'
Plug 'preservim/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'dense-analysis/ale'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline'
Plug 'elzr/vim-json'
Plug 'pangloss/vim-javascript'
Plug 'othree/html5.vim'
Plug 'hail2u/vim-css3-syntax'
Plug 'ekalinin/dockerfile.vim'
Plug 'suan/vim-instant-markdown'
Plug 'pearofducks/ansible-vim'
Plug 'matt-deacalion/vim-systemd-syntax'

call plug#end()

" ---------------------------------------------
" Vim Options
" ---------------------------------------------
syntax on						" Enables Syntax Highlighting
set number						" Displays line numbers
set backspace=indent,eol,start	" Backspace all characters
set formatoptions-=t			" Don't add line-breaks for lines over 'textwidth' characters
set hlsearch					" Highlight search results
set showmatch					" Show matching brackets.
set showmode					" Show the current mode in status line
set showcmd						" Show partial command in status line
set tabstop=4					" Number of spaces <tab> counts for
set textwidth=80				" 80 columns
set title						" Set the title
set termguicolors				" Truecolor support

" ---------------------------------------------
" Theme / Color Scheme
" ---------------------------------------------
colorscheme embark

" ---------------------------------------------
" Abbreviations
" ---------------------------------------------
" iab <expr> me:: strftime("Author: James Stacy <jamesmichaelstacy@gmail.com><cr>Date: %B %d, %Y<cr>License: MIT")

" ---------------------------------------------
" Aliases
" ---------------------------------------------
" cmap w!! w !sudo tee > /dev/null %

" ---------------------------------------------
" File/Indenting and Syntax Highlighting
" ---------------------------------------------
if has("autocmd")
	filetype plugin indent on

	" Jump to previous cursor location, unless it's a commit message
	autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
	autocmd BufReadPost COMMIT_EDITMSG exe "normal! gg"

	" Yaml
	autocmd BufNewFile,BufRead                  *.yaml,*.yml setlocal filetype=yaml
	autocmd FileType                            yaml         setlocal sw=2 sts=2 et

	" JavaScript files
	autocmd BufNewFile,BufReadPre,FileReadPre   *.js        setlocal filetype=javascript
	autocmd FileType                            javascript  setlocal sw=4 sts=4 et

	" JSON files
	autocmd BufNewFile,BufReadPre,FileReadPre   *.json setlocal filetype=json
	autocmd FileType                            json   setlocal sw=2 sts=2 et

	" Python files
	autocmd BufNewFile,BufReadPre,FileReadPre   *.py   setlocal filetype=python
	autocmd FileType                            python setlocal sw=4 sts=4 et

	" Markdown files
	autocmd BufNewFile,BufRead,FileReadPre      *.md,*.markdown setlocal filetype=markdown
	autocmd FileType                            markdown      setlocal sw=4 sts=4 et spell

	" Jekyll posts ignore yaml headers
	autocmd BufNewFile,BufRead                  */_posts/*.md syntax match Comment /\%^---\_.\{-}---$/
	autocmd BufNewFile,BufRead                  */_posts/*.md syntax region lqdHighlight start=/^{%\s*highlight\(\s\+\w\+\)\{0,1}\s*%}$/ end=/{%\s*endhighlight\s*%}/

	" EJS javascript templates
	autocmd BufNewFile,BufRead,FileReadPre      *.ejs setlocal filetype=html

	" TXT files
	autocmd FileType                            text setlocal spell
endif

" ---------------------------------------------
" Highlight Unwanted Whitespace
" ---------------------------------------------
highlight RedundantWhitespace ctermbg=green guibg=green
match RedundantWhitespace /\s\+$\| \+\ze\t/

" ---------------------------------------------
" Spell Check Settings
" ---------------------------------------------
set spelllang=en
highlight clear SpellBad
highlight SpellBad term=standout cterm=underline ctermfg=red
highlight clear SpellCap
highlight SpellCap term=underline cterm=underline
highlight clear SpellRare
highlight SpellRare term=underline cterm=underline
highlight clear SpellLocal
highlight SpellLocal term=underline cterm=underline

" ---------------------------------------------
" Plugins
" ---------------------------------------------
let g:airline_powerline_fonts = 0
let g:ale_linters = {
\  'bash': [],
\  'sh': [],
\  'c': [],
\}
let g:ale_completion_enabled = 0
let g:vim_markdown_folding_disabled = 1

" ---------------------------------------------
" Source local config
" ---------------------------------------------
if filereadable(expand("~/.vimrc.local"))
	source ~/.vimrc.local
endif
if filereadable(expand("~/.vimrc.indent"))
	source ~/.vimrc.indent
endif
