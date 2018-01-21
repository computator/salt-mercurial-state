#!/usr/bin/python

from __future__ import absolute_import

import os
import shlex
import sys
import fnmatch

# enable importing on demand to reduce startup time
import hgdemandimport ; hgdemandimport.enable()

from mercurial import (
    dispatch,
    ui as uimod,
)

def main():
    cwd = os.getcwd()
    readonly = False
    args = sys.argv[1:]
    while len(args):
        if args[0] == '--read-only':
            readonly = True
            args.pop(0)
        else:
            break
    allowed_paths = [os.path.normpath(os.path.join(cwd,
                                                   os.path.expanduser(path)))
                     for path in args]
    orig_cmd = os.getenv('SSH_ORIGINAL_COMMAND', '?')
    try:
        cmdargv = shlex.split(orig_cmd)
    except ValueError as e:
        sys.stderr.write('Illegal command "%s": %s\n' % (orig_cmd, e))
        sys.exit(255)

    if cmdargv[:2] == ['hg', '-R'] and cmdargv[3:] == ['serve', '--stdio']:
        path = cmdargv[2]
        repo = os.path.normpath(os.path.join(cwd, os.path.expanduser(path)))
        if next((True for patt in allowed_paths if fnmatch.fnmatch(repo, patt)),
                False) and os.path.isdir(os.path.join(repo, '.hg')):
            cmd = ['-R', repo, 'serve', '--stdio']
            req = dispatch.request(cmd)
            if readonly:
                if not req.ui:
                    req.ui = uimod.ui.load()
                req.ui.setconfig('hooks', 'pretxnopen.hg-ssh',
                                 'python:__main__.rejectpush', 'hg-ssh')
                req.ui.setconfig('hooks', 'prepushkey.hg-ssh',
                                 'python:__main__.rejectpush', 'hg-ssh')
            dispatch.dispatch(req)
        else:
            sys.stderr.write('Illegal repository "%s"\n' % repo)
            sys.exit(255)
    elif len(cmdargv) == 3 and cmdargv[:2] == ['hg', 'init']:
        path = cmdargv[2]
        repo = os.path.normpath(os.path.join(cwd, os.path.expanduser(path)))
        if not readonly and next((True for patt in allowed_paths
                                  if fnmatch.fnmatch(repo, patt)),
                                 False):
            cmd = ['init', repo]
            req = dispatch.request(cmd)
            dispatch.dispatch(req)
        else:
            sys.stderr.write('Permission denied "%s"\n' % repo)
            sys.exit(255)
    else:
        sys.stderr.write('Illegal command "%s"\n' % orig_cmd)
        sys.exit(255)

def rejectpush(ui, **kwargs):
    ui.warn(("Permission denied\n"))
    # mercurial hooks use unix process conventions for hook return values
    # so a truthy return means failure
    return True

if __name__ == '__main__':
    main()
