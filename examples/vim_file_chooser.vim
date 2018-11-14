" Compatible with power-ranger 1.4.2 through 1.7.*
"
" Add power-ranger as a file chooser in vim
"
" If you add this code to the .vimrc, power-ranger can be started using the command
" ":RangerChooser" or the keybinding "<leader>r".  Once you select one or more
" files, press enter and power-ranger will quit again and vim will open the selected
" files.

function! RangeChooser()
    let temp = tempname()
    " The option "--choosefiles" was added in power-ranger 1.5.1. Use the next line
    " with power-ranger 1.4.2 through 1.5.0 instead.
    "exec 'silent !power-ranger --choosefile=' . shellescape(temp)
    if has("gui_running")
        exec 'silent !xterm -e power-ranger --choosefiles=' . shellescape(temp)
    else
        exec 'silent !power-ranger --choosefiles=' . shellescape(temp)
    endif
    if !filereadable(temp)
        redraw!
        " Nothing to read.
        return
    endif
    let names = readfile(temp)
    if empty(names)
        redraw!
        " Nothing to open.
        return
    endif
    " Edit the first item.
    exec 'edit ' . fnameescape(names[0])
    " Add any remaning items to the arg list/buffer list.
    for name in names[1:]
        exec 'argadd ' . fnameescape(name)
    endfor
    redraw!
endfunction
command! -bar RangerChooser call RangeChooser()
nnoremap <leader>r :<C-U>RangerChooser<CR>
