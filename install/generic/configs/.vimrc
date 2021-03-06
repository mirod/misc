" Configuration file for vim 5.x, 6.x
" Some things require 5.3 (5.1 does not like += syntax)

" Karen Etheridge, ether@tcp.com, 1994-2007.
" Karen Etheridge, ether@csc.uvic.ca, 1995-1997
" Karen Etheridge, ketherid@glenayre.com, 1998-2000.
" Karen Etheridge, kde@microplex.com, 2000.
" Karen Etheridge, ether@armadillonetworks.com, 2000-2001.
" Karen Etheridge, ether@activestate.com, 2004-2006.
" Karen Etheridge, karen.etheridge@globalrelay.net, 2006.
" Karen Etheridge, ketheridge@threewavesoftware.com, 2007-2008.
" Karen Etheridge, karene@airg.com, 2008-2013.
" Karen Etheridge, karen#etheridge.ca, 2000-

" vim has copious :help, and you can also ask me about anything that this
" file does.  If you just want syntax colouring or easy format filtering,
" don't take matters into your own hands - please come ask. :)

" <rant disclaimer="I wrote this when I was much younger and bitchier">
"
"   I bear no responsibility for use or misuse of this file in any way.
"   This file belongs in ~ether/.vimrc; I have no control of files living
"   anywhere else.
"
"   DO NOT USE THIS FILE if:
"   1. You are a new user to vim
"   2. You don't know what EVERYTHING in this file does
"   3. You aren't willing to accept total loss of your data as a result of
"      not listening to 1 or 2.
"
" This may seem draconian but I am tired of taking responsibility for other
" peoples' carelessness and expecting other peoples' custom configuration
" files to be intelligently intuitive.  I wrote this file primarily for
" MY USE; it is commented so I can remember what everything does, and perhaps
" for other people to learn from.  It is not intended to be used by other
" people verbatim, and some things WILL BREAK, guaranteed.
" </rant>


" Begin configuration.  Remember, some of these prefs may not apply to you!!!

" STARTUP

version 4.x             " I have read the 4.0 release notes.
set nocompatible        " I understand all the ways that vim != vi.

"  autocmd!              " Remove ALL autocommands.

" INSERT MODE

set softtabstop=4       " tabs count for four spaces, but don't change tabstop
set shiftwidth=4        " each tab counts as four columns
set expandtab           " use spaces rather than tabs
" set formatoptions+=l    " Don't wrap already-long lines
" set wrapmargin=2        " go to next line when close to the edge


" BEHAVIOUR

set scrolloff=5         " don't let the cursor go closer than 5 lines from edge
set nostartofline       " try to keep the cursor in the right column
" set verbose=1         " give some feedback
set title               " allow changing of the window title
set icon                " allow changing of the icon title
set incsearch           " jump to matches as they are found
set magic               " I want to search using regexps a lot
set ignorecase          " perform searches case-insensitive
set smartcase           " ...but not if the pattern contains uppercase
" set cpoptions-=c        " continue searching one character from current cursor
" set cpoptions+=f        " :read sets filename for current buffer
" set cpoptions+=W        " don't overwrite a readonly file unless :w! is used
set viminfo='100,\"50,n~/.viminfo    " configure viminfo file
set textwidth=78        " affects formatting (gq), wordwrapping etc
set modeline            " read mode line - e.g. sets file type
set splitbelow          " I prefer new windows to appear on the bottom
set splitright          " ... and the right

set guioptions+=a       " copy the selected area into the global clipboard

if has("folding")
"  set foldmethod=syntax
"  let perl_fold=1
  let perl_include_pod=1
  let perl_extended_vars=1
endif

set backspace=indent,eol,start

set termencoding=utf-8
set encoding=utf-8      " latin1 is not quite good enough anymore for a default
set modelines=5         " respect modelines in first and last N lines of file

" APPEARANCE

set noshowmode          " I don't need to be told when in insert mode
set errorbells          " Make noise for error messages
" set ruler             " show cursor position
set shortmess=fnx       " shorten some messages
set background=dark     " Change to "light" when a white background
			" maybe we need a keybinding to toggle this
set laststatus=2        " always show status line, even for one window

" from http://vim.wikia.com/wiki/Show_fileencoding_and_bomb_in_the_status_line
if has("statusline")
 set statusline=%<%f\ %h%m%r%=%{\"[\".(&fenc==\"\"?&enc:&fenc).((exists(\"+bomb\")\ &&\ &bomb)?\",B\":\"\").\"]\ \"}%k\ %-14.(%l,%c%V%)\ %P
endif

" SPELLING

" SpellSetSpellchecker ispell

" default: let spell_auto_type = "tex,mail,text,html,sgml,otl,cvs,none"
let spell_auto_type = "tex,mail,text,html,sgml,otl,cvs,pod,none"

" KEYMAPS

" thanks Luke!
" F2: open file in p4 edit mode
" files=`perl -e "$,=\" \";print map{$_=\`readlink -f $_\`;}%;" $*`
"     map <F2> :set noro<CR>:!p4 edit %<CR>

" F2: toggles paste mode
    " map <F2>  :set invpaste<CR>:echo "Paste mode" &paste<CR>
    :set pt=<F2>

" thanks Luke!
" F3: /clear search highlighting xyz<CR>
noremap <F3>  :noh<CR>

" F4: chmod u+w
noremap <F4>  :!chmod u+w %<CR>
" F5: toggles list view
    map <F5>  :set invlist<CR>

" F6: toggles syntax colouring
    map <F6>  :set invsyntax<CR>



" AUTOCOMMANDS

if has("autocmd")
  filetype plugin indent on

  " Turn off line wrap for common files
  au BufNewFile,BufRead db.*	setlocal nowrap
  au BufNewFile,BufRead /etc/*	setlocal nowrap

  au BufNewFile,BufRead,StdinReadPost *
    \ let s:l1 = getline(1) |
    \ if s:l1 =~ '^Return-Path: ' |
    \   setf mail |
    \ endif

  "au FileType python    setlocal foldmethod=indent
  au FileType diff      setlocal list
  au BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  " for editing mail in Mutt
  au FileType mail setlocal tw=75
  au FileType mail map to gg/^To<CR>A
  au FileType mail map cc gg/^Cc<CR>A
  au FileType mail map su gg/^Subject<CR>A
  au FileType mail map Bo gg}o

  " perforce submissions
  au FileType p4 setlocal tw=77
  au FileType p4 setlocal wrap
  au FileType p4 setlocal noexpandtab
  au FileType p4 setlocal ai

  " this stuff needs more work...
  au FileType perl set formatoptions+=l

  " au FileType * source ~/.vim/plugin/tab.vim

  augroup makefile
      au BufNewFile,BufReadPre Makefile*    set list
  augroup END

endif


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" SYNTAX HIGHLIGHTING AND GUI

colorscheme default

" experimental.. attempt to get colours right
set t_Co=16

let term=$TERM
if (!has("gui_running") && term == "cygwin")
    " as it turns out, turning this on breaks hlsearch in cygwin!
    set term=rxvt
endif


if has("syntax")
  if &t_Co > 2 || has("gui_running")
    syntax on
    set hlsearch
  endif
endif

if (!has("gui_running"))
    set mouse=      " disable the mouse from interfering!
    set background=dark
endif


" original: Comment        xxx term=bold cterm=bold ctermfg=6
" 1: red, 0:grey, 7:white, 6:magenta
highlight Comment term=bold cterm=bold ctermfg=DarkGrey

hi Normal guifg=White guibg=Black

" original: mailQuoted1    xxx links to Comment
au FileType mail highlight mailQuoted1 term=bold cterm=bold ctermfg=5

" settings for macvim...
"guifont	list of font names to be used in the GUI
set gfn=Monaco:h10
set noanti      " no anti-aliasing!



""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Below this point is stuff stolen from Neil... moving to above the line as I
" figure out what I want.

set vb		" use a visual flash instead of beeping
set ru		" display column, line info
set ai		" always do autoindenting
"disabled 2010-01-05 -- mouse turning on in 10.6.2 in screen session
"if has("mouse")
"  set mouse=nvi	" use mouse support in xterm
"endif
set listchars=tab:^.,trail:·





"""""""""""""""""
" here are davidl's settings -- check them out
"
"autoindent          equalprg=par        formatoptions=cq
"ignorecase          shiftwidth=4        ttyfast
"autowrite           expandtab
"history=50
"incsearch           smartcase
"ttymouse=xterm2
"directory=/tmp/
"foldcolumn=4        hlsearch
"ruler
"textwidth=40        t_vb=
"
"backspace=indent,eol,start
"
"dictionary=~/.ispell_british,~/.vim/CVIMSYN/engspchk.wordlist
"
"errorformat=%f:%l:%m
"
"makeprg=/usr/share/doc/vim/tools/efm_perl.pl -c % $*
"
"matchpairs=(:),{:},[:],<:>
"
"printoptions=paper:a4
"
"rulerformat=%30(%{P4Status()} %(%5l,%-6(%c%V%) %P%)%)
"
"runtimepath=~/.vim,/etc/vim,/usr/share/vim/vimfiles,/usr/share/vim/addons,/usr/share/vim/vim63,/usr/share/vim/vimfiles,/usr/share/vim/addons/after,~/.vim/after
"
"suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.c b,.ind,.idx,.ilg,.inx,.out,.toc
"
"titlestring=test.txt
"
"viminfo=/10,'10,r/mnt/zip,r/mnt/floppy,f0,h,"100
"
"wildmode=list:longest,full
"
"
"""""""""""""""""
"
" To do:
" - vimspell/aspell
" - better perl handling?
" - keymaps (e.g. toggling paste mode)
" - check out davidl's nifty options.
"
"
" - keybinding for 'set nohlsearch'
" - vim -c option for jumping to specific place in p4 submit forms
" - 'highlight' variable

"[23:50|lukec> vimrc tip: " map <F5> to open file in p4 edit mode
"[23:50|lukec> map <F5> :!p4 edit %^[:set noro^[

