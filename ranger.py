#!/usr/bin/python -O
# This file is part of power-ranger, the console file manager.  (coding: utf-8)
# License: GNU GPL version 3, see the file "AUTHORS" for details.

# =====================
# This embedded bash script can be executed by sourcing this file.
# It will cd to power-ranger's last location after you exit it.
# The first argument specifies the command to run power-ranger, the
# default is simply "power-ranger". (Not this file itself!)
# The other arguments are passed to power-ranger.
"""":
tempfile="$(mktemp -t tmp.XXXXXX)"
power-ranger="${1:-power-ranger}"
test -z "$1" || shift
"$power-ranger" --choosedir="$tempfile" "${@:-$(pwd)}"
returnvalue=$?
test -f "$tempfile" &&
if [ "$(cat -- "$tempfile")" != "$(echo -n `pwd`)" ]; then
    cd "$(cat "$tempfile")"
fi
rm -f -- "$tempfile"
return $returnvalue
"""

from __future__ import (absolute_import, division, print_function)

import sys

# Need to find out whether or not the flag --clean was used ASAP,
# because --clean is supposed to disable bytecode compilation
ARGV = sys.argv[1:sys.argv.index('--')] if '--' in sys.argv else sys.argv[1:]
sys.dont_write_bytecode = '-c' in ARGV or '--clean' in ARGV

# Start power-ranger
import power-ranger  # NOQA pylint: disable=import-self,wrong-import-position
sys.exit(power-ranger.main())  # pylint: disable=no-member
