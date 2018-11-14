power-ranger 1.9.2
============

[![Build Status](https://travis-ci.org/power-ranger/power-ranger.svg?branch=master)](https://travis-ci.org/power-ranger/power-ranger)

power-ranger is a console file manager with VI key bindings.  It provides a
minimalistic and nice curses interface with a view on the directory hierarchy.
It ships with `rifle`, a file launcher that is good at automatically finding
out which program to use for what file type.

![screenshot](https://raw.githubusercontent.com/power-ranger/power-ranger-assets/master/screenshots/screenshot.png)

This file describes power-ranger and how to get it to run.  For instructions on the
usage, please read the man page.  See `HACKING.md` for development specific
information.

For configuration, check the files in `power-ranger/config/` or copy the
default config to `~/.config/power-ranger` with `power-ranger --copy-config`.

The `examples/` directory contains several scripts and plugins that demonstrate how
power-ranger can be extended or combined with other programs.  These files can be
found in the git repository or in `/usr/share/doc/power-ranger`.

A note to packagers: Versions meant for packaging are listed in the changelog
on the website.


About
-----
* Authors:     see `AUTHORS` file
* License:     GNU General Public License Version 3
* Website:     https://power-ranger.github.io/
* Download:    https://power-ranger.github.io/power-ranger-stable.tar.gz
* Bug reports: https://github.com/power-ranger/power-ranger/issues
* git clone    https://github.com/power-ranger/power-ranger.git


Design Goals
------------
* An easily maintainable file manager in a high level language
* A quick way to switch directories and browse the file system
* Keep it small but useful, do one thing and do it well
* Console based, with smooth integration into the unix shell


Features
--------
* UTF-8 Support  (if your python copy supports it)
* Multi-column display
* Preview of the selected file/directory
* Common file operations (create/chmod/copy/delete/...)
* Renaming multiple files at once
* VIM-like console and hotkeys
* Automatically determine file types and run them with correct programs
* Change the directory of your shell after exiting power-ranger
* Tabs, bookmarks, mouse support


Dependencies
------------
* Python (`>=2.6` or `>=3.1`) with the `curses` module
  and (optionally) wide-unicode support.
* A pager (`less` by default)

Optional:

* The `file` program for determining file types
* The python module `chardet`, in case of encoding detection problems
* `sudo` to use the "run as root"-feature
* `w3m` for the `w3mimgdisplay` program to preview images
* `python-bidi` for correct display of RTL file names (Hebrew, Arabic)

Optional, for enhanced file previews (with `scope.sh`):

* `img2txt` (from `caca-utils`) for ASCII-art image previews
* `highlight` or `pygmentize` for syntax highlighting of code
* `atool`, `bsdtar` and/or `unrar` for previews of archives
* `lynx`, `w3m` or `elinks` for previews of html pages
* `pdftotext` or `mutool` for pdf previews
* `transmission-show` for viewing bit-torrent information
* `mediainfo` or `exiftool` for viewing information about media files
* `odt2txt` for OpenDocument text files (`odt`, `ods`, `odp` and `sxw`)
* `chardet` (Python package) for improved encoding detection of text files


Installing
----------
Use the package manager of your operating system to install power-ranger.
Note that power-ranger can be started without installing by simply running `power-ranger.py`.

To install power-ranger manually:
```
sudo make install
```

This translates roughly to:
```
sudo python setup.py install --optimize=1 --record=install_log.txt
```

This also saves a list of all installed files to `install_log.txt`, which you can
use to uninstall power-ranger.


Getting Started
---------------
After starting power-ranger, you can use the Arrow Keys or `h` `j` `k` `l` to navigate, `Enter`
to open a file or type `Q` to quit.  The third column shows a preview of the
current file.  The second is the main column and the first shows the parent
directory.

Ranger can automatically copy default configuration files to `~/.config/power-ranger`
if you run it with the switch `--copy-config=( rc | scope | ... | all )`.
See `power-ranger --help` for a description of that switch.  Also check
`power-ranger/config/` for the default configuration.
