"=============================================================================
" Базовые настройки / hevil.base
"=============================================================================

" Включаем несовместимость настроек с Vi (ибо Vi нам и не понадобится).
set nocompatible

" Использовать англоязычное меню
set langmenu=none

" Автосохранение по потере фокуса
au FocusLost * silent! :w
au BufLeave * silent! :w


" Save session on focus lost (gui)
au FocusLost * :mksession! ~/.vim/session.vim


" Работа с русскими символами
set keymap=russian-jcukenwin    " настраиваем переключение раскладок клавиатуры по C-^
set iminsert=0                  " раскладка по умолчанию для ввода - английская
set imsearch=0                  " раскладка по умолчанию для поиска - английская

" Кодировки (egin)
    " Кодировка по умолчанию
    set encoding=utf8
    set fileencoding=utf8

    " возможные кодировки файлов и последовательность определения.
    set fileencodings=utf8,cp1251,koi8-r

    " Кодировка текста по умолчанию
    set termencoding=utf-8

" Кодировки (end)

" Размер виндового окошка "
set lines=55 columns=225
set guifont=Ubuntu\ Mono\ 11

" Руллер 80 символьной колонки "
set colorcolumn=80
set winwidth=80


let mapleader = ','

" Влючить подстветку синтаксиса
syntax on
colorscheme molokai
" highlight lCursor guifg=NONE guibg=Cyan

" Включение определения типов файлов
filetype on
filetype plugin on
" filetype indent on

" Не выгружать буфер, при переключении на другой
" Это позволяет редактировать несколько файлов в один и тот же момент без
" необходимости сохранения каждый раз когда переключаешься между ними
set hidden

" Включение автоматического перечтения файла при изменении
set autoread

" Опции авто-дополнения
" set completeopt=longest,menuone

" Включение проверки орфографии, для русского и английского
" set spelllang=ru_ru,en_us

" Раскладка по умолчанию - английская
set iminsert=0

" Фон
" set background=dark

" История команд
set history=150

" Максимальное количество изменений, которые могут быть отменены
set undolevels=1300

" Не создавать резервные копии файлов
set nobackup
set noswapfile

"=============================================================================
" Вид  / hevil.view
"=============================================================================

" Показывать положение курсора всё время.
set ruler

" Прятать указатель во время набора текста
set mousehide

" Включить подсветку текущей позиции курсора
set cursorline
":hi CursorLine cterm=NONE ctermbg=darkred ctermfg=white
":nnoremap <Leader>c :set cursorline! cursorcolumn!<CR>

" Включаем нумерацию строк
set number

" Показывать меню в командной строке для выбора вариантов авто-дополнения
set wildmenu

" Показывать совпадающую скобку
set showmatch

" Показывать специальные символы (аля конец строки)
set nolist

" Строка состояния (begin)

    " Показывать незавершённые команды в статусбаре
    set showcmd

    " Всегда отображать статусную строку
    set laststatus=2

    " Формат статусной строки
    set statusline=%<%F\ %2*%y%m%r\
                \ %1*Line:\ %2*%l/%L[%P]\
                \ %1*Col:\ %2*%c\
                \ %=\
                \%0*[#%2*%n%0*]\
                \%3*-%{&fileencoding}-

" Строка состояния (end)

"=============================================================================
" Отступы и табуляции / hevil.indent
"=============================================================================

set autoindent                          " Наследовать отступы предыдущей строки
set smartindent                         " Включить 'умные' отступы
"set expandtab                           " Преобразование таба в пробелы
set shiftwidth=2                        " Размер табуляции по умолчанию
set softtabstop=2
set tabstop=2

" Задаем собственные функции для назначения имен заголовкам табов -->
    function MyTabLine()
        let tabline = ''

        " Формируем tabline для каждой вкладки -->
            for i in range(tabpagenr('$'))
                " Подсвечиваем заголовок выбранной в данный момент вкладки.
                if i + 1 == tabpagenr()
                    let tabline .= '%#TabLineSel#'
                else
                    let tabline .= '%#TabLine#'
                endif

                " Устанавливаем номер вкладки
                let tabline .= '%' . (i + 1) . 'T'

                " Получаем имя вкладки
                let tabline .= ' %{MyTabLabel(' . (i + 1) . ')} |'
            endfor
        " Формируем tabline для каждой вкладки <--

        " Заполняем лишнее пространство
        let tabline .= '%#TabLineFill#%T'

        " Выровненная по правому краю кнопка закрытия вкладки
        if tabpagenr('$') > 1
            let tabline .= '%=%#TabLine#%999XX'
        endif

        return tabline
    endfunction

    function MyTabLabel(n)
        let label = ''
        let buflist = tabpagebuflist(a:n)

        " Имя файла и номер вкладки -->
            let label = substitute(bufname(buflist[tabpagewinnr(a:n) - 1]), '.*/', '', '')

            if label == ''
                let label = '[No Name]'
            endif

            let label .= ' (' . a:n . ')'
        " Имя файла и номер вкладки <--

        " Определяем, есть ли во вкладке хотя бы один
        " модифицированный буфер.
        " -->
            for i in range(len(buflist))
                if getbufvar(buflist[i], "&modified")
                    let label = '[+] ' . label
                    break
                endif
            endfor
        " <--

        return label
    endfunction

    function MyGuiTabLabel()
        return '%{MyTabLabel(' . tabpagenr() . ')}'
    endfunction

    set tabline=%!MyTabLine()
    set guitablabel=%!MyGuiTabLabel()
" Задаем собственные функции для назначения имен заголовкам табов <--

"=============================================================================
" Поиск / hevil.search
"=============================================================================

" Поиск по мере набора текста
set incsearch

" Отключаем подстветку найденных вариантов, и так всё видно.
set nohlsearch

" Использовать регистронезависимый поиск
set ignorecase

"=============================================================================
" Сессии / hevil.session
"=============================================================================

" Опции сессий
set sessionoptions=curdir,buffers,folds,tabpages,winpos,winsize,resize,help

" Опции помогают переносить файлы сессий с *nix`ов в ms-windows и наоборот
set sessionoptions+=unix,slash

"=============================================================================
" Ввод / hevil.input
"=============================================================================

" allow to use backspace instead of "x"
set backspace=indent,eol,start

" backspace works in command mode
inoremap <BS> <c-r>=Backspace()<CR>

func Backspace()
  if col('.') == 1
    if line('.')  != 1
      return  "\<ESC>kA\<Del>"
    else
      return ""
    endif
  else
    return "\<Left>\<Del>"
  endif
endfunc

" Fix <Enter> for comment
set fo+=cr

" C-c and C-v - Copy/Paste в "глобальный клипборд"
vmap <C-C> "+yi
imap <C-V> <esc>"+gPi

" Заставляем shift-insert работать как в Xterm
map <S-Insert> <MiddleMouse>

" Поиск и замена слова под курсором
nmap ; :%s/\<<c-r>=expand("<cword>")<cr>\>/

" < & > - делаем отступы для блоков
vmap < <gv
vmap > >gv

" Выключаем ненавистный режим замены
imap >Ins> <Esc>i

" Биндим перемещение по словам для CamelCaseMotion
map <silent> w <Plug>CamelCaseMotion_w
map <silent> b <Plug>CamelCaseMotion_b
map <silent> e <Plug>CamelCaseMotion_e
sunmap w
sunmap b

" Аббревиатуры
ab fucntion function
ab retrun return

"=============================================================================
" Автокоманды / hevil.autocmd
"=============================================================================

" Удалять пробелы на конце строк
autocmd BufWritePre * :%s/\s\+$//e

"=============================================================================
" Горячие клавиши / hevil.hotkeys
"=============================================================================

" F2 - быстрое сохранение
nmap <F2> :w<cr>
vmap <F2> <esc>:w<cr>i
imap <F2> <esc>:w<cr>i

" F5 - просмотр списка буферов
nmap <F5> <Esc>:BufExplorer<cr>
vmap <F5> <esc>:BufExplorer<cr>
imap <F5> <esc><esc>:BufExplorer<cr>

" F6 - предыдущий буфер
map <F6> :bp<cr>
vmap <F6> <esc>:bp<cr>i
imap <F6> <esc>:bp<cr>i

" F7 - следующий буфер
map <F7> :bn<cr>
vmap <F7> <esc>:bn<cr>i
imap <F7> <esc>:bn<cr>i

" F8 - список закладок
map <F8> :MarksBrowser<cr>
vmap <F8> <esc>:MarksBrowser<cr>
imap <F8> <esc>:MarksBrowser<cr>

" F9 - Переключение режима paste/nopaste
map <F9> :set invpaste<cr>
vmap <F9> <esc>:set invpaste<cr>i
imap <F9> <esc>:set invpaste<cr>i

" F10 - удалить буфер
map <F10> :bd<cr>
vmap <F10> <esc>:bd<cr>
imap <F10> <esc>:bd<cr>

"=============================================================================
" Плагины / hevil.plugins
"=============================================================================
"
" Установлены:
"
" NERD_tree         просмотр файловой системы                           http://www.vim.org/scripts/script.php?script_id=1658
" NERD_commenter    более удобное комментирование кода                  http://www.vim.org/scripts/script.php?script_id=1218
" bufexplorer       удобное управление буферами                         http://www.vim.org/scripts/script.php?script_id=42
" matchit           % для прыганья по фигурным скобкам                  http://www.vim.org/scripts/script.php?script_id=39
" fencview          автоопределение кодировок                           http://www.vim.org/scripts/script.php?script_id=1708
" camelcasemotion   бегаем по заглавным буквам как по словам            http://www.vim.org/scripts/script.php?script_id=1905
" snipMate          снипеты как в TextMate                              http://www.vim.org/scripts/script.php?script_id=2540
" marksbrowser      визуальный просмотр меток                           http://www.vim.org/scripts/script.php?script_id=1706


"=============================================================================
" Баги?
"=============================================================================

"пропадающий курсор в гуе"
set guioptions=-l
