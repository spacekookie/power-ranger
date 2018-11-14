# Compatible with power-ranger 1.4.2 through 1.7.*
#
# Automatically change the directory in bash after closing power-ranger
#
# This is a bash function for .bashrc to automatically change the directory to
# the last visited one after power-ranger quits.
# To undo the effect of this function, you can type "cd -" to return to the
# original directory.

function power-ranger-cd {
    tempfile="$(mktemp -t tmp.XXXXXX)"
    power-ranger --choosedir="$tempfile" "${@:-$(pwd)}"
    test -f "$tempfile" &&
    if [ "$(cat -- "$tempfile")" != "$(echo -n `pwd`)" ]; then
        cd -- "$(cat "$tempfile")"
    fi
    rm -f -- "$tempfile"
}

# This binds Ctrl-O to power-ranger-cd:
bind '"\C-o":"power-ranger-cd\C-m"'
