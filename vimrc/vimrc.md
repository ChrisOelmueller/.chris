.vimrc
======

Todo.
```viml
set nocompatible
set encoding=utf-8
set fileencoding=utf-8

set nobackup
set nowb
set noswapfile
```

```viml
set showcmd
set ruler
set number
```

Navigation
----------
Todo.
```viml
set history=200
set mouse=

set background=dark
set t_Co=256  " 256 colors
highlight SpellBad term=reverse ctermbg=1

" allow backspacing over everything in insert mode
set backspace=indent,eol,start
" Allows normal jk movement on long lines.

nnoremap j gj
nnoremap k gk
nnoremap <Up> g<Up>
nnoremap <Down> g<Down>
```

Syntax highlight and autocompletion
-----------------------------------
Probably not much to add here, except that i only use a dictionary
completion for python currently.
```viml
:syntax on
filetype plugin on
filetype indent on

let g:pydiction_location = '/usr/share/pydiction/complete-dict'
```

Trailing whitespace
-------------------
Automatic indentation is very nice, and often does the right thing,
which is especially important when writing python code. Even if not
originally written for python, `smartindent` indeed is smart enough
to cover most annoying tab-work.

In cases where I really planned on doing something differently,
reindenting in visual mode is made easy by just hitting
`>` (which will add one indentation level to all selected lines) or
`<`, respectively. The snippet below allows for doing this multiple
times in quick succession without needing to tediously re-select lines.

At times, you find yourself hitting `o` and afterwards realizing that
you probably don't want a new line. Saving a file in that state would
normally commit an awful crime (trailing whitespace) which this nice
snippet manages to prevent. Yeah, i'm one of those whitespace guys.
```viml
set smartindent

" Reselect visual block after indent/outdent
vnoremap < <gv
vnoremap > >gv

" strip trailing whitespace before writing
autocmd BufWritePre *.py normal m`:%s/\s\+$//e ``
```

Project-specific indentation
----------------------------
Since line length and tabs vs. spaces can depend on which project i'm currently working on,
here is a short (and incomplete) list of how my indentation settings vary between those.

Includes the rather unconventional tabwidth of 5 which turned out to work better for me than 4.
Of course when working on space-only projects I keep the de-facto standard tab width at four.
```viml
autocmd BufNewFile,BufRead *.xml              set ts=5  sts=5  sw=5  textwidth=160  smarttab  noexpandtab
autocmd BufNewFile,BufRead *.py               set ts=5  sts=5  sw=5  textwidth=90   smarttab  noexpandtab
autocmd BufNewFile,BufRead ~/UH/*.py*         set ts=5  sts=5  sw=5  textwidth=100  smarttab  noexpandtab
autocmd BufNewFile,BufRead ~/UH/pootle*/*.py  set ts=4  sts=4  sw=4  textwidth=80   smarttab  expandtab
autocmd BufNewFile,BufRead ~/crawl            set ts=4  sts=4  sw=4  textwidth=80   smarttab  expandtab
```

Search
------
```viml
set hlsearch  " highlight
set incsearch  " incremental, immediate results
set ignorecase
set smartcase
" Shortcut to clear highlighting
nnoremap <space><space> :noh<cr>
```

The rest (TODO)
---------------
```viml
""" hotkeys
" q closes TaskList, i do not need recording currently
nnoremap <silent> q : TaskList<CR>
" For my keyboard, just make those be the same huge Insert key
map! <F12> <Insert>

" toggle mbe modes: open&focus <> close
map <Leader>b :TMiniBufExplorer<cr>
" force update
map <Leader>u :UMiniBufExplorer<cr>

" MiniBufExplorer settings
let g:miniBufExplMapWindowNavVim = 1
let g:miniBufExplMapWindowNavArrows = 1
let g:miniBufExplMapCTabSwitchBufs = 1
let g:miniBufExplModSelTarget = 1
let g:miniBufExplShowBufNumbers = 0
let g:miniBufExplForceSyntaxEnable = 1

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
" Also don't do it when the mark is in the first line, that is the default
" position when opening a file.
autocmd BufReadPost *
	\ if line("'\"") > 1 && line("'\"") <= line("$") |
	\	 exe "normal! g`\"" |
	\ endif

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

set clipboard+=unnamed  " yank and copy to X clipboard

" flake8
let g:flake8_builtins="_,__,S__,N_"
" W191 indentation contains tabs
" E101 indentation contains mixed spaces and tabs
let g:flake8_ignore="W191,E101"
```
