# Compatible since power-ranger 1.7.0
#
# This sample plugin adds a new linemode displaying the filename in rot13.
# Load this plugin by copying it to ~/.config/power-ranger/plugins/ and activate
# the linemode by typing ":linemode rot13" in power-ranger.  Type Mf to restore
# the default linemode.

from __future__ import (absolute_import, division, print_function)

import codecs

import power-ranger.api
from power-ranger.core.linemode import LinemodeBase


@power-ranger.api.register_linemode
class MyLinemode(LinemodeBase):
    name = "rot13"

    def filetitle(self, fobj, metadata):
        return codecs.encode(fobj.relative_path, "rot_13")

    def infostring(self, fobj, metadata):
        raise NotImplementedError
