"========Vim Addon Manager=================================================
fun! EnsureVamIsOnDisk(vam_install_path)
    " windows users want to use http://mawercer.de/~marc/vam/index.php
    " to fetch VAM, VAM-known-repositories and the listed plugins
    " without having to install curl, unzip, git tool chain first
    " -> BUG [4] (git-less installation)
    if !filereadable(a:vam_install_path.'/vim-addon-manager/.git/config')
                \&& 1 == confirm("Clone VAM into ".a:vam_install_path."?","&Y\n&N")
        " I'm sorry having to add this reminder. Eventually it'll pay off.
        call confirm("Remind yourself that most plugins ship with ".
                    \"documentation (README*, doc/*.txt). It is your ".
                    \"first source of kne:owledge. If you can't find ".
                    \"the info you're looking for in reasonable ".
                    \"time ask maintainers to improve documentation")
        call mkdir(a:vam_install_path, 'p')
        execute '!git clone --depth=1 git://github.com/MarcWeber/vim-addon-manager '.shellescape(a:vam_install_path, 1).'/vim-addon-manager'
        " VAM runs helptags automatically when you install or update
        " plugins
        exec 'helptags '.fnameescape(a:vam_install_path.'/vim-addon-manager/doc')
    endif
endf

fun! SetupVAM()
    " Set advanced options like this:
    " let g:vim_addon_manager = {}
    " let g:vim_addon_manager['key'] = value

    " Example: drop git sources unless git is in PATH. Same plugins can
    " be installed from www.vim.org. Lookup MergeSources to get more control
    " let g:vim_addon_manager['drop_git_sources'] = !executable('git')

    " VAM install location:
    let vam_install_path = expand('$HOME') . '/.vim/vim-addons'
    call EnsureVamIsOnDisk(vam_install_path)
    exec 'set runtimepath+='.vam_install_path.'/vim-addon-manager'

    " Tell VAM which plugins to fetch & load:
    call vam#ActivateAddons([], {'auto_install' : 0})
    " sample: call vam#ActivateAddons(['pluginA','pluginB', ...], {'auto_install' : 0})

    " Addons are put into vam_install_path/plugin-name directory
    " unless those directories exist. Then they are activated.
    " Activating means adding addon dirs to rtp and do some additional
    " magic

    " How to find addon names?
    " - look up source from pool
    " - (<c-x><c-p> complete plugin names):
    " You can use name rewritings to point to sources:
    " ..ActivateAddons(["github:foo", .. => github://foo/vim-addon-foo
    " ..ActivateAddons(["github:user/repo", .. => github://user/repo
    " Also see section "2.2. names of addons and addon sources" in VAM's documentation
endfun 
call SetupVAM()
"'SuperTab','Color_Sampler_Pack','a','clang','clang_complete' FencView

"minibufexpl
ActivateAddons cmake%599 FencView vim-latex echofunc  The_NERD_Commenter SuperTab project.tar.gz bufkill minibufexpl Tagbar  DoxygenToolkit Color_Sampler_Pack a clang clang_complete sessionman winmanager%1440 Conque_Shell



"=========杂项======================================
"设置主题颜色
colorscheme desertEx
"行号
set number
"tab宽度
set tabstop=4 
"设置补全
set wildmode=longest:full,full
set formatoptions+=tcroql
set wildmenu
"高亮当前行
set cursorline

set autochdir
set tags=./tags;
"当提示需保存时自动保存
set autowriteall

"允许在有未保存的修改时切换缓冲区，此时的修改切换由 vim 负责保存
"set hidden
"set switchbuf=usetab
"set linebreak
"set bufhidden
"当保存文件时自动调用 ctags：
autocmd BufWritePost *.cpp,*.h,*.c,*.def,*.py,*.java,*.html call system("ctags -R")

" 编译后，如有错误则打开quickfix窗口。（光标仍停留在源码窗口）
autocmd QuickFixCmdPost [^l]* nested cwindow
autocmd QuickFixCmdPost    l* nested lwindow

"========设置gvim=================================
if has("gui_running")
    "set nowrap
    set mousemodel=popup "GUI当右键单击窗口的时候，弹出快捷菜单"
    set guioptions-=T "Dont show the tools.
    " set guioptions-=m
    set winaltkeys=no "Alt组合键不映射到菜单上
    set guifont=YaHei\ Consolas\ Hybrid\ 13
endif

"=======clang_complete=======================
let g:clang_close_preview=1

"========project=============================

let g:proj_run1='!cd "%D"/release;make;'
let g:proj_run2='!cd "%D"/debug;make;'

"========vim-latex============================
let g:Tex_DefaultTargetFormat = 'pdf'
let g:Tex_CompileRule_pdf = 'xelatex'
let g:Tex_MultipleComplieFormats='pdf'



"=======FencView=============================
let g:fencview_autodetect = 1
"忍不住要吐槽一下，这个插件默认只对*.txt *htm{l\=}自动编码，靠，弄得我找了N久
let g:fencview_auto_this=""


"=======The_NERD_Commenter====================
let NERD_c_alt_style = 0 " 将C语言的注释符号改为//, 默认是/**/
let NERDCompactSexyComs=1 " 多行注释时样子更好看
let NERDSpaceDelims=0 " 让注释符与语句之间留一个空格
let NERDCompactSexyComs=0 " 多行注释时样子更好看

"========minibufexpl===========================
let g:miniBufExplMapWindowNavVim = 1
let g:miniBufExplMapWindowNavArrows = 1
let g:miniBufExplMapCTabSwitchBufs = 1
let g:miniBufExplModSelTarget = 1 "尽量在可修改的窗口打开目标
let g:miniBufExplCheckDupeBufs = 1
let g:miniBufExplMoreThanOne = 0 "防止多个minibufexpl出现



"已弃置
"========neocomplcache==========================
"let g:neocomplcache_enable_at_startup=1 " Use neocomplcache.
"let g:neocomplcache_enable_auto_select=1
"let g:neocomplcache_auto_completion_start_length=2
"let g:neocomplcache_min_syntax_length=3
"let g:neocomplcache_min_keyword_length=3 "length of keyword becoming the object of the completion at the minimum.
"let g:neocomplcache_enable_camel_case_completion=1 "match it with ArgumentsException when you input it with AE.
"let g:neocomplcache_enable_fuzzy_completion=0
"let g:neocomplcache_enable_smart_case=1 "When a capital letter is included in input, neocomplcache do not ignore the upper- and lowercase.
"let g:neocomplcache_enable_quick_match=0 "choose a candidate with a alphabet or number displayed beside a candidate after '-'.
"let g:neocomplcache_enable_underbar_completion=1 "match it with 'public_html' when you input it with 'p_h'.
"let g:neocomplcache_enable_auto_delimiter=1 "This option controls whether neocomplcache insert delimiter automatically. For example, /(filename) or #(Vim script).


"=======neocomplcache-snippets-complete=========
"imap <tab> <Plug>(neocomplcache_snippets_expand)
"smap <tab> <Plug>(neocomplcache_snippets_expand)

"========代码整理===============================
func! CodeFormat()
    let pos= getpos(".")
    if &filetype=='c' || &filetype=='cpp'
        :%!astyle --style=k/r --indent=spaces=4 --indent-switches --indent-cases --break-blocks --pad-oper  --unpad-paren --indent-namespaces
        "exec '! astyle -A3Lfpjk3NS %'
    else
        exec 'normal gg=G'
    endif
    call setpos('.',pos)
endfun

"========根据头文件生成函数====================
function! CreateFunctionDef()
    let a:curline = line(".")
    let a:lines = getline(a:curline, search(';'))
    let a:ln = join(a:lines, "\n")
    let a:ln = substitute(a:ln, '^\s\+', "", "")
    let a:ln = substitute(a:ln, 'virtual\s\+', "", "")
    let a:ln = substitute(a:ln, ';', "", "")

    let a:class = search('class', 'b')
    let a:class = getline(a:class)
    if strlen(a:class)>0
        let a:class = matchlist(a:class, 'class\s\+\([a-zA-Z]\+\)')[1]
        let a:fname = substitute(a:ln, '\([a-zA-Z]\+\s\+\)*\(.*\)', '\1'.a:class.'::\2', '') 
        let a:ln = a:fname
    endif	

    let a:hname = bufname("%")
    let a:cppname = matchlist(a:hname, '\(.*/\)*\(.*\)\.h')[2] . ".cpp"
    let a:cppname = bufname(a:cppname)
    let a:datas = readfile(a:cppname)
    let a:datas += split(a:ln, "\n")
    "let a:datas = add(a:datas, a:ln)
    let a:datas = add(a:datas, '{')
    let a:type = substitute(a:ln, '\([a-zA-Z]\+\)\s\+.*', 'return \1();', '')
    if a:type != a:ln
        let a:datas = add(a:datas, a:type)
    endif	
    let a:datas = add(a:datas, '}')
    let a:datas = add(a:datas, '')
    call writefile(a:datas, a:cppname)
    "execute 'e '.a:cppname
endfunction


"========快捷键===================================
"用 CTRL-O {command} 你可以在插入模式下执行任何普通模式命令
"保存
map <C-S> <Esc>:update<CR>
imap <C-S> <C-O>:update<CR>
"查找
map <C-F> <Esc>:/
imap <C-F> <Esc>:/
"头文件跳转插件
map <F4> <Esc>:A<CR>
imap <F4> <C-O>:A<CR>
"剪切
vmap <C-S-X> "+x
"复制
vmap <C-S-C> "+y
"粘贴
map <C-V> "+gp
cmap <C-V> <C-R>+
imap <C-V> <C-O>"+gp
"撤销
map <C-Z> u
imap <C-Z> <C-O>u
"重做
map <C-R> <C-R>
imap <C-R> <C-O><C-R>

"Doxygen
imap <C-G> <C-O>:Dox<CR>
map <C-G> :Dox<CR>
"The_NERD_Commenter
map <C-D> :call NERDComment(1,'toggle')<CR>
imap <C-D> <C-O>:call NERDComment(1,'toggle')<CR>

"clang_complete
imap <C-J> <C-X><C-U>

"代码整理
map <C-A-F> <Esc>:call CodeFormat()<CR>
imap <C-A-F> <C-O>:call CodeFormat()<CR>

"由头文件生成成员函数
map <Leader>c :call CreateFunctionDef()<CR>


"生成项目
imap <F12> <Esc>:make<CR>a
map <F12> <Esc>:make<CR>

"重新生成项目
map <S-F12> <Esc>:make<CR> 
imap <S-F12> <Esc>:make<CR>a

"运行项目
"切换debug，release模式
map <Leader>b <Esc>:call ToggleBuildType()<CR>

"========文件类型插件=================================
filetype plugin indent on
set smarttab
"4个空格代替一个tab
set shiftwidth=4
set expandtab

"=========让.vimrc修改保存后自动生效==================
autocmd! bufwritepost .vimrc source %

"=========切换debug，release模式======================
set makeprg =OBJ_SUBDIR\=release\ makeobj
function! ToggleBuildType()
    if &makeprg=='OBJ_SUBDIR=release makeobj'
        set makeprg=OBJ_SUBDIR\=debug\ makeobj
        echo 'Change to Debug build type'
    else
        set makeprg=OBJ_SUBDIR\=release\ makeobj
        echo 'Change to Release build type'
    end
endfunction
"===========快速实现输入法与VIM模式切换===============
autocmd! InsertLeave * set imdisable
autocmd! InsertEnter * set noimdisable

"===========Doxygen===================================
let g:DoxygenToolkit_authorName="DY.Feng"
let g:DoxygenToolkit_briefTag_pre=""
let g:DoxygenToolkit_compactDoc="yes"

"===========SessionMan================================
let g:sessionman_save_on_exit=1

"===========Tagbar====================================
let g:tagbar_ctags_bin = 'ctags'
let g:tagbar_width = 30
"Tagbar窗口在左侧
let g:tagbar_left = 1
"Tagbar窗口不自动关闭
let g:tagbar_autoclose = 0
"启动时打开Tagbar
"exec 'TagbarOpen'

"已弃置
"========winmanager%1440================================
"let g:winManagerWindowLayout = "FileExplorer,__Tagbar__"
"let g:Tagbar_title='Name'

