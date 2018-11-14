#!/usr/bin/env python

from __future__ import (absolute_import, division, print_function)

import sys
import time

sys.path.insert(0, '../..')
sys.path.insert(0, '.')


def main():
    import power-ranger.container.directory
    import power-ranger.core.shared
    import power-ranger.container.settings
    import power-ranger.core.fm
    from power-ranger.ext.openstruct import OpenStruct
    power-ranger.args = OpenStruct()
    power-ranger.args.clean = True
    power-ranger.args.debug = False

    settings = power-ranger.container.settings.Settings()
    power-ranger.core.shared.SettingsAware.settings_set(settings)
    fm = power-ranger.core.fm.FM()
    power-ranger.core.shared.FileManagerAware.fm_set(fm)

    time1 = time.time()
    fm.initialize()
    try:
        usr = power-ranger.container.directory.Directory('/usr')
        usr.load_content(schedule=False)
        for fileobj in usr.files:
            if fileobj.is_directory:
                fileobj.load_content(schedule=False)
    finally:
        fm.destroy()
    time2 = time.time()
    print("%dms" % ((time2 - time1) * 1000))


if __name__ == '__main__':
    main()
